--!strict
--[[
	Complex numbers with basic arithmetic.
]]

type RawComplexObject = {
	Real: number,
	Imaginary: number,
}

type ProtoSchema = {
	new: (real: number, imaginary: number?) -> ComplexObject,
	Add: (self: ComplexObject, other: ComplexObject) -> ComplexObject,
	Sub: (self: ComplexObject, other: ComplexObject) -> ComplexObject,
	Mul: (self: ComplexObject, other: ComplexObject) -> ComplexObject,
	Div: (self: ComplexObject, other: ComplexObject) -> ComplexObject,
	Conjugate: (self: ComplexObject) -> ComplexObject,
	Magnitude: (self: ComplexObject) -> number,
	Argument: (self: ComplexObject) -> number,
	ToString: (self: ComplexObject) -> string,
	FromPolar: (magnitude: number, angle: number) -> ComplexObject,
}

export type ComplexObject = typeof(setmetatable({} :: RawComplexObject, { __index = {} :: ProtoSchema }))

local module = {}

--[[
	Creates a complex number a + bi.
]]
module.new = function(real: number, imaginary: number?)
	return (setmetatable({
		Real = real;
		Imaginary = imaginary or 0;
	} :: RawComplexObject, { __index = module })) :: ComplexObject
end

--[[
	Adds another complex number.
]]
module.Add = function(self: ComplexObject, other: ComplexObject)
	return module.new(self.Real + other.Real, self.Imaginary + other.Imaginary)
end

--[[
	Subtracts another complex number.
]]
module.Sub = function(self: ComplexObject, other: ComplexObject)
	return module.new(self.Real - other.Real, self.Imaginary - other.Imaginary)
end

--[[
	Multiplies by another complex number.
]]
module.Mul = function(self: ComplexObject, other: ComplexObject)
	local real = self.Real * other.Real - self.Imaginary * other.Imaginary
	local imaginary = self.Real * other.Imaginary + self.Imaginary * other.Real

	return module.new(real, imaginary)
end

--[[
	Divides by another complex number.
]]
module.Div = function(self: ComplexObject, other: ComplexObject)
	local denominator = other.Real ^ 2 + other.Imaginary ^ 2
	assert(denominator ~= 0, "Cannot divide by zero")

	local real = (self.Real * other.Real + self.Imaginary * other.Imaginary) / denominator
	local imaginary = (self.Imaginary * other.Real - self.Real * other.Imaginary) / denominator

	return module.new(real, imaginary)
end

--[[
	Returns the complex conjugate.
]]
module.Conjugate = function(self: ComplexObject)
	return module.new(self.Real, -self.Imaginary)
end

--[[
	Returns the magnitude.
]]
module.Magnitude = function(self: ComplexObject)
	return math.sqrt(self.Real ^ 2 + self.Imaginary ^ 2)
end

--[[
	Returns the angle in radians.
]]
module.Argument = function(self: ComplexObject)
	return math.atan2(self.Imaginary, self.Real)
end

--[[
	Returns a + bi text representation.
]]
module.ToString = function(self: ComplexObject)
	local sign = if self.Imaginary < 0 then " - " else " + "
	return tostring(self.Real) .. sign .. tostring(math.abs(self.Imaginary)) .. "i"
end

--[[
	Creates a complex number from polar coordinates.
]]
module.FromPolar = function(magnitude: number, angle: number)
	return module.new(magnitude * math.cos(angle), magnitude * math.sin(angle))
end

return module
