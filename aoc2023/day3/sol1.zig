const std = @import("std");
const fmt = std.fmt;

const bufSize = 1024;

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    _ = stdout;

    //    var num: [20]u8 = undefined;
    //    var numLen: usize = 0;
    //    var numStart: usize = 0;
    //    var ln: usize = 0;
    //    var numCont: bool = false;

    var buf1: [bufSize]u8 = undefined;
    var buf2: [bufSize]u8 = undefined;
    var buf3: [bufSize]u8 = undefined;

    @memset(&buf1, '.');
    @memset(&buf2, '.');
    @memset(&buf3, '.');

    var l1 = try stdin.readUntilDelimiterOrEof(buf2[1..], '\n');
    _ = l1;
    var l2 = try stdin.readUntilDelimiterOrEof(buf3[1..], '\n');
    _ = l2;

    std.mem.swap(@TypeOf(buf1), buf1, buf2);
    std.mem.swap(@TypeOf(buf1), buf2, buf3);

    while (try stdin.readUntilDelimiterOrEof(buf2[1..], '\n')) |line| {
        _ = line;
        var i: usize = 0;
        _ = i;
    }

    var sum: i64 = 0;
    _ = sum;
}
