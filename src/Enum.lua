--!strict
--[[
	Named enum values with immutable lookup tables.
]]

type RawEnumObject = {
	Name: string,
	Values: { [string]: any },
}

type ProtoSchema = {
	new: (name: string, values: { [any]: any }) -> EnumObject,
	Get: (self: EnumObject, name: string) -> any,
	Has: (self: EnumObject, name: string) -> boolean,
}

export type EnumObject = typeof(setmetatable(
	{} :: RawEnumObject,
	{ __index = {} :: ProtoSchema }
))

local module = {}

--[[
	Creates an enum from a list or dictionary of values.
]]
module.new = function(name: string, values: { [any]: any })
	assert(type(name) == "string" and name:match("%S") ~= nil, "Enum name cannot be empty")
	assert(type(values) == "table", "Enum values must be a table")

	local raw = {}

	for key, value in values do
		if type(key) == "number" then
			assert(type(value) == "string" and value:match("%S") ~= nil, "List enum entries must be non-empty strings")
			assert(raw[value] == nil, "Duplicate enum name: " .. value)
			raw[value] = key
		elseif type(key) == "string" then
			assert(key:match("%S") ~= nil, "Enum names cannot be empty")
			assert(raw[key] == nil, "Duplicate enum name: " .. key)
			raw[key] = value
		else
			error("Enum keys must be strings or numbers")
		end
	end

	assert(next(raw) ~= nil, "Enum must contain at least one value")

	return (setmetatable(
		{
			Name = name;
			Values = table.freeze(raw);
		} :: RawEnumObject, { __index = module }
	)) :: EnumObject
end

--[[
	Returns a named enum value.
]]
module.Get = function(self: EnumObject, name: string)
	return self.Values[name]
end

--[[
	Checks whether an enum name exists.
]]
module.Has = function(self: EnumObject, name: string)
	return rawget(self.Values, name) ~= nil
end

return module
