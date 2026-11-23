--!strict
--[[
	A shared mutable value container.
]]

type RawReferenceObject = {
	Value: any,
}

type ProtoSchema = {
	new: (value: any) -> ReferenceObject,
	Get: (self: ReferenceObject) -> any,
	Set: (self: ReferenceObject, value: any) -> any,
	Update: (self: ReferenceObject, callback: (any) -> any) -> any,
	Swap: (self: ReferenceObject, other: ReferenceObject) -> (),
	CompareExchange: (self: ReferenceObject, expected: any, replacement: any) -> boolean,
}

export type ReferenceObject = typeof(setmetatable({} :: RawReferenceObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a reference to a mutable value.
]]
module.new = function(value: any)
	return (setmetatable(
		{
			Value = value,
		} :: RawReferenceObject,
		{ __index = module }
	)) :: ReferenceObject
end

--[[
	Returns the current value.
]]
module.Get = function(self: ReferenceObject)
	return self.Value
end

--[[
	Replaces the current value and returns the new value.
]]
module.Set = function(self: ReferenceObject, value: any)
	self.Value = value
	return value
end

--[[
	Updates the value using a callback and returns the new value.
]]
module.Update = function(self: ReferenceObject, callback: (any) -> any)
	assert(type(callback) == "function", "Reference.Update callback must be a function")

	self.Value = callback(self.Value)
	return self.Value
end

--[[
	Exchanges values with another reference.
]]
module.Swap = function(self: ReferenceObject, other: ReferenceObject)
	local value = self.Value
	self.Value = other.Value
	other.Value = value
end

--[[
	Replaces the value only when it equals the expected value.
]]
module.CompareExchange = function(self: ReferenceObject, expected: any, replacement: any)
	if self.Value ~= expected then
		return false
	end

	self.Value = replacement
	return true
end

return module
