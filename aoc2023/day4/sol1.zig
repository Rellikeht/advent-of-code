const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const numt = i32;
const List = std.ArrayList(numt);
const Set = std.AutoHashMap(numt, void);

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

    var sum: i32 = 0;

    while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var split = mem.splitScalar(u8, line, ':');
        _ = split.next();
        split = mem.splitScalar(u8, split.next() orelse "", '|');

        inHand.clearRetainingCapacity();
        winning.clearRetainingCapacity();

        var nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');
        while (nsplit.next()) |elem| {
            if (elem.len == 0) continue;
            try winning.put(try fmt.parseInt(numt, elem, 10), {});
        }

        nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');
        while (nsplit.next()) |elem| {
            if (elem.len == 0) continue;
            try inHand.append(try fmt.parseInt(numt, elem, 10));
        }

        var value: numt = 0;
        for (inHand.items) |e| {
            if (winning.contains(e)) {
                if (value == 0) {
                    value = 1;
                } else {
                    value *= 2;
                }
            }
        }

        sum += value;
    }

    try stdout.print("{}\n", .{sum});
}
