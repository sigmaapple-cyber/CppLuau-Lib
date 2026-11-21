# Containers

The Containers module exports sequence and associative containers. All containers are table-backed Luau objects; they do not provide C++ iterator invalidation guarantees or compile-time element types.

~~~lua
local Containers = CppLuau.Containers

local values = Containers.Vector.new({ 10, 20 })
values:PushBack(30)
print(values:At(2)) -- 20

local queue = Containers.Queue.new()
queue:Enqueue("first"):Enqueue("second")
print(queue:Dequeue()) -- first

local unique = Containers.Set.new({ "a", "b", "a" })
print(unique:Size()) -- 2
~~~

## Array

A fixed-size, one-based sequence.

- Array.new(size, fill)
- :Get(index), :Set(index, value)
- :Fill(value)
- :Size(), :ToArray(), :ForEach(callback)

An array requires an explicit fill value when its size is non-zero. Its size never changes.

## Vector

A resizable, one-based sequence.

- Vector.new(values?)
- :PushBack(value), :PopBack()
- :At(index), :Set(index, value)
- :Insert(index, value), :Erase(index)
- :Front(), :Back()
- :Size(), :Empty(), :Clear()
- :Resize(size, fill?)
- :ToArray(), :ForEach(callback)

Growing with Resize requires a non-nil fill value because Luau arrays cannot contain nil entries.

## Deque

A double-ended queue backed by a circular buffer.

- Deque.new(values?)
- :PushFront(value), :PushBack(value)
- :PopFront(), :PopBack()
- :Front(), :Back(), :At(index)
- :Size(), :Empty(), :Clear(), :ToArray()

Push and pop operations at either end avoid shifting all remaining values.

## Stack

A last-in, first-out sequence.

- Stack.new(values?)
- :Push(value), :Pop(), :Top()
- :Size(), :Empty(), :Clear(), :ToArray()

The last input value is the top of a stack created from an array.

## Queue

A first-in, first-out sequence. Dequeue advances a head index instead of shifting the remaining array on every removal.

- Queue.new(values?)
- :Enqueue(value), :Dequeue()
- :Front(), :Back()
- :Size(), :Empty(), :Clear(), :ToArray()

## PriorityQueue

A binary heap which returns the highest-priority value first.

- PriorityQueue.new(values?, compare?)
- :Push(value), :Pop(), :Top()
- :Size(), :Empty(), :Clear(), :ToArray()

The default comparator creates a max-heap. Supply a comparator returning true when the first value has higher priority than the second to customize ordering. To create a min-heap, use a less-than comparator.

## Map

A key-value collection. Keys and values cannot be nil; false is a valid value.

- Map.new()
- :Set(key, value), :Get(key), :Has(key)
- :Remove(key)
- :Size(), :Empty(), :Clear()
- :Keys(), :Values(), :ForEach(callback)

Map iteration order is unspecified.

## Set

A collection of unique values.

- Set.new(values?)
- :Add(value), :Remove(value), :Contains(value)
- :Size(), :Empty(), :Clear(), :ToArray()
- :Union(other), :Intersection(other), :Difference(other)
- :IsSubsetOf(other)

Set output order is unspecified.
