const std = @import("std");

fn getHashSum(input: []const u8) u64 {
    var input_it = std.mem.splitScalar(u8, input, ',');
    var sum: u64 = 0;

    while (input_it.next()) |text| {
        var hash: u64 = 0;

        for (text) |c| hash = (hash + c) * 17 % 256;

        sum += hash;
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

    var sum = getHashSum(input);
    try stdout.print("{}\n", .{sum});
}
