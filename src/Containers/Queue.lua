--!strict
--[[
	A first-in, first-out container with constant-time dequeue.
]]

type RawQueueObject = {
	_Items: { [number]: any },
	_First: number,
	_Last: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> QueueObject,
	Enqueue: (self: QueueObject, value: any) -> QueueObject,
	Dequeue: (self: QueueObject) -> any,
	Front: (self: QueueObject) -> any,
	Back: (self: QueueObject) -> any,
	Size: (self: QueueObject) -> number,
	Empty: (self: QueueObject) -> boolean,
	Clear: (self: QueueObject) -> (),
	ToArray: (self: QueueObject) -> { any },
}

export type QueueObject = typeof(setmetatable({} :: RawQueueObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a queue from an optional array.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "Queue values must be a table")

	local raw = {}
	local last = 0

	if values then
		for _, value in ipairs(values) do
			assert(value ~= nil, "Queue cannot store nil")

			last += 1
			raw[last] = value
		end
	end

	return (
		setmetatable(
			{
				_Items = raw,
				_First = if last > 0 then 1 else 0,
				_Last = last,
			} :: RawQueueObject,
			{ __index = module }
		)
	) :: QueueObject
end

--[[
	Adds a value to the back of the queue.
]]
module.Enqueue = function(self: QueueObject, value: any)
	assert(value ~= nil, "Queue cannot store nil")

	if self._Last == 0 then
		self._First = 1
		self._Last = 1
	else
		self._Last += 1
	end

	self._Items[self._Last] = value
	return self
end

--[[
	Removes and returns the front value.
]]
module.Dequeue = function(self: QueueObject)
	if self._First == 0 then
		return nil
	end

	local value = self._Items[self._First]
	self._Items[self._First] = nil
	self._First += 1

	if self._First > self._Last then
		self._First = 0
		self._Last = 0
		table.clear(self._Items)
	end

	return value
end

--[[
	Returns the front value without removing it.
]]
module.Front = function(self: QueueObject)
	if self._First == 0 then
		return nil
	end

	return self._Items[self._First]
end

--[[
	Returns the back value without removing it.
]]
module.Back = function(self: QueueObject)
	if self._Last == 0 then
		return nil
	end

	return self._Items[self._Last]
end

--[[
	Returns the number of queued values.
]]
module.Size = function(self: QueueObject)
	if self._First == 0 then
		return 0
	end

	return self._Last - self._First + 1
end

--[[
	Checks whether the queue is empty.
]]
module.Empty = function(self: QueueObject)
	return self._First == 0
end

--[[
	Removes every queued value.
]]
module.Clear = function(self: QueueObject)
	table.clear(self._Items)
	self._First = 0
	self._Last = 0
end

--[[
	Returns a shallow copy in dequeue order.
]]
module.ToArray = function(self: QueueObject)
	local raw = {}

	for idx = self._First, self._Last do
		table.insert(raw, self._Items[idx])
	end

	return raw
end

return module
