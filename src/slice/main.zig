const std = @import("std");
const expect = std.testing.expect;
const mem = std.mem;
const fmt = std.fmt;

test "basic slices" {
    var array = [_]i32{ 1, 2, 3, 4 };

    // by explicitly specifying the type, it becomes comptime known
    var known_at_runtime_zero: usize = 0;
    // if you slice with runtime-known values, you get a slice.
    const slice = array[known_at_runtime_zero..array.len];
    try expect(@TypeOf(slice) == []i32);
    try expect(&slice[0] == &array[0]);
    try expect(slice.len == array.len);

    const known_at_comptime_zero: usize = 0;
    const array_ptr = array[known_at_comptime_zero..array.len];
    // if you slice with comptime known values, you get a single-item array pointer.
    try expect(@TypeOf(array_ptr) == *[array.len]i32);

    // single-item array pointer performs comptime bounds checking while slice does at runtime.
    // slice[array.len] = 5; // this dumps runtime error
    // array_ptr[array.len] = 5; // this dumps comptime error

    var runtime_start: usize = 1;
    const length = 2;
    const array_ptr_len = array[runtime_start..][0..length];
    try expect(@TypeOf(array_ptr_len) == *[length]i32);

    try expect(@TypeOf(slice.ptr) == [*]i32);
    try expect(@TypeOf(&slice[0]) == *i32);
    try expect(@intFromPtr(slice.ptr) == @intFromPtr(&slice[0]));
}

test "slices for strings" {
    const hello: []const u8 = "hello";
    const world: []const u8 = "世界";

    var all_together: [100]u8 = undefined;
    var start: usize = 0;
    const all_together_slice = all_together[start..];
    const hello_world = try fmt.bufPrint(all_together_slice, "{s} {s}", .{ hello, world });
    try expect(mem.eql(u8, hello_world, "hello 世界"));
}

test "slice pointer" {
    var a: []u8 = undefined;
    try expect(@TypeOf(a) == []u8);
    var array: [10]u8 = undefined;
    const ptr = &array;
    try expect(@TypeOf(ptr) == *[10]u8);

    // you can slice a pointer to an array, just like slicing an array.
    var start: usize = 0;
    var end: usize = 5;
    const slice = ptr[start..end];
    slice[2] = 3;
    try expect(slice[2] == 3);
    try expect(@TypeOf(slice) == []u8);
}

test "sentinental" {
    var array1 = [_]u8{ 3, 2, 1, 0, 3, 2, 1, 0 };
    var runtime_length1: usize = 3;
    const slice1 = array1[0..runtime_length1 :0];

    try expect(@TypeOf(slice1) == [:0]u8);
    try expect(slice1.len == 3);
    try expect(slice1[runtime_length1] == 0);

    // This would cause `Sentinental Mismatch`
    // var runtime_length2: usize = 4;
    // const slice2 = array1[0..runtime_length2 :0];
    // try expect(slice2.len == 4);
}
