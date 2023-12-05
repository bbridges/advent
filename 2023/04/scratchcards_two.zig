const std = @import("std");

fn getMatches(line: []const u8) !usize {
    var line_it = std.mem.splitAny(u8, line, ":|");

    _ = line_it.next();
    var winners_it = std.mem.splitScalar(u8, line_it.next().?, ' ');
    var numbers_it = std.mem.splitScalar(u8, line_it.next().?, ' ');

    var win_count: usize = 0;

    while (numbers_it.next()) |n| {
        if (n.len == 0) continue;

        while (winners_it.next()) |w| {
            if (w.len == 0) continue;

            if (std.mem.eql(u8, n, w)) {
                win_count += 1;
                break;
            }
        }

        winners_it.reset();
    }

    return win_count;
}

fn getScratchcardCount(input: []const u8, allocator: std.mem.Allocator) !usize {
    var count: usize = 0;
    var card_counts = std.AutoHashMap(usize, usize).init(allocator);
    defer card_counts.deinit();

    var it = std.mem.splitScalar(u8, input, '\n');
    var x: usize = 0;

    while (it.next()) |line| : (x += 1) {
        const matches = try getMatches(line);
        const x_count = if (card_counts.get(x)) |c| c else 1;

        count += x_count;

        for (x + 1..x + 1 + matches) |i| {
            if (card_counts.get(i)) |curr| {
                try card_counts.put(i, curr + x_count);
            } else {
                try card_counts.put(i, 1 + x_count);
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

    const count = try getScratchcardCount(input, allocator);
    try stdout.print("{}\n", .{count});
}
