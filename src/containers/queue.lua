--!strict

type RawQueue<T> = {
	_Items: { [number]: T },
	_First: number,
	_Last: number,
}

type QueueMethods<T> = {
	Enqueue: (self: Queue<T>, value: T) -> Queue<T>,
	Dequeue: (self: Queue<T>) -> T?,
	Front: (self: Queue<T>) -> T?,
	Back: (self: Queue<T>) -> T?,
	Size: (self: Queue<T>) -> number,
	Empty: (self: Queue<T>) -> boolean,
	Clear: (self: Queue<T>) -> (),
	ToArray: (self: Queue<T>) -> { T },
}

export type Queue<T> = typeof(setmetatable({} :: RawQueue<T>, { __index = {} :: QueueMethods<T> }))

local module = {}

local function compact<T>(self: Queue<T>)
	local count = self._Last - self._First + 1
	local raw = table.create(count)

	for idx = 1, count do
		raw[idx] = self._Items[self._First + idx - 1]
	end

	self._Items = raw
	self._First = 1
	self._Last = count
end

module.new = function<T>(values: { T }?): Queue<T>
	assert(values == nil or type(values) == "table", "Queue values must be a table")

	local raw = {}
	local last = 0

	if values then
		for _, value in ipairs(values) do
			last += 1
			raw[last] = value
		end
	end

	return setmetatable(
		{
			_Items = raw,
			_First = if last > 0 then 1 else 0,
			_Last = last,
		} :: RawQueue<T>,
		{ __index = module }
	) :: Queue<T>
end

module.Enqueue = function<T>(self: Queue<T>, value: T): Queue<T>
	if self._Last == 0 then
		self._First = 1
		self._Last = 1
	else
		self._Last += 1
	end

	self._Items[self._Last] = value
	return self
end

module.Dequeue = function<T>(self: Queue<T>): T?
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
	elseif self._First > 64 and self._First > self._Last / 2 then
		compact(self)
	end

	return value
end

module.Front = function<T>(self: Queue<T>): T?
	if self._First == 0 then
		return nil
	end

	return self._Items[self._First]
end

module.Back = function<T>(self: Queue<T>): T?
	if self._Last == 0 then
		return nil
	end

	return self._Items[self._Last]
end

module.Size = function<T>(self: Queue<T>): number
	if self._First == 0 then
		return 0
	end

	return self._Last - self._First + 1
end

module.Empty = function<T>(self: Queue<T>): boolean
	return self._First == 0
end

module.Clear = function<T>(self: Queue<T>)
	table.clear(self._Items)
	self._First = 0
	self._Last = 0
end

module.ToArray = function<T>(self: Queue<T>): { T }
	local count = self:Size()
	local raw = table.create(count)

	for offset = 0, count - 1 do
		raw[offset + 1] = self._Items[self._First + offset]
	end

	return raw
end

return table.freeze(module)
