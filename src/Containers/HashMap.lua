--!strict
--[[
	A key-value container backed by a Luau hash table.
]]

type RawHashMapObject = {
	_Items: { [any]: any },
	_Count: number,
}

type ProtoSchema = {
	new: () -> HashMapObject,
	Set: (self: HashMapObject, key: any, value: any) -> HashMapObject,
	Get: (self: HashMapObject, key: any) -> any,
	Has: (self: HashMapObject, key: any) -> boolean,
	Remove: (self: HashMapObject, key: any) -> boolean,
	Size: (self: HashMapObject) -> number,
	Empty: (self: HashMapObject) -> boolean,
	Clear: (self: HashMapObject) -> (),
	Keys: (self: HashMapObject) -> { any },
	Values: (self: HashMapObject) -> { any },
	ForEach: (self: HashMapObject, callback: (any, any) -> ()) -> (),
}

export type HashMapObject = typeof(setmetatable({} :: RawHashMapObject, { __index = {} :: ProtoSchema }))

local module = {}

module.new = function()
	return (setmetatable({
		_Items = {};
		_Count = 0;
	} :: RawHashMapObject, { __index = module })) :: HashMapObject
end

--[[
	Stores a value at the supplied key.
]]
module.Set = function(self: HashMapObject, key: any, value: any)
	assert(key ~= nil, "HashMap key cannot be nil")
	assert(value ~= nil, "HashMap value cannot be nil")

	if self._Items[key] == nil then
		self._Count += 1
	end

	self._Items[key] = value
	return self
end

--[[
	Returns the value associated with a key.
]]
module.Get = function(self: HashMapObject, key: any)
	return self._Items[key]
end

--[[
	Checks whether a key exists.
]]
module.Has = function(self: HashMapObject, key: any)
	return self._Items[key] ~= nil
end

--[[
	Removes a key and reports whether it existed.
]]
module.Remove = function(self: HashMapObject, key: any)
	if self._Items[key] == nil then
		return false
	end

	self._Items[key] = nil
	self._Count -= 1
	return true
end

--[[
	Returns the number of key-value pairs.
]]
module.Size = function(self: HashMapObject)
	return self._Count
end

--[[
	Checks whether the map is empty.
]]
module.Empty = function(self: HashMapObject)
	return self._Count == 0
end

--[[
	Removes every key-value pair.
]]
module.Clear = function(self: HashMapObject)
	table.clear(self._Items)
	self._Count = 0
end

--[[
	Returns all keys in unspecified iteration order.
]]
module.Keys = function(self: HashMapObject)
	local raw = {}

	for key in self._Items do
		table.insert(raw, key)
	end

	return raw
end

--[[
	Returns all values in unspecified iteration order.
]]
module.Values = function(self: HashMapObject)
	local raw = {}

	for _, value in self._Items do
		table.insert(raw, value)
	end

	return raw
end

--[[
	Calls a function for each key-value pair.
]]
module.ForEach = function(self: HashMapObject, callback: (any, any) -> ())
	for key, value in self._Items do
		callback(key, value)
	end
end

return module
