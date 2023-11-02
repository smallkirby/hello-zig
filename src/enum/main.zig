const std = @import("std");
const expect = @import("std").testing.expect;
const expectEqual = @import("std").testing.expectEqual;
const mem = @import("std").mem;

const Type = enum {
    ok,
    not_ok,
};

const c = Type.ok;

const Value = enum(u2) {
    zero,
    one,
    two,
    three,
    // You cannot declare a value exceeding the enum's bit width.
    // four,
};

const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
};

// you have to specify the type of the enum to override part of ordinals
const Value3 = enum(u32) {
    a,
    b = 8,
    c,
    d = 50,
};

test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0);
    try expect(@intFromEnum(Value.two) == 2);
    try expect(@intFromEnum(Value2.thousand) == 1000);
    // ordinals are automatically assigned
    try expect(@intFromEnum(Type.ok) == 0);
    // you can override the ordinal
    try expect(@intFromEnum(Value3.c) == 9);
}

const Suit = enum {
    clubs,
    diamonds,
    hearts,
    spades,

    pub fn isClubs(self: Suit) bool {
        return self == .clubs; // enum literal
    }
};

test "enum method" {
    const club = Suit.clubs;
    const spade = Suit.spades;
    try expect(club.isClubs());
    try expect(!spade.isClubs());
}

const Foo = enum {
    string,
    number,
    none,
};

test "enum switch" {
    const p = Foo.number;
    const what = switch (p) {
        .string => "string",
        .number => "number",
        .none => "none",
    };

    try expect(mem.eql(u8, what, "number"));
}

test "@typeInfo" {
    try expect(@typeInfo(Value).Enum.tag_type == u2);
    try expect(@typeInfo(Value).Enum.fields.len == 4);
    try expect(mem.eql(u8, @typeInfo(Value).Enum.fields[1].name, "one"));
}

// non-exhaustive enum must explicitly specify tag type
const Number = enum(u8) {
    zero,
    one,
    two,
    _,
};

test "non-exhaustive" {
    const n = Number.one;
    // non-exhaustive enum swicth with `_` prong must handle all cases
    const result = switch (n) {
        .one => true,
        .zero, .two => false,
        _ => false,
    };
    try expect(result);

    // `else` prong can handle all cases including `_`
    const result2 = switch (n) {
        .one => true,
        else => false,
    };
    try expect(result2);
}
