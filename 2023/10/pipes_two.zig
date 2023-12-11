const std = @import("std");

fn getEnclosedCount(input: []u8) u32 {
    const w = 1 + @as(isize, @bitCast(std.mem.indexOfScalar(u8, input, '\n').?));
    const start = @as(isize, @bitCast(std.mem.indexOfScalar(u8, input, 'S').?));

    var start_move: isize = 1;

    if (start < w) {
        var down = input[@bitCast(start + w)];
        if (down == 'J' or down == '|' or down == 'L') start_move = w;
    } else {
        var up = input[@bitCast(start - w)];
        if (up == '7' or up == '|' or up == 'F') start_move = -w;

        var down = input[@bitCast(start + w)];
        if (down == 'J' or down == '|' or down == 'L') start_move = w;
    }

    var i = start + start_move;
    var prev: isize = 0;
    var move = start_move;

    while (i != start) : (i += move) {
        var next = switch (input[@bitCast(i)]) {
            'J' => if (move == 1) -w else -1,
            'L' => if (move == -1) -w else 1,
            'F' => if (move == -1) w else 1,
            '7' => if (move == 1) w else -1,
            '|' => {
                input[@bitCast(i)] = '#';
                continue;
            },
            '-' => {
                input[@bitCast(i)] = '=';
                continue;
            },
            else => unreachable,
        };

        input[@bitCast(i)] = if (prev * next > 1) '=' else '#';

        prev = move;
        move = next;
    }

    input[@bitCast(start)] = if (prev * start > 1) '=' else '#';

    var enclosed: u32 = 0;
    var inside = false;
    var len = @as(isize, @bitCast(input.len));
    i = 0;

    while (i < len) : (i += 1) {
        switch (input[@bitCast(i)]) {
            '#' => inside = !inside,
            '=' => {},
            else => {
                if (inside) enclosed += 1;
            },
        }
    }

    return enclosed;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var count = getEnclosedCount(input);
    try stdout.print("{}\n", .{count});
}
