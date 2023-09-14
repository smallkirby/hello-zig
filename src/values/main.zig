const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

fn print_optional(name: []const u8, opt: ?[]const u8) void {
    print("{s}:\n", .{name});
    print("\ttype : {}\n", .{@TypeOf(opt)});
    print("\tvalue: {?s}\n", .{opt});
}

fn print_error_union(name: []const u8, err: anyerror!i32) void {
    print("{s}:\n", .{name});
    print("\ttype : {}\n", .{@TypeOf(err)});
    print("\tvalue: {!}\n", .{err});
}

pub fn main() !void {
    const one_plus_one: i32 = 1 + 1;
    print("1 + 1 = {}\n", .{one_plus_one});

    const seven_div_three = 7.0 / 3.0;
    print("7 / 3 = {}\n", .{seven_div_three});

    print("{}\n", .{
        true and false,
    });
    print("{}\n{}\n", .{
        true or false,
        !true,
    });

    var opt: ?[]const u8 = null;
    assert(opt == null);
    print_optional("opt", opt);
    opt = "hi";
    assert(opt != null);
    print_optional("opt", opt);

    var number_or_error: anyerror!i32 = error.HogeFuga;
    print_error_union("number_or_error", number_or_error);
    number_or_error = 42;
    print_error_union("number_or_error", number_or_error);

    const seven_bits: i7 = 0x3F;
    print("seven_bits: 0b{b}\n", .{seven_bits});
}
