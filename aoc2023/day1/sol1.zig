const std = @import("std");

pub fn main() !void {

  // Allocator, yay
  var gp = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
  defer _ = gp.deinit();
  const allocator = gp.allocator();

  // Weird
//  var file = try std.fs.openFileAbsolute("./input", .{});
  var file = try std.fs.cwd().openFile("input", .{});
  defer file.close();
  var reader = file.reader();
  const maxSize = 65536;

  var num: i32 = 0;
  var sum: i32 = 0;

  while (try reader.readUntilDelimiterOrEofAlloc(allocator, '\n', maxSize)) |line| {
    defer allocator.free(line);
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
