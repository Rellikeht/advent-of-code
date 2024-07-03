// {{{
const std = @import("std");
const mem = std.mem;
const fmt = std.fmt;
const io = std.io;
const math = std.math;

const pts2 = struct { u32, u32, u32, u32 };
// }}}

pub fn main() !void {

    // {{{
    var buf: [1 << 13]u8 = undefined;

    const stdout = io.getStdOut();
    var out_buf = io.bufferedWriter(stdout.writer());
    const writer = out_buf.writer();

    const stdin = io.getStdIn();
    var in_buf = io.bufferedReader(stdin.reader());
    const reader = in_buf.reader();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const alist = std.ArrayList(pts2);
    var points = alist.init(allocator);
    // }}}

    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| { // {{{
        var comma_iter = std.mem.splitScalar(u8, line, ',');
        const x1 = try std.fmt.parseInt(u32, comma_iter.first(), 10);
        var space_iter = std.mem.splitScalar(u8, comma_iter.rest(), ' ');
        const y1 = try std.fmt.parseInt(u32, space_iter.first(), 10);

        _ = space_iter.next() orelse "";
        comma_iter = std.mem.splitScalar(u8, space_iter.rest(), ',');
        const x2 = try std.fmt.parseInt(u32, comma_iter.first(), 10);
        const y2 = try std.fmt.parseInt(u32, comma_iter.next() orelse "fuck", 10);

        // leave only vertical and horizontal
        if (x1 != x2 and y1 != y2) continue;
        var val: pts2 = undefined;

        if (x1 > x2) {
            val[0] = x2;
            val[2] = x1;
        } else {
            val[0] = x1;
            val[2] = x2;
        }

        if (y1 > x2) {
            val[1] = y2;
            val[3] = y1;
        } else {
            val[1] = y1;
            val[3] = y2;
        }

        try points.append(val);
    } // }}}

    // {{{
    const map = std.array_hash_map.AutoArrayHashMap(struct { u32, u32 }, bool);
    var counted = map.init(allocator);
    const pts = points.items;
    // }}}

    for (0..pts.len - 1) |i| { // {{{
        for (i + 1..pts.len) |j| {
            const p1 = pts[i];
            const p2 = pts[j];

            if (p1[0] == p1[2]) { // first line is vertical
                if (p2[0] == p2[2]) { // {{{ second line is vertical

                    if (p1[0] == p2[0]) { // they are on the same level
                        var s = @max(p1[1], p2[1]);
                        const e = @min(p1[3], p2[3]);

                        if (s > e) continue;
                        // try writer.print("{} {}\n", .{ s, e });
                        // try out_buf.flush();

                        while (s <= e) {
                            try counted.put(.{
                                p1[0],
                                @intCast(s),
                            }, true);
                            s += 1;
                        }
                    }

                    // }}}
                } else { // {{{ second line is horizontal
                    if ( // they intersect
                    p1[1] <= p2[1] and p1[3] >= p2[1] // horizontally
                    and p1[0] >= p2[0] and p1[0] <= p2[2] // vertically
                    ) { //
                        try counted.put(.{ p1[0], p2[1] }, true);
                        // try writer.print("{} {}\n", .{ p1[0], p2[1] });
                    }
                }
                // }}}
            } else { // first line is horizontal
                if (p2[0] == p2[2]) { // {{{ second line is vertical
                    if ( // they intersect
                    p2[1] <= p1[1] and p2[3] >= p1[1] // horizontally
                    and p1[0] <= p2[0] and p1[2] >= p2[0] // vertically
                    ) { //
                        try counted.put(.{ p2[0], p1[1] }, true);
                        // try writer.print("{} {}\n", .{ p2[0], p1[1] });
                    }
                    // }}}
                } else { // {{{ second line is vertical

                    if (p1[1] == p2[1]) { // they are on the same level
                        var s = @max(p1[0], p2[0]);
                        const e = @min(p1[2], p2[2]);

                        if (s > e) continue;
                        // try writer.print("{} {}\n", .{ s, e });
                        // try out_buf.flush();

                        while (s <= e) {
                            try counted.put(.{
                                @intCast(s),
                                p1[1],
                            }, true);
                            s += 1;
                        }

                        // try writer.print("{} {}\n", .{ p1[0], k });
                        // try out_buf.flush();
                    }

                    // }}}
                }
            }

            try writer.print("{} {} {}\n\n", .{ p1, p2, counted.count() });
            try out_buf.flush();
        }
    } // }}}

    try writer.print("{}\n", .{counted.count()});
    try out_buf.flush();
}
