const std = @import("std");
const fmt = std.fmt;

const SymEl = struct {
    x: usize,
    y: usize,
};

const NumEl = struct { val: i64, line: usize, start: usize, len: usize };

pub fn main() !void {
    var input: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();
    _ = stdout;

    var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gp.deinit();
    const allocator = gp.allocator();
    _ = allocator;

    var symbols: std.ArrayList(SymEl) = undefined;
    var numbers: std.ArrayList(NumEl) = undefined;

    var num: [20]u8 = undefined;
    var numLen: usize = 0;
    var numStart: usize = 0;
    var ln: usize = 0;
    var numCont: bool = false;

    while (try stdin.readUntilDelimiterOrEof(&input, '\n')) |line| {
        var i: usize = 0;
        //      try stdout.print("line: {s}\n", .{line});

        while (i < line.len) {
            numCont = false;
            switch (line[i]) {
                '.' => {},
                else => {
                    try symbols.append(SymEl{ .x = i, .y = ln });
                },

                '0'...'9' => {
                    if (numLen == 0) numStart = i;
                    num[numLen] = line[i];
                    numLen += 1;
                    numCont = true;
                },
            }

            if (!numCont and numLen > 0) {
                const val = try fmt.parseInt(i64, &num, 10);
                try numbers.append(NumEl{ .val = val, .line = ln, .start = numStart, .len = numLen });
                numLen = 0;
            }
            i += 1;
        }

        ln += 1;
    }

    var sum: i64 = 0;
    _ = sum;
}
