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
                '2'...'9' => c - '2',
                'T' => 8,
                'J' => 9,
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

        var found_three = false;
        var found_two = false;
        var found_one = false;

        for (found) |f| {
            switch (f) {
                5 => return 7, // five-of-a-kind
                4 => return 6, // four-of-a-kind
                3 => {
                    if (found_two) return 5; // full house
                    if (found_one) return 4; // three-of-a-kind

                    found_three = true;
                },
                2 => {
                    if (found_three) return 5; // full house
                    if (found_two) return 3; // two pair

                    found_two = true;
                },
                1 => {
                    if (found_three) return 4; // three-of-a-kind

                    found_one = true;
                },
                else => {},
            }
        }

        if (found_two) return 2; // one pair

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
