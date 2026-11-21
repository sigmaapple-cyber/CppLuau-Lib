# CppLuau-Lib

A Luau library bringing C++-inspired programming concepts into Roblox and Luau.

## Direction

This is **not C++ compiled inside Luau**. It implements familiar ideas with native Luau syntax, including class-like objects, structs, enums, interfaces, namespaces, casts, containers, and utilities.

## Current modules

- **Class** — class objects, instance creation, inheritance, constructor chaining, and `IsA`
- **Struct** — schema-based data structures with defaults
- **Enum** — named constant collections

## Planned modules

- **Interface** — contract and method validation
- **Namespace** — organized module-like scopes
- **Cast** — explicit type conversion helpers
- **Containers** — List, Stack, Queue, Map, Set

Modules are developed incrementally, with typed APIs and small implementations.

## Class example

```lua
local Class = require(path.Class)

local Entity = Class.new("Entity")
	:Constructor(function(self, name)
		self.Name = name
	end)

local Player = Entity:Extend("Player")
	:Constructor(function(self, name, level)
		self.Level = level
	end)

function Player:GetName()
	return self.Name
end

local player = Player:Create("Alex", 10)
print(player:GetName())
print(player:IsA("Player")) -- true
print(player:IsA("Entity")) -- true
```

Constructors run from base to derived. All constructors receive the same arguments; derived constructors can ignore arguments they don't need.

## Style

See [AGENTS.md](AGENTS.md). Code follows a compact, metatable-driven Luau style inspired by LocalOneX's MockSignal, without copying its implementation.
