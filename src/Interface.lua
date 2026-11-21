--!strict
--[[
	Defines runtime contracts for classes and table-based objects.
]]

type RawInterfaceObject = {
	Name: string,
	Methods: { string },
}

type ProtoSchema = {
	new: (name: string, methods: { string }) -> InterfaceObject,
	Validate: (self: InterfaceObject, target: any) -> (boolean, { string }),
	Assert: (self: InterfaceObject, target: any) -> (),
	HasMethod: (self: InterfaceObject, name: string) -> boolean,
}

export type InterfaceObject = typeof(setmetatable({} :: RawInterfaceObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates an interface from a list of required method names.
]]
module.new = function(name: string, methods: { string })
	assert(type(name) == "string" and name:match("%S") ~= nil, "Interface name cannot be empty")
	assert(type(methods) == "table", "Interface methods must be a table")

	local raw = {}
	local seen = {}

	for _, method in methods do
		assert(type(method) == "string" and method:match("%S") ~= nil, "Interface method names must be non-empty strings")
		assert(not seen[method], "Duplicate interface method: " .. method)

		seen[method] = true
		table.insert(raw, method)
	end

	return (setmetatable({
		Name = name;
		Methods = table.freeze(raw);
	} :: RawInterfaceObject, { __index = module })) :: InterfaceObject
end

--[[
	Checks whether a value implements every required method.
]]
module.Validate = function(self: InterfaceObject, target: any)
	local missing = {}

	if type(target) ~= "table" then
		for _, method in self.Methods do
			table.insert(missing, method)
		end

		return false, missing
	end

	for _, method in self.Methods do
		if type(target[method]) ~= "function" then
			table.insert(missing, method)
		end
	end

	return #missing == 0, missing
end

--[[
	Throws when a value does not satisfy this interface.
]]
module.Assert = function(self: InterfaceObject, target: any)
	local valid, missing = self:Validate(target)
	assert(valid, string.format("'%s' is missing required methods: %s", self.Name, table.concat(missing, ", ")))
end

--[[
	Checks whether a method is part of this interface.
]]
module.HasMethod = function(self: InterfaceObject, name: string)
	return table.find(self.Methods, name) ~= nil
end

return module
