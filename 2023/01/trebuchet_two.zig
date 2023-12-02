const std = @import("std");

pub fn getDigit(line: []u8, pos: usize, comptime reverse: bool) ?u8 {
    const value = line[pos];

    if (value >= '0' and value <= '9') {
        return value - '0';
    }

    const comparer = if (reverse) std.mem.endsWith else std.mem.startsWith;
    const slice = if (reverse) line[0..(pos + 1)] else line[pos..];

    if (comparer(u8, slice, "zero")) {
        return 0;
    } else if (comparer(u8, slice, "one")) {
        return 1;
    } else if (comparer(u8, slice, "two")) {
        return 2;
    } else if (comparer(u8, slice, "three")) {
        return 3;
    } else if (comparer(u8, slice, "four")) {
        return 4;
    } else if (comparer(u8, slice, "five")) {
        return 5;
    } else if (comparer(u8, slice, "six")) {
        return 6;
    } else if (comparer(u8, slice, "seven")) {
        return 7;
    } else if (comparer(u8, slice, "eight")) {
        return 8;
    } else if (comparer(u8, slice, "nine")) {
        return 9;
    }

    return null;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var sum: u32 = 0;
    var buf: [128]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const length = line.len;

        var i: usize = 0;

        while (i < length) {
            if (getDigit(line, i, false)) |digit| {
                sum += 10 * digit;
                break;
            }

            i += 1;
        }

        i = length - 1;

        while (i >= 0) {
            if (getDigit(line, i, true)) |digit| {
                sum += digit;
                break;
            }

            i -= 1;
        }
    }

    try stdout.print("{}\n", .{sum});
}
