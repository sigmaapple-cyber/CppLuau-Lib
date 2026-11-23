# Contributing

Keep changes small enough to review, explicit in behavior, and consistent with Luau's runtime.

## Before editing

1. Read [AGENTS.md](AGENTS.md).
2. Inspect the implementation and its tests.
3. Check whether an existing module already owns the behavior.

## Source rules

- Use `--!strict`.
- Prefer lower-camel module names and direct module tables.
- Keep object shapes and exported types near the top of each module.
- Use generics for collection contracts when they genuinely preserve type information.
- Avoid redundant wrappers, speculative abstractions, and comments that repeat the code.
- Document ordering, index bases, mutation, and complexity where relevant.

## Tests and checks

Add TestEZ coverage for normal behavior, boundaries, and regressions.

```sh
stylua --check src tests examples
selene src
wally install
rojo build test.project.json -o /tmp/luapp-tests.rbxlx
```

Run the test place in Roblox Studio to execute TestEZ. Build success is not runtime test success.

## Pull requests

Describe the behavior changed, why it belongs in the library, compatibility impact, and the checks actually run. Do not claim a check passed unless it ran.
