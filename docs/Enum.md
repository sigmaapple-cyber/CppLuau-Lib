# Enum

The `Enum` module creates named collections of constant values. It accepts either a list or a name-to-value dictionary.

## Create an enum from a list

```lua
local State = Enum.new("State", {
	"Idle",
	"Running",
	"Finished",
})

print(State:Get("Idle")) -- 1
print(State:Get("Finished")) -- 3
```

List entries receive their one-based numeric positions.

## Create an enum from a dictionary

```lua
local ErrorCode = Enum.new("ErrorCode", {
	None = 0,
	NotFound = 404,
	Denied = 403,
})

print(ErrorCode:Get("NotFound")) -- 404
```

## API

### `Enum.new(name, values)`

Creates an enum from a list or dictionary. Names must be non-empty strings. List entries must be non-empty strings, and duplicate names are rejected.

### `enum:Get(name)`

Returns the value associated with a name, or `nil` when the name does not exist.

### `enum:Has(name)`

Returns whether the enum contains the requested name.

## Notes

- The enum's value table is frozen after creation.
- Enum values are not Roblox `EnumItem` values.
