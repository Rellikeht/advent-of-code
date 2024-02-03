const std = @import("std");
const fmt = std.fmt;

const bufSize = 1024;
const ntype = i64;
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

pub fn sumFromLine(upper: []const u8, line: []const u8, lower: []const u8) !ntype {
    var buf: [bufSize]u8 = undefined;
    var sum: ntype = 0;
    var c: usize = 0;
    var i: usize = 0;
    var sym = false;

    while (c < line.len) {
        while ((c < line.len) and
            ((line[c] < '0') or
            (line[c] > '9'))) : (c += 1)
        {
            sym = upper[c] != '.' or line[c] != '.' or lower[c] != '.';
        }

        i = 0;
        while ((c < line.len) and
            (line[c] >= '0') and
            (line[c] <= '9')) : (c += 1)
        {
            buf[i] = line[c];
            sym = sym or upper[c] != '.' or lower[c] != '.';
            i += 1;
        }

        if (i > 0) {
            const num = try fmt.parseInt(ntype, buf[0..i], 10);
            if (c < line.len) {
                sym = sym or upper[c] != '.' or line[c] != '.' or lower[c] != '.';
            }
            if (sym) sum += num;
        }
    }

    return sum;
}

pub fn main() !void {
    var buf1: [bufSize]u8 = undefined;
    var buf2: [bufSize]u8 = undefined;
    var buf3: [bufSize]u8 = undefined;
    var top = buf1;
    var cur = buf2;
    var bot = buf3;
    @memset(&bot, '.');

    var l1 = try stdin.readUntilDelimiterOrEof(&top, '\n') orelse "kurwa";
    var l2 = try stdin.readUntilDelimiterOrEof(&cur, '\n') orelse "kurwa";
    var sum: ntype = try sumFromLine(&bot, l1, l2);

    while (try stdin.readUntilDelimiterOrEof(&bot, '\n')) |line| {
        sum += try sumFromLine(l1, l2, line);
        var tmp = top;
        top = cur;
        cur = bot;
        bot = tmp;
    }

    @memset(&bot, '.');
    sum += try sumFromLine(l1, l2, &bot);
    try stdout.print("{}\n", .{sum});
}
