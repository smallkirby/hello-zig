const Point = struct {
    x: f32,
    y: f32,
};

const PointPacked = packed struct {
    x: f32,
    y: f32,
};

const p = Point{
    .x = 0.12,
    .y = 0.34,
};

var p2 = Point{
    .x = 0.12,
    .y = undefined,
};

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }
};

const memeql = @import("std").mem.eql;
const expect = @import("std").testing.expect;

test "dot product" {
    const v1 = Vec3.init(1.0, 0.0, 0.0);
    const v2 = Vec3.init(0.0, 1.0, 0.0);
    try expect(v1.dot(v2) == 0.0);

    // You can write as static method
    try expect(Vec3.dot(v1, v2) == 0.0);
}

const Empty = struct {
    pub const PI = 3.141;
};

test "struct namespaced variable" {
    try expect(Empty.PI == 3.141);
    try expect(@sizeOf(Empty) == 0);

    const does_nothing = Empty{};
    try expect(@sizeOf(@TypeOf(does_nothing)) == 0);
}

fn setYBasedOnX(x: *f32, y: f32) void {
    // Why the pointer can be assigned to the struct var?
    const point = @fieldParentPtr(Point, "x", x);
    point.y = y;
}

test "field parent pointer" {
    var point = Point{
        .x = 0.1234,
        .y = 0.5678,
    };
    setYBasedOnX(&point.x, 1.0);
    try expect(point.y == 1.0);
}

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node = null,
            next: ?*Node = null,
            data: T,
        };

        first: ?*Node = null,
        last: ?*Node = null,
        len: usize = 0,
    };
}

test "linked list" {
    try expect(LinkedList(i32) == LinkedList(i32));

    var list = LinkedList(i32){
        .len = 0,
    };
    try expect(list.len == 0);

    const ListOfInts = LinkedList(i32);
    try expect(ListOfInts == LinkedList(i32));

    var node = ListOfInts.Node{
        .data = 123,
    };
    var list2 = LinkedList(i32){
        .first = &node,
        .last = &node,
        .len = 1,
    };

    try expect(list2.first.?.data == 123);
    try expect(list2.first.?.next == null);
}

test "struct naming" {
    const std = @import("std");
    try expect(memeql(u8, @typeName(Point), "main.Point"));
    std.debug.print("Point: {s}\n", .{@typeName(struct {})});
    try expect(memeql(u8, @typeName(struct {})[0..30], "main.test.struct naming__struct"[0..30]));
}

test "annonymous" {
    var pt: Point = .{
        .x = 0.0,
        .y = 0.0,
    };
    try expect(pt.x == 0.0);
    try expect(pt.y == 0.0);
}

test "tuple" {
    const values = .{
        @as(u32, 1234),
        @as(f64, 12.24),
        true,
        "hi",
    } ++ .{false} ** 2;
    try expect(values[0] == 1234);
    try expect(values[1] == 12.24);
    try expect(values.len == 6);
    try expect(memeql(u8, values.@"3", "hi"));
}
