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

    var total_steps: u64 = 1;
    var key_it = network.keyIterator();

    while (key_it.next()) |key_ptr| {
        var curr: []const u8 = key_ptr.*;
        if (curr[2] != 'A') continue;

        var steps: u32 = 0;

        while (curr[2] != 'Z') : (steps += 1) {
            var node = network.get(curr) orelse return error.NodeNotFound;
            var instruction = instructions[steps % instructions.len];

            curr = if (instruction == 'L') node.left else node.right;
        }

        total_steps = total_steps / std.math.gcd(total_steps, steps) * steps;
    }

    try stdout.print("{}\n", .{total_steps});
}
