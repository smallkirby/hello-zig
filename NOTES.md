# Random thoughts during my learning of Zig

These notes are being written while I'm learning Zig.
Therefore, some of them can be written while I don't know the necessary concept or syntax of the language.

## Zig syntax

- Zig does not have multiline comments.......!?!?
- Zig's has three types of comments as a language.
  - The compiler emits error for misplaced doc comments...!
  - Doc comments can be compiled into HTML documents...! : `zig test -femit-docs`
- Zig does not allow us to write `void` to for a function's argument.
- The formatter adds peculiar expression for unused vars:

```zig
const one_plus_one: i32 = 1 + 1;

// format, then...

const one_plus_one: i32 = 1 + 1;
_ = one_plus_one;
```

- `std.debug.print` takes `anytype` as a 2nd argument. But it emits error for `print("{}", 3)`. Why? It says `expected tuple or struct argument`. `i32` is not `anytype`? And also VSCode extension does not show errors for this code :(
- `boolean` is no longer a `0` or `1`. good. It is printed as `true` or `false`.
- Integer type can take any width of bits: `u7` or `i99` is allowed.
- Error Union is similar to Go?
- Modules imported by `@import` can be used before the `@import` statement.
  - I'm now not sure but it's called `top-level declaration`
- No operator overloads, good.
- In zig, `comptime` and `runtime` seems to be distinguished clearly. For example, if the function can be evaluated to be `comptime`, array can be initialized with the function call:

```zig
var morep = [_]u32{getU32(3)} ** 10;
```

However, if some statements/expressions cannot be evaluated to be `comptime`, the above initialization fails:

```zig
var morep = [_]u32{getU32(3)} ** 10;
var param: i32 = 2; // `:i32` is necessary to be `runtime`
fn getU32(x: i32) i32 {
    return 2 * param; // This operation is `runtime` due to `param`
                      // so `getU32` cannot be evaluated at `comptime`.
}
```

- Zig's array can have explicit *sentinel* elemnt.
  - We can access `len`-th for sentinel.
  - We cannot access ``len+1`-th. Compiler emits error. good.
  - However, `.len` omits the sentinel element.
  - Therefore, `string`(`[]const u8`) is printed without sentinel element. good, but strange.

### Variables

- `threadlocal` variable is interesting.
- I'm not sure how `comptime` qualifier is used. This type of const optimization would be done by the normal C compiler without explicitly telling it to do so.
- Integers can be split by underscores, good.

### Types

- Zig supports built-in vector support with SIMD instructions, good.
  - :thinking: > Note that excessively long vector lengths (e.g. 2^20) may result in compiler crashes on current versions of Zig.
  - We CANNOT know the length of vector at runtime...? `@Vector` does not have `.len` property.
  - `@shuffle()` seems a little bit strange and hacky to me. And its name should be `@select()` or something.
  - ah, `@select()` is already used for something which selects one of two values based on a boolean condition.
  - Comparison operators with `@Vector` becomes `@Vector(len, bool)`.
- Zig's slice is just a fat pointer with length and ptr.
- Zig's pointer type `*i32` must have aligned address, good.
- Slices type is a little bit confusing:
  - `*T`: single-item pointer
  - `[*]T`: many-item pointer
  - `[]T`: slice The length is determined at runtime.
  - `*[N]T`: array. The length is determined at comptime.
- If you slice with a comptime-known start/end position, you get a single-item array pointer (`*[N]T`) instead of slice.
  - The only difference between slice and single-item array pointer is that the formater performs bounds checking.
- You can get the parent struct ot a field with `@fieldParentPtr()` like as `container_of()`.
  - I'm not sure the return type of `@fieldParentPtr()`. Doc says it returns a pointer bit you can assign it to a struct variable.
- You can return `type` from a function. Then you can assign it to a variable.
- All the struct in Zig is annonymous. They are named depending on the context.
- `Tuple` is a struct with anonymous fields. Argunent ot `print()` is a tuple!

### enum

- You can specify the type of enum tield value. Good.
- Enum can have method, great.

### union

- Zig has a union type, super good.
- Tagged union must be declared with `enum`.
Both `enum` and `union` must have the exactly same fields.
This seems a little bit redundant to me.
- No, unions can be made to infer the enum tag type!

```zig
const Variant = union(enum) {
  int: i32,
  bool: bool,
  none: void,
}
```

### Syntax

- `break` can return a value.
  - Blocks can be named.
- Shadowing is NOT allowed.
- `switch` can be used outside functions.

## Zig ecosystem

- Zig has built-in formatter, good really.
  - Though it uses 4 spaces... :( Can I change the default?
- The compiler does not show the line number of source code for `fmt` error for real ...!?!?

```bash
# This is the all I can get from the compiler...
$ zig build-exe ./main.zig
/snap/zig/8241/lib/std/fmt.zig:648:21: error: cannot format slice without a specifier (i.e. {s} or {any})
                    @compileError("cannot format slice without a specifier (i.e. {s} or {any})");
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

- Zig allows in-file testing. Good so good.

## Zig std

- `stdout.print` requires two arguments even if we don't provide any variables.
- Does the lib provide `puts()`-like function?
  - `std.log.info()` seems to automatically add a newline.

## VSCode Integration

- VSCode's Zig Language extension is not enough for now. For example, it does not show error for below code:

```zig
const std = @import("std");

pub fn main() void { // this must be `!void`
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, {s}!\n", .{"World"});
}
```

- VSCode markdown does not provide syntax highlighting for Zig code blocks in the editor.
- VSCode Zig Language extension opens `OUTPUT` tab for compilation errors. It's really annoying...
- VSCode Zig Language extension's tab completion for functions is annoying:

```txt
// We type `Tab` here, then...
const std = @im
// I want it to leave the inside empty....
const std = @import(comptime path: []const u8) // :(

// Even worse, if I type `Tab` here...
const print = std.debug.pri
// Why do you think I want to complete it here...?
const print = std.debug.print(comptime fmt: []const u8, args: anytype)
```

- Language extension cannot infer the type of `const a = 7.0/3.0` (shown as `unknown`). Really poor.
