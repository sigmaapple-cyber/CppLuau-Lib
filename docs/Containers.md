# Containers

All collection indexes are one-based, except buffer and bit offsets which are documented separately. Containers store non-nil values; use `Values.Optional` or a separate presence flag when nil itself must be represented.

## Sequence containers

### Array

Fixed-size indexed storage.

- `Array.new(size, fill)`
- `:Get(index)`, `:Set(index, value)`
- `:Fill(value)`
- `:Size()`, `:ToArray()`, `:ForEach(callback)`

### Vector

Resizable array.

- `Vector.new(values?)`
- `:PushBack(value)`, `:PopBack()`
- `:At(index)`, `:Set(index, value)`
- `:Insert(index, value)`, `:Erase(index)`
- `:Front()`, `:Back()`
- `:Resize(size, fill?)`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

Growing a vector requires a non-nil fill value.

### Deque

Double-ended circular buffer.

- `Deque.new(values?)`
- `:PushFront(value)`, `:PushBack(value)`
- `:PopFront()`, `:PopBack()`
- `:Front()`, `:Back()`, `:At(index)`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

### List

Doubly linked list.

- `List.new(values?)`
- `:PushFront(value)`, `:PushBack(value)`
- `:PopFront()`, `:PopBack()`
- `:At(index)`, `:Insert(index, value)`, `:Erase(index)`
- `:Find(value)`, `:Remove(value)`
- `:Front()`, `:Back()`, `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

### ForwardList

Singly linked list.

- `ForwardList.new(values?)`
- `:PushFront(value)`, `:PushBack(value)`, `:PopFront()`
- `:InsertAfter(index, value)`, `:EraseAfter(index)`
- `:Find(value)`, `:Remove(value)`
- `:Front()`, `:Back()`, `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

Index zero is the position before the first node for the `After` methods.

## Adaptors

### Stack

Last-in, first-out.

- `Stack.new(values?)`
- `:Push(value)`, `:Pop()`, `:Top()`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

### Queue

First-in, first-out.

- `Queue.new(values?)`
- `:Enqueue(value)`, `:Dequeue()`
- `:Front()`, `:Back()`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

### PriorityQueue

Binary heap. The default comparator creates a max-heap.

- `PriorityQueue.new(values?, compare?)`
- `:Push(value)`, `:Pop()`, `:Top()`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

The comparator returns true when its first argument has higher priority. A less-than comparator creates a min-heap.

## Associative containers

### HashMap

A Luau hash-table-backed key-value collection.

- `HashMap.new()`
- `:Set(key, value)`, `:Get(key)`, `:Has(key)`, `:Remove(key)`
- `:Size()`, `:Empty()`, `:Clear()`
- `:Keys()`, `:Values()`, `:ForEach(callback)`

Keys and values cannot be nil. False is a valid value. Iteration order is unspecified.

### HashSet

A Luau hash-table-backed unique-value collection.

- `HashSet.new(values?)`
- `:Add(value)`, `:Remove(value)`, `:Contains(value)`
- `:Union(other)`, `:Intersection(other)`, `:Difference(other)`
- `:IsSubsetOf(other)`
- `:Size()`, `:Empty()`, `:Clear()`, `:ToArray()`

Set output order is unspecified.

## Views and bit storage

### Span

Non-owning view over part of an array.

- `Span.new(source, first?, count?)`
- `:Get(index)`, `:Set(index, value)`
- `:Subspan(first, count?)`
- `:Size()`, `:Empty()`, `:ToArray()`, `:ForEach(callback)`

A span writes through to its source array. It does not copy or own the source.

### BitSet

Fixed-size bit collection backed by 32-bit words.

- `BitSet.new(size, fill?)`
- `:Set(index, value?)`, `:Reset(index?)`, `:Flip(index?)`
- `:Test(index)`, `:Count()`, `:Size()`
- `:Any()`, `:None()`, `:All()`, `:ToArray()`

Bit indexes are one-based.
