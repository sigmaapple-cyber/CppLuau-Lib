# Class

Public module: `luapp.core.class`.

The Class module creates table-based objects with single inheritance, constructor chaining, inherited method lookup, and runtime type checks.

## Create a class

~~~lua
local Class = luapp.core.class

local Entity = Class.new("Entity")
	:Constructor(function(self, name)
		self.Name = name
	end)

function Entity:GetName()
	return self.Name
end

local entity = Entity:Create("Alex")
print(entity:GetName())
~~~

## Inheritance

Use `:Extend()` to create a child class.

~~~lua
local Player = Entity:Extend("Player")
	:Constructor(function(self, name, level)
		self.Level = level
	end)

local player = Player:Create("Alex", 10)

print(player.Name)
print(player.Level)
print(player:IsA("Player"))
print(player:IsA(Entity))
~~~

Constructors run once per class, from base to derived. Every constructor receives the same arguments passed to `:Create()`. A derived constructor does not implicitly call its base constructor; the class system performs the chain.

## API

- `Class.new(name, base?)` creates a class.
- `:Extend(name)` creates a child class.
- `:Constructor(callback)` registers a constructor.
- `:Create(...)` creates an instance.
- `:GetName()`, `:GetBase()`.
- Instance: `:GetClass()`, `:GetClassName()`.
- `:IsA(nameOrClass)` checks the inheritance chain.

Use a class object with IsA when names may be duplicated across separate class hierarchies.

Instances are Luau tables, not Roblox Instances.
