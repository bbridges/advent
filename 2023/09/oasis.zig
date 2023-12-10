const std = @import("std");

pub fn getNextNumber(line: []const u8, allocator: std.mem.Allocator) !i32 {
    var count: usize = 0;
    var line_it = std.mem.splitScalar(u8, line, ' ');

    while (line_it.next()) |_| {
        count += 1;
    }

    var data = try allocator.alloc(i32, (count * count + count) / 2);
    defer allocator.free(data);

    var i: usize = 0;
    line_it.reset();

    while (line_it.next()) |num| : (i += 1) {
        data[i] = try std.fmt.parseInt(i32, num, 10);
    }

    i = 0;
    var curr_len = count;

    while (curr_len > 1) : (curr_len -= 1) {
        var done = true;
        var last_i = i + curr_len - 1;
        var row_start = data[i];

        while (i < last_i) : (i += 1) {
            data[i + curr_len] = data[i + 1] - data[i];

            if (data[i + 1] != row_start) done = false;
        }

        if (done) break;

        i += 1;
    } else {
        return error.NonZeroFinalState;
    }

    var next_number: i32 = 0;

    while (true) {
        next_number += data[i];

        if (curr_len == count) return next_number;

        i -= curr_len;
        curr_len += 1;
    }
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var input_it = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: i32 = 0;

    while (input_it.next()) |line| {
        sum += try getNextNumber(line, allocator);
    }

    try stdout.print("{}\n", .{sum});
}
