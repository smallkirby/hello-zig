const std = @import("std");
const expect = std.testing.expect;

test "labeled break" {
    var y: i32 = 123;

    // blocks can be labeled
    const x = blk: {
        y += 1;
        break :blk y;
    };

    try expect(x == 124);
    try expect(y == 124);
}

test "separate scopes" {
    {
        const pi = 3.14;
        _ = pi;
    }
    {
        var pi: bool = false;
        _ = pi;
    }
}

test "empty block" {
    const a = {};
    const b = void{};

    try expect(@TypeOf(a) == void);
    try expect(@TypeOf(b) == void);
}
