# CppLuau-Lib

C++-inspired library modules implemented in Luau for Roblox. The project focuses on familiar programming building blocks: object models, value types, containers, algorithms, text processing, binary data, mathematics, and time utilities.

It is a Luau library. It does not compile or execute C++.

## Install

Build the model with Rojo:

~~~sh
rojo build default.project.json -o CppLuau.rbxm
~~~

Place the model in ReplicatedStorage, then require its entry point:

~~~lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib"))
~~~

## API layout

The public API is grouped by responsibility. There are no flat duplicate exports.

### Core

| Module | Purpose |
| --- | --- |
| `Core.Class` | Classes, single inheritance, and constructor chaining |
| `Core.Struct` | Schema-based values |
| `Core.Enum` | Named constants |
| `Core.Interface` | Runtime method contracts |
| `Core.Namespace` | Nested named scopes |

### Values

| Module | Purpose |
| --- | --- |
| `Values.Optional` | Present or absent value |
| `Values.Result` | Success or error result |
| `Values.Pair` | Pair of values |
| `Values.Tuple` | Fixed argument/value sequence |
| `Values.Variant` | Tagged alternative |
| `Values.Reference` | Shared mutable value |

### Containers

| Module | Purpose |
| --- | --- |
| `Containers.Array` | Fixed-size sequence |
| `Containers.Vector` | Resizable sequence |
| `Containers.Deque` | Double-ended circular buffer |
| `Containers.List` | Doubly linked list |
| `Containers.ForwardList` | Singly linked list |
| `Containers.Stack` | Last-in, first-out |
| `Containers.Queue` | First-in, first-out |
| `Containers.PriorityQueue` | Binary heap |
| `Containers.HashMap` | Hash-table-backed key-value collection |
| `Containers.HashSet` | Hash-table-backed unique values |
| `Containers.Span` | Non-owning array view |
| `Containers.BitSet` | Fixed-size bit collection |

### Algorithms

| Module | Purpose |
| --- | --- |
| `Algorithms.Sequence` | Find, map, filter, reduce, predicates, unique |
| `Algorithms.Search` | Binary search, lower and upper bounds |
| `Algorithms.Sort` | Sort, stable sort, merge, sorted check |

### Math

| Module | Purpose |
| --- | --- |
| `Math.Scalar` | Scalar operations and statistics |
| `Math.Numeric` | Accumulation, sequences, GCD, LCM |
| `Math.Random` | Seeded xorshift32 generator |
| `Math.Bit` | 32-bit bitwise operations |
| `Math.Complex` | Complex number arithmetic |

### Text

| Module | Purpose |
| --- | --- |
| `Text.String` | Plain string operations |
| `Text.StringBuilder` | Build strings from appended parts |
| `Text.StringView` | Non-owning string slice |
| `Text.Format` | Positional templates and padding |

### Utility

| Module | Purpose |
| --- | --- |
| `Utility.Functional` | Compose, pipe, bind, once |
| `Utility.Iterator` | Range, enumerate, zip, reverse |
| `Utility.TypeInfo` | Runtime type inspection |
| `Utility.ScopeGuard` | Reverse-order cleanup callbacks |

### Time and binary data

| Module | Purpose |
| --- | --- |
| `Time.Clock` | Monotonic and Unix clock helpers |
| `Time.Duration` | Duration arithmetic and conversion |
| `Time.Timer` | Accumulated elapsed-time timer |
| `Binary.Buffer` | Growable byte buffer and primitive reads/writes |

## Example

~~~lua
local Containers = CppLuau.Containers
local Random = CppLuau.Math.Random
local Search = CppLuau.Algorithms.Search

local values = Containers.Vector.new({ 8, 2, 5, 1 })
local sorted = CppLuau.Algorithms.Sort.StableSort(values:ToArray())

local random = Random.new(1234)
local picked = sorted[random:NextInteger(1, #sorted)]

print(Search.BinarySearch(sorted, picked))
~~~

More examples are in [examples](examples/).

## Repository

~~~text
src/
├── Core/
├── Values/
├── Containers/
├── Algorithms/
├── Math/
├── Text/
├── Utility/
├── Time/
├── Binary/
└── init.lua
tests/
├── RunTests.server.lua
└── specs/
docs/
examples/
~~~

## Development

Install tools and dependencies:

~~~sh
rokit install
wally install
~~~

Run formatting, linting, and builds:

~~~sh
stylua --check src tests examples
selene src
rojo build default.project.json -o CppLuau.rbxm
rojo build test.project.json -o CppLuau-Tests.rbxlx
~~~

Open the test place in Roblox Studio and press **Play** to run the TestEZ specifications.

## Design

- Strict Luau types for public object shapes and APIs.
- Category folders with one public entry point per category.
- Data structures implemented for the operations they expose.
- Tests and API notes live alongside the source.
- No claims of C++ ABI, template instantiation, pointers, or manual memory management. Luau has its own runtime and garbage collector.

The source style takes inspiration from the compact, type-first organization used by [LocalOneX/MockSignal](https://github.com/LocalOneX/MockSignal). Implementations in this repository are original.
