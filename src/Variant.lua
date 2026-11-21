--!strict
--[[
	A tagged value which can hold one of several runtime types.
]]

type RawVariantObject = {
	Tag: string,
	Value: any,
}

type ProtoSchema = {
	new: (tag: string, value: any) -> VariantObject,
	GetTag: (self: VariantObject) -> string,
	Get: (self: VariantObject) -> any,
	Is: (self: VariantObject, tag: string) -> boolean,
	Set: (self: VariantObject, tag: string, value: any) -> VariantObject,
	Match: (self: VariantObject, handlers: { [string]: (any) -> any }) -> any,
}

export type VariantObject = typeof(setmetatable({} :: RawVariantObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a tagged value.
]]
module.new = function(tag: string, value: any)
	assert(type(tag) == "string" and tag:match("%S") ~= nil, "Variant tag cannot be empty")

	return (setmetatable({
		Tag = tag;
		Value = value;
	} :: RawVariantObject, { __index = module })) :: VariantObject
end

--[[
	Returns the active tag.
]]
module.GetTag = function(self: VariantObject)
	return self.Tag
end

--[[
	Returns the stored value.
]]
module.Get = function(self: VariantObject)
	return self.Value
end

--[[
	Checks whether the active tag matches.
]]
module.Is = function(self: VariantObject, tag: string)
	return self.Tag == tag
end

--[[
	Replaces the tag and its associated value.
]]
module.Set = function(self: VariantObject, tag: string, value: any)
	assert(type(tag) == "string" and tag:match("%S") ~= nil, "Variant tag cannot be empty")

	self.Tag = tag
	self.Value = value

	return self
end

--[[
	Calls the handler registered for the active tag.
]]
module.Match = function(self: VariantObject, handlers: { [string]: (any) -> any })
	local callback = handlers[self.Tag]
	assert(type(callback) == "function", "Variant handler is missing: " .. self.Tag)

	return callback(self.Value)
end

return module
