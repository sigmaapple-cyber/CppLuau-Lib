# Algorithms

The algorithms are split by operation instead of being collected in one generic module.

## Sequence

Array transformations and predicates.

- `Find(values, predicate)`, `FindIndex(values, predicate)`
- `Count(values, predicate)`, `CountValue(values, target)`
- `Any(values, predicate)`, `All(values, predicate)`
- `Filter(values, predicate)`, `Map(values, callback)`
- `Reduce(values, callback, initial)`, `ForEach(values, callback)`
- `Sorted(values, comparator?)`, `Reversed(values)`, `Unique(values)`

Predicates and mapping callbacks receive value and index. Reduce callbacks receive accumulator, value, and index.

## Search

Binary search functions require sorted input.

- `LowerBound(values, target, comparator?)`
- `UpperBound(values, target, comparator?)`
- `BinarySearch(values, target, comparator?)`
- `Contains(values, target, comparator?)`

Bounds return one-based insertion positions. When a value is not found, BinarySearch returns nil.

## Sort

- `Sort(values, comparator?)` sorts the supplied array in place.
- `StableSort(values, comparator?)` returns a new stable-sorted array.
- `Merge(left, right, comparator?)` merges two sorted arrays.
- `IsSorted(values, comparator?)` checks ordering.

The default comparator sorts ascending. Custom comparators return true when the left value should appear before the right value.

## math.numeric

Arithmetic algorithms.

- `Accumulate(values, initial, callback?)`
- `Iota(count, initial?, step?)`
- `GCD(left, right)`, `LCM(left, right)`
- `InnerProduct(left, right, initial?)`

GCD and LCM require integer inputs. InnerProduct uses the shorter array length.


## Heap

Heap algorithms mutate the supplied array.

- `MakeHeap(values, comparator?)` builds a heap in place.
- `IsHeap(values, comparator?)` checks heap order.
- `PushHeap(values, comparator?)` restores heap order after appending one value.
- `PopHeap(values, comparator?)` moves the top value to the final position and restores the remaining heap.
- `SortHeap(values, comparator?)` sorts in place.

The default comparator is less-than, producing a max-heap. For `PopHeap`, call `table.remove(values)` afterward to discard the former root.
