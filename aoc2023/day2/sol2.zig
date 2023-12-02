const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

pub fn main() !void {
    var input: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    var sum: u64 = 0;

    while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var split = mem.splitAny(u8, line, ":;");
        _ = split.next();
        var colors = [_]u64{ 0, 0, 0 };

        while (split.next()) |elem| {
            var cols = mem.splitScalar(u8, elem, ' ');
            _ = cols.next();

            while (true) {
                var numStr = cols.next() orelse "";
                var col = cols.next() orelse "NOPE";

                if (numStr.len == 0) break;
                var i: usize = switch (col[0]) {
                    'r' => 0,
                    'g' => 1,
                    'b' => 2,
                    else => 999,
                };

                var num = try fmt.parseInt(u64, numStr, 10);
                if (colors[i] < num) colors[i] = num;
            }
        }

        var prod: u64 = 1;
        for (colors) |c| prod *= c;
        sum += prod;
    }

    try stdout.print("{}\n", .{sum});
}
