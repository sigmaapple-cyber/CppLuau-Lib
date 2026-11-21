--!strict
--[[
	A key-value container with explicit size tracking.
]]

type RawMapObject = {
	_Items: { [any]: any },
	_Count: number,
}

type ProtoSchema = {
	new: () -> MapObject,
	Set: (self: MapObject, key: any, value: any) -> MapObject,
	Get: (self: MapObject, key: any) -> any,
	Has: (self: MapObject, key: any) -> boolean,
	Remove: (self: MapObject, key: any) -> boolean,
	Size: (self: MapObject) -> number,
	Empty: (self: MapObject) -> boolean,
	Clear: (self: MapObject) -> (),
	Keys: (self: MapObject) -> { any },
	Values: (self: MapObject) -> { any },
	ForEach: (self: MapObject, callback: (any, any) -> ()) -> (),
}

export type MapObject = typeof(setmetatable({} :: RawMapObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates an empty map.
]]
module.new = function()
	return (setmetatable(
		{
			_Items = {},
			_Count = 0,
		} :: RawMapObject,
		{ __index = module }
	)) :: MapObject
end

--[[
	Stores a value using the given key.
]]
module.Set = function(self: MapObject, key: any, value: any)
	assert(key ~= nil, "Map key cannot be nil")
	assert(value ~= nil, "Map value cannot be nil")

	if self._Items[key] == nil then
		self._Count += 1
	end

	self._Items[key] = value
	return self
end

--[[
	Returns the value associated with a key.
]]
module.Get = function(self: MapObject, key: any)
	return self._Items[key]
end

--[[
	Checks whether a key exists.
]]
module.Has = function(self: MapObject, key: any)
	return self._Items[key] ~= nil
end

--[[
	Removes a key and reports whether it existed.
]]
module.Remove = function(self: MapObject, key: any)
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
module.Size = function(self: MapObject)
	return self._Count
end

--[[
	Checks whether the map is empty.
]]
module.Empty = function(self: MapObject)
	return self._Count == 0
end

--[[
	Removes every key-value pair.
]]
module.Clear = function(self: MapObject)
	table.clear(self._Items)
	self._Count = 0
end

--[[
	Returns all keys in unspecified iteration order.
]]
module.Keys = function(self: MapObject)
	local raw = {}

	for key in self._Items do
		table.insert(raw, key)
	end

	return raw
end

--[[
	Returns all values in unspecified iteration order.
]]
module.Values = function(self: MapObject)
	local raw = {}

	for _, value in self._Items do
		table.insert(raw, value)
	end

	return raw
end

--[[
	Calls a function for each key-value pair.
]]
module.ForEach = function(self: MapObject, callback: (any, any) -> ())
	for key, value in self._Items do
		callback(key, value)
	end
end

return module
