const std = @import("std");

const Hand = struct {
    cards: [5]u8,
    bet: usize,
    kind: u8,

    pub fn parse(string: []const u8) !Hand {
        var cards: [5]u8 = undefined;
        var bet = try std.fmt.parseInt(usize, string[6..], 10);

        for (0..5, string[0..5]) |i, c| {
            cards[i] = try switch (c) {
                'J' => 0,
                '2'...'9' => c - '1',
                'T' => 9,
                'Q' => 10,
                'K' => 11,
                'A' => 12,
                else => error.InvalidCard,
            };
        }

        return Hand{ .cards = cards, .bet = bet, .kind = kind(cards) };
    }

    pub fn winnings(hands: []Hand) usize {
        std.mem.sortUnstable(Hand, hands, {}, compare);

        var sum: usize = 0;

        for (1.., hands) |i, hand| {
            sum += i * hand.bet;
        }

        return sum;
    }

    fn compare(_: void, left: Hand, right: Hand) bool {
        if (left.kind < right.kind) return true;
        if (left.kind > right.kind) return false;

        return std.mem.lessThan(u8, &left.cards, &right.cards);
    }

    fn kind(cards: [5]u8) u8 {
        var found = std.mem.zeroes([13]u8);

        for (cards) |c| {
            found[c] += 1;
        }

        var j = found[0];

        var five: u8 = 0;
        var four: u8 = 0;
        var three: u8 = 0;
        var two: u8 = 0;

        for (found[1..]) |f| {
            switch (f) {
                5 => five += 1,
                4 => four += 1,
                3 => three += 1,
                2 => two += 1,
                else => {},
            }
        }

        if (five == 1) return 7; // five-of-a-kind
        if (four == 1 and j == 1) return 7; // five-of-a-kind
        if (three == 1 and j == 2) return 7; // five-of-a-kind
        if (two == 1 and j == 3) return 7; // five-of-a-kind
        if (j >= 4) return 7; // five-of-a-kind

        if (four == 1) return 6; // four-of-a-kind
        if (three == 1 and j == 1) return 6; // four-of-a-kind
        if (two == 1 and j == 2) return 6; // four-of-a-kind
        if (j == 3) return 6; // four-of-a-kind

        if (three == 1 and two == 1) return 5; // full house
        if (two == 2 and j == 1) return 5; // full house

        if (three == 1) return 4; // three-of-a-kind
        if (two == 1 and j == 1) return 4; // three-of-a-kind
        if (j == 2) return 4; // three-of-a-kind

        if (two == 2) return 3; // two pair
        if (two == 1 and j == 1) return 3; // two pair

        if (two == 1) return 2; // one pair
        if (j == 1) return 2; // one pair

        return 1; // high card
    }
};

pub fn main() !void {
    var stdin = std.io.getStdIn().reader();
    var stdout = std.io.getStdOut().writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const input = try stdin.readAllAlloc(allocator, std.math.maxInt(u32));
    defer allocator.free(input);

    var hands = std.ArrayList(Hand).init(allocator);
    defer hands.deinit();

    var input_it = std.mem.splitScalar(u8, input, '\n');

    while (input_it.next()) |line| {
        try hands.append(try Hand.parse(line));
    }

    const winnings = Hand.winnings(hands.items);
    try stdout.print("{}\n", .{winnings});
}
