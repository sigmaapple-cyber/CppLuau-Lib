--!strict

type RawVector<T> = {
	_Items: { T },
}

type VectorMethods<T> = {
	PushBack: (self: Vector<T>, value: T) -> Vector<T>,
	PopBack: (self: Vector<T>) -> T?,
	At: (self: Vector<T>, index: number) -> T,
	Set: (self: Vector<T>, index: number, value: T) -> Vector<T>,
	Insert: (self: Vector<T>, index: number, value: T) -> Vector<T>,
	Erase: (self: Vector<T>, index: number) -> T,
	Front: (self: Vector<T>) -> T?,
	Back: (self: Vector<T>) -> T?,
	Size: (self: Vector<T>) -> number,
	Empty: (self: Vector<T>) -> boolean,
	Clear: (self: Vector<T>) -> (),
	Resize: (self: Vector<T>, size: number, fill: T?) -> Vector<T>,
	ToArray: (self: Vector<T>) -> { T },
	ForEach: (self: Vector<T>, callback: (T, number) -> ()) -> (),
}

export type Vector<T> = typeof(setmetatable(
	{} :: RawVector<T>,
	{ __index = {} :: VectorMethods<T> }
))

local module = {}

module.new = function<T>(values: { T }?): Vector<T>
	assert(values == nil or type(values) == "table", "Vector values must be a table")

	return setmetatable({
		_Items = if values then table.clone(values) else {},
	} :: RawVector<T>, { __index = module }) :: Vector<T>
end

module.PushBack = function<T>(self: Vector<T>, value: T): Vector<T>
	table.insert(self._Items, value)
	return self
end

module.PopBack = function<T>(self: Vector<T>): T?
	return table.remove(self._Items)
end

module.At = function<T>(self: Vector<T>, index: number): T
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")
	return self._Items[index]
end

module.Set = function<T>(self: Vector<T>, index: number, value: T): Vector<T>
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")

	self._Items[index] = value
	return self
end

module.Insert = function<T>(self: Vector<T>, index: number, value: T): Vector<T>
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items + 1, "Vector index out of bounds")

	table.insert(self._Items, index, value)
	return self
end

module.Erase = function<T>(self: Vector<T>, index: number): T
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")
	return table.remove(self._Items, index)
end

module.Front = function<T>(self: Vector<T>): T?
	return self._Items[1]
end

module.Back = function<T>(self: Vector<T>): T?
	return self._Items[#self._Items]
end

module.Size = function<T>(self: Vector<T>): number
	return #self._Items
end

module.Empty = function<T>(self: Vector<T>): boolean
	return #self._Items == 0
end

module.Clear = function<T>(self: Vector<T>)
	table.clear(self._Items)
end

module.Resize = function<T>(self: Vector<T>, size: number, fill: T?): Vector<T>
	assert(size % 1 == 0 and size >= 0, "Vector size must be a non-negative integer")
	assert(size <= #self._Items or fill ~= nil, "Vector.Resize requires a fill value when growing")

	while #self._Items > size do
		table.remove(self._Items)
	end

	while #self._Items < size do
		table.insert(self._Items, fill :: T)
	end

	return self
end

module.ToArray = function<T>(self: Vector<T>): { T }
	return table.clone(self._Items)
end

module.ForEach = function<T>(self: Vector<T>, callback: (T, number) -> ())
	assert(type(callback) == "function", "Vector.ForEach expects a function")

	for idx, value in self._Items do
		callback(value, idx)
	end
end

return table.freeze(module)
