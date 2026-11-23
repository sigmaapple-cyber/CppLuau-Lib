# luapp

C++-inspired programming primitives implemented in native Luau.

The library brings familiar ideas from C++ into Roblox Luau: class-based object models, value wrappers, generic containers, standard algorithms, heap operations, binary buffers, and text utilities. It uses Luau tables, types, metatables, and the Roblox runtime. It is not a C++ compiler or a manual-memory runtime.

## Install

Build the package with Rojo:

```sh
rojo build default.project.json -o luapp.rbxm
```

Place the model in `ReplicatedStorage` and require it:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp"))
```

## API

The entry point is deliberately small. Feature modules are grouped by responsibility and use lower-camel names.

| Namespace | Modules |
| --- | --- |
| `luapp.core` | `class`, `struct`, `enum`, `interface`, `namespace` |
| `luapp.values` | `optional`, `result`, `pair`, `tuple`, `variant`, `reference` |
| `luapp.containers` | `array`, `vector`, `deque`, `list`, `forwardList`, `stack`, `queue`, `priorityQueue`, `hashMap`, `hashSet`, `orderedMap`, `span`, `bitSet` |
| `luapp.algorithms` | `sequence`, `search`, `sort`, `heap` |
| `luapp.math` | `scalar`, `numeric`, `random`, `bit`, `complex` |
| `luapp.text` | `string`, `stringBuilder`, `stringView`, `format`, `utf8` |
| `luapp.utility` | `functional`, `iterator`, `typeInfo`, `scopeGuard` |
| `luapp.time` | `clock`, `duration`, `timer` |
| `luapp.binary` | `buffer` |

## Example

```lua
local containers = luapp.containers
local algorithms = luapp.algorithms

local scores = containers.vector.new({ 12, 4, 18, 7 })
local values = scores:ToArray()

algorithms.sort.Sort(values)
print(algorithms.search.BinarySearch(values, 12))

local names = containers.orderedMap.new()
names:Set("Ada", "Engineer")
names:Set("Grace", "Computer scientist")

names:ForEach(function(name, role)
	print(name, role)
end)
```

## Development

Install the tools pinned by Rokit, then install Wally dependencies:

```sh
rokit install
wally install
```

Run formatting, linting, and builds:

```sh
stylua --check src tests examples
selene src
rojo build default.project.json -o /tmp/luapp.rbxm
rojo build test.project.json -o /tmp/luapp-tests.rbxlx
```

Open the test place in Roblox Studio and press **Play** to execute the TestEZ suite. A successful Rojo build only confirms that the place can be built; it does not mean the runtime tests were executed.

## Design

- Strict Luau source and public type exports for generic containers.
- Lower-camel module paths and namespaces.
- One implementation per concept; no duplicate aliases or placeholder modules.
- One-based indexes for collection APIs. Binary buffer offsets are zero-based.
- Hash maps have unspecified iteration order; ordered maps preserve insertion order.
- Collections reject nil entries where nil would make storage ambiguous. Use `values.optional` or a tuple when absence is part of the data.
- Luau owns object lifetime through garbage collection. The library does not simulate C++ pointers, destructors, or manual allocation.

See [docs](docs/) for API contracts and [examples](examples/) for runnable patterns.
