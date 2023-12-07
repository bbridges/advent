const std = @import("std");

fn parseNumber(reader: std.fs.File.Reader) u64 {
    var number: u64 = 0;

    while (reader.readByte() catch null) |c| {
        if (c >= '0' and c <= '9') {
            number = 10 * number + c - '0';
        } else if (c == '\n') {
            return number;
        }
    }

    return number;
}

fn getRecordCount(time: u64, dist: u64) u64 {
    var wait: u64 = 0;

    while (wait <= time + 1) : (wait += 1) {
        if (wait * (time - wait) > dist) {
            return time - 2 * wait + 1;
        }
    }

    return 0;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    const time = parseNumber(stdin);
    const dist = parseNumber(stdin);

    const record_count = getRecordCount(time, dist);
    try stdout.print("{}\n", .{record_count});
}
