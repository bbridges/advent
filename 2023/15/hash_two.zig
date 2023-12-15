const std = @import("std");

fn getHash(label: []const u8) u8 {
    var hash: u64 = 0;

    for (label) |c| hash = (hash + c) * 17 % 256;

    return @truncate(hash);
}

fn getFocusingPower(input: []const u8, allocator: std.mem.Allocator) !u64 {
    var boxes: [256]std.StringArrayHashMap(u8) = undefined;
    defer for (0..256) |i| boxes[i].deinit();

    for (0..256) |i| boxes[i] = std.StringArrayHashMap(u8).init(allocator);

    var input_it = std.mem.splitScalar(u8, input, ',');

    while (input_it.next()) |text| {
        if (text[text.len - 1] == '-') {
            const label = text[0 .. text.len - 1];
            const hash = getHash(label);

            _ = boxes[hash].orderedRemove(label);
        } else {
            const label = text[0 .. text.len - 2];
            const focal_length = text[text.len - 1] - '0';
            const hash = getHash(label);

            try boxes[hash].put(label, focal_length);
        }
    }

    var focusing_power: u64 = 0;

    for (0..256) |i| {
        var j: u64 = 1;

        for (boxes[i].values()) |f| {
            if (f != 0) {
                focusing_power += (i + 1) * j * f;
                j += 1;
            }
        }
    }

    return focusing_power;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var power = try getFocusingPower(input, allocator);
    try stdout.print("{}\n", .{power});
}
