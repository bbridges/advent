const std = @import("std");

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var sum: u32 = 0;
    var buf: [256]u8 = undefined;

    while (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var iter = std.mem.splitScalar(u8, line, ' ');

        _ = iter.next();
        _ = iter.next();

        var max_red: u32 = 0;
        var max_green: u32 = 0;
        var max_blue: u32 = 0;

        while (iter.next()) |num_str| {
            const int = try std.fmt.parseInt(u8, num_str, 10);
            const color = iter.next().?;

            switch (color[0]) {
                'r' => {
                    if (int > max_red) {
                        max_red = int;
                    }
                },
                'g' => {
                    if (int > max_green) {
                        max_green = int;
                    }
                },
                'b' => {
                    if (int > max_blue) {
                        max_blue = int;
                    }
                },
                else => {},
            }
        }

        sum += max_red * max_green * max_blue;
    }

    try stdout.print("{}\n", .{sum});
}
