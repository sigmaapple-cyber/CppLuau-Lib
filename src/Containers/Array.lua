--!strict
--[[
	A fixed-size sequence with indexed access.
]]

type RawArrayObject = {
	_Items: { any },
	_Size: number,
}

type ProtoSchema = {
	new: (size: number, fill: any) -> ArrayObject,
	Get: (self: ArrayObject, index: number) -> any,
	Set: (self: ArrayObject, index: number, value: any) -> ArrayObject,
	Fill: (self: ArrayObject, value: any) -> ArrayObject,
	Size: (self: ArrayObject) -> number,
	ToArray: (self: ArrayObject) -> { any },
	ForEach: (self: ArrayObject, callback: (any, number) -> ()) -> (),
}

export type ArrayObject = typeof(setmetatable({} :: RawArrayObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates an array with a fixed size and fill value.
]]
module.new = function(size: number, fill: any)
	assert(size % 1 == 0 and size >= 0, "Array size must be a non-negative integer")
	assert(fill ~= nil or size == 0, "Array fill value cannot be nil")

	local raw = table.create(size, fill)

	return (
		setmetatable(
			{
				_Items = raw,
				_Size = size,
			} :: RawArrayObject,
			{ __index = module }
		)
	) :: ArrayObject
end

--[[
	Returns a value at a one-based index.
]]
module.Get = function(self: ArrayObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= self._Size, "Array index out of bounds")
	return self._Items[index]
end

--[[
	Replaces a value at a one-based index.
]]
module.Set = function(self: ArrayObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 1 and index <= self._Size, "Array index out of bounds")
	assert(value ~= nil, "Array cannot store nil")

	self._Items[index] = value
	return self
end

--[[
	Replaces every element with the supplied value.
]]
module.Fill = function(self: ArrayObject, value: any)
	assert(value ~= nil or self._Size == 0, "Array cannot store nil")

	for idx = 1, self._Size do
		self._Items[idx] = value
	end

	return self
end

--[[
	Returns the fixed number of elements.
]]
module.Size = function(self: ArrayObject)
	return self._Size
end

--[[
	Returns a shallow copy of the elements.
]]
module.ToArray = function(self: ArrayObject)
	return table.clone(self._Items)
end

--[[
	Calls a function for each element.
]]
module.ForEach = function(self: ArrayObject, callback: (any, number) -> ())
	for idx, value in self._Items do
		callback(value, idx)
	end
end

return module
