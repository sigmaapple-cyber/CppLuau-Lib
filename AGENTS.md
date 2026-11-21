# CppLuau-Lib

A Luau library implementing C++-inspired programming concepts. This is not a C++ compiler, transpiler, or syntax replacement.

## Repository map

- `src/init.lua`: public package entry point.
- `src/Class.lua`: class objects, inheritance, constructors, and instance checks.
- `src/Struct.lua`: schema-based data values.
- `src/Enum.lua`: named constant collections.
- `tests/specs`: TestEZ behavior tests.
- `tests/RunTests.server.lua`: Studio test runner.
- `docs`: public API guides.
- `examples`: runnable usage examples.

## Coding style

Follow the Luau style shown in LocalOneX/MockSignal as closely as the feature allows.

- Begin source files with `--!strict`.
- Put raw object shapes, prototype schemas, and exported types near the top.
- Prefer `local module = {}`, `module.new = function(...)`, and `module.Method = function(self: Type, ...)`.
- Use metatables and `__index` directly for object behavior.
- Keep method implementations small and data flow direct.
- Use natural, contextual names such as `raw`, `self`, `callback`, `class`, and `idx`.
- Use tabs, preserve readable spacing, and avoid unnecessary wrappers.
- Use multiline method comments where they clarify public behavior; do not comment every line.
- Use generics when they improve the public type contract.
- Avoid unnecessary abstraction layers, artificial naming, excessive defensive code, and unrelated refactors.

## API and compatibility

- Keep public methods typed and document their arguments, return values, and behavior.
- Preserve existing behavior unless a deliberate API change is documented.
- For inheritance, execute constructors from base to derived and pass the same argument list to each constructor.
- Prefer exact class-object identity when a name comparison could be ambiguous.
- Add TestEZ specs for new public behavior and regression cases.
- Update README or the relevant guide when a public API changes.

## Validation

Run these commands before considering a change complete:

```sh
stylua --check src tests examples
selene src
wally install
rojo build default.project.json -o /tmp/CppLuauLib.rbxm
rojo build test.project.json -o /tmp/CppLuauLib-Tests.rbxlx
```

Run the TestEZ place in Roblox Studio. Do not claim tests or builds passed unless they were actually run.

## Repository rules

- Do not copy other repositories' implementations or documentation verbatim.
- Do not add placeholder modules just to make the file tree look larger.
- Keep generated dependencies and build output out of commits.
- Keep the package API focused; implement planned modules only when they have real behavior and tests.
