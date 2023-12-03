const std = @import("std");

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    const red_count = 12;
    const green_count = 13;
    const blue_count = 14;

    var sum: u32 = 0;
    var buf: [256]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = std.mem.splitScalar(u8, line, ' ');

        _ = iter.next();
        const id_str = iter.next().?;

        while (iter.next()) |num_str| {
            const int = try std.fmt.parseInt(u8, num_str, 10);
            const color = iter.next().?;

            const over = switch (color[0]) {
                'r' => int > red_count,
                'g' => int > green_count,
                'b' => int > blue_count,
                else => false,
            };

            if (over) {
                break;
            }
        } else {
            sum += try std.fmt.parseInt(u8, id_str[0 .. id_str.len - 1], 10);
        }
    }

    try stdout.print("{}\n", .{sum});
}
