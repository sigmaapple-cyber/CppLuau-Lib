--!strict

type RawClassObject = {
	_Class: boolean,
	Name: string,
	Base: ClassObject?,
	_Constructor: ((...any) -> ())?,
	[string]: any,
}

type RawInstanceObject = {
	_class: ClassObject,
	[string]: any,
}

type ProtoSchema = {
	new: (name: string, base: ClassObject?) -> ClassObject,
	Create: (self: ClassObject, ...any) -> InstanceObject,
	Extend: (self: ClassObject, name: string) -> ClassObject,
	Constructor: (self: ClassObject, callback: (...any) -> ()) -> ClassObject,
	IsA: (self: ClassObject, name: string) -> boolean,
	[string]: any,
}

type InstanceSchema = {
	IsA: (self: InstanceObject, name: string) -> boolean,
	[string]: any,
}


export type ClassObject = typeof(setmetatable(
	{} :: RawClassObject,
	{ __index = {} :: ProtoSchema }
))


export type InstanceObject = typeof(setmetatable(
	{} :: RawInstanceObject,
	{ __index = {} :: InstanceSchema }
))


local module = {}

--[[
	Creates a class with optional inheritance.
--]]
module.new = function(name: string, base: ClassObject?)
	assert(name ~= "", "Class name cannot be empty")
	assert(base == nil or rawget(base, "_Class") == true, "Base must be a CppLuau class")

	local raw = {
		_Class = true,
		Name = name,
		Base = base,
		_Constructor = nil,
	} :: RawClassObject

	return (setmetatable(raw, {
		__index = function(self, key)
			local value = (module :: any)[key]
			if value ~= nil then
				return value
			end

			local parent = rawget(self, "Base")
			return parent and parent[key]
		end,
	})) :: ClassObject
end


--[[
	Creates an instance and runs constructors from base to derived.
--]]
module.Create = function(self: ClassObject, ...)
	local raw = {
		_class = self,
	} :: RawInstanceObject

	local object = setmetatable(raw, {
		__index = function(instance, key)
			local class = rawget(instance, "_class")
			return class[key]
		end,
	}) :: InstanceObject


	local classes = {}
	local class: ClassObject? = self

	while class do
		table.insert(classes, class)
		class = rawget(class, "Base")
	end

	for idx = #classes, 1, -1 do
		local callback = rawget(classes[idx], "_Constructor")
		if callback then
			callback(object, ...)
		end
	end

	return object
end


--[[
	Creates a child class.
--]]
module.Extend = function(self: ClassObject, name: string)
	return module.new(name, self)
end


--[[
	Assigns the class constructor.
--]]
module.Constructor = function(self: ClassObject, callback: (...any) -> ())
	self._Constructor = callback
	return self
end


--[[
	Checks whether a class or instance inherits from the given class name.
--]]
module.IsA = function(self: ClassObject | InstanceObject, name: string)
	local class = if rawget(self, "_Class") == true then self else rawget(self, "_class")

	while class do
		if rawget(class, "Name") == name then
			return true
		end

		class = rawget(class, "Base")
	end

	return false
end


return module
