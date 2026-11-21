--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("String", function()
		it("trims and checks substrings", function()
			expect(CppLuau.String.Trim("  hello  ")).to.equal("hello")
			expect(CppLuau.String.StartsWith("CppLuau", "Cpp")).to.equal(true)
			expect(CppLuau.String.EndsWith("CppLuau", "Luau")).to.equal(true)
			expect(CppLuau.String.Contains("standard library", "library")).to.equal(true)
		end)

		it("splits, joins, and replaces plain substrings", function()
			local values = CppLuau.String.Split("a,,b,", ",")

			expect(#values).to.equal(4)
			expect(values[2]).to.equal("")
			expect(values[4]).to.equal("")
			expect(CppLuau.String.Join(values, "|")).to.equal("a||b|")
			expect(CppLuau.String.Replace("a-b-a", "a", "x")).to.equal("x-b-x")
		end)

		it("counts non-overlapping occurrences", function()
			expect(CppLuau.String.Count("aaaa", "aa")).to.equal(2)
		end)
	end)

	describe("Math", function()
		it("clamps and interpolates", function()
			expect(CppLuau.Math.Clamp(12, 0, 10)).to.equal(10)
			expect(CppLuau.Math.Lerp(0, 10, 0.5)).to.equal(5)
			expect(CppLuau.Math.InverseLerp(0, 10, 5)).to.equal(0.5)
			expect(CppLuau.Math.Remap(5, 0, 10, 0, 100)).to.equal(50)
		end)

		it("provides common numeric helpers", function()
			expect(CppLuau.Math.Round(3.14159, 2)).to.equal(3.14)
			expect(CppLuau.Math.Sign(-5)).to.equal(-1)
			expect(CppLuau.Math.Wrap(12, 0, 10)).to.equal(2)
			expect(CppLuau.Math.Factorial(5)).to.equal(120)
			expect(CppLuau.Math.IsFinite(math.huge)).to.equal(false)
		end)
	end)

	describe("Reference", function()
		it("shares updates through one reference object", function()
			local reference = CppLuau.Reference.new(2)

			reference:Update(function(value)
				return value * 5
			end)

			expect(reference:Get()).to.equal(10)
			expect(reference:CompareExchange(10, 12)).to.equal(true)
			expect(reference:Get()).to.equal(12)
			expect(reference:CompareExchange(10, 20)).to.equal(false)
		end)
	end)

	describe("Tuple", function()
		it("preserves its fixed length and nil positions", function()
			local tuple = CppLuau.Tuple.new("left", nil, "right")
			local first, second, third = tuple:Unpack()

			expect(tuple:Size()).to.equal(3)
			expect(first).to.equal("left")
			expect(second).to.equal(nil)
			expect(third).to.equal("right")
			expect(tuple:ToArray().n).to.equal(3)
		end)

		it("maps tuple positions", function()
			local tuple = CppLuau.Tuple.new(1, 2, 3):Map(function(value)
				return value * 2
			end)

			expect(table.concat(tuple:ToArray(), ",")).to.equal("2,4,6")
		end)
	end)

	describe("Type", function()
		it("inspects values", function()
			expect(CppLuau.Type.Of(Vector3.zero)).to.equal("Vector3")
			expect(CppLuau.Type.IsInteger(5)).to.equal(true)
			expect(CppLuau.Type.IsInteger(5.5)).to.equal(false)
			expect(CppLuau.Type.IsNumber(math.huge)).to.equal(false)
			expect(CppLuau.Type.IsCallable(function() end)).to.equal(true)
			expect(CppLuau.Type.IsArray({ 1, 2, 3 })).to.equal(true)
			expect(CppLuau.Type.IsArray({ key = 1 })).to.equal(false)
		end)
	end)

	describe("Iterator", function()
		it("iterates half-open numeric ranges", function()
			local values = {}

			for value in CppLuau.Iterator.Range(1, 5) do
				table.insert(values, value)
			end

			expect(table.concat(values, ",")).to.equal("1,2,3,4")
		end)

		it("supports reverse and zip iterators", function()
			local reversed = {}

			for _, value in CppLuau.Iterator.Reverse({ "a", "b", "c" }) do
				table.insert(reversed, value)
			end

			expect(table.concat(reversed, ",")).to.equal("c,b,a")

			local combined = {}
			for left, right in CppLuau.Iterator.Zip({ 1, 2 }, { "a", "b", "c" }) do
				table.insert(combined, tostring(left) .. right)
			end

			expect(table.concat(combined, ",")).to.equal("1a,2b")
		end)
	end)

	describe("Scope", function()
		it("runs deferred callbacks in reverse order once", function()
			local scope = CppLuau.Scope.new()
			local order = {}

			scope:Defer(function()
				table.insert(order, "first")
			end)

			scope:Defer(function()
				table.insert(order, "second")
			end)

			scope:Destroy()
			scope:Destroy()

			expect(table.concat(order, ",")).to.equal("second,first")
			expect(scope:IsDestroyed()).to.equal(true)
			expect(scope:Count()).to.equal(0)
		end)
	end)
end
