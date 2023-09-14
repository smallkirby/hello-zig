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
