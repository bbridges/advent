const std = @import("std");
const Allocator = std.mem.Allocator;

const Cache = struct {
    allocator: Allocator,
    hash_map: std.StringHashMap(u64),

    fn init(allocator: Allocator) Cache {
        return .{
            .allocator = allocator,
            .hash_map = std.StringHashMap(u64).init(allocator),
        };
    }

    fn deinit(self: *Cache) void {
        var it = self.hash_map.keyIterator();

        while (it.next()) |key| {
            self.allocator.free(key.*);
        }

        self.hash_map.deinit();
    }

    fn get(self: *Cache, key: []u8) ?u64 {
        return self.hash_map.get(key);
    }

    fn put(self: *Cache, key: []u8, value: u64) Allocator.Error!void {
        return self.hash_map.put(key, value);
    }

    fn getKey(self: *Cache, row: []u8, groups: []u8) Allocator.Error![]u8 {
        var key = try self.allocator.alloc(u8, row.len + groups.len);

        @memcpy(key[0..row.len], row);
        @memcpy(key[row.len..], groups);

        return key;
    }
};

fn getArrangements(row: []u8, groups: []u8, rem: isize, cache: *Cache) Allocator.Error!u64 {
    // Atempt to get the key from the cache first.
    var key = try cache.getKey(row, groups);
    errdefer cache.allocator.free(key);

    if (cache.get(key)) |count| return count;

    const count = try getArrangementsInner(row, groups, rem, cache);
    try cache.put(key, count);

    return count;
}

fn getArrangementsInner(row: []u8, groups: []u8, rem: isize, cache: *Cache) Allocator.Error!u64 {
    // When there's no more groups, verify no "#"s exist.
    if (groups.len == 0) {
        return if (std.mem.indexOfScalar(u8, row, '#') == null) 1 else 0;
    }

    // Not enough space to finish.
    if (row.len < rem) return 0;

    if (std.mem.indexOfScalar(u8, row[0..groups[0]], '.') == null) {
        // A potential match was found.

        // All is great if we're at the end.
        if (groups.len == 1 and row.len == groups[0]) return 1;

        // If it doesn't end with "#", then we have a match.
        // If the group started explicitly, then the group
        // needs to be removed.
        if (row[groups[0]] != '#') {
            if (row[0] == '#') {
                return try getArrangements(row[groups[0] + 1 ..], groups[1..], rem - groups[0] - 1, cache);
            }

            return try getArrangements(row[1..], groups, rem, cache) +
                try getArrangements(row[groups[0] + 1 ..], groups[1..], rem - groups[0] - 1, cache);
        }
    }

    // Any "#"s have to be matched.
    if (row[0] == '#') {
        return 0;
    }

    // No match was found, continue.
    return try getArrangements(row[1..], groups, rem, cache);
}

fn getArrangementsSum(input: []u8, allocator: Allocator) !u64 {
    var cache = Cache.init(allocator);
    defer cache.deinit();

    var sum: u64 = 0;
    var i: usize = 0;

    while (i < input.len) {
        // Read the row of data up until the space and repeat it 5 times
        // with a "?" separator.
        var j = i;
        while (input[j] != ' ') j += 1;

        var row = try allocator.alloc(u8, (j - i) * 5 + 4);
        defer allocator.free(row);

        for (0..5) |k| {
            @memcpy(row[k + k * (j - i) .. k + (k + 1) * (j - i)], input[i..j]);
        }

        for (1..5) |k| {
            row[k + k * (j - i) - 1] = '?';
        }

        // Count commas to allocate the group.
        var group_count: usize = 1;
        j += 1;
        i = j;
        while (j < input.len and input[j] != '\n') : (j += 1) {
            if (input[j] == ',') group_count += 1;
        }

        var groups = try allocator.alloc(u8, group_count * 5);
        defer allocator.free(groups);

        // Parse numbers and insert them into the group 5 times.
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

        for (1..5) |k| {
            @memcpy(groups[k * group_count .. (k + 1) * group_count], groups[0..group_count]);
        }

        // Compute the minimum length of groups all in a row.
        var min_len = groups[0];

        for (1..groups.len) |k| {
            min_len += 1 + groups[k];
        }

        // Add the number of arrangements to the sum.
        sum += try getArrangements(row, groups, min_len, &cache);
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
