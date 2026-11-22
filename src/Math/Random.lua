--!strict
--[[
	A deterministic xorshift32 random-number generator.
]]

type RawRandomObject = {
	_State: number,
}

type ProtoSchema = {
	new: (seed: number) -> RandomObject,
	NextNumber: (self: RandomObject, minimum: number?, maximum: number?) -> number,
	NextInteger: (self: RandomObject, minimum: number, maximum: number) -> number,
	Choice: <T>(self: RandomObject, values: { T }) -> T?,
	Shuffle: <T>(self: RandomObject, values: { T }) -> { T },
}

export type RandomObject = typeof(setmetatable({} :: RawRandomObject, { __index = {} :: ProtoSchema }))

local module = {}

local function nextState(self: RandomObject): number
	local state = self._State

	state = bit32.bxor(state, bit32.lshift(state, 13))
	state = bit32.bxor(state, bit32.rshift(state, 17))
	state = bit32.bxor(state, bit32.lshift(state, 5))

	self._State = bit32.band(state, 0xFFFFFFFF)
	return self._State
end

--[[
	Creates a generator with a reproducible integer seed.
]]
module.new = function(seed: number)
	assert(seed % 1 == 0, "Random seed must be an integer")

	local state = bit32.band(seed, 0xFFFFFFFF)
	if state == 0 then
		state = 0x6D2B79F5
	end

	return (setmetatable({
		_State = state;
	} :: RawRandomObject, { __index = module })) :: RandomObject
end

--[[
	Returns a random number in [0, 1) or within the supplied range.
]]
module.NextNumber = function(self: RandomObject, minimum: number?, maximum: number?)
	local value = nextState(self) / 4294967296

	if minimum == nil and maximum == nil then
		return value
	end

	local first = minimum or 0
	local last = maximum or 1
	assert(first <= last, "Random minimum cannot exceed maximum")

	return first + (last - first) * value
end

--[[
	Returns a random integer in an inclusive range.
]]
module.NextInteger = function(self: RandomObject, minimum: number, maximum: number)
	assert(minimum % 1 == 0 and maximum % 1 == 0, "Random bounds must be integers")
	assert(minimum <= maximum, "Random minimum cannot exceed maximum")

	local range = maximum - minimum + 1
	assert(range <= 4294967296, "Random integer range is too large")

	local limit = math.floor(4294967296 / range) * range
	local value = nextState(self)

	while value >= limit do
		value = nextState(self)
	end

	return minimum + (value % range)
end

--[[
	Returns a random element from an array.
]]
module.Choice = function<T>(self: RandomObject, values: { T }): T?
	if #values == 0 then
		return nil
	end

	return values[self:NextInteger(1, #values)]
end

--[[
	Returns a shuffled copy without changing the input.
]]
module.Shuffle = function<T>(self: RandomObject, values: { T }): { T }
	local raw = table.clone(values)

	for idx = #raw, 2, -1 do
		local other = self:NextInteger(1, idx)
		raw[idx], raw[other] = raw[other], raw[idx]
	end

	return raw
end

return module
