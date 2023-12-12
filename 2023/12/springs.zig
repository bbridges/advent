const std = @import("std");

fn getArrangements(row: []u8, groups: []u8) u64 {
    // When there's no more groups, verify no "#"s exist.
    if (groups.len == 0) {
        return if (std.mem.indexOfScalar(u8, row, '#') == null) 1 else 0;
    }

    // Not enough space to finish.
    if (row.len < groups[0] or
        (groups.len > 1 and row.len < groups[0] + 1)) return 0;

    if (std.mem.indexOfScalar(u8, row[0..groups[0]], '.') == null) {
        // A potential match was found.

        // All is great if we're at the end.
        if (groups.len == 1 and row.len == groups[0]) return 1;

        // If it doesn't end with "#", then we have a match.
        // If the group started explicitly, then the group
        // needs to be removed.
        if (row[groups[0]] != '#') {
            if (row[0] == '#') {
                return getArrangements(row[groups[0] + 1 ..], groups[1..]);
            }

            return getArrangements(row[1..], groups) +
                getArrangements(row[groups[0] + 1 ..], groups[1..]);
        }
    }

    // Any "#"s have to be matched.
    if (row[0] == '#') {
        return 0;
    }

    // No match was found, continue.
    return getArrangements(row[1..], groups);
}

fn getArrangementsSum(input: []u8, allocator: std.mem.Allocator) !u64 {
    var sum: u64 = 0;
    var i: usize = 0;

    while (i < input.len) {
        // Read the row of data up until the space.
        var j = i;
        while (input[j] != ' ') j += 1;
        var row = input[i..j];

        // Count commas to allocate the group.
        var group_count: usize = 1;
        j += 1;
        i = j;
        while (j < input.len and input[j] != '\n') : (j += 1) {
            if (input[j] == ',') group_count += 1;
        }

        var groups = try allocator.alloc(u8, group_count);
        defer allocator.free(groups);

        // Parse numbers and insert them into the group.
        j = i;
        i = 0;
        while (i < group_count) : (i += 1) {
            groups[i] = 0;
            while (j < input.len and input[j] >= '0' and input[j] <= '9') : (j += 1) {
                groups[i] = groups[i] * 10 + input[j] - '0';
            }
            j += 1;
        }
        i = j;

        // Add the number of arrangements to the sum.
        sum += getArrangements(row, groups);
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

    var sum = try getArrangementsSum(input, allocator);
    try stdout.print("{}\n", .{sum});
}
