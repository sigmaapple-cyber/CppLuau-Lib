# Changelog

## 0.2.0 — Unreleased

### Added
- OrderedMap, preserving insertion order while providing key lookup.
- Heap algorithms: MakeHeap, PushHeap, PopHeap, SortHeap, and IsHeap.
- UTF-8 helpers for validation, character length, slicing, codepoints, and byte offsets.

### Improved
- Generic public types for Array, Vector, and Queue.
- Struct schemas are recursively frozen and reject unknown override fields.
- Queue periodically compacts its consumed prefix to avoid unbounded index growth.
- Public module paths and namespace exports use lower-camel naming.
- Package identity and project files use the name `luapp`.

### Notes
- C++ concepts are represented using Luau tables, types, and the Roblox runtime. No C++ ABI or manual memory model is implied.
