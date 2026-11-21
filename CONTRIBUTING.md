# Contributing

CppLuau-Lib is an early-stage Luau library. Keep changes focused, typed, tested, and consistent with the existing API.

## Before changing code

1. Read [AGENTS.md](AGENTS.md).
2. Check the existing module and its tests.
3. Keep public behavior and naming consistent unless the change is intentional and documented.

## Code style

- Use `--!strict`.
- Follow the type-first, metatable-driven style used by LocalOneX/MockSignal.
- Prefer small functions and direct Luau operations.
- Keep comments purposeful and focused on public behavior.
- Avoid broad refactors unrelated to the feature.

## Tests

Add or update TestEZ specs under `tests/specs`. Cover normal behavior, edge cases, and regression cases for public APIs.

Run:

```sh
stylua --check src tests examples
selene src
wally install
rojo build test.project.json -o /tmp/CppLuauLib-Tests.rbxlx
```

Open the test place in Roblox Studio and press **Play** to execute the server test runner.

## Pull requests

Use a focused title and describe:

- What changed.
- Why the change is needed.
- Which tests or checks were run.
- Any public API or compatibility impact.

Do not claim a check passed unless it was actually executed.
