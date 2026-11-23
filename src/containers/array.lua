--!strict

type RawArray<T> = {
	_Items: { T },
	_Size: number,
}

type ArrayMethods<T> = {
	Get: (self: Array<T>, index: number) -> T,
	Set: (self: Array<T>, index: number, value: T) -> Array<T>,
	Fill: (self: Array<T>, value: T) -> Array<T>,
	Size: (self: Array<T>) -> number,
	ToArray: (self: Array<T>) -> { T },
	ForEach: (self: Array<T>, callback: (T, number) -> ()) -> (),
}

export type Array<T> = typeof(setmetatable({} :: RawArray<T>, { __index = {} :: ArrayMethods<T> }))

local module = {}

module.new = function<T>(size: number, fill: T): Array<T>
	assert(size % 1 == 0 and size >= 0, "Array size must be a non-negative integer")

	return setmetatable(
		{
			_Items = table.create(size, fill),
			_Size = size,
		} :: RawArray<T>,
		{ __index = module }
	) :: Array<T>
end

module.Get = function<T>(self: Array<T>, index: number): T
	assert(index % 1 == 0 and index >= 1 and index <= self._Size, "Array index out of bounds")
	return self._Items[index]
end

module.Set = function<T>(self: Array<T>, index: number, value: T): Array<T>
	assert(index % 1 == 0 and index >= 1 and index <= self._Size, "Array index out of bounds")

	self._Items[index] = value
	return self
end

module.Fill = function<T>(self: Array<T>, value: T): Array<T>
	for idx = 1, self._Size do
		self._Items[idx] = value
	end

	return self
end

module.Size = function<T>(self: Array<T>): number
	return self._Size
end

module.ToArray = function<T>(self: Array<T>): { T }
	return table.clone(self._Items)
end

module.ForEach = function<T>(self: Array<T>, callback: (T, number) -> ())
	assert(type(callback) == "function", "Array.ForEach expects a function")

	for idx, value in self._Items do
		callback(value, idx)
	end
end

return table.freeze(module)
