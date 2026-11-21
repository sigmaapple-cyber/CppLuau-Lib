--!strict

type RawEnumObject = {
	Name: string,
	Values: { [string]: any },
}

type ProtoSchema = {
	new: (name: string, values: { [any]: any }) -> EnumObject,
	Get: (self: EnumObject, name: string) -> any,
}


export type EnumObject = typeof(setmetatable(
	{} :: RawEnumObject,
	{ __index = {} :: ProtoSchema }
))


local module = {}

--[[
	Creates an enum from a list or dictionary of values.
--]]
module.new = function(name: string, values: { [any]: any })
	local raw = {}

	for key, value in values do
		if typeof(key) == "number" then
			raw[value] = key
		else
			raw[key] = value
		end
	end

	return (setmetatable(
		{
			Name = name,
			Values = table.freeze(raw),
		} :: RawEnumObject, { __index = module }
	)) :: EnumObject
end


--[[
	Returns a named enum value.
--]]
module.Get = function(self: EnumObject, name: string)
	return self.Values[name]
end


return module
