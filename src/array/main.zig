const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const assert = std.debug.assert;
const mem = std.mem;

const message = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

comptime {
    assert(message.len == 5);
}

const message2 = "hello";

comptime {
    assert(mem.eql(u8, &message, message2));
}

test "iterate" {
    var sum: usize = 0;
    for (message) |byte| {
        sum += byte;
    }
    try expect(sum == 532);
}

var integers: [100]i32 = undefined;

test "modify" {
    for (&integers, 0..) |*item, ix| {
        item.* = @intCast(ix);
    }

    try expect(integers[10] == 10);
    try expect(integers[99] == 99);
}

const ints1 = [_]i32{ 1, 2, 3 };
const ints2 = [_]i32{ 4, 5, 6 };
const inst12 = ints1 ++ ints2;
comptime {
    assert(mem.eql(i32, &inst12, &[_]i32{ 1, 2, 3, 4, 5, 6 }));
}

const hello = "hello";
const world = "world";
const helloworld = hello ++ " " ++ world;
comptime {
    assert(mem.eql(u8, helloworld, "hello world"));
}

const pattern = "ab" ** 3;
comptime {
    assert(mem.eql(u8, pattern, "ababab"));
}

const allzero = [_]u16{0} ** 0x10;
comptime {
    assert(allzero.len == 0x10);
    assert(allzero[0] == 0);
}

const fancy = init: {
    var initial_value: [10]Point = undefined;
    for (&initial_value, 0..) |*item, ix| {
        item.* = Point{
            .x = @intCast(ix),
            .y = @intCast(ix * 2),
        };
    }
    break :init initial_value;
};

const Point = struct {
    x: i32,
    y: i32,
};

test "compile-time init" {
    try expect(fancy[0].x == 0);
    try expect(fancy[2].y == 4);
}

var morep = [_]Point{makePoint(3)} ** 10;

fn makePoint(x: i32) Point {
    return Point{
        .x = x,
        .y = x * 2,
    };
}

test "array init with func" {
    try expect(morep[2].x == 3);
    try expect(morep[4].y == 6);
    try expect(morep.len == 10);
}

test "sentinel" {
    const sentinel = [_:9]u8{ 1, 2, 3, 4 };
    try expect(@TypeOf(sentinel) == [4:9]u8);
    try expect(sentinel.len == 4);
    try expect(sentinel[sentinel.len] == 9);

    const s = [_:'A']u8{ 'a', 'b', 'c' };
    std.debug.print("s = {s}\n", .{s});
}
