# Text

## String

`luapp.text.string` provides plain substring operations: Trim, StartsWith, EndsWith, Contains, Split, Join, Replace, Repeat, Reverse, Count, Lower, Upper, and ByteLength.

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


## UTF-8

The `utf8` module operates on Unicode codepoints while Luau string positions and lengths are byte-based.

- `IsValid(value)`, `Length(value)`
- `ByteOffset(value, characterIndex)`
- `Sub(value, firstCharacter, lastCharacter?)`
- `Codepoints(value)`, `Char(...codepoints)`

Character positions are one-based. `ByteOffset` returns the one-based byte position expected by Luau's string functions. Invalid UTF-8 is rejected by operations that require decoding.
