--!strict
--[[
	A hash-table-backed collection of unique values.
]]

type RawHashSetObject = {
	_Items: { [any]: boolean },
	_Count: number,
}

type ProtoSchema = {
	new: (values: { any }?) -> HashSetObject,
	Add: (self: HashSetObject, value: any) -> HashSetObject,
	Remove: (self: HashSetObject, value: any) -> boolean,
	Contains: (self: HashSetObject, value: any) -> boolean,
	Size: (self: HashSetObject) -> number,
	Empty: (self: HashSetObject) -> boolean,
	Clear: (self: HashSetObject) -> (),
	ToArray: (self: HashSetObject) -> { any },
	Union: (self: HashSetObject, other: HashSetObject) -> HashSetObject,
	Intersection: (self: HashSetObject, other: HashSetObject) -> HashSetObject,
	Difference: (self: HashSetObject, other: HashSetObject) -> HashSetObject,
	IsSubsetOf: (self: HashSetObject, other: HashSetObject) -> boolean,
}

export type HashSetObject = typeof(setmetatable({} :: RawHashSetObject, { __index = {} :: ProtoSchema }))

local module = {}

module.new = function(values: { any }?)
	assert(values == nil or type(values) == "table", "HashSet values must be a table")

	local object = setmetatable(
		{
			_Items = {},
			_Count = 0,
		} :: RawHashSetObject,
		{ __index = module }
	) :: HashSetObject

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
module.Add = function(self: HashSetObject, value: any)
	assert(value ~= nil, "HashSet cannot store nil")

	if not self._Items[value] then
		self._Items[value] = true
		self._Count += 1
	end

	return self
end

--[[
	Removes a value and reports whether it existed.
]]
module.Remove = function(self: HashSetObject, value: any)
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
module.Contains = function(self: HashSetObject, value: any)
	return self._Items[value] == true
end

--[[
	Returns the number of unique values.
]]
module.Size = function(self: HashSetObject)
	return self._Count
end

--[[
	Checks whether the set is empty.
]]
module.Empty = function(self: HashSetObject)
	return self._Count == 0
end

--[[
	Removes every value.
]]
module.Clear = function(self: HashSetObject)
	table.clear(self._Items)
	self._Count = 0
end

--[[
	Returns all values in unspecified iteration order.
]]
module.ToArray = function(self: HashSetObject)
	local raw = {}

	for value in self._Items do
		table.insert(raw, value)
	end

	return raw
end

--[[
	Returns the union of this set and another set.
]]
module.Union = function(self: HashSetObject, other: HashSetObject)
	local raw = module.new(self:ToArray())

	for value in other._Items do
		raw:Add(value)
	end

	return raw
end

--[[
	Returns values shared by both sets.
]]
module.Intersection = function(self: HashSetObject, other: HashSetObject)
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
module.Difference = function(self: HashSetObject, other: HashSetObject)
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
module.IsSubsetOf = function(self: HashSetObject, other: HashSetObject)
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
