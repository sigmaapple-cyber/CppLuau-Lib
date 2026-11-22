--!strict
--[[
	A non-owning view over a contiguous part of an array.
]]

type RawSpanObject = {
	_Source: { [number]: any },
	_First: number,
	_Count: number,
}

type ProtoSchema = {
	new: (source: { [number]: any }, first: number?, count: number?) -> SpanObject,
	Get: (self: SpanObject, index: number) -> any,
	Set: (self: SpanObject, index: number, value: any) -> SpanObject,
	Subspan: (self: SpanObject, first: number, count: number?) -> SpanObject,
	Size: (self: SpanObject) -> number,
	Empty: (self: SpanObject) -> boolean,
	ToArray: (self: SpanObject) -> { any },
	ForEach: (self: SpanObject, callback: (any, number) -> ()) -> (),
}

export type SpanObject = typeof(setmetatable({} :: RawSpanObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a view over an array without copying its values.
]]
module.new = function(source: { [number]: any }, first: number?, count: number?)
	assert(type(source) == "table", "Span source must be a table")

	local start = first or 1
	local length = count or (#source - start + 1)

	assert(start % 1 == 0 and start >= 1 and start <= #source + 1, "Span start out of bounds")
	assert(length % 1 == 0 and length >= 0 and start + length - 1 <= #source, "Span length out of bounds")

	return (setmetatable({
		_Source = source;
		_First = start;
		_Count = length;
	} :: RawSpanObject, { __index = module })) :: SpanObject
end

--[[
	Returns a value at a one-based view index.
]]
module.Get = function(self: SpanObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "Span index out of bounds")
	return self._Source[self._First + index - 1]
end

--[[
	Writes through the view into its source array.
]]
module.Set = function(self: SpanObject, index: number, value: any)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "Span index out of bounds")
	assert(value ~= nil, "Span cannot store nil")

	self._Source[self._First + index - 1] = value
	return self
end

--[[
	Creates another view relative to this one.
]]
module.Subspan = function(self: SpanObject, first: number, count: number?)
	assert(first % 1 == 0 and first >= 1 and first <= self._Count + 1, "Subspan start out of bounds")

	local length = count or (self._Count - first + 1)
	assert(length % 1 == 0 and length >= 0 and first + length - 1 <= self._Count, "Subspan length out of bounds")

	return module.new(self._Source, self._First + first - 1, length)
end

--[[
	Returns the number of values in the view.
]]
module.Size = function(self: SpanObject)
	return self._Count
end

--[[
	Checks whether the view is empty.
]]
module.Empty = function(self: SpanObject)
	return self._Count == 0
end

--[[
	Returns a shallow copy of the viewed values.
]]
module.ToArray = function(self: SpanObject)
	local raw = table.create(self._Count)

	for idx = 1, self._Count do
		raw[idx] = self._Source[self._First + idx - 1]
	end

	return raw
end

--[[
	Calls a function for every value in the view.
]]
module.ForEach = function(self: SpanObject, callback: (any, number) -> ())
	for idx = 1, self._Count do
		callback(self._Source[self._First + idx - 1], idx)
	end
end

return module
