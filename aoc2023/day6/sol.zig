const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const math = std.math;

const numt = i64;
const fltt = f64;
const List = std.ArrayList(numt);

pub fn main() !void {
    var input: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    var times = List.init(allocator);
    defer times.deinit();

    var line = try stdin.readUntilDelimiterOrEof(&input, '\n');
    var split = mem.splitScalar(u8, line orelse "", ':');
    _ = split.next();
    var nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');

    while (nsplit.next()) |elem| {
        if (elem.len == 0 or elem[0] == ' ') continue;
        try times.append(try fmt.parseInt(numt, elem, 10));
    }

    line = try stdin.readUntilDelimiterOrEof(&input, '\n');
    split = mem.splitScalar(u8, line orelse "", ':');
    _ = split.next();
    nsplit = mem.splitScalar(u8, split.next() orelse "", ' ');

    var prod: numt = 1;
    var i: usize = 0;

    while (nsplit.next()) |elem| {
        if (elem.len == 0 or elem[0] == ' ') continue;
        var tmp = try fmt.parseInt(numt, elem, 10);
        tmp = times.items[i] * times.items[i] - 4 * tmp;
        var del = math.sqrt(@as(fltt, @floatFromInt(tmp)));
        var b = @as(fltt, @floatFromInt(times.items[i]));
        var s1 = @as(numt, @intFromFloat(math.floor((-b - del) / 2)));
        var s2 = @as(numt, @intFromFloat(math.ceil((-b + del) / 2)));
        tmp = s2 - s1 - 1;
        prod *= tmp;
        i += 1;
    }

    try stdout.print("{}\n", .{prod});
}
