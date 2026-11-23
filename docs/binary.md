# binary.buffer

`luapp.binary.buffer.new(capacity?)` creates a growable byte buffer with a zero-based cursor.

## Cursor and capacity

- `:Position()` returns the cursor offset.
- `:Seek(position)` moves the cursor within written data.
- `:Size()` returns the written byte count.
- `:Capacity()` returns allocated capacity.
- `:Clear()` resets the written length and cursor.

## Writes

- `:WriteU8(value)`, `:WriteI8(value)`
- `:WriteU16(value)`, `:WriteI16(value)`
- `:WriteU32(value)`, `:WriteI32(value)`
- `:WriteF32(value)`, `:WriteF64(value)`
- `:WriteString(value)`
- `:WriteBytes(buffer, first?, count?)`

Multi-byte numeric writes use little-endian order. Integer writers validate the representable range.

## Reads

- `:ReadU8()`, `:ReadI8()`
- `:ReadU16()`, `:ReadI16()`
- `:ReadU32()`, `:ReadI32()`
- `:ReadF32()`, `:ReadF64()`
- `:ReadString(count)`

Reads throw if they would advance beyond the written data.

## Conversion

- `:ToBuffer()` returns a copy of the written bytes.
- `:ToString()` returns the written bytes as a string.

The module uses Luau's built-in buffer type. It is not a C++ memory allocator and does not expose raw pointers.
