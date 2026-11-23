# Utility

## Functional

`luapp.utility.functional` provides Identity, Constant, Compose, Pipe, Bind, and Once. Once caches all return values after the first successful call.

## Iterator

`luapp.utility.iterator` provides generic-for iterators:

- `Range(first, last, step?)` yields a half-open numeric range.
- `Enumerate(values)` yields index and value.
- `Zip(left, right)` yields matching elements until the shorter array ends.
- `Reverse(values)` yields index and value from last to first.

## TypeInfo

`luapp.utility.typeInfo` provides Of, Is, IsInteger, IsNumber, IsCallable, IsArray, IsEmpty, and IsInstance.

## ScopeGuard

`ScopeGuard.new()` registers cleanup callbacks with `:Defer(callback)`. `:Close()` executes callbacks once in reverse order. `:Release()` discards callbacks without executing them. Errors from cleanup callbacks are sent to warn and do not stop later cleanup.


All module paths use lower-camel names. `scopeGuard` only runs explicitly registered callbacks when `:Close()` is called; it is not automatic destructor behavior.
