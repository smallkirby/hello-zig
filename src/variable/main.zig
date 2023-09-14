const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;

threadlocal var tlsx: i32 = 1234;

test "TLS" {
    const th1 = try std.Thread.spawn(.{}, dotls, .{});
    const th2 = try std.Thread.spawn(.{}, dotls, .{});

    dotls();

    th1.join();
    th2.join();
}

test "comptime" {
    var x: i32 = 1;
    comptime var y: i32 = 1;

    x += 1;
    y += 1;

    try expect(x == 2);
    try expect(y == 2);

    if (y != 2) {
        std.debug.print("ERROR: y != 2\n", .{});
        @compileError("y != 2");
    }
}

test "wrapping and saturating arithmetic" {
    const a: u3 = 0b111;
    const b: u3 = 0b011;

    // wrapping addition
    try expect(a +% b == 0b010);
    // saturating addition
    try expect(a +| b == 0b111);

    // We cannot write as below.
    // Negative value must be written as -0b001;
    // const c: i3 = 0b111;
}

pub fn main() !void {
    comptime var x_comptime: i32 = 1;

    x_comptime += 1;

    if (x_comptime != 2) {
        std.debug.print("ERROR: x_comptime != 2\n", .{});
        @compileError("x_comptime != 2");
    }
}

fn dotls() void {
    assert(tlsx == 1234);
    tlsx += 1;
    assert(tlsx == 1235);
}
