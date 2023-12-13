const std = @import("std");

fn getMirrorNumber(pattern: []const u8) !u64 {
    const w = std.mem.indexOfScalar(u8, pattern, '\n') orelse return error.MissingNewline;
    const h = 1 + pattern.len / (w + 1);

    outer: for (1..h) |row| {
        for (0..@min(row, h - row)) |i| {
            for (0..w) |j| {
                if (pattern[(w + 1) * (row - i - 1) + j] != pattern[(w + 1) * (row + i) + j]) {
                    continue :outer;
                }
            }
        }

        return 100 * row;
    }

    outer: for (1..w) |col| {
        for (0..@min(col, w - col)) |j| {
            for (0..h) |i| {
                if (pattern[(w + 1) * i + col - j - 1] != pattern[(w + 1) * i + col + j]) {
                    continue :outer;
                }
            }
        }

        return col;
    }

    return error.NoSymmetry;
}

fn getMirrorNumberSum(input: []const u8) !u64 {
    var sum: u64 = 0;

    var i: usize = 0;
    var j: usize = 0;

    while (j < input.len) {
        if (input[j] == '\n' and input[j + 1] == '\n') {
            sum += try getMirrorNumber(input[i..j]);

            j += 2;
            i = j;
        } else {
            j += 1;
        }
    }

    sum += try getMirrorNumber(input[i..]);

    return sum;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var sum = try getMirrorNumberSum(input);
    try stdout.print("{}\n", .{sum});
}
