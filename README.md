# CppLuau-Lib

A Luau standard-library-inspired toolkit for Roblox. It brings C++-style programming concepts into native Luau: classes, contracts, value wrappers, containers, algorithms, iterators, and utilities.

This is **not** a C++ compiler or transpiler. It uses Luau tables, functions, metatables, and the Roblox runtime.

> **Status:** Early development. APIs may change before the first stable release.

## Modules

### Core concepts

| Module | Purpose |
| --- | --- |
| [Class](docs/Class.md) | Class objects, inheritance, constructor chaining, and IsA. |
| [Struct](docs/Struct.md) | Schema-based values with copied defaults. |
| [Enum](docs/Enum.md) | Named constant collections. |
| [Interface](docs/ContractsAndScopes.md#interface) | Runtime method contracts. |
| [Namespace](docs/ContractsAndScopes.md#namespace) | Named, nestable scopes for related values. |

### Value types

| Module | Purpose |
| --- | --- |
| [Optional](docs/Values.md#optional) | A present value or an empty value. |
| [Result](docs/Values.md#result) | Success or error values with mapping and chaining. |
| [Pair](docs/Values.md#pair) | A pair of related values. |
| [Tuple](docs/Values.md#tuple) | Fixed-length values that preserve nil positions. |
| [Variant](docs/Values.md#variant) | Tagged value with runtime dispatch. |
| [Reference](docs/Values.md#reference) | A shared mutable value box. |

### Containers

| Module | Purpose |
| --- | --- |
| Containers.Array | Fixed-size indexed sequence. |
| Containers.Vector | Resizable indexed sequence. |
| Containers.Deque | Double-ended queue using a circular buffer. |
| Containers.Stack | Last-in, first-out container. |
| Containers.Queue | First-in, first-out container. |
| Containers.PriorityQueue | Binary heap with custom priority comparison. |
| Containers.Map | Key-value collection. |
| Containers.Set | Unique-value collection and set operations. |

See [Containers](docs/Containers.md) for the complete API.

### Algorithms and utilities

| Module | Purpose |
| --- | --- |
| [Algorithms](docs/Algorithms.md) | Find, filter, map, reduce, sort, reverse, unique, and predicates. |
| [Numeric](docs/Algorithms.md#numeric) | Accumulate, Iota, GCD, LCM, and inner product. |
| [Iterator](docs/ContractsAndScopes.md#iterator) | Numeric ranges, enumerate, zip, and reverse iteration. |
| [Scope](docs/ContractsAndScopes.md#scope) | Reverse-order deferred cleanup. |
| [String](docs/Utilities.md#string) | Plain string operations and transformations. |
| [StringBuilder](docs/Utilities.md#stringbuilder) | Efficiently builds strings from parts. |
| [Math](docs/Utilities.md#math) | Numeric helpers, interpolation, wrapping, and factorial. |
| [Type](docs/Utilities.md#type) | Runtime type and value inspection. |
| [Functional](docs/Utilities.md#functional) | Compose, pipe, bind, and once-only callbacks. |

## Quick start

Build the library as a Roblox model with Rojo:

~~~sh
rojo build default.project.json -o CppLuauLib.rbxm
~~~

Require the package's public entry point:

~~~lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib"))

local Class = CppLuau.Class
local Containers = CppLuau.Containers
local Optional = CppLuau.Optional
~~~

## Example

~~~lua
local Queue = CppLuau.Containers.Queue
local Optional = CppLuau.Optional

local tasks = Queue.new()
tasks:Enqueue("Load")
tasks:Enqueue("Save")

local nextTask = Optional.Some(tasks:Dequeue())
print(nextTask:Unwrap()) -- Load
~~~

A larger example is available in [examples/containers.luau](examples/containers.luau).

## Repository layout

~~~text
CppLuau-Lib/
├── .github/
├── docs/
├── examples/
├── src/
│   ├── Containers/
│   ├── Algorithms.lua
│   ├── Class.lua
│   ├── Enum.lua
│   ├── Functional.lua
│   ├── Interface.lua
│   ├── Iterator.lua
│   ├── Math.lua
│   ├── Namespace.lua
│   ├── Numeric.lua
│   ├── Optional.lua
│   ├── Pair.lua
│   ├── Reference.lua
│   ├── Result.lua
│   ├── Scope.lua
│   ├── String.lua
│   ├── StringBuilder.lua
│   ├── Struct.lua
│   ├── Tuple.lua
│   ├── Type.lua
│   ├── Variant.lua
│   └── init.lua
├── tests/
│   ├── RunTests.server.lua
│   └── specs/
├── AGENTS.md
├── CHANGELOG.md
├── CONTRIBUTING.md
├── default.project.json
├── test.project.json
├── rokit.toml
├── selene.toml
├── stylua.toml
└── wally.toml
~~~

## Development

Install the pinned tools with Rokit:

~~~sh
rokit install
wally install
~~~

Check formatting and lint the source:

~~~sh
stylua --check src tests examples
selene src
~~~

Build the package and test place:

~~~sh
rojo build default.project.json -o CppLuauLib.rbxm
rojo build test.project.json -o CppLuauLib-Tests.rbxlx
~~~

Open the test place in Roblox Studio and press **Play** to execute TestEZ specs under tests/specs.

## Design principles

- Strict Luau types and direct metatable-driven objects.
- Small modules with focused responsibilities.
- Predictable APIs and explicit edge-case behavior.
- Tests and documentation alongside public features.
- No fake manual-memory management: Luau uses garbage collection.

Source formatting is inspired by the type-first, compact style of [LocalOneX/MockSignal](https://github.com/LocalOneX/MockSignal). Repository organization follows common Roblox package conventions. Implementations are original.
