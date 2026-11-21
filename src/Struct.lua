--!strict
--[[
	Schema-based structures with independent default values.
]]

type RawStructObject = {
	Name: string,
	Schema: { [string]: any },
}

export type StructValue = {
	[string]: any,
}

type ProtoSchema = {
	new: (name: string, schema: { [string]: any }) -> StructObject,
	Create: (self: StructObject, values: StructValue?) -> StructValue,
	HasField: (self: StructObject, name: string) -> boolean,
}

export type StructObject = typeof(setmetatable(
	{} :: RawStructObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

--[[
	Copies nested table values without sharing them between struct values.
]]
local function clone(value: any, copies: { [any]: any }): any
	if type(value) ~= "table" then
		return value
	end

	local existing = copies[value]
	if existing ~= nil then
		return existing
	end

	local raw = {}
	copies[value] = raw

	for key, child in value do
		raw[key] = clone(child, copies)
	end

	local metatable = getmetatable(value)
	if type(metatable) == "table" then
		setmetatable(raw, metatable)
	end

	return raw
end

--[[
	Defines a struct using a field schema.
]]
module.new = function(name: string, schema: { [string]: any })
	assert(type(name) == "string" and name:match("%S") ~= nil, "Struct name cannot be empty")
	assert(type(schema) == "table", "Struct schema must be a table")

	local raw = {}
	local copies: { [any]: any } = {}

	for field, value in schema do
		assert(type(field) == "string", "Struct field names must be strings")
		raw[field] = clone(value, copies)
	end

	return (setmetatable(
		{
			Name = name;
			Schema = table.freeze(raw);
		} :: RawStructObject, { __index = module }
	)) :: StructObject
end

--[[
	Creates a struct value using schema defaults and supplied overrides.
]]
module.Create = function(self: StructObject, values: StructValue?)
	assert(values == nil or type(values) == "table", "Struct values must be a table")

	local raw = {}
	local copies: { [any]: any } = {}

	for field, value in self.Schema do
		raw[field] = clone(value, copies)
	end

	if values then
		for field, value in values do
			if self.Schema[field] ~= nil then
				raw[field] = clone(value, copies)
			end
		end
	end

	return raw
end

--[[
	Checks whether a field exists in this struct schema.
]]
module.HasField = function(self: StructObject, name: string)
	return self.Schema[name] ~= nil
end

return module
