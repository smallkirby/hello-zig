const Derp = opaque {};
const Wat = opaque {};

extern fn bar(d: *Derp) void;
fn foo(w: *Wat) callconv(.C) void {
    bar(w);
}
fn hey(d: *Derp) callconv(.C) void {
    bar(d);
}

test "call foo" {
    // compiler emits type errot
    foo(undefined);

    // lld invokes undefined symbol error
    // hey(undefined);
}
