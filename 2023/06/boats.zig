const std = @import("std");

const Race = struct { time: u32, dist: u32 };

fn getErrorMargin(races: []const Race) !u64 {
    var error_margin: u64 = 1;

    for (races) |race| {
        var faster_count: u64 = 0;

        for (0..race.time + 1) |wait| {
            if (wait * (race.time - wait) > race.dist) {
                faster_count += 1;
            }
        }

        error_margin *= faster_count;
    }

    return error_margin;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var races = std.ArrayList(Race).init(allocator);
    defer races.deinit();

    var line_1_it = std.mem.tokenizeScalar(u8, input[9 .. input.len / 2], ' ');
    var line_2_it = std.mem.tokenizeScalar(u8, input[10 + input.len / 2 ..], ' ');

    while (line_1_it.next()) |time_str| {
        const dist_str = line_2_it.next().?;

        const time = try std.fmt.parseInt(u32, time_str, 10);
        const dist = try std.fmt.parseInt(u32, dist_str, 10);

        try races.append(Race{ .time = time, .dist = dist });
    }

    const error_margin = try getErrorMargin(races.items);
    try stdout.print("{}\n", .{error_margin});
}
