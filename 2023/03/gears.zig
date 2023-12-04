const std = @import("std");

fn isSymbol(input: []u8, w: usize, x: usize, y: usize) bool {
    return switch (input[x * (w + 1) + y]) {
        '.', '0'...'9' => false,
        else => return true,
    };
}

fn isPartNumber(input: []u8, w: usize, x: usize, y1: usize, y2: usize) bool {
    if (x > 0) {
        for (@max(1, y1) - 1..@min(w, y2 + 1)) |j| {
            if (isSymbol(input, w, x - 1, j)) return true;
        }
    }

    if (y1 > 0 and isSymbol(input, w, x, y1 - 1)) return true;
    if (y2 < w and isSymbol(input, w, x, y2)) return true;

    if (x < w - 1) {
        for (@max(1, y1) - 1..@min(w, y2 + 1)) |j| {
            if (isSymbol(input, w, x + 1, j)) return true;
        }
    }

    return false;
}

fn getPartNumberSum(input: []u8) !u32 {
    var sum: u32 = 0;

    var x: usize = 0;
    var it = std.mem.splitScalar(u8, input, '\n');
    const w = it.peek().?.len;

    while (it.next()) |line| : (x += 1) {
        var y: usize = 0;

        while (y < w) : (y += 1) {
            if (line[y] >= '0' and line[y] <= '9') {
                const start = y;
                y += 1;

                while (y < w and line[y] >= '0' and line[y] <= '9') : (y += 1) {}

                if (isPartNumber(input, w, x, start, y)) {
                    sum += try std.fmt.parseInt(u16, line[start..y], 10);
                }
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

    const sum = try getPartNumberSum(input);
    try stdout.print("{}\n", .{sum});
}
