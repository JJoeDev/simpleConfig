const std = @import("std");

pub fn main() !void {
    var allocator = std.heap.page_allocator;

    const buff = try readFile(&allocator, "data.txt");
    defer allocator.free(buff);

    var lines = std.mem.split(u8, buff, "\n");

    while(lines.next()) |line| {
        if(line.len <= 0) continue;

        if(line[0] == '*') continue;
        std.log.info("READ LINE: {s}", .{line});
    }
}

fn readFile(allocator: *std.mem.Allocator, filename: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator.*, stat.size);
    return buff;
}