--!strict
--[[
	A binary-heap priority queue.
]]

type Compare = (any, any) -> boolean

type RawPriorityQueueObject = {
	_Heap: { any },
	_Compare: Compare,
}

type ProtoSchema = {
	new: (values: { any }?, compare: Compare?) -> PriorityQueueObject,
	Push: (self: PriorityQueueObject, value: any) -> PriorityQueueObject,
	Pop: (self: PriorityQueueObject) -> any,
	Top: (self: PriorityQueueObject) -> any,
	Size: (self: PriorityQueueObject) -> number,
	Empty: (self: PriorityQueueObject) -> boolean,
	Clear: (self: PriorityQueueObject) -> (),
	ToArray: (self: PriorityQueueObject) -> { any },
}

export type PriorityQueueObject = typeof(setmetatable({} :: RawPriorityQueueObject, { __index = {} :: ProtoSchema }))

local module = {}

local function push(self: PriorityQueueObject, value: any)
	local heap = self._Heap
	local idx = #heap + 1

	heap[idx] = value

	while idx > 1 do
		local parent = math.floor(idx / 2)
		if self._Compare(heap[parent], heap[idx]) then
			break
		end

		heap[parent], heap[idx] = heap[idx], heap[parent]
		idx = parent
	end
end

local function pop(self: PriorityQueueObject)
	local heap = self._Heap
	local count = #heap
	if count == 0 then
		return nil
	end

	local value = heap[1]
	local last = table.remove(heap)

	if count == 1 then
		return value
	end

	heap[1] = last

	local idx = 1
	local size = #heap

	while true do
		local left = idx * 2
		local right = left + 1
		local child = left

		if left > size then
			break
		end

		if right <= size and not self._Compare(heap[left], heap[right]) then
			child = right
		end

		if self._Compare(heap[idx], heap[child]) then
			break
		end

		heap[idx], heap[child] = heap[child], heap[idx]
		idx = child
	end

	return value
end

--[[
	Creates a priority queue. The default comparator makes the largest value the top.
]]
module.new = function(values: { any }?, compare: Compare?)
	assert(values == nil or type(values) == "table", "PriorityQueue values must be a table")

	local object = setmetatable(
		{
			_Heap = {},
			_Compare = compare or function(a, b)
				return a > b
			end,
		} :: RawPriorityQueueObject,
		{ __index = module }
	) :: PriorityQueueObject

	if values then
		for _, value in ipairs(values) do
			object:Push(value)
		end
	end

	return object
end

--[[
	Inserts a value and restores heap order.
]]
module.Push = function(self: PriorityQueueObject, value: any)
	assert(value ~= nil, "PriorityQueue cannot store nil")

	push(self, value)
	return self
end

--[[
	Removes and returns the highest-priority value.
]]
module.Pop = function(self: PriorityQueueObject)
	return pop(self)
end

--[[
	Returns the highest-priority value without removing it.
]]
module.Top = function(self: PriorityQueueObject)
	return self._Heap[1]
end

--[[
	Returns the number of stored values.
]]
module.Size = function(self: PriorityQueueObject)
	return #self._Heap
end

--[[
	Checks whether the queue is empty.
]]
module.Empty = function(self: PriorityQueueObject)
	return #self._Heap == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: PriorityQueueObject)
	table.clear(self._Heap)
end

--[[
	Returns a shallow copy of the internal heap order.
]]
module.ToArray = function(self: PriorityQueueObject)
	return table.clone(self._Heap)
end

return module
