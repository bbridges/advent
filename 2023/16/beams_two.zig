const std = @import("std");

const Dir = enum(usize) { Up, Down, Left, Right, Vert, Horiz };

fn getEnergizedTiles(
    input: []const u8,
    w: usize,
    h: usize,
    start: struct { usize, Dir },
    allocator: std.mem.Allocator,
) !u64 {
    var visited = try allocator.alloc([4]bool, input.len);
    defer allocator.free(visited);

    @memset(visited, [4]bool{ false, false, false, false });

    var positions = std.ArrayList(struct { usize, Dir }).init(allocator);
    defer positions.deinit();

    try positions.append(start);

    while (positions.popOrNull()) |pos| {
        var i = pos[0];
        var d = pos[1];

        while (!visited[i][@intFromEnum(d)]) {
            visited[i][@intFromEnum(d)] = true;

            switch (input[i]) {
                '\\' => d = switch (d) {
                    .Up => .Left,
                    .Down => .Right,
                    .Left => .Up,
                    .Right => .Down,
                    else => unreachable,
                },
                '/' => d = switch (d) {
                    .Up => .Right,
                    .Down => .Left,
                    .Left => .Down,
                    .Right => .Up,
                    else => unreachable,
                },
                '|' => d = if (d == .Up or d == .Down) d else .Vert,
                '-' => d = if (d == .Left or d == .Right) d else .Horiz,
                else => {},
            }

            switch (d) {
                .Up => {
                    if (i / w == 0) break;
                    i -= w;
                },
                .Down => {
                    if (i / w == h - 1) break;
                    i += w;
                },
                .Left => {
                    if (i % w == 0) break;
                    i -= 1;
                },
                .Right => {
                    if (i % w == w - 2) break;
                    i += 1;
                },
                .Vert => {
                    if (i / w != 0) try positions.append(.{ i - w, .Up });
                    if (i / w != h - 1) try positions.append(.{ i + w, .Down });
                    break;
                },
                .Horiz => {
                    if (i % w != 0) try positions.append(.{ i - 1, .Left });
                    if (i % w != w - 2) try positions.append(.{ i + 1, .Right });
                    break;
                },
            }
        }
    }

    var energized: u64 = 0;

    for (visited) |v| {
        if (v[0] or v[1] or v[2] or v[3]) energized += 1;
    }

    return energized;
}

fn getMaxEnergizedTiles(input: []const u8, allocator: std.mem.Allocator) !u64 {
    const l = input.len;
    const w = 1 + (std.mem.indexOfScalar(u8, input, '\n') orelse return error.MissingNewline);
    const h = 1 + l / w;

    var max: u64 = 0;

    for (0..w - 1) |j| {
        const top = try getEnergizedTiles(input, w, h, .{ j, .Down }, allocator);
        const bottom = try getEnergizedTiles(input, w, h, .{ l - j - 1, .Up }, allocator);

        if (top > max) max = top;
        if (bottom > max) max = bottom;
    }

    for (0..h) |i| {
        const left = try getEnergizedTiles(input, w, h, .{ w * i, .Right }, allocator);
        const right = try getEnergizedTiles(input, w, h, .{ l - w * i - 1, .Left }, allocator);

        if (left > max) max = left;
        if (right > max) max = right;
    }

    return max;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const tiles = try getMaxEnergizedTiles(input, allocator);
    try stdout.print("{}\n", .{tiles});
}
