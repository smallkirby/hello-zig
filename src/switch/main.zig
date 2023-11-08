const std = @import("std");
const builtin = @import("builtin");
const expect = std.testing.expect;

test "switch simple" {
    const a: u64 = 10;
    const zz: u64 = 123;

    const b = switch (a) {
        1, 2, 3 => 0,
        5...100 => 1,
        101 => blk: {
            const c: u64 = 5;
            break :blk c * 2 + 1;
        },
        zz => zz,
        // as far as expression is compile known, you can use it in switch
        blk: {
            const d: u32 = 5;
            const e: u32 = 100;
            break :blk d + e;
        } => 107,
        else => 9,
    };

    try expect(b == 1);
}

const os_msg = switch (builtin.target.os.tag) {
    .linux => "linux",
    else => "unknown",
};

test "switch os" {
    try expect(std.mem.eql(u8, os_msg, "linux"));
}

test "switch inside function" {
    switch (builtin.target.os.tag) {
        .fuchsia => {
            // if the expression is compile-time known, switch is evaluated at compile-time
            @compileError("fuchsia is not supported");
        },
        else => return,
    }
}

test "swicth on tagged union" {
    const Point = struct {
        x: u32,
        y: u32,
    };
    const Item = union(enum) {
        a: u32,
        c: Point,
        d,
        e: u32,
    };
    var a = Item{ .c = Point{ .x = 1, .y = 2 } };

    const b = switch (a) {
        Item.a, Item.e => |item| item,
        Item.c => |*item| blk: {
            item.*.x += 1;
            break :blk 6;
        },
        Item.d => 8,
    };

    try expect(b == 6);
    try expect(a.c.x == 2);
}

fn isFieldOptional(comptime T: type, field_index: usize) !bool {
    const fields = @typeInfo(T).Struct.fields;
    return switch (field_index) {
        inline 0...fields.len - 1 => |idx| @typeInfo(fields[idx].type) == .Optional,
        else => return error.IndexOutOfBounds,
    };
}

const Struct1 = struct {
    a: u32,
    b: ?u32,
};

test "using @typeInfo with runtime values" {
    var index: usize = 0;
    try expect(!try isFieldOptional(Struct1, index));
    index += 1;
    try expect(try isFieldOptional(Struct1, index));
    index += 1;
    try std.testing.expectError(error.IndexOutOfBounds, isFieldOptional(Struct1, index));
}
