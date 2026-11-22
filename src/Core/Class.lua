--!strict
--[[
	A class system with inheritance, constructor chaining, and instance checks.
]]

type ClassConstructor = (self: InstanceObject, ...any) -> ()

type RawClassObject = {
	_Class: true,
	Name: string,
	Base: ClassObject?,
	_Constructor: ClassConstructor?,
	[string]: any,
}

type RawInstanceObject = {
	_class: ClassObject,
	[string]: any,
}

type ClassProtoSchema = {
	new: (name: string, base: ClassObject?) -> ClassObject,
	Create: (self: ClassObject, ...any) -> InstanceObject,
	Extend: (self: ClassObject, name: string) -> ClassObject,
	Constructor: (self: ClassObject, callback: ClassConstructor) -> ClassObject,
	GetName: (self: ClassObject) -> string,
	GetBase: (self: ClassObject) -> ClassObject?,
	IsA: (self: ClassObject, target: string | ClassObject) -> boolean,
	[string]: any,
}

type InstanceProtoSchema = {
	GetClass: (self: InstanceObject) -> ClassObject,
	GetClassName: (self: InstanceObject) -> string,
	IsA: (self: InstanceObject, target: string | ClassObject) -> boolean,
	[string]: any,
}

export type ClassObject = typeof(setmetatable({} :: RawClassObject, { __index = {} :: ClassProtoSchema }))

export type InstanceObject = typeof(setmetatable({} :: RawInstanceObject, { __index = {} :: InstanceProtoSchema }))

local module = {}

--[[
	Creates a new class with an optional base class.
]]
module.new = function(name: string, base: ClassObject?)
	assert(type(name) == "string" and name:match("%S") ~= nil, "Class name cannot be empty")
	assert(base == nil or (type(base) == "table" and rawget(base, "_Class") == true), "Base must be a CppLuau class")

	local raw = {
		_Class = true,
		Name = name,
		Base = base,
		_Constructor = nil,
	} :: RawClassObject

	return (
		setmetatable(raw, {
			__index = function(self, key)
				local value = (module :: any)[key]
				if value ~= nil then
					return value
				end

				local parent = rawget(self, "Base")
				return parent and parent[key]
			end,
		})
	) :: ClassObject
end

--[[
	Creates an instance and runs constructors from base to derived.
]]
module.Create = function(self: ClassObject, ...)
	local raw = {
		_class = self,
	} :: RawInstanceObject

	local object = setmetatable(raw, {
		__index = function(instance, key)
			local class = rawget(instance, "_class")
			return class and class[key]
		end,
	}) :: InstanceObject

	local classes: { ClassObject } = {}
	local class: ClassObject? = self
	local callback: ClassConstructor?

	while class do
		table.insert(classes, class)
		class = rawget(class, "Base")
	end

	for idx = #classes, 1, -1 do
		callback = rawget(classes[idx], "_Constructor")
		if callback then
			callback(object, ...)
		end
	end

	return object
end

--[[
	Creates a child class.
]]
module.Extend = function(self: ClassObject, name: string)
	return module.new(name, self)
end

--[[
	Assigns the constructor for this class.
]]
module.Constructor = function(self: ClassObject, callback: ClassConstructor)
	assert(type(callback) == "function", "Constructor must be a function")

	rawset(self, "_Constructor", callback)
	return self
end

--[[
	Returns the name of this class.
]]
module.GetName = function(self: ClassObject)
	return rawget(self, "Name")
end

--[[
	Returns the direct base class.
]]
module.GetBase = function(self: ClassObject)
	return rawget(self, "Base")
end

--[[
	Returns the class which created this instance.
]]
module.GetClass = function(self: InstanceObject)
	return rawget(self, "_class")
end

--[[
	Returns the name of the class which created this instance.
]]
module.GetClassName = function(self: InstanceObject)
	return self._class.Name
end

--[[
	Checks inheritance by class name or exact class object.
]]
module.IsA = function(self: ClassObject | InstanceObject, target: string | ClassObject)
	local class: ClassObject?
	local targetClass: ClassObject? = nil
	local targetName: string? = nil

	if rawget(self, "_Class") == true then
		class = self :: ClassObject
	else
		class = rawget(self, "_class")
	end

	if type(target) == "string" then
		targetName = target
	elseif type(target) == "table" and rawget(target, "_Class") == true then
		targetClass = target :: ClassObject
	else
		return false
	end

	while class do
		if class == targetClass or (targetName ~= nil and class.Name == targetName) then
			return true
		end

		class = rawget(class, "Base")
	end

	return false
end

return module
