const std = @import("std");

fn getPoints(line: []const u8) !u32 {
    var line_it = std.mem.splitAny(u8, line, ":|");

    _ = line_it.next();
    var winners_it = std.mem.splitScalar(u8, line_it.next().?, ' ');
    var numbers_it = std.mem.splitScalar(u8, line_it.next().?, ' ');

    var win_count: u32 = 0;

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

    return if (win_count == 0) 0 else std.math.pow(u32, 2, win_count - 1);
}

fn getPointTotal(input: []const u8) !u32 {
    var sum: u32 = 0;
    var it = std.mem.splitScalar(u8, input, '\n');

    while (it.next()) |line| {
        sum += try getPoints(line);
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

    const sum = try getPointTotal(input);
    try stdout.print("{}\n", .{sum});
}
