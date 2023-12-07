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

pub fn rule(cards: Cards) Rule {
    var set = Set.initEmpty();
    var count: [AMOUNT]u8 = [_]u8{0} ** AMOUNT;
    var max: u8 = 0;

    for (cards) |c| {
        const i = c - LOW;
        set.set(i);
        count[i] += 1;
        if (count[i] > max) max = count[i];
    }

    return switch (set.count()) {
        1 => Rule.Five,
        2 => if (max == 4) Rule.Four else Rule.Full,
        3 => if (max == 3) Rule.Three else Rule.Two,
        4 => Rule.One,
        else => Rule.High,
    };
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
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

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
