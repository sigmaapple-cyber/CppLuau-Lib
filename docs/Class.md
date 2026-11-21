# Class

The `Class` module creates class objects and table-based instances. It supports single inheritance, base-to-derived constructor chaining, inherited methods, and runtime type checks.

## Create a class

```lua
local Entity = Class.new("Entity")
	:Constructor(function(self, name)
		self.Name = name
	end)

function Entity:GetName()
	return self.Name
end

local entity = Entity:Create("Alex")
print(entity:GetName())
```

## Inheritance

Use `:Extend()` to create a child class. A child class can define its own constructor and methods while inheriting methods from its parent.

```lua
local Entity = Class.new("Entity")
	:Constructor(function(self, name)
		self.Name = name
	end)

local Player = Entity:Extend("Player")
	:Constructor(function(self, name, level)
		self.Level = level
	end)

local player = Player:Create("Alex", 10)

print(player.Name) -- Alex
print(player.Level) -- 10
print(player:IsA("Player")) -- true
print(player:IsA("Entity")) -- true
```

### Constructor order

Constructors execute once per class in the inheritance chain, starting at the base class and ending at the class used to create the instance.

Every constructor receives the same arguments passed to `:Create()`. Constructors do not automatically receive a shortened argument list based on their position in the inheritance chain.

### Method lookup

An instance first resolves a member on its own class. If the member is not present, lookup continues through its base classes. A child class can override a parent method by defining a member with the same name.

## API

### `Class.new(name, base?)`

Creates a class object. `name` must be a non-empty string. The optional `base` must be a class created by this module.

### `class:Extend(name)`

Creates and returns a child class whose direct base is `class`.

### `class:Constructor(callback)`

Sets the constructor for this class and returns the class object for chaining. The callback receives the new instance as its first argument, followed by every argument passed to `:Create()`.

### `class:Create(...)`

Creates an instance and executes constructors from base to derived.

### `class:GetName()`

Returns this class's name.

### `class:GetBase()`

Returns the direct base class, or `nil` for a root class.

### `instance:GetClass()`

Returns the exact class object used to create the instance.

### `instance:GetClassName()`

Returns the name of the exact class used to create the instance.

### `:IsA(target)`

Available on class objects and instances. Accepts either a class name or a class object.

- A string target checks class names in the inheritance chain.
- A class-object target checks exact class identity in the inheritance chain.

Use a class object when different inheritance trees may contain classes with the same name.

## Notes

- Inheritance is single-parent.
- Constructors are optional.
- The instance is a Luau table; it is not a Roblox `Instance`.
- Class methods and instance methods use ordinary table lookup through metatables.
