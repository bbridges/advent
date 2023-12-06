const std = @import("std");

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var lines_it = std.mem.splitScalar(u8, input, '\n');

    // Get initial values.
    const ValueRange = struct { start: u64, len: u64 };

    var value_ranges = std.ArrayList(ValueRange).init(allocator);
    defer value_ranges.deinit();

    var init_values_it = std.mem.splitScalar(u8, lines_it.next().?, ' ');
    _ = init_values_it.next();

    while (init_values_it.next()) |v| {
        const start = try std.fmt.parseInt(u64, v, 10);
        const len = try std.fmt.parseInt(u64, init_values_it.next().?, 10);

        try value_ranges.append(.{ .start = start, .len = len });
    }

    // Clear empty line.
    _ = lines_it.next();

    const Mapping = struct { src: u64, dest: u64, len: u64 };

    var mappings_list = std.ArrayList(std.ArrayList(Mapping)).init(allocator);
    defer {
        for (mappings_list.items) |m| {
            m.deinit();
        }
        mappings_list.deinit();
    }

    // Find the mapping for each section.
    // Clear map description line before each.
    while (lines_it.next()) |_| {
        var mappings = std.ArrayList(Mapping).init(allocator);

        while (lines_it.next()) |line| {
            if (line.len == 0) break;

            var line_it = std.mem.splitScalar(u8, line, ' ');

            const dest = try std.fmt.parseInt(u64, line_it.next().?, 10);
            const src = try std.fmt.parseInt(u64, line_it.next().?, 10);
            const len = try std.fmt.parseInt(u64, line_it.next().?, 10);

            try mappings.append(.{ .src = src, .dest = dest, .len = len });
        }

        try mappings_list.append(mappings);
    }

    var lowest: u64 = std.math.maxInt(u64);

    // Apply all mappings one value at a time and find the lowest.
    for (value_ranges.items) |vr| {
        for (vr.start..vr.start + vr.len) |v| {
            var value: u64 = v;

            for (mappings_list.items) |ml| {
                for (ml.items) |m| {
                    if (value >= m.src and value < m.src + m.len) {
                        value = value - m.src + m.dest;
                        break;
                    }
                }
            }

            lowest = @min(lowest, value);
        }
    }

    try stdout.print("{}\n", .{lowest});
}
