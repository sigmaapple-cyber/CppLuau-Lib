--!strict
--[[
	Stores and transforms two related values.
]]

type RawPairObject = {
	First: any,
	Second: any,
}

type ProtoSchema = {
	new: (first: any, second: any) -> PairObject,
	Unpack: (self: PairObject) -> (any, any),
	Swap: (self: PairObject) -> PairObject,
	Map: (self: PairObject, callback: (any, any) -> (any, any)) -> PairObject,
}

export type PairObject = typeof(setmetatable({} :: RawPairObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a pair of values.
]]
module.new = function(first: any, second: any)
	return (setmetatable({
		First = first;
		Second = second;
	} :: RawPairObject, { __index = module })) :: PairObject
end

--[[
	Returns both values.
]]
module.Unpack = function(self: PairObject)
	return self.First, self.Second
end

--[[
	Creates a pair with the values reversed.
]]
module.Swap = function(self: PairObject)
	return module.new(self.Second, self.First)
end

--[[
	Transforms both values using one callback.
]]
module.Map = function(self: PairObject, callback: (any, any) -> (any, any))
	assert(type(callback) == "function", "Pair.Map callback must be a function")

	local first, second = callback(self.First, self.Second)
	return module.new(first, second)
end

return module
