# Text

## String

`CppLuau.Text.String` provides plain substring operations: Trim, StartsWith, EndsWith, Contains, Split, Join, Replace, Repeat, Reverse, Count, Lower, Upper, and ByteLength.

Split, Replace, and Count use plain substring matching rather than Lua patterns. These operations are byte-oriented and not Unicode grapheme-aware.

## StringBuilder

`StringBuilder.new()` builds a string from appended parts.

- `:Append(value)`, `:AppendLine(value?)`
- `:Length()`, `:Clear()`, `:ToString()`

## StringView

`StringView.new(source, first?, count?)` creates a non-owning view over a string slice.

- `:Size()`, `:Empty()`, `:At(index)`
- `:Slice(first, count?)`, `:Find(value, first?)`
- `:StartsWith(value)`, `:EndsWith(value)`, `:ToString()`

Strings are immutable in Luau, so a StringView avoids creating the slice until ToString is called.

## Format

- `Format(template, ...)` uses Luau's string.format rules.
- `Template(template, ...)` replaces zero-based fields such as {0} and {1}.
- `PadLeft(value, width, fill?)`, `PadRight(value, width, fill?)`.
- `Join(values, separator?)` converts each value with tostring before joining.
