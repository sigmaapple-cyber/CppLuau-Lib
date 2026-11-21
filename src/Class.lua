--!strict

type RawClassObject = {
	Name: string,
	Base: ClassObject?,
	Constructor: ((...any) -> ())?,
}

type ProtoSchema = {
	new: (name: string, base: ClassObject?) -> ClassObject,
	Create: (self: ClassObject, ...any) -> any,
	Extend: (self: ClassObject, name: string) -> ClassObject,
	Constructor: (self: ClassObject, callback: (...any) -> ()) -> ClassObject,
}


export type ClassObject = typeof(setmetatable(
	{} :: RawClassObject,
	{ __index = {} :: ProtoSchema }
))


local module = {}

--[[
	Create a class object with optional inheritance.
--]]
module.new = function(name: string, base: ClassObject?)
	local raw = {
		Name = name,
		Base = base,
		Constructor = nil,
	} :: RawClassObject

	local class = setmetatable(raw, {
		__index = base,
	}) :: ClassObject

	return class
end


--[[
	Creates an instance of the class.
--]]
module.Create = function(self: ClassObject, ...)
	local raw = {}
	local object = setmetatable(raw, {
		__index = self,
	})

	if self.Constructor then
		self.Constructor(object, ...)
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
	self.Constructor = callback
	return self
end


return module
