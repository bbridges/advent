const std = @import("std");

const Part = struct {
    x: u16,
    m: u16,
    a: u16,
    s: u16,

    fn getRating(self: Part) u16 {
        return self.x + self.m + self.a + self.s;
    }

    fn fromString(s: []const u8) !Part {
        var s_it = std.mem.splitScalar(u8, s[1 .. s.len - 1], ',');

        return .{
            .x = try getPartNumber(s_it.next()),
            .m = try getPartNumber(s_it.next()),
            .a = try getPartNumber(s_it.next()),
            .s = try getPartNumber(s_it.next()),
        };
    }

    fn getPartNumber(segment: ?[]const u8) !u16 {
        if (segment == null) return error.InvalidPart;

        const numResult = std.fmt.parseInt(u16, segment.?[2..], 10);
        return numResult catch error.InvalidPart;
    }
};

const Rule = union(enum) {
    accept,
    reject,
    comparison: struct {
        op: enum { gt, lt },
        category: enum { x, m, a, s },
        value: u16,
        result: union(enum) { accept, reject, workflow: []const u8 },
    },
    workflow: []const u8,
};

const Workflow = struct {
    rules: [4]Rule,

    fn fromString(s: []const u8) !Workflow {
        var s_it = std.mem.splitScalar(u8, s[1 .. s.len - 1], ',');
        var workflow: Workflow = undefined;

        var i: usize = 0;
        while (s_it.next()) |rule_s| : (i += 1) {
            if (std.mem.eql(u8, rule_s, "A")) {
                workflow.rules[i] = .{ .accept = {} };
            } else if (std.mem.eql(u8, rule_s, "R")) {
                workflow.rules[i] = .{ .reject = {} };
            } else if (rule_s[1] == '>' or rule_s[1] == '<') {
                const sepResult = std.mem.indexOfScalar(u8, rule_s, ':');
                const sep = sepResult orelse return error.InvalidWorkflow;

                workflow.rules[i] = .{
                    .comparison = .{
                        .op = if (rule_s[1] == '>') .gt else .lt,
                        .category = switch (rule_s[0]) {
                            'x' => .x,
                            'm' => .m,
                            'a' => .a,
                            's' => .s,
                            else => return error.InvalidWorkflow,
                        },
                        .value = try std.fmt.parseInt(u16, rule_s[2..sep], 10),
                        .result = blk: {
                            var result_s = rule_s[sep + 1 ..];

                            if (std.mem.eql(u8, result_s, "A")) {
                                break :blk .{ .accept = {} };
                            } else if (std.mem.eql(u8, result_s, "R")) {
                                break :blk .{ .reject = {} };
                            }

                            break :blk .{ .workflow = result_s };
                        },
                    },
                };
            } else {
                workflow.rules[i] = .{ .workflow = rule_s };
            }
        }

        return workflow;
    }
};

const Engine = struct {
    workflows: std.StringArrayHashMap(Workflow),

    fn init(allocator: std.mem.Allocator) Engine {
        return .{
            .workflows = std.StringArrayHashMap(Workflow).init(allocator),
        };
    }

    fn deinit(self: *Engine) void {
        self.workflows.deinit();
    }

    fn addWorkflow(self: *Engine, name: []const u8, workflow: Workflow) !void {
        try self.workflows.put(name, workflow);
    }

    fn getWorkflow(self: Engine, name: []const u8) !Workflow {
        return self.workflows.get(name) orelse error.MissingWorkflow;
    }

    fn isAccepted(self: Engine, part: Part) !bool {
        var workflow = try self.getWorkflow("in");

        while (true) {
            for (workflow.rules) |rule| {
                switch (rule) {
                    .accept => return true,
                    .reject => return false,
                    .comparison => |c| {
                        const test_value = switch (c.category) {
                            .x => part.x,
                            .m => part.m,
                            .a => part.a,
                            .s => part.s,
                        };

                        const applies = switch (c.op) {
                            .gt => test_value > c.value,
                            .lt => test_value < c.value,
                        };

                        if (!applies) continue;

                        switch (c.result) {
                            .accept => return true,
                            .reject => return false,
                            .workflow => |w| {
                                workflow = try self.getWorkflow(w);
                                break;
                            },
                        }
                    },
                    .workflow => |w| {
                        workflow = try self.getWorkflow(w);
                        break;
                    },
                }
            }
        }
    }
};

fn getRatingSum(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var engine = Engine.init(allocator);
    defer engine.deinit();

    var input_it = std.mem.splitScalar(u8, input, '\n');

    while (input_it.next()) |line| {
        if (line.len == 0) break;

        const workflowStartResult = std.mem.indexOfScalar(u8, line, '{');
        const workflowStart = workflowStartResult orelse return error.InvalidWorkflow;

        const name = line[0..workflowStart];
        const workflow = try Workflow.fromString(line[workflowStart..]);

        try engine.addWorkflow(name, workflow);
    }

    var sum: u64 = 0;

    while (input_it.next()) |line| {
        const part = try Part.fromString(line);

        if (try engine.isAccepted(part)) {
            sum += part.getRating();
        }
    }

    return sum;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const sum = try getRatingSum(input, allocator);
    try stdout.print("{}\n", .{sum});
}
