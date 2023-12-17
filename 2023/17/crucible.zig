const std = @import("std");

const Dir = enum(usize) { Up, Down, Left, Right };

const Block = struct {
    x: usize,
    y: usize,
    dir: Dir,
    stride: u8,
    total_loss: usize,
    est_loss: usize,

    fn compare(_: void, left: Block, right: Block) std.math.Order {
        return std.math.order(left.est_loss, right.est_loss);
    }

    fn move(self: Block, input: []u8, w: usize, h: usize, comptime dir: Dir) ?Block {
        switch (dir) {
            .Up => {
                if (self.dir == .Down or self.x == 0 or
                    self.dir == .Up and self.stride == 3) return null;
            },
            .Down => {
                if (self.dir == .Up or self.x == h - 1 or
                    self.dir == .Down and self.stride == 3) return null;
            },
            .Left => {
                if (self.dir == .Right or self.y == 0 or
                    self.dir == .Left and self.stride == 3) return null;
            },
            .Right => {
                if (self.dir == .Left or self.y == w - 1 or
                    self.dir == .Right and self.stride == 3) return null;
            },
        }

        const new_x = switch (dir) {
            .Up => self.x - 1,
            .Down => self.x + 1,
            else => self.x,
        };
        const new_y = switch (dir) {
            .Left => self.y - 1,
            .Right => self.y + 1,
            else => self.y,
        };
        const new_total_loss = self.total_loss + input[(w + 1) * new_x + new_y] - '0';

        return Block{
            .x = new_x,
            .y = new_y,
            .dir = dir,
            .stride = if (self.dir == dir) self.stride + 1 else 1,
            .total_loss = new_total_loss,
            .est_loss = new_total_loss + h - new_x + w - new_y - 2,
        };
    }
};

fn getMinHeatLoss(input: []u8, allocator: std.mem.Allocator) !u64 {
    const w = std.mem.indexOfScalar(u8, input, '\n') orelse return error.MissingNewline;
    const h = 1 + input.len / (w + 1);

    var queue = std.PriorityQueue(Block, void, Block.compare).init(allocator, {});
    defer queue.deinit();

    var visited = try allocator.alloc([12]bool, input.len);
    defer allocator.free(visited);

    const start = Block{
        .x = 0,
        .y = 0,
        .dir = .Right,
        .stride = 0,
        .total_loss = 0,
        .est_loss = w + h - 2,
    };

    try queue.add(start.move(input, w, h, .Right).?);
    try queue.add(start.move(input, w, h, .Down).?);

    visited[1][@intFromEnum(Dir.Right)] = true;
    visited[w + 1][@intFromEnum(Dir.Down)] = true;

    while (queue.removeOrNull()) |block| {
        if (block.x == h - 1 and block.y == w - 1) return block.total_loss;

        inline for (.{ .Up, .Down, .Left, .Right }) |dir| {
            if (block.move(input, w, h, dir)) |new| {
                if (!visited[(w + 1) * new.x + new.y][@intFromEnum(new.dir) + (new.stride - 1) * 4]) {
                    try queue.add(new);

                    visited[(w + 1) * new.x + new.y][@intFromEnum(new.dir) + (new.stride - 1) * 4] = true;
                }
            }
        }
    }

    return error.EndNotFound;
}

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    const heat_loss = try getMinHeatLoss(input, allocator);
    try stdout.print("{}\n", .{heat_loss});
}
