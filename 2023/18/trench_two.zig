const std = @import("std");

fn getStep(line: []const u8) !struct { x: i64, y: i64 } {
    const length = try std.fmt.parseInt(i64, line[line.len - 7 .. line.len - 2], 16);

    return switch (line[line.len - 2]) {
        '0' => .{ .x = length, .y = 0 },
        '1' => .{ .x = 0, .y = -length },
        '2' => .{ .x = -length, .y = 0 },
        '3' => .{ .x = 0, .y = length },
        else => error.InvalidDirection,
    };
}

fn getArea(input: []const u8) !u64 {
    var input_it = std.mem.splitScalar(u8, input, '\n');

    var perim: u64 = 0;
    var area: i64 = 0;
    var prev_x: i64 = 0;

    const first = try getStep(input_it.next().?);

    while (input_it.next()) |line| {
        const step = try getStep(line);

        perim += std.math.absCast(step.x + step.y);
        area += (2 * prev_x + step.x) * step.y;

        prev_x += step.x;
    }

    perim += std.math.absCast(first.x + first.y);
    area += (2 * prev_x + first.x) * first.y;

    return std.math.absCast(area) / 2 + perim / 2 + 1;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const area = try getArea(input);
    try stdout.print("{}\n", .{area});
}
