const std = @import("std");
const expect = std.testing.expect;

const Payload = union {
    int: i64,
    float: f64,
    boolean: bool,
};

test "simple union" {
    var payload = Payload{ .int = 1234 };
    try expect(payload.int == 1234);

    // You cannot access a inactive field
    // payload.float = 1234.5678;
    // try expect(payload.float == 1234.5678);

    // You can assign an entire union
    payload = Payload{ .float = 1234.5678 };
    try expect(payload.float == 1234.5678);
}

const ComplexTypeTag = enum {
    ok,
    not_ok,
};
// Tagged union must have the exactly same fields as the enum.
const ComplexType = union(ComplexTypeTag) {
    ok: u8,
    not_ok: void,
};

test "switch on tagged union" {
    const c = ComplexType{ .ok = 123 };
    try expect(@as(ComplexTypeTag, c) == ComplexTypeTag.ok);

    // Tagged union can be used in switch
    switch (c) {
        ComplexTypeTag.ok => |value| try expect(value == 123),
        ComplexTypeTag.not_ok => unreachable,
    }
}

test "modify tagged union in switch" {
    var c = ComplexType{ .ok = 123 };

    switch (c) {
        ComplexTypeTag.ok => |*value| value.* *= 2,
        ComplexTypeTag.not_ok => unreachable,
    }

    try expect(c.ok == 246);
}

const Variant = union(enum) {
    int: i32,
    boolean: bool,
    none: void,

    fn truthy(self: Variant) bool {
        return switch (self) {
            Variant.int => |x| x != 0,
            Variant.boolean => |x| x,
            Variant.none => false,
        };
    }
};

test "union method" {
    var v1 = Variant{ .int = 1 };
    var v2 = Variant{ .boolean = false };

    try expect(v1.truthy());
    try expect(!v2.truthy());
}

test "tag name" {
    try expect(std.mem.eql(u8, @tagName(Variant.int), "int"));
}

test "annonymous union literal" {
    var i: Variant = .{ .boolean = false };
    var f = makeNumber();
    try expect(i.boolean == false);
    try expect(f.int == 1234);
}

fn makeNumber() Variant {
    return .{ .int = 1234 };
}
