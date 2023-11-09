const std = @import("std");
const expect = std.testing.expect;

test "basic for" {
    const items = [_]i32{ 4, 5, 3, 4, 6 };
    var sum: i32 = 0;

    for (items) |value| {
        if (value == 0) {
            continue;
        }
        sum += value;
    }
    try expect(sum == 22);

    sum = 0;
    for (items[0..1]) |value| {
        sum += value;
    }
    try expect(sum == 4);

    sum = 0;
    for (items, 0..) |_, ix| {
        try expect(@TypeOf(ix) == usize);
        sum += @as(i32, @intCast(ix));
    }
    try expect(sum == 10);

    sum = 0;
    for (0..items.len) |ix| {
        sum += @as(i32, @intCast(ix));
    }
    try expect(sum == 10);
}

test "multi objects" {
    const items1 = [_]usize{ 1, 2, 3 };
    const items2 = [_]usize{ 4, 5, 6 };
    const items3 = [_]usize{ 7, 8, 9, 10 };
    var count: usize = 0;

    for (items1, items2) |i, j| {
        count += i + j;
    }
    try expect(count == 21);

    // Items must have the same length
    //for (items1, items2, items3) |i, j, k| {
    //    count += i + j + k;
    //}
    _ = items3;
}

test "for reference" {
    var items = [_]i32{ 3, 4, 2 };
    for (&items) |*value| {
        value.* += 1;
    }

    try expect(items[0] == 4);
}

test "for else" {
    var items = [_]?i32{ 3, 4, null, 5 };
    var sum: i32 = 0;

    const result = for (items) |v| {
        if (v != null) {
            sum += v.?;
        }
    } else blk: {
        // else branch is executed after the loop finishes without break
        try expect(sum == 12);
        break :blk @as(i32, 999);
    };
    try expect(result == 999);
}

test "nested break" {
    var count: usize = 0;
    // you can label a for loop, like Kotlin
    outer: for (1..6) |_| {
        for (1..6) |_| {
            count += 1;
            break :outer;
        }
    }
    try expect(count == 1);
}

test "nested continue" {
    var count: usize = 0;
    outer: for (0..9) |_| {
        for (0..6) |_| {
            count += 1;
            continue :outer;
        }
    }

    try expect(count == 9);
}

test "inline for loop" {
    const nums = [_]i32{ 2, 4, 6 };
    var sum: usize = 0;
    // you can use inline for where you can use types as first class values
    // this loop is unrolled at compile time
    inline for (nums) |i| {
        const T = switch (i) {
            2 => f32,
            4 => i8,
            6 => bool,
            else => unreachable,
        };
        sum += typeNameLength(T);
    }
    try expect(sum == 9);
}

fn typeNameLength(comptime T: type) usize {
    return @typeName(T).len;
}
