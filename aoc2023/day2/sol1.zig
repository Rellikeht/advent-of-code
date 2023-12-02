const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;

const colors = [_]i32{ 12, 13, 14 };

pub fn main() !void {
    var input: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var sum: i32 = 0;

    lines: while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var split = mem.splitScalar(u8, line, ':');
        var nsplit = mem.splitScalar(u8, split.first(), ' ');
        _ = nsplit.next();
        var id = try fmt.parseInt(i32, nsplit.next() orelse "-999999", 10);

        split = mem.splitScalar(u8, split.next() orelse "", ';');
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

                var num = try fmt.parseInt(i32, numStr, 10);
                if (num > colors[i]) continue :lines;
            }
        }

        sum += id;
    }

    try stdout.print("{}\n", .{sum});
}
