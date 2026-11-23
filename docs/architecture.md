# Project structure

`luapp` is a Luau library, not a C++ compatibility runtime. It translates selected programming concepts into APIs that fit Luau's type system, table model, garbage collector, and Roblox environment.

## Public entry point

Require the model once:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp"))
```

The public namespaces are `core`, `values`, `containers`, `algorithms`, `math`, `text`, `utility`, `time`, and `binary`. Each namespace is assembled by its local `init.lua`. Feature modules do not require one another unless a real dependency exists.

## Naming

Source folders and module files use lower-camel names. Public methods and exported types use PascalCase. Constructors use `new`. The naming is intentional: modules are required as values (`luapp.containers.vector`), while their methods describe operations (`:PushBack()`).

## Types

Collection modules preserve element types through generics where their public contract permits it. Dynamic heterogeneous records use `any` only where the shape is genuinely open, such as schemas and runtime interface checks.

## Semantics

- Sequence and span indexes are one-based.
- Binary buffer offsets are zero-based.
- HashMap iteration order is unspecified. OrderedMap preserves insertion order.
- Container values are non-nil; use `values.optional` to represent absence.
- Methods document whether they mutate the receiver or return a copy.
- Luau garbage collection owns object lifetime. ScopeGuard runs callbacks explicitly; it is not a destructor or automatic stack-unwinding mechanism.

## Adding a module

Add a feature only when it provides a distinct, useful operation that does not belong in an existing module. Export it through the category `init.lua`, add focused TestEZ coverage, document edge cases and mutation behavior, and provide an example when usage is not self-evident.
