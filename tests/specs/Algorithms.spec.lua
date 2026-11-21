--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Algorithms = CppLuau.Algorithms

return function()
	describe("Algorithms", function()
		it("finds values and indexes", function()
			local values = { 2, 4, 6, 8 }

			expect(Algorithms.Find(values, function(value)
				return value > 4
			end)).to.equal(6)

			expect(Algorithms.FindIndex(values, function(value)
				return value == 8
			end)).to.equal(4)
		end)

		it("filters and maps arrays", function()
			local values = Algorithms.Filter({ 1, 2, 3, 4 }, function(value)
				return value % 2 == 0
			end)

			local doubled = Algorithms.Map(values, function(value)
				return value * 2
			end)

			expect(table.concat(doubled, ",")).to.equal("4,8")
		end)

		it("reduces values", function()
			local total = Algorithms.Reduce({ 1, 2, 3, 4 }, function(sum, value)
				return sum + value
			end, 0)

			expect(total).to.equal(10)
		end)

		it("checks predicates", function()
			expect(Algorithms.Any({ 1, 2, 3 }, function(value)
				return value == 2
			end)).to.equal(true)

			expect(Algorithms.All({ 2, 4, 6 }, function(value)
				return value % 2 == 0
			end)).to.equal(true)

			expect(Algorithms.Count({ 1, 2, 2, 3 }, function(value)
				return value == 2
			end)).to.equal(2)
		end)

		it("returns sorted and reversed copies", function()
			local values = { 3, 1, 2 }
			local sorted = Algorithms.Sorted(values)
			local reversed = Algorithms.Reversed(values)

			expect(table.concat(sorted, ",")).to.equal("1,2,3")
			expect(table.concat(reversed, ",")).to.equal("2,1,3")
			expect(values[1]).to.equal(3)
		end)

		it("removes duplicates while preserving order", function()
			local values = Algorithms.Unique({ "a", "b", "a", "c", "b" })

			expect(table.concat(values, ",")).to.equal("a,b,c")
			expect(Algorithms.CountValue(values, "b")).to.equal(1)
		end)
	end)
end
