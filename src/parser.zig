const std = @import("std");

const KeyValue = struct {
    key: []const u8,
    value: []const u8,
};

pub fn ParseFile(filename: []const u8) !KeyValue {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    const buff: []u8 = try readFile(&allocator, filename);
    defer allocator.free(buff);

    var lines = std.mem.split(u8, buff, "\n");

    while(lines.next()) |line| {
        if(line.len <= 0) continue;
        if(line[0] == '*') continue;

        const seperator = std.mem.indexOf(u8, line, ":");

        if(seperator != null){
            const key = line[0..seperator.?];
            const value = line[seperator.? + 1..];

            return KeyValue{.key = key, .value = value};
        }
    }

    return error.NoLines;
}

fn readFile(allocator: *std.mem.Allocator, filename: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator.*, stat.size);
    return buff;
}