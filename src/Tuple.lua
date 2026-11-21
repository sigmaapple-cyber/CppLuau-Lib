--!strict
--[[
	Stores a fixed sequence of values, including nil entries.
]]

type RawTupleObject = {
	_Values: { [number]: any },
	_Count: number,
}

type ProtoSchema = {
	new: (...any) -> TupleObject,
	Size: (self: TupleObject) -> number,
	Get: (self: TupleObject, index: number) -> any,
	Unpack: (self: TupleObject) -> ...any,
	Map: (self: TupleObject, callback: (any, number) -> any) -> TupleObject,
	ToArray: (self: TupleObject) -> { [number]: any },
}

export type TupleObject = typeof(setmetatable({} :: RawTupleObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a tuple from the supplied arguments.
]]
module.new = function(...)
	local values = table.pack(...)

	return (setmetatable({
		_Values = values;
		_Count = values.n;
	} :: RawTupleObject, { __index = module })) :: TupleObject
end

--[[
	Returns the number of tuple positions.
]]
module.Size = function(self: TupleObject)
	return self._Count
end

--[[
	Returns a value at a one-based index.
]]
module.Get = function(self: TupleObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "Tuple index out of bounds")
	return self._Values[index]
end

--[[
	Returns all values, preserving nil positions.
]]
module.Unpack = function(self: TupleObject)
	return table.unpack(self._Values, 1, self._Count)
end

--[[
	Transforms every position and preserves the tuple length.
]]
module.Map = function(self: TupleObject, callback: (any, number) -> any)
	assert(type(callback) == "function", "Tuple.Map callback must be a function")

	local values = table.create(self._Count)
	for idx = 1, self._Count do
		values[idx] = callback(self._Values[idx], idx)
	end

	return module.new(table.unpack(values, 1, self._Count))
end

--[[
	Returns a packed array with its explicit n field.
]]
module.ToArray = function(self: TupleObject)
	local raw = table.clone(self._Values)
	raw.n = self._Count
	return raw
end

return module
