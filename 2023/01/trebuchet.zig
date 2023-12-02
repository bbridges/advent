const std = @import("std");

pub fn getDigit(value: u8) ?u8 {
    if (value >= '0' and value <= '9') {
        return value - '0';
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
            if (getDigit(line[i])) |digit| {
                sum += 10 * digit;
                break;
            }

            i += 1;
        }

        i = length - 1;

        while (i >= 0) {
            if (getDigit(line[i])) |digit| {
                sum += digit;
                break;
            }

            i -= 1;
        }
    }

    try stdout.print("{}\n", .{sum});
}
