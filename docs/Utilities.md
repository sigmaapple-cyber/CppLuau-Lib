# Utilities

## String

Plain string helpers: Trim, StartsWith, EndsWith, Contains, Split, Join, Replace, Repeat, Reverse, and Count.

Split, Replace, and Count use plain substring matching rather than Lua patterns. Empty split fields are preserved. These operations use Luau's byte-oriented string functions and are not Unicode grapheme-aware.

## StringBuilder

StringBuilder stores appended string parts and joins them when ToString is called.

- StringBuilder.new()
- :Append(value), :AppendLine(value?)
- :Length(), :Clear(), :ToString()

## Math

Numeric helpers: Clamp, Lerp, InverseLerp, Remap, Round, Sign, Wrap, IsFinite, and Factorial.

Wrap(value, minimum, maximum) uses a half-open interval. Factorial accepts non-negative integers.

## Type

Runtime inspection helpers:

- Type.Of(value) — typeof(value).
- Type.Is(value, name) — runtime type comparison.
- Type.IsInteger(value), Type.IsNumber(value).
- Type.IsCallable(value) — functions and tables with a callable metatable.
- Type.IsArray(value) — table with sequential positive integer keys.

## Functional

Small helpers for adapting callbacks:

- Identity(value) — returns the input.
- Constant(value) — creates a callback which returns a fixed value.
- Compose(outer, inner) — applies inner before outer.
- Pipe(first, second) — passes the first result into the second callback.
- Bind(callback, ...) — binds leading arguments.
- Once(callback) — caches the callback's return values after its first successful call.

Once preserves multiple return values and does not mark a callback as complete when that callback throws.

## Reference

For a mutable reference box, see [Value utilities](Values.md#reference).
