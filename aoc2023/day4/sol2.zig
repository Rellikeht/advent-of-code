const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const numt = i32;
const List = std.ArrayList(numt);
const Set = std.AutoHashMap(numt, void);
const Map = std.AutoHashMap(numt, numt);

pub fn main() !void {
    var input: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();

    var winning = Set.init(allocator);
    defer winning.deinit();
    var inHand = List.init(allocator);
    defer inHand.deinit();
    var cards = Map.init(allocator);
    defer cards.deinit();

    var sum: i32 = 0;

    while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var split = mem.splitScalar(u8, line, ':');
        var nsplit = mem.splitScalar(u8, split.first(), ' ');

        _ = nsplit.next();
        var nstr = nsplit.next() orelse "-999999";
        while (nstr.len == 0) nstr = nsplit.next() orelse "-999999";
        var id = try fmt.parseInt(i32, nstr, 10);

        split = mem.splitScalar(u8, split.next() orelse "", '|');
        nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');

        inHand.clearRetainingCapacity();
        winning.clearRetainingCapacity();
        try cards.put(id, (cards.get(id) orelse 0) + 1);

        while (nsplit.next()) |elem| {
            if (elem.len == 0) continue;
            var val = try fmt.parseInt(numt, elem, 10);
            try winning.put(val, {});
        }

        nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');
        while (nsplit.next()) |elem| {
            if (elem.len == 0) continue;
            var val = try fmt.parseInt(numt, elem, 10);
            try inHand.append(val);
        }

        var next = id;
        const cur = cards.get(id) orelse -9999;
        sum += cur;

        for (inHand.items) |e| {
            if (winning.contains(e)) {
                next += 1;
                try cards.put(next, (cards.get(next) orelse 0) + cur);
            }
        }
    }

    try stdout.print("{}\n", .{sum});
}
