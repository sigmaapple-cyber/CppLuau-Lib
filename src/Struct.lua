--!strict

type RawStructObject = {
	Name: string,
	Schema: { [string]: any },
}

type ProtoSchema = {
	new: (name: string, schema: { [string]: any }) -> StructObject,
	Create: (self: StructObject, values: { [string]: any }?) -> { [string]: any },
}


export type StructObject = typeof(setmetatable(
	{} :: RawStructObject,
	{ __index = {} :: ProtoSchema }
))


local module = {}

--[[
	Defines a struct using a field schema.
--]]
module.new = function(name: string, schema: { [string]: any })
	return (setmetatable(
		{
			Name = name,
			Schema = schema,
			;
			;
		} :: RawStructObject, { __index = module }
	)) :: StructObject
end


--[[
	Creates a struct value using the schema defaults.
--]]
module.Create = function(self: StructObject, values: { [string]: any }?)
	local raw = {}

	for name, value in self.Schema do
		raw[name] = value
	end

	if values then
		for name, value in values do
			if self.Schema[name] ~= nil then
				raw[name] = value
			end
		end
	end

	return raw
end


return module
