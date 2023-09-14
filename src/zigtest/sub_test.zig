test "expect 1 to equal 1" {
    try expect(1 == 1);
}

const std = @import("std");
const expect = std.testing.expect;
