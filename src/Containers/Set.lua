--!strict
--[[
	A collection of unique values.
]]

type RawSetObject = {
	_Items: { [any]: boolean },
	_Count: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> SetObject,
	Add: (self: SetObject, value: any) -> SetObject,
	Remove: (self: SetObject, value: any) -> boolean,
	Contains: (self: SetObject, value: any) -> boolean,
	Size: (self: SetObject) -> number,
	Empty: (self: SetObject) -> boolean,
	Clear: (self: SetObject) -> (),
	ToArray: (self: SetObject) -> { any },
	Union: (self: SetObject, other: SetObject) -> SetObject,
	Intersection: (self: SetObject, other: SetObject) -> SetObject,
	Difference: (self: SetObject, other: SetObject) -> SetObject,
	IsSubsetOf: (self: SetObject, other: SetObject) -> boolean,
}

export type SetObject = typeof(setmetatable({} :: RawSetObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a set from an optional array of values.
]]
module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "Set values must be a table")

	local object = setmetatable(
		{
			_Items = {},
			_Count = 0,
		} :: RawSetObject,
		{ __index = module }
	) :: SetObject

	if values then
		for _, value in values do
			object:Add(value)
		end
	end

	return object
end

--[[
	Adds a value if it is not already present.
]]
module.Add = function(self: SetObject, value: any)
	assert(value ~= nil, "Set cannot store nil")

	if not self._Items[value] then
		self._Items[value] = true
		self._Count += 1
	end

	return self
end

--[[
	Removes a value and reports whether it existed.
]]
module.Remove = function(self: SetObject, value: any)
	if not self._Items[value] then
		return false
	end

	self._Items[value] = nil
	self._Count -= 1

	return true
end

--[[
	Checks whether a value is present.
]]
module.Contains = function(self: SetObject, value: any)
	return self._Items[value] == true
end

--[[
	Returns the number of unique values.
]]
module.Size = function(self: SetObject)
	return self._Count
end

--[[
	Checks whether the set is empty.
]]
module.Empty = function(self: SetObject)
	return self._Count == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: SetObject)
	table.clear(self._Items)
	self._Count = 0
end

--[[
	Returns all values in unspecified iteration order.
]]
module.ToArray = function(self: SetObject)
	local raw = {}

	for value in self._Items do
		table.insert(raw, value)
	end

	return raw
end

--[[
	Returns the union of this set and another set.
]]
module.Union = function(self: SetObject, other: SetObject)
	local raw = module.new(self:ToArray())

	for value in other._Items do
		raw:Add(value)
	end

	return raw
end

--[[
	Returns values shared by both sets.
]]
module.Intersection = function(self: SetObject, other: SetObject)
	local raw = module.new()

	for value in self._Items do
		if other:Contains(value) then
			raw:Add(value)
		end
	end

	return raw
end

--[[
	Returns values in this set which are not in the other set.
]]
module.Difference = function(self: SetObject, other: SetObject)
	local raw = module.new()

	for value in self._Items do
		if not other:Contains(value) then
			raw:Add(value)
		end
	end

	return raw
end

--[[
	Checks whether every value in this set is also in another set.
]]
module.IsSubsetOf = function(self: SetObject, other: SetObject)
	if self._Count > other._Count then
		return false
	end

	for value in self._Items do
		if not other:Contains(value) then
			return false
		end
	end

	return true
end

return module
