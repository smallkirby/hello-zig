const std = @import("std");
const expect = std.testing.expect;

test "basec while" {
    var i: usize = 0;
    while (i < 10) {
        i += 1;
    }
    try expect(i == 10);
}

test "while break" {
    var i: usize = 0;
    while (true) {
        if (i == 10) break;
        i += 1;
    }
    try expect(i == 10);
}

test "while continue" {
    var i: usize = 0;
    while (true) {
        i += 1;
        if (i < 10) continue;
        break;
    }
    try expect(i == 10);
}

test "while loop continue expression" {
    var i: usize = 0;
    // it is like a do-while loop
    while (i < 10) : (i += 1) {}
    try expect(i == 10);
}

test "while loop continue expression, more complicated" {
    var i: usize = 1;
    var j: usize = 1;
    while (i * j < 2000) : ({
        i *= 2;
        j *= 3;
    }) {
        const ij = i * j;
        try expect(ij < 2000);
        if (i != 1 and j != 1) {
            try expect(i % 2 == 0);
            try expect(j % 3 == 0);
        }
    }
}

test "while else" {
    try expect(rangeHasNumber(0, 10, 5));
    try expect(!rangeHasNumber(0, 100, 999));
}

fn rangeHasNumber(begin: usize, end: usize, number: usize) bool {
    var i = begin;
    return while (i < end) : (i += 1) {
        if (i == number) break true;
    } else false;
}

test "while null capture" {
    var sum1: u32 = 0;
    numbers_left = 3;
    while (eventuallyNullSequence()) |v| {
        sum1 += v;
    }
    try expect(sum1 == 3);

    var sum2: u32 = 0;
    numbers_left = 3;
    while (eventuallyNullSequence()) |v| {
        sum2 += v;
    } else {
        sum2 += 100;
    }
    try expect(sum2 == 103);
}

test "while error union capture" {
    var sum1: u32 = 0;
    numbers_left = 3;
    while (eventuallyErrorSequence()) |v| {
        sum1 += v;
    } else |err| {
        try expect(err == error.ReachedZero);
    }
    try expect(sum1 == 3);
}

var numbers_left: u32 = undefined;
fn eventuallyNullSequence() ?u32 {
    return if (numbers_left == 0) null else {
        numbers_left -= 1;
        return numbers_left;
    };
}

fn eventuallyErrorSequence() anyerror!u32 {
    return if (numbers_left == 0) error.ReachedZero else {
        numbers_left -= 1;
        return numbers_left;
    };
}
