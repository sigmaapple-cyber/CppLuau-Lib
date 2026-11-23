# luapp

A C++-inspired library written in native Luau for Roblox. Work on the existing library as a real codebase, not as a module-count exercise.

## Layout

- `src/core`: class, struct, enum, interface, namespace.
- `src/values`: optional, result, pair, tuple, variant, reference.
- `src/containers`: sequential, linked, associative, and bit containers.
- `src/algorithms`: sequence, search, sort, and heap algorithms.
- `src/math`, `src/text`, `src/time`, `src/binary`: focused domain modules.
- `src/utility`: functional, iteration, type inspection, and cleanup helpers.
- Every category exports through its `init.lua`; `src/init.lua` is the public entry point.

## Luau style

- Use `--!strict` in every source and test module.
- Use lower-camel names for module files, local variables, and namespace exports.
- Use PascalCase for public methods and exported type names.
- Declare raw object shapes and prototype types near the top of an object module.
- Prefer direct tables and metatables. Do not introduce a framework to wrap a simple table.
- Give collection APIs generic type parameters when the stored value type can be expressed.
- Use a local helper only when it removes meaningful duplication or clarifies an algorithm.
- Keep functions short and explicit. Avoid clever control flow, speculative abstractions, and pointless defensive code.
- Comments explain public contracts or non-obvious algorithms. Do not narrate obvious statements.
- Follow the formatting already configured in `stylua.toml`.

## Design

- Preserve Luau and Roblox semantics; do not pretend this is C++ execution.
- Document index bases, iteration order, mutation, and complexity when they matter.
- Do not silently discard input or invent behavior for invalid input.
- Keep ordered and unordered containers distinct.
- Do not expose internals when a clear method can express the operation.
- Add tests for normal use, boundary cases, and regressions.
- Update the relevant guide and examples when public behavior changes.
- Never copy source implementations from reference repositories.

## Validation

```sh
stylua --check src tests examples
selene src
wally install
rojo build default.project.json -o /tmp/luapp.rbxm
rojo build test.project.json -o /tmp/luapp-tests.rbxlx
```

The TestEZ suite must run inside Roblox Studio. Do not report runtime tests as passed based only on a successful Rojo build.
