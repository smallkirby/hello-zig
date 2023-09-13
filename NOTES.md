# Notes

## Zig syntax

- Zig does not have multiline comments.......!?!?
- Zig's has three types of comments as a language.
  - The compiler emits error for misplaced doc comments...!
  - Doc comments can be compiled into HTML documents...! : `zig test -femit-docs`

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
