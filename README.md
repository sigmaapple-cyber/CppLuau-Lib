# CppLuau-Lib

C++-inspired programming concepts implemented with native Luau. Built for Roblox developers who want class-like objects, structured values, enums, and reusable abstractions without a C++ compiler or transpilation step.

> **Status:** Early development. Public APIs may change before the first stable release.

## Modules

| Module | Status | Description |
| --- | --- | --- |
| `Class` | Implemented | Class objects, inheritance, constructor chaining, inherited methods, and `IsA`. |
| `Struct` | Implemented | Schema-based values with copied defaults and field checks. |
| `Enum` | Implemented | Named constant collections with immutable lookup values. |
| `Interface` | Planned | Runtime contract and method validation. |
| `Namespace` | Planned | Named scopes for organizing related values. |
| `Cast` | Planned | Explicit conversion and type-check helpers. |
| `Containers` | Planned | List, Stack, Queue, Map, and Set. |

## Quick start

The repository includes a Rojo project. Build the library as a Roblox model:

```sh
rojo build default.project.json -o CppLuauLib.rbxm
```

Import the resulting model into Studio or include the `src` folder in your own Rojo project. The public entry point exports all implemented modules:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib"))

local Class = CppLuau.Class
local Struct = CppLuau.Struct
local Enum = CppLuau.Enum
```

## Class example

```lua
local Entity = Class.new("Entity")
	:Constructor(function(self, name)
		self.Name = name
	end)

function Entity:GetName()
	return self.Name
end

local Player = Entity:Extend("Player")
	:Constructor(function(self, name, level)
		self.Level = level
	end)

local player = Player:Create("Alex", 10)

print(player:GetName())
print(player:IsA("Player")) -- true
print(player:IsA("Entity")) -- true
print(player:IsA(Entity)) -- true
print(player:GetClassName()) -- Player
```

Constructors run from the base class to the derived class. Every constructor receives the same arguments, so a derived constructor can use only the arguments it needs. Methods resolve from the instance's class and then through its base classes.

Guides: [Class](docs/Class.md) · [Struct](docs/Struct.md) · [Enum](docs/Enum.md).

## Repository layout

```text
CppLuau-Lib/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── workflows/
├── docs/
│   ├── Class.md
│   ├── Struct.md
│   └── Enum.md
├── examples/
├── src/
│   ├── init.lua
│   ├── Class.lua
│   ├── Struct.lua
│   └── Enum.lua
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
```

## Development

Install the pinned tools with [Rokit](https://github.com/rojo-rbx/rokit):

```sh
rokit install
wally install
```

Check formatting and lint the source:

```sh
stylua --check src tests examples
selene src
```

Build the library:

```sh
rojo build default.project.json -o CppLuauLib.rbxm
```

Build the TestEZ test place:

```sh
rojo build test.project.json -o CppLuauLib-Tests.rbxlx
```

Open the test place in Roblox Studio and press **Play**. The server runner executes the specs under `tests/specs`.

## Design

The code uses strict Luau typing and direct metatable-based objects. Its implementation style is inspired by the compact, type-first organization of [LocalOneX/MockSignal](https://github.com/LocalOneX/MockSignal). The repository layout follows common Roblox library conventions: a clear source entry point, isolated tests, examples, documentation, package metadata, and automated checks.

This project borrows organizational patterns, not other libraries' implementations.

## License

No license has been selected for this repository yet. Add a license before redistributing or accepting external contributions under open-source terms.
