--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Variant", function()
		it("stores a tag and dispatches to its matching handler", function()
			local value = CppLuau.Variant.new("Number", 12)

			local result = value:Match({
				Number = function(number)
					return number * 2
				end,
				Text = function(text)
					return string.upper(text)
				end,
			})

			expect(value:Is("Number")).to.equal(true)
			expect(result).to.equal(24)
		end)

		it("can change its active alternative", function()
			local value = CppLuau.Variant.new("Text", "hello")
			value:Set("Number", 5)

			expect(value:GetTag()).to.equal("Number")
			expect(value:Get()).to.equal(5)
		end)
	end)

	describe("Numeric", function()
		it("creates sequences and accumulates values", function()
			local values = CppLuau.Numeric.Iota(4, 2, 3)

			expect(table.concat(values, ",")).to.equal("2,5,8,11")
			expect(CppLuau.Numeric.Accumulate(values, 0)).to.equal(26)
		end)

		it("computes integer products and divisors", function()
			expect(CppLuau.Numeric.GCD(24, 18)).to.equal(6)
			expect(CppLuau.Numeric.LCM(4, 6)).to.equal(12)
			expect(CppLuau.Numeric.InnerProduct({ 1, 2, 3 }, { 4, 5, 6 })).to.equal(32)
		end)
	end)

	describe("Functional", function()
		it("composes two functions", function()
			local double = function(value)
				return value * 2
			end

			local addOne = function(value)
				return value + 1
			end

			local callback = CppLuau.Functional.Compose(double, addOne)

			expect(callback(4)).to.equal(10)
		end)

		it("binds leading arguments", function()
			local add = function(left, right)
				return left + right
			end

			expect(CppLuau.Functional.Bind(add, 5)(7)).to.equal(12)
		end)

		it("runs a callback once and preserves multiple results", function()
			local count = 0
			local callback = CppLuau.Functional.Once(function()
				count += 1
				return "value", 10
			end)

			local first, second = callback()
			local third, fourth = callback()

			expect(count).to.equal(1)
			expect(first).to.equal("value")
			expect(second).to.equal(10)
			expect(third).to.equal("value")
			expect(fourth).to.equal(10)
		end)
	end)

	describe("StringBuilder", function()
		it("joins appended strings and tracks their length", function()
			local builder = CppLuau.StringBuilder.new()

			builder:Append("Hello"):Append(" "):AppendLine("Luau")

			expect(builder:ToString()).to.equal("Hello Luau\n")
			expect(builder:Length()).to.equal(11)
		end)

		it("clears appended parts", function()
			local builder = CppLuau.StringBuilder.new()
			builder:Append("temporary")
			builder:Clear()

			expect(builder:ToString()).to.equal("")
			expect(builder:Length()).to.equal(0)
		end)
	end)
end
