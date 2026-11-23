# Struct

Public module: `luapp.core.struct`.

Struct defines a named schema and creates table values from it.

~~~lua
local Struct = luapp.core.struct

local PlayerData = Struct.new("PlayerData", {
	Coins = 0,
	Level = 1,
	Stats = {
		XP = 0,
	},
})

local data = PlayerData:Create({
	Coins = 100,
})

print(data.Coins, data.Level, data.Stats.XP)
~~~

Each call to `:Create()` clones table defaults recursively so nested tables are independent. Unknown override fields are ignored.

## API

- `Struct.new(name, schema)` creates a definition.
- `:Create(values?)` creates a value from copied defaults and known overrides.
- `:HasField(name)` checks for a schema field.

The schema's top-level table is frozen. Struct values are ordinary Luau tables.
