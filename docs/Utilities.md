# Utilities

## String

Plain string helpers: `Trim`, `StartsWith`, `EndsWith`, `Contains`, `Split`, `Join`, `Replace`, `Repeat`, `Reverse`, and `Count`.

`Split`, `Replace`, and `Count` use plain substring matching rather than Lua patterns. Empty split fields are preserved. These operations use Luau's byte-oriented string functions and are not Unicode grapheme-aware.

## Math

Numeric helpers: `Clamp`, `Lerp`, `InverseLerp`, `Remap`, `Round`, `Sign`, `Wrap`, `IsFinite`, and `Factorial`.

`Wrap(value, minimum, maximum)` uses a half-open interval. `Factorial` accepts non-negative integers.

## Type

Runtime inspection helpers:

- `Type.Of(value)` — `typeof(value)`.
- `Type.Is(value, name)` — runtime type comparison.
- `Type.IsInteger(value)`, `Type.IsNumber(value)`.
- `Type.IsCallable(value)` — functions and tables with a callable metatable.
- `Type.IsArray(value)` — table with sequential positive integer keys.

## Reference

For a mutable reference box, see [Value utilities](Values.md#reference).
