--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Sequence = CppLuau.Algorithms.Sequence

return function()
	describe("Algorithms.Sequence", function()
		it("finds, filters, and maps values", function()
			local values = { 2, 4, 6, 8 }

			expect(Sequence.Find(values, function(value)
				return value > 4
			end)).to.equal(6)

			expect(Sequence.FindIndex(values, function(value)
				return value == 8
			end)).to.equal(4)

			local doubled = Sequence.Map(Sequence.Filter(values, function(value)
				return value % 2 == 0
			end), function(value)
				return value * 2
			end)

			expect(table.concat(doubled, ",")).to.equal("4,8,12,16")
		end)

		it("reduces, checks predicates, and removes duplicates", function()
			expect(Sequence.Reduce({ 1, 2, 3, 4 }, function(sum, value)
				return sum + value
			end, 0)).to.equal(10)

			expect(Sequence.Any({ 1, 2, 3 }, function(value)
				return value == 2
			end)).to.equal(true)

			expect(Sequence.All({ 2, 4, 6 }, function(value)
				return value % 2 == 0
			end)).to.equal(true)

			expect(table.concat(Sequence.Unique({ "a", "b", "a" }), ",")).to.equal("a,b")
		end)
	end)

	describe("Algorithms.Search", function()
		it("finds bounds in sorted data", function()
			local values = { 1, 2, 2, 2, 4, 8 }

			expect(CppLuau.Algorithms.Search.LowerBound(values, 2)).to.equal(2)
			expect(CppLuau.Algorithms.Search.UpperBound(values, 2)).to.equal(5)
			expect(CppLuau.Algorithms.Search.BinarySearch(values, 4)).to.equal(5)
			expect(CppLuau.Algorithms.Search.Contains(values, 9)).to.equal(false)
		end)
	end)

	describe("Algorithms.Sort", function()
		it("sorts, stably sorts, and merges arrays", function()
			local values = { 4, 1, 3, 2 }

			expect(table.concat(CppLuau.Algorithms.Sort.StableSort(values), ",")).to.equal("1,2,3,4")
			expect(table.concat(CppLuau.Algorithms.Sort.Merge({ 1, 3 }, { 2, 4 }), ",")).to.equal("1,2,3,4")
			expect(CppLuau.Algorithms.Sort.IsSorted(values)).to.equal(false)
		end)
	end)
end
