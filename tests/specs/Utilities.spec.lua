--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Text.String", function()
		it("trims, searches, splits, joins, and replaces", function()
			local String = CppLuau.Text.String

			expect(String.Trim("  hello  ")).to.equal("hello")
			expect(String.StartsWith("CppLuau", "Cpp")).to.equal(true)
			expect(String.EndsWith("CppLuau", "Luau")).to.equal(true)
			expect(String.Contains("standard library", "library")).to.equal(true)

			local values = String.Split("a,,b,", ",")
			expect(#values).to.equal(4)
			expect(String.Join(values, "|")).to.equal("a||b|")
			expect(String.Replace("a-b-a", "a", "x")).to.equal("x-b-x")
			expect(String.Count("aaaa", "aa")).to.equal(2)
		end)
	end)

	describe("Math.Scalar", function()
		it("provides common scalar operations", function()
			local Scalar = CppLuau.Math.Scalar

			expect(Scalar.Clamp(12, 0, 10)).to.equal(10)
			expect(Scalar.Lerp(0, 10, 0.5)).to.equal(5)
			expect(Scalar.InverseLerp(0, 10, 5)).to.equal(0.5)
			expect(Scalar.Remap(5, 0, 10, 0, 100)).to.equal(50)
			expect(Scalar.Round(3.14159, 2)).to.equal(3.14)
			expect(Scalar.Wrap(12, 0, 10)).to.equal(2)
			expect(Scalar.Factorial(5)).to.equal(120)
		end)
	end)

	describe("Values", function()
		it("updates references", function()
			local reference = CppLuau.Values.Reference.new(2)
			reference:Update(function(value)
				return value * 5
			end)

			expect(reference:Get()).to.equal(10)
			expect(reference:CompareExchange(10, 12)).to.equal(true)
		end)

		it("preserves tuple nil positions", function()
			local tuple = CppLuau.Values.Tuple.new("left", nil, "right")
			local first, second, third = tuple:Unpack()

			expect(tuple:Size()).to.equal(3)
			expect(first).to.equal("left")
			expect(second).to.equal(nil)
			expect(third).to.equal("right")
			expect(tuple:ToArray().n).to.equal(3)
		end)
	end)

	describe("Utility.TypeInfo", function()
		it("inspects values", function()
			local TypeInfo = CppLuau.Utility.TypeInfo

			expect(TypeInfo.Of(Vector3.zero)).to.equal("Vector3")
			expect(TypeInfo.IsInteger(5)).to.equal(true)
			expect(TypeInfo.IsInteger(5.5)).to.equal(false)
			expect(TypeInfo.IsNumber(math.huge)).to.equal(false)
			expect(TypeInfo.IsCallable(function() end)).to.equal(true)
			expect(TypeInfo.IsArray({ 1, 2, 3 })).to.equal(true)
			expect(TypeInfo.IsArray({ key = 1 })).to.equal(false)
		end)
	end)

	describe("Utility.Iterator", function()
		it("iterates ranges and zipped values", function()
			local values = {}
			for value in CppLuau.Utility.Iterator.Range(1, 5) do
				table.insert(values, value)
			end

			expect(table.concat(values, ",")).to.equal("1,2,3,4")

			local combined = {}
			for left, right in CppLuau.Utility.Iterator.Zip({ 1, 2 }, { "a", "b" }) do
				table.insert(combined, tostring(left) .. right)
			end

			expect(table.concat(combined, ",")).to.equal("1a,2b")
		end)
	end)

	describe("Utility.ScopeGuard", function()
		it("runs deferred cleanup in reverse order", function()
			local scope = CppLuau.Utility.ScopeGuard.new()
			local order = {}

			scope:Defer(function()
				table.insert(order, "first")
			end)

			scope:Defer(function()
				table.insert(order, "second")
			end)

			scope:Close()
			scope:Close()

			expect(table.concat(order, ",")).to.equal("second,first")
			expect(scope:IsClosed()).to.equal(true)
		end)
	end)
end
