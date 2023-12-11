const std = @import("std");

fn getStepsToFarthest(input: []const u8) u32 {
    const w = 1 + @as(isize, @bitCast(std.mem.indexOfScalar(u8, input, '\n').?));
    const start = @as(isize, @bitCast(std.mem.indexOfScalar(u8, input, 'S').?));

    var move: isize = 1;

    if (start < w) {
        var down = input[@bitCast(start + w)];
        if (down == 'J' or down == '|' or down == 'L') move = w;
    } else {
        var up = input[@bitCast(start - w)];
        if (up == '7' or up == '|' or up == 'F') move = -w;

        var down = input[@bitCast(start + w)];
        if (down == 'J' or down == '|' or down == 'L') move = w;
    }

    var steps: u32 = 1;
    var i = start + move;

    while (i != start) : (i += move) {
        steps += 1;

        switch (input[@bitCast(i)]) {
            'J' => move = if (move == 1) -w else -1,
            'L' => move = if (move == -1) -w else 1,
            'F' => move = if (move == -1) w else 1,
            '7' => move = if (move == 1) w else -1,
            else => {},
        }
    }

    return steps / 2;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var steps = getStepsToFarthest(input);
    try stdout.print("{}\n", .{steps});
}
