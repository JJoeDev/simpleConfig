const std = @import("std");
const parser = @import("parser.zig");

pub fn main() !void {
    const config = try parser.ParseFile("data.txt");

    std.log.info("KEY: {s} | VALUE: {s}", .{config.key, config.value});
}