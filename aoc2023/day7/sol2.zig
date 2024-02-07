const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const math = std.math;

const numt = i64;
const CARDS = 5;
const Cards = [CARDS]u8;
const Hand = struct { cards: Cards, bid: numt };

const HIGH = 'T';
const LOW = '2';
const AMOUNT = HIGH - LOW + 1;

const List = std.ArrayList(Hand);
const Set = std.bit_set.IntegerBitSet(AMOUNT);

const Rule = enum(u8) { Five = 1, Four = 2, Full = 3, Three = 4, Two = 5, One = 6, High = 7 };

const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn rule(cards: Cards) Rule {
    var set = Set.initEmpty();
    var count: [AMOUNT]u8 = [_]u8{0} ** AMOUNT;
    var max: u8 = 0;
    var jockers: u8 = 0;

    for (cards) |c| {
        if (c == 'J') jockers += 1;
        const i = c - LOW;
        set.set(i);
        count[i] += 1;
        if (count[i] > max) max = count[i];
    }

    switch (set.count()) {
        1 => return Rule.Five,
        2 => {
            return if (jockers > 0) Rule.Five else if (max == 4) Rule.Four else Rule.Full;
        },

        // TODO
        // 3 => if (max == 3) Rule.Three else Rule.Two,
        // 4 => return Rule.One,
        // 5 => return Rule.High,
    }

    //     Five of a kind, where all five cards have the same label: AAAAA
    //     Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    //     Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
    //     Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
    //     Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
    //     One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
    //     High card, where all cards' labels are distinct: 23456

    // 32T3K 765
    // T55J5 684
    // KK677 28
    // KTJJT 220
    // QQQJA 483

    //     32T3K is still the only one pair; it doesn't contain any jokers, so its strength doesn't increase.
    //     KK677 is now the only two pair, making it the second-weakest hand.
    //     T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3, QQQJA gets rank 4, and KTJJT gets rank 5.

    // With the new joker rule, the total winnings in this example are 5905.

    //     switch (max + jockers) {
    //         5 => return Rule.Five,
    //         4 => return Rule.Four,
    //         3 => {
    //             var iter = set.iterator(.{});
    //             while (iter.next()) |el| {
    //                 _ = el;
    //                 // try stdout.print("{}\n", .{1});
    //             }
    //             return Rule.Three;
    //         },
    //         2 => {
    //             return Rule.Two;
    //         },
    //         else => return Rule.High,
    //     }

    //     return switch (set.count()) {
    //         1 => Rule.Five,
    //         2 => if (max == 4) Rule.Four else Rule.Full,
    //         3 => if (max == 3) Rule.Three else Rule.Two,
    //         4 => Rule.One,
    //         else => Rule.High,
    //     };

    return Rule.Full;
}

pub fn stronger(t: void, a: Hand, b: Hand) bool {
    _ = t;
    const ra = @intFromEnum(rule(a.cards));
    const rb = @intFromEnum(rule(b.cards));
    if (ra > rb) return true;
    if (ra < rb) return false;

    for (0..CARDS) |i| {
        var al = a.cards[i];
        var bl = b.cards[i];

        if (al <= '9') {
            if (al < bl) return true;
            if (al > bl) return false;
            continue;
        }
        if (bl <= '9') return false;

        // A J K Q T
        switch (al) {
            'A' => if (bl != 'A') return false,
            'K' => {
                if (bl == 'A') return true;
                if (bl != 'K') return false;
            },
            'Q' => {
                if (bl == 'A' or bl == 'K') return true;
                if (bl == 'J' or bl == 'T') return false;
            },
            'J' => {
                if (bl == 'T') return false;
                if (bl != 'J') return true;
            },
            'T' => if (bl != 'T') return true,
            else => {},
        }
    }

    return false;
}

pub fn main() !void {
    var input: [1024]u8 = undefined;

    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    var hands = List.init(allocator);
    defer hands.deinit();

    while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var split = mem.splitScalar(u8, line, ' ');
        var cards = split.next() orelse "";
        var bid = try fmt.parseInt(numt, split.next() orelse "99999", 10);
        var hand = Hand{ .cards = [_]u8{0} ** 5, .bid = bid };
        mem.copy(u8, &hand.cards, cards[0..CARDS]);
        try hands.append(hand);
    }

    mem.sort(Hand, hands.items, {}, stronger);

    var sum: numt = 0;
    var i: numt = 1;

    for (hands.items) |hand| {
        try stdout.print("{}\n", .{hand});
        sum += i * hand.bid;
        i += 1;
    }

    try stdout.print("{}\n", .{sum});
}
