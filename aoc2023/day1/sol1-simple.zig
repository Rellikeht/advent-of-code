const std = @import("std");

pub fn main() !void {
  var buf: [1024]u8 = undefined;

  var file = try std.fs.cwd().openFile("input", .{});
  defer file.close();

  var in_stream = b: {
    var buf_reader = std.io.bufferedReader(file.reader());
    break :b buf_reader.reader();
  };

  var num: i32 = 0;
  var sum: i32 = 0;

  while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
    var i: usize = 0;
    while ((line[i] < '0') or (line[i] > '9')) : (i+=1) {}
    num = @as(@TypeOf(num), line[i] - '0');

    i = line.len - 1;
    while ((line[i] < '0') or (line[i] > '9')) : (i-=1) {}
    num = 10*num + @as(@TypeOf(num), line[i] - '0');

    sum += num;
  }
  std.debug.print("{}\n", .{sum});

}
