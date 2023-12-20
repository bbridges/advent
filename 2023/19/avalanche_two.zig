const std = @import("std");

const Range = struct {
    start: u64,
    stop: u64,
};

const PartRange = struct {
    x: Range,
    m: Range,
    a: Range,
    s: Range,

    fn getCount(self: PartRange) u64 {
        return (self.x.stop - self.x.start + 1) *
            (self.m.stop - self.m.start + 1) *
            (self.a.stop - self.a.start + 1) *
            (self.s.stop - self.s.start + 1);
    }
};

const Rule = union(enum) {
    accept,
    reject,
    comparison: struct {
        op: enum { gt, lt },
        category: enum { x, m, a, s },
        value: u64,
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
                        .value = try std.fmt.parseInt(u64, rule_s[2..sep], 10),
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

    fn getAcceptedCount(self: Engine, part_range: PartRange, workflow: []const u8) !u64 {
        var r = part_range;
        var count: u64 = 0;

        for ((try self.getWorkflow(workflow)).rules) |rule| {
            switch (rule) {
                .accept => {
                    count += r.getCount();
                    break;
                },
                .reject => {
                    break;
                },
                .comparison => |c| {
                    var sub_r = r;

                    var r_edit: *Range = undefined;
                    var sub_r_edit: *Range = undefined;

                    switch (c.category) {
                        .x => {
                            r_edit = &r.x;
                            sub_r_edit = &sub_r.x;
                        },
                        .m => {
                            r_edit = &r.m;
                            sub_r_edit = &sub_r.m;
                        },
                        .a => {
                            r_edit = &r.a;
                            sub_r_edit = &sub_r.a;
                        },
                        .s => {
                            r_edit = &r.s;
                            sub_r_edit = &sub_r.s;
                        },
                    }

                    switch (c.op) {
                        .gt => {
                            sub_r_edit.*.start = @max(sub_r_edit.*.start, c.value + 1);
                            r_edit.*.stop = @min(r_edit.*.stop, c.value);
                        },
                        .lt => {
                            sub_r_edit.*.stop = @min(sub_r_edit.*.stop, c.value - 1);
                            r_edit.*.start = @max(r_edit.*.start, c.value);
                        },
                    }

                    if (sub_r_edit.*.stop <= sub_r_edit.*.start) continue;

                    switch (c.result) {
                        .accept => count += sub_r.getCount(),
                        .reject => {},
                        .workflow => |w| count += try self.getAcceptedCount(sub_r, w),
                    }

                    if (r_edit.*.stop <= r_edit.*.start) continue;
                },
                .workflow => |w| {
                    count += try self.getAcceptedCount(r, w);
                    break;
                },
            }
        }

        return count;
    }
};

fn getRatingCombinations(input: []const u8, allocator: std.mem.Allocator) !u64 {
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

    return engine.getAcceptedCount(.{
        .x = .{ .start = 1, .stop = 4000 },
        .m = .{ .start = 1, .stop = 4000 },
        .a = .{ .start = 1, .stop = 4000 },
        .s = .{ .start = 1, .stop = 4000 },
    }, "in");
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const combinations = try getRatingCombinations(input, allocator);
    try stdout.print("{}\n", .{combinations});
}
