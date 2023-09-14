fn addOne(x: i32) i32 {
    return x + 1;
}

test "expect addOne() adds one to 41" {
    try expect(addOne(41) == 42);
}

test "expect addOne() adds one to -29" {
    try expect(addOne(-29) == -28);
}

test "skip" {
    return error.SkipZigTest;
}

// This test reports error for the memory leak (lack of defer)
test "leak" {
    var list = std.ArrayList(u30).init(std.testing.allocator);
    defer list.deinit(); // comment-out this line to see the error
    try list.append('A');

    const len = list.items.len;
    const expected: usize = 1;
    try std.testing.expectEqual(expected, len);
}

test "aware test" {
    try expect(builtin.is_test);
}

// Tests are run iff the container is referenced by semantic analyzer.
test {
    std.testing.refAllDecls(sub_test);
}

const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;
const sub_test = @import("sub_test.zig");
