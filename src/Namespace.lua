--!strict
--[[
	Organizes values into named, nestable scopes.
]]

type RawNamespaceObject = {
	_Namespace: true,
	Name: string,
	Values: { [string]: any },
}

type ProtoSchema = {
	new: (name: string) -> NamespaceObject,
	Define: (self: NamespaceObject, name: string, value: any) -> NamespaceObject,
	Set: (self: NamespaceObject, name: string, value: any) -> NamespaceObject,
	Get: (self: NamespaceObject, name: string) -> any,
	Has: (self: NamespaceObject, name: string) -> boolean,
	Remove: (self: NamespaceObject, name: string) -> boolean,
	Child: (self: NamespaceObject, name: string) -> NamespaceObject,
	Export: (self: NamespaceObject) -> { [string]: any },
}

export type NamespaceObject = typeof(setmetatable({} :: RawNamespaceObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a named namespace.
]]
module.new = function(name: string)
	assert(type(name) == "string" and name:match("%S") ~= nil, "Namespace name cannot be empty")

	return (
		setmetatable(
			{
				_Namespace = true,
				Name = name,
				Values = {},
			} :: RawNamespaceObject,
			{ __index = module }
		)
	) :: NamespaceObject
end

--[[
	Defines a new value without replacing an existing one.
]]
module.Define = function(self: NamespaceObject, name: string, value: any)
	assert(type(name) == "string" and name:match("%S") ~= nil, "Namespace key cannot be empty")
	assert(value ~= nil, "Namespace value cannot be nil")
	assert(self.Values[name] == nil, "Namespace key already exists: " .. name)

	self.Values[name] = value
	return self
end

--[[
	Sets a value, replacing an existing entry when necessary.
]]
module.Set = function(self: NamespaceObject, name: string, value: any)
	assert(type(name) == "string" and name:match("%S") ~= nil, "Namespace key cannot be empty")
	assert(value ~= nil, "Namespace value cannot be nil")

	self.Values[name] = value
	return self
end

--[[
	Returns a value stored in this namespace.
]]
module.Get = function(self: NamespaceObject, name: string)
	return self.Values[name]
end

--[[
	Checks whether a key exists.
]]
module.Has = function(self: NamespaceObject, name: string)
	return self.Values[name] ~= nil
end

--[[
	Removes a value and reports whether an entry was removed.
]]
module.Remove = function(self: NamespaceObject, name: string)
	if self.Values[name] == nil then
		return false
	end

	self.Values[name] = nil
	return true
end

--[[
	Returns an existing child namespace or creates a new one.
]]
module.Child = function(self: NamespaceObject, name: string)
	assert(type(name) == "string" and name:match("%S") ~= nil, "Child namespace name cannot be empty")

	local child = self.Values[name]
	if child ~= nil then
		assert(type(child) == "table" and rawget(child, "_Namespace") == true, "Namespace key is already occupied")
		return child
	end

	child = module.new(self.Name .. "." .. name)
	self.Values[name] = child

	return child
end

--[[
	Returns a frozen shallow copy of the namespace values.
]]
module.Export = function(self: NamespaceObject)
	local raw = {}

	for name, value in self.Values do
		raw[name] = value
	end

	return table.freeze(raw)
end

return module
