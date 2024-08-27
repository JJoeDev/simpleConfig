const std = @import("std");
const parser = @import("parser.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const config = try parser.ParseFile("data.txt", allocator);

    std.log.info("KEY: {s} | VALUE: {s}", .{config.key, config.value});
}