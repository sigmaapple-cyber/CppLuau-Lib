# Contracts and scopes

## Interface

Defines a set of required method names and checks a table-based object at runtime.

```lua
local Drawable = CppLuau.Interface.new("Drawable", {
	"Draw",
	"Destroy",
})

local valid, missing = Drawable:Validate(object)
if not valid then
	warn(table.concat(missing, ", "))
end
```

API:

- `Interface.new(name, methods)`
- `:Validate(target)` — returns `valid, missingMethods`.
- `:Assert(target)` — throws when methods are missing.
- `:HasMethod(name)`

This is runtime validation, not Luau compile-time structural typing.

## Namespace

Stores named values and nested namespaces.

```lua
local std = CppLuau.Namespace.new("std")
local containers = std:Child("containers")

containers:Define("Vector", CppLuau.Containers.Vector)
print(containers:Get("Vector"))
```

API:

- `Namespace.new(name)`
- `:Define(name, value)` — adds a value only when the key is unused.
- `:Set(name, value)` — adds or replaces a value.
- `:Get(name)`, `:Has(name)`, `:Remove(name)`
- `:Child(name)` — returns or creates a nested namespace.
- `:Export()` — frozen shallow copy of values.

## Scope

Registers cleanup functions and executes them once in reverse registration order. This is useful for predictable cleanup of connections, temporary objects, and other resources.

```lua
local scope = CppLuau.Scope.new()

scope:Defer(function()
	print("clean up second")
end)

scope:Defer(function()
	print("clean up first")
end)

scope:Destroy()
```

API:

- `Scope.new()`
- `:Defer(callback)`
- `:Destroy()`
- `:IsDestroyed()`
- `:Count()`

Cleanup continues when a callback errors; the error is sent to `warn`. Luau has garbage collection, so this is an explicit cleanup scope rather than a C++ destructor or memory manager.

## Iterator

Creates closures for generic-for loops.

- `Iterator.Range(first, last, step?)` — numeric half-open range; the last value is excluded.
- `Iterator.Enumerate(values)` — yields index and value.
- `Iterator.Zip(left, right)` — yields matching values until the shorter array ends.
- `Iterator.Reverse(values)` — yields index and value from last to first.
