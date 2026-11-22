--!strict
--[[
	A non-owning view over a string slice.
]]

type RawStringViewObject = {
	_Source: string,
	_First: number,
	_Count: number,
}

type ProtoSchema = {
	new: (source: string, first: number?, count: number?) -> StringViewObject,
	Size: (self: StringViewObject) -> number,
	Empty: (self: StringViewObject) -> boolean,
	At: (self: StringViewObject, index: number) -> string,
	Slice: (self: StringViewObject, first: number, count: number?) -> StringViewObject,
	Find: (self: StringViewObject, value: string, first: number?) -> number?,
	StartsWith: (self: StringViewObject, value: string) -> boolean,
	EndsWith: (self: StringViewObject, value: string) -> boolean,
	ToString: (self: StringViewObject) -> string,
}

export type StringViewObject = typeof(setmetatable(
	{} :: RawStringViewObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

--[[
	Creates a view over a string without copying its source.
]]
module.new = function(source: string, first: number?, count: number?)
	assert(type(source) == "string", "StringView source must be a string")

	local start = first or 1
	local length = count or (#source - start + 1)

	assert(start % 1 == 0 and start >= 1 and start <= #source + 1, "StringView start out of bounds")
	assert(length % 1 == 0 and length >= 0 and start + length - 1 <= #source, "StringView length out of bounds")

	return (setmetatable({
		_Source = source;
		_First = start;
		_Count = length;
	} :: RawStringViewObject, { __index = module })) :: StringViewObject
end

--[[
	Returns the byte length of the view.
]]
module.Size = function(self: StringViewObject)
	return self._Count
end

--[[
	Checks whether the view is empty.
]]
module.Empty = function(self: StringViewObject)
	return self._Count == 0
end

--[[
	Returns one byte at a one-based index.
]]
module.At = function(self: StringViewObject, index: number)
	assert(index % 1 == 0 and index >= 1 and index <= self._Count, "StringView index out of bounds")
	return string.sub(self._Source, self._First + index - 1, self._First + index - 1)
end

--[[
	Creates another view relative to this one.
]]
module.Slice = function(self: StringViewObject, first: number, count: number?)
	assert(first % 1 == 0 and first >= 1 and first <= self._Count + 1, "StringView slice start out of bounds")

	local length = count or (self._Count - first + 1)
	assert(length % 1 == 0 and length >= 0 and first + length - 1 <= self._Count, "StringView slice length out of bounds")

	return module.new(self._Source, self._First + first - 1, length)
end

--[[
	Finds a plain substring and returns its one-based view index.
]]
module.Find = function(self: StringViewObject, value: string, first: number?)
	local start = first or 1
	assert(start % 1 == 0 and start >= 1 and start <= self._Count + 1, "StringView search start out of bounds")

	local found = string.find(
		self._Source,
		value,
		self._First + start - 1,
		true
	)

	if not found or found + #value - 1 > self._First + self._Count - 1 then
		return nil
	end

	return found - self._First + 1
end

--[[
	Checks whether the view begins with a value.
]]
module.StartsWith = function(self: StringViewObject, value: string)
	return self._Count >= #value and string.sub(self._Source, self._First, self._First + #value - 1) == value
end

--[[
	Checks whether the view ends with a value.
]]
module.EndsWith = function(self: StringViewObject, value: string)
	return self._Count >= #value and string.sub(self._Source, self._First + self._Count - #value, self._First + self._Count - 1) == value
end

--[[
	Returns the viewed substring.
]]
module.ToString = function(self: StringViewObject)
	return string.sub(self._Source, self._First, self._First + self._Count - 1)
end

return module
