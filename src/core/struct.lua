--!strict

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

export type StructObject = typeof(setmetatable({} :: RawStructObject, { __index = {} :: ProtoSchema }))

local module = {}

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

local function freeze(value: any, seen: { [any]: boolean })
	if type(value) ~= "table" or seen[value] then
		return
	end

	seen[value] = true

	for _, child in value do
		freeze(child, seen)
	end

	table.freeze(value)
end

module.new = function(name: string, schema: { [string]: any }): StructObject
	assert(type(name) == "string" and name:match("%S") ~= nil, "Struct name cannot be empty")
	assert(type(schema) == "table", "Struct schema must be a table")

	local defaults = {}
	local copies: { [any]: any } = {}

	for field, value in schema do
		assert(type(field) == "string", "Struct field names must be strings")
		defaults[field] = clone(value, copies)
	end

	freeze(defaults, {})

	return setmetatable(
		{
			Name = name,
			Schema = defaults,
		} :: RawStructObject,
		{ __index = module }
	) :: StructObject
end

module.Create = function(self: StructObject, values: StructValue?): StructValue
	assert(values == nil or type(values) == "table", "Struct values must be a table")

	local raw = {}
	local copies: { [any]: any } = {}

	for field, value in self.Schema do
		raw[field] = clone(value, copies)
	end

	if values then
		for field, value in values do
			assert(self.Schema[field] ~= nil, "Unknown struct field: " .. tostring(field))
			raw[field] = clone(value, copies)
		end
	end

	return raw
end

module.HasField = function(self: StructObject, name: string): boolean
	return self.Schema[name] ~= nil
end

return table.freeze(module)
