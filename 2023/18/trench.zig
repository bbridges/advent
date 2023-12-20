const std = @import("std");

fn getArea(input: []u8, allocator: std.mem.Allocator) !u64 {
    var input_it = std.mem.splitScalar(u8, input, '\n');

    var i: isize = 0;
    var j: isize = 0;
    var min_i: isize = 0;
    var max_i: isize = 0;
    var min_j: isize = 0;
    var max_j: isize = 0;

    const Dir = enum { Up, Down, Left, Right };

    var steps = std.ArrayList(struct { dir: Dir, len: usize }).init(allocator);
    defer steps.deinit();

    while (input_it.next()) |line| {
        var line_it = std.mem.splitScalar(u8, line, ' ');

        const dir_s = line_it.next() orelse return error.MissingDirection;
        var dir: Dir = undefined;
        const len_s = line_it.next() orelse return error.MissingLength;
        const len = try (std.fmt.parseInt(usize, len_s, 10) catch error.InvalidLength);

        if (std.mem.eql(u8, dir_s, "U")) {
            dir = .Up;
            i -= @bitCast(len);
            if (i < min_i) min_i = i;
        } else if (std.mem.eql(u8, dir_s, "D")) {
            dir = .Down;
            i += @bitCast(len);
            if (i > max_i) max_i = i;
        } else if (std.mem.eql(u8, dir_s, "L")) {
            dir = .Left;
            j -= @bitCast(len);
            if (j < min_j) min_j = j;
        } else if (std.mem.eql(u8, dir_s, "R")) {
            dir = .Right;
            j += @bitCast(len);
            if (j > max_j) max_j = j;
        } else {
            return error.InvalidDirection;
        }

        try steps.append(.{ .dir = dir, .len = len });
    }

    const h: usize = @bitCast(max_i - min_i + 1);
    const w: usize = @bitCast(max_j - min_j + 1);

    var ground = try allocator.alloc(u8, h * w);
    defer allocator.free(ground);

    var x: usize = @bitCast(-min_i);
    var y: usize = @bitCast(-min_j);

    @memset(ground, ' ');

    var prev_dir = steps.getLast().dir;

    for (steps.items) |step| {
        switch (step.dir) {
            .Up => {
                ground[w * x + y] = if (prev_dir == .Left) 'R' else 'L';
                for (1..step.len) |k| ground[w * (x - k) + y] = '|';
                x -= step.len;
            },
            .Down => {
                ground[w * x + y] = if (prev_dir == .Left) 'L' else 'R';
                for (1..step.len) |k| ground[w * (x + k) + y] = '|';
                x += step.len;
            },
            .Left => {
                ground[w * x + y] = if (prev_dir == .Up) 'L' else 'R';
                for (1..step.len) |k| ground[w * x + y - k] = '-';
                y -= step.len;
            },
            .Right => {
                ground[w * x + y] = if (prev_dir == .Up) 'R' else 'L';
                for (1..step.len) |k| ground[w * x + y + k] = '-';
                y += step.len;
            },
        }

        prev_dir = step.dir;
    }

    var count: u64 = 0;

    x = 0;
    while (x < h) : (x += 1) {
        var inside = false;
        var corner: u8 = 0;

        y = 0;
        while (y < w) : (y += 1) {
            switch (ground[w * x + y]) {
                'L', 'R' => |c| {
                    if (corner == 0) {
                        corner = c;
                    } else {
                        inside = inside != (corner != c);
                        corner = 0;
                    }

                    count += 1;
                },
                '-' => {
                    count += 1;
                },
                '|' => {
                    inside = !inside;
                    count += 1;
                },
                else => {
                    if (inside) count += 1;
                },
            }
        }
    }

    return count;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const area = try getArea(input, allocator);
    try stdout.print("{}\n", .{area});
}
