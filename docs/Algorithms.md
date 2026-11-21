# Algorithms

The `Algorithms` module provides common array operations. Operations that return a collection create a new array unless their name explicitly describes iteration.

- `Find(values, predicate)` — first matching value.
- `FindIndex(values, predicate)` — first matching one-based index.
- `Count(values, predicate)` — number of matches.
- `CountValue(values, target)` — number of equal values.
- `Any(values, predicate)` — whether at least one value matches.
- `All(values, predicate)` — whether every value matches.
- `Filter(values, predicate)` — matching values.
- `Map(values, callback)` — transformed values.
- `Reduce(values, callback, initial)` — accumulated value.
- `ForEach(values, callback)` — visit every value.
- `Sorted(values, comparator?)` — sorted copy.
- `Reversed(values)` — reversed copy.
- `Unique(values)` — first occurrence of each value, preserving order.

Predicates receive `(value, index)`. Mapping callbacks receive `(value, index)`. Reduce callbacks receive `(accumulator, value, index)`.

```lua
local scores = { 4, 8, 2, 10 }

local passing = CppLuau.Algorithms.Filter(scores, function(score)
	return score >= 5
end)

local doubled = CppLuau.Algorithms.Map(passing, function(score)
	return score * 2
end)

local total = CppLuau.Algorithms.Reduce(doubled, function(sum, score)
	return sum + score
end, 0)

print(total) -- 36
```
