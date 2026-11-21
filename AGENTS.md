# CppLuau-Lib

## Coding Style
- Follow the Luau style used in LocalOneX/MockSignal as closely as practical.
- Start Luau files with `--!strict`.
- Keep type declarations near the top: `Raw...` schemas, prototype schemas, and exported types.
- Use `local module = {}`, `module.new = function(...)`, and `module.Method = function(self: Type, ...)` when appropriate.
- Use metatables and `__index` directly for object behavior.
- Prefer compact, straightforward Luau, natural variable names, small functions, and direct table operations.
- Keep comments sparse and purposeful, using multiline method/section comments where useful.
- Avoid unnecessary abstraction layers, excessive defensive code, artificial naming, and unrelated refactors.
- Keep generic types where they add real value.

## Project Direction
CppLuau-Lib implements C++-inspired programming concepts in Luau. It is not a C++ transpiler. Build typed, usable, idiomatic Luau modules and document public usage.
