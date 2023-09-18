const std = @import("std");
const testing = std.testing;
const expect = testing.expect;
const expectEqual = testing.expectEqual;

test "vector" {
    const a = @Vector(4, i32){ 1, 2, 3, 4 };
    const b = @Vector(4, i32){ 5, 6, 7, 8 };

    const c = a + b;

    try expectEqual(6, c[0]);
    try expectEqual(8, c[1]);
    // How to know the length of vector...?
    // try expectEqual(c.len, 4);
}

test "convert" {
    var arr1: [4]f32 = [_]f32{ 1.1, 2.2, 3.3, 4.4 };
    var vec1: @Vector(4, f32) = arr1; // implicit conversion from array to vector
    var arr2: [4]f32 = vec1; // implicit conversion from vector to array
    try expectEqual(arr1, arr2);

    const vec2: @Vector(2, f32) = arr1[1..3].*; // `.*` converts slice to vector
    var slice: []const f32 = &arr1;
    var offset: u32 = 1;
    try expectEqual(slice[offset], vec2[0]);
    try expectEqual(slice[offset + 1], vec2[1]);

    const vec3: @Vector(2, f32) = slice[offset..][0..2].*;
    try expectEqual(vec2, vec3);
}

test "@splat" {
    const scalar: u32 = 5;
    const result: @Vector(4, u32) = @splat(scalar);
    try expect(std.mem.eql(u32, &@as([4]u32, result), &[_]u32{ 5, 5, 5, 5 }));
}

test "@shuffle" {
    const a = @Vector(7, u8){ 'o', 'l', 'h', 'e', 'r', 'z', 'w' };
    const b = @Vector(4, u8){ 'w', 'd', '!', 'x' };

    const mask1 = @Vector(5, i32){ 2, 3, 1, 1, 0 };
    // `b` is considered as `[7]u8=@splat(undefined)`
    const res1: @Vector(5, u8) = @shuffle(u8, a, undefined, mask1);
    try expect(std.mem.eql(u8, &@as([5]u8, res1), "hello"));

    const mask2 = @Vector(6, i32){ -1, 0, 4, 1, -2, -3 };
    // Negative index is for `b`
    const res2: @Vector(6, u8) = @shuffle(u8, a, b, mask2);
    try expect(std.mem.eql(u8, &@as([6]u8, res2), "world!"));
}

test "@select" {
    const a = @Vector(6, u32){ 1, 2, 3, 4, 5, 6 };
    const b = @Vector(6, u32){ 7, 8, 9, 10, 11, 12 };
    const pred = @Vector(6, bool){ true, false, true, false, true, false };
    const res = @select(u32, pred, a, b);
    try expectEqual(res, @Vector(6, u32){ 1, 8, 3, 10, 5, 12 });
}

test "@reduce" {
    const vtype = @Vector(4, i32); // type variable
    const value = vtype{ 1, 2, 3, 4 };
    const result = value > @as(vtype, @splat(0));
    try comptime expect(@TypeOf(result) == @Vector(4, bool));

    const is_all_true = @reduce(.And, result);
    try comptime expect(@TypeOf(is_all_true) == bool);
    try comptime expect(is_all_true);
}
