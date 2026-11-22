--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Math.Random", function()
		it("produces reproducible sequences", function()
			local first = CppLuau.Math.Random.new(12345)
			local second = CppLuau.Math.Random.new(12345)

			for _ = 1, 10 do
				expect(first:NextInteger(1, 1000)).to.equal(second:NextInteger(1, 1000))
			end
		end)

		it("chooses and shuffles values", function()
			local random = CppLuau.Math.Random.new(42)
			local values = { 1, 2, 3, 4, 5 }
			local shuffled = random:Shuffle(values)

			expect(#shuffled).to.equal(5)
			expect(#values).to.equal(5)
			expect(random:Choice(values) >= 1).to.equal(true)
		end)
	end)

	describe("Math.Bit", function()
		it("performs bit operations", function()
			local Bit = CppLuau.Math.Bit

			expect(Bit.And(7, 3)).to.equal(3)
			expect(Bit.Or(4, 1)).to.equal(5)
			expect(Bit.Xor(7, 3)).to.equal(4)
			expect(Bit.ShiftLeft(1, 3)).to.equal(8)
			expect(Bit.Extract(0xF0, 4, 4)).to.equal(15)
		end)
	end)

	describe("Math.Complex", function()
		it("performs complex arithmetic", function()
			local Complex = CppLuau.Math.Complex
			local value = Complex.new(1, 2)
			local result = value:Mul(Complex.new(3, 4))

			expect(result.Real).to.equal(-5)
			expect(result.Imaginary).to.equal(10)
			expect(value:Conjugate().Imaginary).to.equal(-2)
			expect(Complex.new(3, 4):Magnitude()).to.equal(5)
		end)
	end)
end
