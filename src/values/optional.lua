--!strict
--[[
	Represents a value that may or may not be present.
]]

type RawOptionalObject = {
	_HasValue: boolean,
	_Value: any,
}

type ProtoSchema = {
	Some: (value: any) -> OptionalObject,
	None: () -> OptionalObject,
	IsSome: (self: OptionalObject) -> boolean,
	IsNone: (self: OptionalObject) -> boolean,
	Unwrap: (self: OptionalObject) -> any,
	UnwrapOr: (self: OptionalObject, fallback: any) -> any,
	Map: (self: OptionalObject, callback: (any) -> any) -> OptionalObject,
	AndThen: (self: OptionalObject, callback: (any) -> OptionalObject) -> OptionalObject,
}

export type OptionalObject = typeof(setmetatable({} :: RawOptionalObject, { __index = {} :: ProtoSchema }))

local module = {}

local none = table.freeze(setmetatable(
	{
		_HasValue = false,
		_Value = nil,
	} :: RawOptionalObject,
	{ __index = module }
)) :: OptionalObject

--[[
	Wraps a non-nil value in an Optional.
]]
module.Some = function(value: any)
	assert(value ~= nil, "Optional.Some cannot contain nil")

	return (
		table.freeze(setmetatable(
			{
				_HasValue = true,
				_Value = value,
			} :: RawOptionalObject,
			{ __index = module }
		))
	) :: OptionalObject
end

--[[
	Returns the empty Optional value.
]]
module.None = function()
	return none
end

--[[
	Checks whether a value is present.
]]
module.IsSome = function(self: OptionalObject)
	return self._HasValue
end

--[[
	Checks whether this Optional is empty.
]]
module.IsNone = function(self: OptionalObject)
	return not self._HasValue
end

--[[
	Returns the value or throws when the Optional is empty.
]]
module.Unwrap = function(self: OptionalObject)
	assert(self._HasValue, "Cannot unwrap an empty Optional")
	return self._Value
end

--[[
	Returns the value or a fallback when the Optional is empty.
]]
module.UnwrapOr = function(self: OptionalObject, fallback: any)
	if self._HasValue then
		return self._Value
	end

	return fallback
end

--[[
	Transforms a present value and preserves an empty Optional.
]]
module.Map = function(self: OptionalObject, callback: (any) -> any)
	assert(type(callback) == "function", "Optional.Map callback must be a function")

	if not self._HasValue then
		return none
	end

	local value = callback(self._Value)
	if value == nil then
		return none
	end

	return module.Some(value)
end

--[[
	Chains an operation which returns another Optional.
]]
module.AndThen = function(self: OptionalObject, callback: (any) -> OptionalObject)
	assert(type(callback) == "function", "Optional.AndThen callback must be a function")

	if not self._HasValue then
		return none
	end

	local result = callback(self._Value)
	assert(type(result) == "table" and type(result._HasValue) == "boolean", "Optional.AndThen must return an Optional")

	return result
end

return table.freeze(module)
