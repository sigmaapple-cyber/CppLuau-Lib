--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

return function()
	describe("Values.variant", function()
		it("dispatches by active tag", function()
			local value = luapp.values.variant.new("Number", 12)
			local result = value:Match({
				Number = function(number)
					return number * 2
				end,
			})

			expect(result).to.equal(24)
			expect(value:Is("Number")).to.equal(true)
		end)
	end)

	describe("Math.numeric", function()
		it("creates ranges and calculates integer products", function()
			local Numeric = luapp.math.numeric
			local values = Numeric.Iota(4, 2, 3)

			expect(table.concat(values, ",")).to.equal("2,5,8,11")
			expect(Numeric.Accumulate(values, 0)).to.equal(26)
			expect(Numeric.GCD(24, 18)).to.equal(6)
			expect(Numeric.LCM(4, 6)).to.equal(12)
			expect(Numeric.InnerProduct({ 1, 2, 3 }, { 4, 5, 6 })).to.equal(32)
		end)
	end)

	describe("Utility.functional", function()
		it("composes and binds callbacks", function()
			local Functional = luapp.utility.functional
			local callback = Functional.Compose(function(value)
				return value * 2
			end, function(value)
				return value + 1
			end)

			expect(callback(4)).to.equal(10)
			expect(Functional.Bind(function(a, b)
				return a + b
			end, 5)(7)).to.equal(12)
		end)
	end)

	describe("Text.stringBuilder", function()
		it("joins parts and tracks byte length", function()
			local builder = luapp.text.stringBuilder.new()
			builder:Append("Hello"):Append(" "):AppendLine("Luau")

			expect(builder:ToString()).to.equal("Hello Luau\n")
			expect(builder:Length()).to.equal(11)
		end)
	end)
end
