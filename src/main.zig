const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile("data.txt", .{});
    defer file.close();

    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var lineCount: usize = 0;
    var byteCount: usize = 0;

    while(true){
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch(err){
            error.EndOfStream => break,
            else => return err,
        };

        lineCount += 1;
        byteCount += arr.items.len;
        arr.clearRetainingCapacity();
    }

    std.log.info("{d} lines | {d} bytes", .{lineCount, byteCount});
}