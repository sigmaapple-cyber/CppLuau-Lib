--!strict
--[[
	Builds strings from appended parts.
]]

type RawStringBuilderObject = {
	_Parts: { string },
	_Length: number,
}

type ProtoSchema = {
	new: () -> StringBuilderObject,
	Append: (self: StringBuilderObject, value: string) -> StringBuilderObject,
	AppendLine: (self: StringBuilderObject, value: string?) -> StringBuilderObject,
	Length: (self: StringBuilderObject) -> number,
	Clear: (self: StringBuilderObject) -> (),
	ToString: (self: StringBuilderObject) -> string,
}

export type StringBuilderObject = typeof(setmetatable(
	{} :: RawStringBuilderObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

--[[
	Creates an empty string builder.
]]
module.new = function()
	return (setmetatable({
		_Parts = {};
		_Length = 0;
	} :: RawStringBuilderObject, { __index = module })) :: StringBuilderObject
end

--[[
	Appends a string.
]]
module.Append = function(self: StringBuilderObject, value: string)
	assert(type(value) == "string", "StringBuilder.Append expects a string")

	table.insert(self._Parts, value)
	self._Length += #value

	return self
end

--[[
	Appends a string followed by a newline.
]]
module.AppendLine = function(self: StringBuilderObject, value: string?)
	return self:Append((value or "") .. "\n")
end

--[[
	Returns the current byte length.
]]
module.Length = function(self: StringBuilderObject)
	return self._Length
end

--[[
	Removes every appended part.
]]
module.Clear = function(self: StringBuilderObject)
	table.clear(self._Parts)
	self._Length = 0
end

--[[
	Combines every part into one string.
]]
module.ToString = function(self: StringBuilderObject)
	return table.concat(self._Parts)
end

return module
