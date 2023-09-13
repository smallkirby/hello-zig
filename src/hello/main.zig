//! This is a top-level doc comment.
//! And this is a second line.

const std = @import("std");
const print = @import("std").debug.print;
const log = @import("std").log;

/// Hello main function
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"World"});
    print("Hello from std.debug.print...!\n", .{});
    log.info("Hello from std.log.info...!", .{});
}
