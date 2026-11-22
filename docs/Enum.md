# Enum

Public module: `CppLuau.Core.Enum`.

Enum creates named collections of constants from a list or name-to-value dictionary.

~~~lua
local Enum = CppLuau.Core.Enum

local State = Enum.new("State", {
	"Idle",
	"Running",
	"Finished",
})

print(State:Get("Idle"))
print(State:Get("Finished"))
~~~

List values receive one-based numeric values. Dictionary values are retained.

## API

- `Enum.new(name, values)` creates an enum.
- `:Get(name)` returns a value or nil.
- `:Has(name)` checks for a name.

Names must be non-empty and duplicate names are rejected. The values table is frozen. These values are not Roblox EnumItems.
