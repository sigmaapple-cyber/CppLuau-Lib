# CppLuau-Lib

A C++-inspired Luau library for Roblox. Its public API is organized into category namespaces under `src`.

## Public API map

- `Core`: Class, Struct, Enum, Interface, Namespace.
- `Values`: Optional, Result, Pair, Tuple, Variant, Reference.
- `Containers`: Array, Vector, Deque, List, ForwardList, Stack, Queue, PriorityQueue, HashMap, HashSet, Span, BitSet.
- `Algorithms`: Sequence, Search, Sort.
- `Math`: Scalar, Numeric, Random, Bit, Complex.
- `Text`: String, StringBuilder, StringView, Format.
- `Utility`: Functional, Iterator, TypeInfo, ScopeGuard.
- `Time`: Clock, Duration, Timer.
- `Binary`: Buffer.

`src/init.lua` is the only public entry point. Category folders each expose an `init.lua`.

## Coding style

Follow the type-first, compact Luau style in LocalOneX/MockSignal as a reference.

- Start source modules with `--!strict`.
- Put raw object shapes, prototype schemas, and exported types near the top.
- Prefer `local module = {}`, `module.new = function(...)`, and `module.Method = function(self: Type, ...)`.
- Use direct metatables and `__index` for object behavior.
- Keep function bodies focused. Avoid framework layers around simple tables.
- Use natural variable names such as `raw`, `self`, `callback`, `node`, and `idx`.
- Tabs for indentation; run StyLua before committing.
- Comments should describe public behavior or a non-obvious algorithm, not narrate each line.
- Add generics where they describe a meaningful public contract.

## API rules

- Export new modules through their category `init.lua` and root `src/init.lua`.
- Keep names precise. Use `HashMap` and `HashSet` for hash-table-backed collections.
- Keep unrelated features out of an existing module.
- Document indexing conventions, ordering, ownership, and complexity where relevant.
- Luau has garbage collection. Do not claim pointers, destructors, or manual memory management.
- Add TestEZ coverage and an API note for every new public module.
- Update examples when public naming changes.

## Validation

~~~sh
stylua --check src tests examples
selene src
wally install
rojo build default.project.json -o /tmp/CppLuau.rbxm
rojo build test.project.json -o /tmp/CppLuau-Tests.rbxlx
~~~

The TestEZ place must also be run in Roblox Studio. Do not claim runtime tests passed unless they were executed.

## Repository rules

- Do not copy another repository's implementation.
- Do not create empty placeholder modules.
- Keep generated Wally packages and build outputs out of commits.
