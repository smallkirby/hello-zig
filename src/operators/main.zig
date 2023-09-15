const std = @import("std");
const assert = std.debug.assert;
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const mem = std.mem;

test "orelse" {
    const v: ?u32 = null;
    const unwrapped = v orelse 0;
    try expectEqual(0, unwrapped);

    const w: ?u32 = 1;
    const unwrapped2 = w orelse 0;
    try expectEqual(1, unwrapped2);
}

test ".?" {
    const v: ?u32 = 1;
    try expectEqual(1, v.?);
}

fn err2num(e: anyerror) u32 {
    if (e == error.Unreachable) {
        return 2;
    } else {
        return 3;
    }
}

test "catch" {
    const v: anyerror!u32 = 1;
    const w: anyerror!u32 = error.Unreachable;
    const x: anyerror!u32 = error.Hoge;
    try expectEqual(1, v catch 0);
    try expectEqual(0, w catch 0);
    try expectEqual(@as(u32, 2), (w catch |e| err2num(e)));
    try expectEqual(@as(u32, 3), (x catch |e| err2num(e)));
}

test "array concat" {
    const arr1 = [_]u32{ 1, 2, 3 };
    const arr2 = [_]u32{ 4, 5 };
    const expected = [_]u32{ 1, 2, 3, 4, 5 };
    try expectEqual(expected, arr1 ++ arr2);
}

test "array multiplication" {
    const arr1 = [_]u32{ 1, 2, 3 };
    const expected = [_]u32{ 1, 2, 3, 1, 2, 3, 1, 2, 3 };
    try expectEqual(expected, arr1 ** 3);
}

test "pointer" {
    var x: u32 = 32;
    const ptr_x = &x;
    ptr_x.* = 90;
    try expectEqual(@as(u32, 90), ptr_x.*);
}
