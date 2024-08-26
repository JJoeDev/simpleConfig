const std = @import("std");

const Settings = struct {
    key: []const u8,
    value: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var allocator = gpa.allocator();

    const buff = try readFile(&allocator, "data.txt");
    defer allocator.free(buff);

    var lines = std.mem.split(u8, buff, "\n");

    while(lines.next()) |line| {
        if(line.len <= 0) continue;
        if(line[0] == '*') continue;

        const seperator = std.mem.indexOf(u8, line, ":");

        if(seperator != null){
            const key = line[0..seperator.?];
            const value = line[seperator.? + 1..];

            const kv = Settings{
                .key = std.mem.trim(u8, key, " "),
                .value = std.mem.trim(u8, value, " "),
            };

            std.log.info("Key: {s} | Value: {s}", .{kv.key, kv.value});
        }
    }
}

fn readFile(allocator: *std.mem.Allocator, filename: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(filename, .{});
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator.*, stat.size);
    return buff;
}