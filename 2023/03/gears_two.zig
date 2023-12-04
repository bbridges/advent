const std = @import("std");

fn isDigit(input: []u8, w: usize, x: usize, y: usize) bool {
    const value = input[x * (w + 1) + y];
    return value >= '0' and value <= '9';
}

fn getNumber(input: []u8, w: usize, x: usize, y: usize) !u32 {
    var y1: usize = y;
    var y2: usize = y + 1;

    while (y1 > 0 and isDigit(input, w, x, y1 - 1)) : (y1 -= 1) {}
    while (y2 < w and isDigit(input, w, x, y2)) : (y2 += 1) {}

    return try std.fmt.parseInt(u16, input[x * (w + 1) + y1 .. x * (w + 1) + y2], 10);
}

fn getGearRatio(input: []u8, w: usize, x: usize, y: usize) !u32 {
    var count: u8 = 0;
    var ratio: u32 = 1;

    if (y > 0) {
        if (isDigit(input, w, x, y - 1)) {
            count += 1;
            ratio *= try getNumber(input, w, x, y - 1);
        }
    }

    if (y < w - 1) {
        if (isDigit(input, w, x, y + 1)) {
            count += 1;
            ratio *= try getNumber(input, w, x, y + 1);
        }
    }

    if (x > 0) {
        if (isDigit(input, w, x - 1, y)) {
            count += 1;
            ratio *= try getNumber(input, w, x - 1, y);
        } else {
            if (y > 0 and isDigit(input, w, x - 1, y - 1)) {
                count += 1;
                ratio *= try getNumber(input, w, x - 1, y - 1);
            }

            if (y < w - 1 and isDigit(input, w, x - 1, y + 1)) {
                count += 1;
                ratio *= try getNumber(input, w, x - 1, y + 1);
            }
        }
    }

    if (x < w - 1) {
        if (isDigit(input, w, x + 1, y)) {
            count += 1;
            ratio *= try getNumber(input, w, x + 1, y);
        } else {
            if (y > 0 and isDigit(input, w, x + 1, y - 1)) {
                count += 1;
                ratio *= try getNumber(input, w, x + 1, y - 1);
            }

            if (y < w - 1 and isDigit(input, w, x + 1, y + 1)) {
                count += 1;
                ratio *= try getNumber(input, w, x + 1, y + 1);
            }
        }
    }

    return if (count == 2) ratio else 0;
}

fn getGearRatioSum(input: []u8) !u32 {
    var sum: u32 = 0;

    var x: usize = 0;
    var it = std.mem.splitScalar(u8, input, '\n');
    const w = it.peek().?.len;

    while (it.next()) |line| : (x += 1) {
        var y: usize = 0;

        while (y < w) : (y += 1) {
            if (line[y] == '*') {
                sum += try getGearRatio(input, w, x, y);
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

    const sum = try getGearRatioSum(input);
    try stdout.print("{}\n", .{sum});
}
