const std = @import("std");

fn getLoad(input: []const u8) !u64 {
    const w = 1 + (std.mem.indexOfScalar(u8, input, '\n') orelse return error.MissingNewline);
    const h = 1 + input.len / w;

    var load: u64 = 0;

    for (0..w - 1) |j| {
        var i: usize = 0;
        var rock_start: usize = 0;
        var round_rocks: u64 = 0;

        while (i < h) : (i += 1) {
            switch (input[w * i + j]) {
                'O' => round_rocks += 1,
                '#' => {
                    for (0..round_rocks) |k| load += h - rock_start - k;

                    rock_start = i + 1;
                    round_rocks = 0;
                },
                else => {},
            }
        }

        for (0..round_rocks) |k| load += h - rock_start - k;
    }

    return load;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var load = try getLoad(input);
    try stdout.print("{}\n", .{load});
}
