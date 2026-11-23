--!strict
--[[
	A last-in, first-out container.
]]

type RawStackObject = {
	_Items: { any },
}

type ProtoSchema = {
	new: (values: { any }?) -> StackObject,
	Push: (self: StackObject, value: any) -> StackObject,
	Pop: (self: StackObject) -> any,
	Top: (self: StackObject) -> any,
	Size: (self: StackObject) -> number,
	Empty: (self: StackObject) -> boolean,
	Clear: (self: StackObject) -> (),
	ToArray: (self: StackObject) -> { any },
}

export type StackObject = typeof(setmetatable({} :: RawStackObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a stack from an optional array. The last value is the top.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "Stack values must be a table")

	return (
		setmetatable(
			{
				_Items = if values then table.clone(values) else {},
			} :: RawStackObject,
			{ __index = module }
		)
	) :: StackObject
end

--[[
	Pushes a value onto the top.
]]
module.Push = function(self: StackObject, value: any)
	assert(value ~= nil, "Stack cannot store nil")

	table.insert(self._Items, value)
	return self
end

--[[
	Removes and returns the top value.
]]
module.Pop = function(self: StackObject)
	return table.remove(self._Items)
end

--[[
	Returns the top value without removing it.
]]
module.Top = function(self: StackObject)
	return self._Items[#self._Items]
end

--[[
	Returns the number of stored values.
]]
module.Size = function(self: StackObject)
	return #self._Items
end

--[[
	Checks whether the stack is empty.
]]
module.Empty = function(self: StackObject)
	return #self._Items == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: StackObject)
	table.clear(self._Items)
end

--[[
	Returns a shallow copy from bottom to top.
]]
module.ToArray = function(self: StackObject)
	return table.clone(self._Items)
end

return module
