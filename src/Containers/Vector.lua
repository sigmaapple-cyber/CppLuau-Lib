--!strict
--[[
	A resizable sequence with indexed access.
]]

type RawVectorObject = {
	_Items: { any },
}

type ProtoSchema = {
	new: (values: { any }?) -> VectorObject,
	PushBack: (self: VectorObject, value: any) -> VectorObject,
	PopBack: (self: VectorObject) -> any,
	At: (self: VectorObject, index: number) -> any,
	Set: (self: VectorObject, index: number, value: any) -> VectorObject,
	Insert: (self: VectorObject, index: number, value: any) -> VectorObject,
	Erase: (self: VectorObject, index: number) -> any,
	Front: (self: VectorObject) -> any,
	Back: (self: VectorObject) -> any,
	Size: (self: VectorObject) -> number,
	Empty: (self: VectorObject) -> boolean,
	Clear: (self: VectorObject) -> (),
	Resize: (self: VectorObject, size: number, fill: any?) -> VectorObject,
	ToArray: (self: VectorObject) -> { any },
	ForEach: (self: VectorObject, callback: (any, number) -> ()) -> (),
}

export type VectorObject = typeof(setmetatable({} :: RawVectorObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a vector from an optional array.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "Vector values must be a table")

	return (
		setmetatable(
			{
				_Items = if values then table.clone(values) else {},
			} :: RawVectorObject,
			{ __index = module }
		)
	) :: VectorObject
end

--[[
	Appends a value to the end.
]]
module.PushBack = function(self: VectorObject, value: any)
	assert(value ~= nil, "Vector cannot store nil")

	table.insert(self._Items, value)
	return self
end

--[[
	Removes and returns the last value.
]]
module.PopBack = function(self: VectorObject)
	return table.remove(self._Items)
end

--[[
	Returns the value at a one-based index.
]]
module.At = function(self: VectorObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")
	return self._Items[index]
end

--[[
	Replaces the value at a one-based index.
]]
module.Set = function(self: VectorObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")
	assert(value ~= nil, "Vector cannot store nil")

	self._Items[index] = value
	return self
end

--[[
	Inserts a value before a one-based index.
]]
module.Insert = function(self: VectorObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items + 1, "Vector index out of bounds")
	assert(value ~= nil, "Vector cannot store nil")

	table.insert(self._Items, index, value)
	return self
end

--[[
	Removes and returns the value at a one-based index.
]]
module.Erase = function(self: VectorObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= #self._Items, "Vector index out of bounds")
	return table.remove(self._Items, index)
end

--[[
	Returns the first value.
]]
module.Front = function(self: VectorObject)
	return self._Items[1]
end

--[[
	Returns the last value.
]]
module.Back = function(self: VectorObject)
	return self._Items[#self._Items]
end

--[[
	Returns the number of stored values.
]]
module.Size = function(self: VectorObject)
	return #self._Items
end

--[[
	Checks whether the vector has no values.
]]
module.Empty = function(self: VectorObject)
	return #self._Items == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: VectorObject)
	table.clear(self._Items)
end

--[[
	Changes the vector length, filling new positions with the supplied value.
]]
module.Resize = function(self: VectorObject, size: number, fill: any?)
	assert(size % 1 == 0 and size >= 0, "Vector size must be a non-negative integer")
	assert(size <= #self._Items or fill ~= nil, "Vector.Resize requires a fill value when growing")

	while #self._Items > size do
		table.remove(self._Items)
	end

	while #self._Items < size do
		table.insert(self._Items, fill)
	end

	return self
end

--[[
	Returns a shallow copy of the stored values.
]]
module.ToArray = function(self: VectorObject)
	return table.clone(self._Items)
end

--[[
	Calls a function for every stored value.
]]
module.ForEach = function(self: VectorObject, callback: (any, number) -> ())
	for idx, value in self._Items do
		callback(value, idx)
	end
end

return module
