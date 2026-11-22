--!strict
--[[
	A fixed-size collection of bits.
]]

type RawBitSetObject = {
	_Words: { number },
	_Size: number,
}

type ProtoSchema = {
	new: (size: number, fill: boolean?) -> BitSetObject,
	Set: (self: BitSetObject, index: number, value: boolean?) -> BitSetObject,
	Reset: (self: BitSetObject, index: number?) -> BitSetObject,
	Flip: (self: BitSetObject, index: number?) -> BitSetObject,
	Test: (self: BitSetObject, index: number) -> boolean,
	Count: (self: BitSetObject) -> number,
	Size: (self: BitSetObject) -> number,
	Any: (self: BitSetObject) -> boolean,
	None: (self: BitSetObject) -> boolean,
	All: (self: BitSetObject) -> boolean,
	ToArray: (self: BitSetObject) -> { number },
}

export type BitSetObject = typeof(setmetatable({} :: RawBitSetObject, { __index = {} :: ProtoSchema }))

local module = {}

local function position(index: number): (number, number)
	assert(index % 1 == 0 and index >= 1, "BitSet index must be a positive integer")
	return math.floor((index - 1) / 32) + 1, (index - 1) % 32
end

local function check(self: BitSetObject, index: number): (number, number)
	local word, offset = position(index)
	assert(index <= self._Size, "BitSet index out of bounds")
	return word, offset
end

--[[
	Creates a bit set with an optional initial value.
]]
module.new = function(size: number, fill: boolean?)
	assert(size % 1 == 0 and size >= 0, "BitSet size must be a non-negative integer")

	local count = math.ceil(size / 32)
	local words = table.create(count, if fill then 0xFFFFFFFF else 0)

	if fill and count > 0 and size % 32 ~= 0 then
		words[count] = bit32.lshift(1, size % 32) - 1
	end

	return (
		setmetatable(
			{
				_Words = words,
				_Size = size,
			} :: RawBitSetObject,
			{ __index = module }
		)
	) :: BitSetObject
end

--[[
	Sets or clears one bit.
]]
module.Set = function(self: BitSetObject, index: number, value: boolean?)
	local word, offset = check(self, index)
	local mask = bit32.lshift(1, offset)

	if value == false then
		self._Words[word] = bit32.band(self._Words[word], bit32.bnot(mask))
	else
		self._Words[word] = bit32.bor(self._Words[word], mask)
	end

	return self
end

--[[
	Clears one bit or every bit.
]]
module.Reset = function(self: BitSetObject, index: number?)
	if index then
		local word, offset = check(self, index)
		self._Words[word] = bit32.band(self._Words[word], bit32.bnot(bit32.lshift(1, offset)))
	else
		table.clear(self._Words)
		for idx = 1, math.ceil(self._Size / 32) do
			self._Words[idx] = 0
		end
	end

	return self
end

--[[
	Flips one bit or every bit.
]]
module.Flip = function(self: BitSetObject, index: number?)
	if index then
		local word, offset = check(self, index)
		self._Words[word] = bit32.bxor(self._Words[word], bit32.lshift(1, offset))
	else
		for idx, word in self._Words do
			self._Words[idx] = bit32.bnot(word)
		end

		if self._Size % 32 ~= 0 and #self._Words > 0 then
			self._Words[#self._Words] = bit32.band(self._Words[#self._Words], bit32.lshift(1, self._Size % 32) - 1)
		end
	end

	return self
end

--[[
	Checks whether a bit is set.
]]
module.Test = function(self: BitSetObject, index: number)
	local word, offset = check(self, index)
	return bit32.band(self._Words[word], bit32.lshift(1, offset)) ~= 0
end

--[[
	Counts the number of set bits.
]]
module.Count = function(self: BitSetObject)
	local count = 0

	for _, word in self._Words do
		local value = word

		while value ~= 0 do
			value = bit32.band(value, value - 1)
			count += 1
		end
	end

	return count
end

--[[
	Returns the fixed number of bits.
]]
module.Size = function(self: BitSetObject)
	return self._Size
end

--[[
	Checks whether at least one bit is set.
]]
module.Any = function(self: BitSetObject)
	for _, word in self._Words do
		if word ~= 0 then
			return true
		end
	end

	return false
end

--[[
	Checks whether no bits are set.
]]
module.None = function(self: BitSetObject)
	return not self:Any()
end

--[[
	Checks whether every bit is set.
]]
module.All = function(self: BitSetObject)
	return self:Count() == self._Size
end

--[[
	Returns the one-based indexes of every set bit.
]]
module.ToArray = function(self: BitSetObject)
	local raw = {}

	for index = 1, self._Size do
		if self:Test(index) then
			table.insert(raw, index)
		end
	end

	return raw
end

return module
