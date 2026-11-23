--!strict

type RawOrderedMap<K, V> = {
	_Keys: { K },
	_Items: { [K]: V },
}

type OrderedMapMethods<K, V> = {
	Set: (self: OrderedMap<K, V>, key: K, value: V) -> OrderedMap<K, V>,
	Get: (self: OrderedMap<K, V>, key: K) -> V?,
	Has: (self: OrderedMap<K, V>, key: K) -> boolean,
	Remove: (self: OrderedMap<K, V>, key: K) -> boolean,
	Keys: (self: OrderedMap<K, V>) -> { K },
	Values: (self: OrderedMap<K, V>) -> { V },
	ForEach: (self: OrderedMap<K, V>, callback: (K, V) -> ()) -> (),
	Size: (self: OrderedMap<K, V>) -> number,
	Empty: (self: OrderedMap<K, V>) -> boolean,
	Clear: (self: OrderedMap<K, V>) -> (),
	ToTable: (self: OrderedMap<K, V>) -> { [K]: V },
}

export type OrderedMap<K, V> = typeof(setmetatable(
	{} :: RawOrderedMap<K, V>,
	{ __index = {} :: OrderedMapMethods<K, V> }
))

local module = {}

module.new = function<K, V>(): OrderedMap<K, V>
	return setmetatable(
		{
			_Keys = {},
			_Items = {},
		} :: RawOrderedMap<K, V>,
		{ __index = module }
	) :: OrderedMap<K, V>
end

module.Set = function<K, V>(self: OrderedMap<K, V>, key: K, value: V): OrderedMap<K, V>
	assert(key ~= nil, "OrderedMap key cannot be nil")
	assert(value ~= nil, "OrderedMap value cannot be nil")

	if self._Items[key] == nil then
		table.insert(self._Keys, key)
	end

	self._Items[key] = value
	return self
end

module.Get = function<K, V>(self: OrderedMap<K, V>, key: K): V?
	return self._Items[key]
end

module.Has = function<K, V>(self: OrderedMap<K, V>, key: K): boolean
	return self._Items[key] ~= nil
end

module.Remove = function<K, V>(self: OrderedMap<K, V>, key: K): boolean
	if self._Items[key] == nil then
		return false
	end

	self._Items[key] = nil
	table.remove(self._Keys, table.find(self._Keys, key) :: number)

	return true
end

module.Keys = function<K, V>(self: OrderedMap<K, V>): { K }
	return table.clone(self._Keys)
end

module.Values = function<K, V>(self: OrderedMap<K, V>): { V }
	local values = table.create(#self._Keys)

	for idx, key in self._Keys do
		values[idx] = self._Items[key]
	end

	return values
end

module.ForEach = function<K, V>(self: OrderedMap<K, V>, callback: (K, V) -> ())
	assert(type(callback) == "function", "OrderedMap.ForEach expects a function")

	local keys = table.clone(self._Keys)

	for _, key in keys do
		local value = self._Items[key]
		if value ~= nil then
			callback(key, value)
		end
	end
end

module.Size = function<K, V>(self: OrderedMap<K, V>): number
	return #self._Keys
end

module.Empty = function<K, V>(self: OrderedMap<K, V>): boolean
	return #self._Keys == 0
end

module.Clear = function<K, V>(self: OrderedMap<K, V>)
	table.clear(self._Keys)
	table.clear(self._Items)
end

module.ToTable = function<K, V>(self: OrderedMap<K, V>): { [K]: V }
	return table.clone(self._Items)
end

return table.freeze(module)
