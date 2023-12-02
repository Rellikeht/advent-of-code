const std = @import("std");

pub fn hasNumAt(line: []u8, str: []const u8, i: usize) bool {
  return str.len <= line.len and
    i <= line.len - str.len and
    std.mem.eql(u8, line[i..i+str.len], str);
}

pub fn getDig(line: []u8, start: i32, step: i32) i32 {
  var i: i32 = start;
  while ((i >= 0) and (i < @as(i32, @intCast(line.len)))) : (i+=step) {
    var j: usize = @as(usize, @intCast(i));
    switch (line[j]) {
      '0'...'9' => return @as(i32, line[j] - '0'),
      'o' => if (hasNumAt(line, "one", j)) {return 1;},
      'e' => if (hasNumAt(line, "eight", j)) {return 8;},
      'n' => if (hasNumAt(line, "nine", j)) {return 9;},

      't' => if (hasNumAt(line, "two", j)) {return 2;}
      else if (hasNumAt(line, "three", j)) {return 3;}
      ,
      'f' => if (hasNumAt(line, "four", j)) {return 4;}
      else if (hasNumAt(line, "five", j)) {return 5;}
      ,
      's' => if (hasNumAt(line, "six", j)) {return 6;}
      else if (hasNumAt(line, "seven", j)) {return 7;}
      ,

      else => {},
    }
  }

  return -999999;
}

pub fn main() !void {
  var buf: [1024]u8 = undefined;

  var file = try std.fs.cwd().openFile("input", .{});
  defer file.close();

  var in_stream = b: {
    var buf_reader = std.io.bufferedReader(file.reader());
    break :b buf_reader.reader();
};

var num1: i32 = 0;
var num2: i32 = 0;
var sum: i32 = 0;

while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
  num1 = getDig(line, 0, 1);
  num2 = getDig(line, @as(i32, @intCast(line.len))-1, -1);
  sum += num1*10 + num2;
}
std.debug.print("{}\n", .{sum});

}
