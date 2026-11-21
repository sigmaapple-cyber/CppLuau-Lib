--!strict
--[[
	A double-ended queue backed by a circular buffer.
]]

type RawDequeObject = {
	_Items: { [number]: any },
	_First: number,
	_Count: number,
	_Capacity: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> DequeObject,
	PushFront: (self: DequeObject, value: any) -> DequeObject,
	PushBack: (self: DequeObject, value: any) -> DequeObject,
	PopFront: (self: DequeObject) -> any,
	PopBack: (self: DequeObject) -> any,
	Front: (self: DequeObject) -> any,
	Back: (self: DequeObject) -> any,
	At: (self: DequeObject, index: number) -> any,
	Size: (self: DequeObject) -> number,
	Empty: (self: DequeObject) -> boolean,
	Clear: (self: DequeObject) -> (),
	ToArray: (self: DequeObject) -> { any },
}

export type DequeObject = typeof(setmetatable({} :: RawDequeObject, { __index = {} :: ProtoSchema }))

local module = {}

local function grow(self: DequeObject)
	local capacity = self._Capacity * 2
	local raw = table.create(capacity)

	for idx = 1, self._Count do
		local current = ((self._First + idx - 2) % self._Capacity) + 1
		raw[idx] = self._Items[current]
	end

	self._Items = raw
	self._First = 1
	self._Capacity = capacity
end

--[[
	Creates a deque from an optional array.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "Deque values must be a table")

	local size = if values then #values else 0
	local capacity = math.max(8, size)
	local raw = table.create(capacity)

	if values then
		for idx, value in ipairs(values) do
			assert(value ~= nil, "Deque cannot store nil")
			raw[idx] = value
		end
	end

	return (
		setmetatable(
			{
				_Items = raw,
				_First = 1,
				_Count = size,
				_Capacity = capacity,
			} :: RawDequeObject,
			{ __index = module }
		)
	) :: DequeObject
end

--[[
	Adds a value to the front.
]]
module.PushFront = function(self: DequeObject, value: any)
	assert(value ~= nil, "Deque cannot store nil")

	if self._Count == self._Capacity then
		grow(self)
	end

	self._First = ((self._First - 2) % self._Capacity) + 1
	self._Items[self._First] = value
	self._Count += 1

	return self
end

--[[
	Adds a value to the back.
]]
module.PushBack = function(self: DequeObject, value: any)
	assert(value ~= nil, "Deque cannot store nil")

	if self._Count == self._Capacity then
		grow(self)
	end

	local last = ((self._First + self._Count - 1) % self._Capacity) + 1
	self._Items[last] = value
	self._Count += 1

	return self
end

--[[
	Removes and returns the front value.
]]
module.PopFront = function(self: DequeObject)
	if self._Count == 0 then
		return nil
	end

	local value = self._Items[self._First]
	self._Items[self._First] = nil
	self._Count -= 1
	self._First = (self._First % self._Capacity) + 1

	return value
end

--[[
	Removes and returns the back value.
]]
module.PopBack = function(self: DequeObject)
	if self._Count == 0 then
		return nil
	end

	local last = ((self._First + self._Count - 2) % self._Capacity) + 1
	local value = self._Items[last]
	self._Items[last] = nil
	self._Count -= 1

	return value
end

--[[
	Returns the front value without removing it.
]]
module.Front = function(self: DequeObject)
	if self._Count == 0 then
		return nil
	end

	return self._Items[self._First]
end

--[[
	Returns the back value without removing it.
]]
module.Back = function(self: DequeObject)
	if self._Count == 0 then
		return nil
	end

	local last = ((self._First + self._Count - 2) % self._Capacity) + 1
	return self._Items[last]
end

--[[
	Returns the value at a one-based logical index.
]]
module.At = function(self: DequeObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "Deque index out of bounds")

	local current = ((self._First + index - 2) % self._Capacity) + 1
	return self._Items[current]
end

--[[
	Returns the number of stored values.
]]
module.Size = function(self: DequeObject)
	return self._Count
end

--[[
	Checks whether the deque is empty.
]]
module.Empty = function(self: DequeObject)
	return self._Count == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: DequeObject)
	table.clear(self._Items)
	self._First = 1
	self._Count = 0
end

--[[
	Returns a shallow copy in front-to-back order.
]]
module.ToArray = function(self: DequeObject)
	local raw = table.create(self._Count)

	for idx = 1, self._Count do
		raw[idx] = self:At(idx)
	end

	return raw
end

return module
