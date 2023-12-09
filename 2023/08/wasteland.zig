const std = @import("std");

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var input_it = std.mem.tokenizeScalar(u8, input, '\n');

    const Node = struct { left: []const u8, right: []const u8 };
    var network = std.StringHashMap(Node).init(allocator);
    defer network.deinit();

    const instructions = input_it.next() orelse return error.MissingInstructions;

    while (input_it.next()) |line| {
        var key = line[0..3];
        var node = .{ .left = line[7..10], .right = line[12..15] };

        try network.put(key, node);
    }

    var curr: []const u8 = network.getKey("AAA") orelse return error.StartNotFound;
    var goal: []const u8 = network.getKey("ZZZ") orelse return error.StopNotFound;
    var steps: u32 = 0;

    while (!std.mem.eql(u8, curr, goal)) : (steps += 1) {
        var node = network.get(curr) orelse return error.NodeNotFound;
        var instruction = instructions[steps % instructions.len];

        curr = if (instruction == 'L') node.left else node.right;
    }

    try stdout.print("{}\n", .{steps});
}
