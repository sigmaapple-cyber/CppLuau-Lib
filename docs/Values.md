# Value utilities

These modules provide value wrappers commonly found in standard libraries.

## Optional

Represents either a present non-nil value or an empty value.

~~~lua
local result = CppLuau.Optional.Some(12)
	:Map(function(value)
		return value * 2
	end)

print(result:Unwrap()) -- 24
print(CppLuau.Optional.None():UnwrapOr(0)) -- 0
~~~

API:

- Optional.Some(value), Optional.None()
- :IsSome(), :IsNone()
- :Unwrap(), :UnwrapOr(fallback)
- :Map(callback), :AndThen(callback)

Some(nil) is rejected. Use None() to represent absence.

## Result

Represents success or failure without using exceptions as the normal return path.

~~~lua
local parsed = CppLuau.Result.Ok("42")
	:Map(tonumber)

print(parsed:Unwrap()) -- 42
~~~

API:

- Result.Ok(value), Result.Err(error)
- :IsOk(), :IsErr()
- :Unwrap(), :UnwrapErr(), :Expect(message)
- :Map(callback), :MapErr(callback), :AndThen(callback)

## Pair

Stores two related values.

- Pair.new(first, second)
- :Unpack()
- :Swap()
- :Map(callback)

## Tuple

Stores a fixed number of values, including nil positions.

~~~lua
local values = CppLuau.Tuple.new("name", nil, 10)
local name, optional, level = values:Unpack()
print(values:Size()) -- 3
~~~

API:

- Tuple.new(...)
- :Size(), :Get(index), :Unpack()
- :Map(callback), :ToArray()

ToArray() returns a packed table with an explicit n field.

## Variant

Stores one value with an explicit active tag. This provides a runtime tagged union pattern.

~~~lua
local value = CppLuau.Variant.new("Number", 12)

local output = value:Match({
	Number = function(number)
		return number * 2
	end,
	Text = function(text)
		return string.upper(text)
	end,
})

print(output) -- 24
~~~

API:

- Variant.new(tag, value)
- :GetTag(), :Get(), :Is(tag)
- :Set(tag, value)
- :Match(handlers)

Match requires a function for the active tag.

## Reference

A mutable box that can be shared by multiple parts of a program.

- Reference.new(value)
- :Get(), :Set(value)
- :Update(callback)
- :Swap(other)
- :CompareExchange(expected, replacement)

Luau uses garbage collection. This module does not allocate, free, or manually own memory.
