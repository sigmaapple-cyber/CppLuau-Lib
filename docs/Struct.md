# Struct

The `Struct` module defines a named schema and creates plain Luau table values from that schema.

## Create a struct

```lua
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

print(data.Coins) -- 100
print(data.Level) -- 1
print(data.Stats.XP) -- 0
```

Each call to `:Create()` copies table defaults recursively, so nested table defaults are not shared between values. Unknown override fields are ignored.

## API

### `Struct.new(name, schema)`

Creates a struct definition. The name must be a non-empty string, and schema field names must be strings.

### `struct:Create(values?)`

Creates a new table with copied schema defaults. Values supplied for known fields replace their defaults. Unknown fields are ignored.

### `struct:HasField(name)`

Returns whether the schema contains the requested field.

## Notes

- A struct value is a Luau table, not a Roblox `Instance`.
- The schema's top-level table is frozen after creation.
- Nested table defaults are cloned when each struct value is created.
