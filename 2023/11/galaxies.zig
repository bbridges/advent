const std = @import("std");

fn getPairLengthSum(input: []const u8, allocator: std.mem.Allocator) !u64 {
    const w = std.mem.indexOfScalar(u8, input, '\n') orelse return error.MissingNewline;

    var row_counts = try allocator.alloc(u32, w);
    defer allocator.free(row_counts);
    var col_counts = try allocator.alloc(u32, w);
    defer allocator.free(col_counts);

    for (0..w) |i| {
        row_counts[i] = 0;
        col_counts[i] = 0;
    }

    for (0..input.len) |i| {
        if (input[i] == '#') {
            row_counts[i / (w + 1)] += 1;
            col_counts[i % (w + 1)] += 1;
        }
    }

    var sum: u64 = 0;

    for (0..w) |i| {
        var x_dist: u64 = 0;
        var y_dist: u64 = 0;

        for (i + 1..w) |j| {
            if (row_counts[j] == 0) {
                x_dist += 2;
            } else {
                x_dist += 1;
                sum += row_counts[j] * row_counts[i] * x_dist;
            }

            if (col_counts[j] == 0) {
                y_dist += 2;
            } else {
                y_dist += 1;
                sum += col_counts[j] * col_counts[i] * y_dist;
            }
        }
    }

    return sum;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var sum = try getPairLengthSum(input, allocator);
    try stdout.print("{}\n", .{sum});
}
