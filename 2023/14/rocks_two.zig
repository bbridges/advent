const std = @import("std");

fn runTilt(input: []u8, w: usize, h: usize, comptime dir: enum { N, S, E, W }) void {
    // If doing a vertical tilt, and whether to tilt in the reverse.
    const vertical = dir == .N or dir == .S;
    const reverse = dir == .S or dir == .E;

    const rock = if (reverse) '.' else 'O';
    const other = if (reverse) 'O' else '.';

    for (0..if (vertical) w - 1 else h) |j| {
        var i: usize = 0;
        var start: usize = 0;
        var count: u64 = 0;

        while (true) : (i += 1) {
            var end = i == if (vertical) h else w - 1;

            if (!end) {
                var value = input[if (vertical) w * i + j else w * j + i];

                if (value == rock) {
                    count += 1;
                    continue;
                } else if (value != '#') {
                    continue;
                }
            }

            // Move all rocks up, and other ones down.
            for (start..start + count) |k| {
                input[if (vertical) w * k + j else w * j + k] = rock;
            }
            for (start + count..i) |k| {
                input[if (vertical) w * k + j else w * j + k] = other;
            }

            if (end) break;

            start = i + 1;
            count = 0;
        }
    }
}

fn runCycle(input: []u8, w: usize, h: usize) void {
    runTilt(input, w, h, .N);
    runTilt(input, w, h, .W);
    runTilt(input, w, h, .S);
    runTilt(input, w, h, .E);
}

fn getFinalLoad(input: []u8, allocator: std.mem.Allocator) !u64 {
    const w = 1 + (std.mem.indexOfScalar(u8, input, '\n') orelse return error.MissingNewline);
    const h = 1 + input.len / w;

    var input_2 = try allocator.alloc(u8, input.len);
    defer allocator.free(input_2);
    @memcpy(input_2, input);

    // Find the first time both inputs are the same with one of them
    // doing two cycles at a time.
    var i: u64 = 2;
    runCycle(input, w, h);
    runCycle(input, w, h);
    runCycle(input_2, w, h);

    while (!std.mem.eql(u8, input, input_2)) : (i += 2) {
        runCycle(input, w, h);
        runCycle(input, w, h);
        runCycle(input_2, w, h);
    }

    // Find how long it takes to repeat again.
    var c: u64 = 1;
    runCycle(input, w, h);

    while (!std.mem.eql(u8, input, input_2)) : (c += 1) runCycle(input, w, h);

    // Using the cycle repeat count, run cycles to the end.
    i += (1000000000 - i) / c * c;
    while (i < 1000000000) : (i += 1) runCycle(input, w, h);

    // Calculate the final load.
    var load: u64 = 0;

    for (0..input.len) |k| {
        if (input[k] == 'O') {
            load += h - k / w;
        }
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

    var load = try getFinalLoad(input, allocator);
    try stdout.print("{}\n", .{load});
}
