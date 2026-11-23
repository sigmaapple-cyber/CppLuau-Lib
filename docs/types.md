# Core and value types

## Core

### Class

See [Class](Class.md). `luapp.core.class` creates metatable-backed classes with single inheritance and base-to-derived constructor chaining.

### Struct

See [Struct](Struct.md). `luapp.core.struct` creates table values from a schema and copies nested table defaults.

### Enum

See [Enum](Enum.md). `luapp.core.enum` creates frozen named-value collections.

### Interface

`luapp.core.interface.new(name, methods)` creates a runtime list of required method names. `:Validate(value)` returns a validity flag and missing method names; `:Assert(value)` throws on a missing method. It does not add compile-time structural typing to Luau.

### Namespace

`luapp.core.namespace.new(name)` creates a named table scope. Use `:Define`, `:Set`, `:Get`, `:Has`, `:Remove`, `:Child`, and `:Export`.

## Values

### Optional

`luapp.values.optional.Some(value)` and `None()` represent presence and absence. Methods: `:IsSome()`, `:IsNone()`, `:Unwrap()`, `:UnwrapOr(fallback)`, `:Map(callback)`, and `:AndThen(callback)`.

### Result

`luapp.values.result.Ok(value)` and `Err(error)` represent success and failure. Methods: `:IsOk()`, `:IsErr()`, `:Unwrap()`, `:UnwrapErr()`, `:Expect(message)`, `:Map(callback)`, `:MapErr(callback)`, and `:AndThen(callback)`.

### Pair and Tuple

- `Pair.new(first, second)`: `:Unpack()`, `:Swap()`, `:Map(callback)`.
- `Tuple.new(...)`: `:Size()`, `:Get(index)`, `:Unpack()`, `:Map(callback)`, `:ToArray()`.

Tuple stores an explicit length and preserves nil positions.

### Variant

`Variant.new(tag, value)` stores an active tag and value. Use `:GetTag()`, `:Get()`, `:Is(tag)`, `:Set(tag, value)`, and `:Match(handlers)`.

### Reference

`Reference.new(value)` creates a shared mutable box. Use `:Get()`, `:Set(value)`, `:Update(callback)`, `:Swap(other)`, and `:CompareExchange(expected, replacement)`.
