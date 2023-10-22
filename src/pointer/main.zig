const expect = @import("std").testing.expect;

test "address of" {
    const x: i32 = 1234;
    const x_ptr = &x;

    try expect(x_ptr.* == 1234);

    try expect(@TypeOf(x_ptr) == *const i32);

    var y: i32 = 5678;
    const y_ptr = &y;
    try expect(@TypeOf(y_ptr) == *i32);
    y_ptr.* += 1;
    try expect(y_ptr.* == 5679);
    try expect(y == 5679);
}

test "pointer array access" {
    var array = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const ptr = &array[2];
    try expect(@TypeOf(ptr) == *u8);

    try expect(array[2] == 3);
    ptr.* += 1;
    try expect(array[2] == 4);
}

test "pointer arith" {
    const array = [_]i32{ 1, 2, 3, 4, 5 };
    try expect(array.len == 5);
    var ptr: [*]const i32 = &array;

    try expect(ptr[0] == 1);
    ptr += 1;
    try expect(ptr[0] == 2);
}

test "pointer arith slice" {
    var array = [_]i32{ 1, 2, 3, 4 };
    var length: usize = 0;
    var slice = array[length..array.len];

    try expect(slice.len == 4);
    try expect(slice[0] == 1);

    slice.ptr += 1;
    try expect(slice.len == 4);
    try expect(slice[0] == 2);
}

test "pointer casting" {
    // `*i32` type must have aligned address
    const ptr: *i32 = @ptrFromInt(0xDEADBEE0);
    const addr = @intFromPtr(ptr);
    try expect(@TypeOf(addr) == usize);
    try expect(addr == 0xDEADBEE0);

    const bytes align(@alignOf(u32)) = [_]u8{ 0x10, 0x11, 0x12, 0x13 };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    try expect(u32_ptr.* == 0x13121110);
}
