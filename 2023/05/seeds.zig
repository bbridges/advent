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
    var values = std.ArrayList(u64).init(allocator);
    defer values.deinit();

    var init_values_it = std.mem.splitScalar(u8, lines_it.next().?, ' ');
    _ = init_values_it.next();

    while (init_values_it.next()) |v| {
        try values.append(try std.fmt.parseInt(u64, v, 10));
    }

    // Clear empty line.
    _ = lines_it.next();

    // Find the mapping for each section and update values.
    // Clear map description line before each.
    while (lines_it.next()) |_| {
        var mappings = std.ArrayList(struct { src: u64, dest: u64, len: u64 }).init(allocator);
        defer mappings.deinit();

        while (lines_it.next()) |line| {
            if (line.len == 0) break;

            var line_it = std.mem.splitScalar(u8, line, ' ');

            const dest = try std.fmt.parseInt(u64, line_it.next().?, 10);
            const src = try std.fmt.parseInt(u64, line_it.next().?, 10);
            const len = try std.fmt.parseInt(u64, line_it.next().?, 10);

            try mappings.append(.{ .src = src, .dest = dest, .len = len });
        }

        for (0.., values.items) |i, v| {
            for (mappings.items) |m| {
                if (v >= m.src and v < m.src + m.len) {
                    values.items[i] = v - m.src + m.dest;
                    break;
                }
            }
        }
    }

    // Find the lowest of the values and report it.
    const lowest = std.mem.min(u64, values.items);

    try stdout.print("{}\n", .{lowest});
}
