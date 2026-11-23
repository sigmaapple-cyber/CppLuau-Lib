--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

return function()
	describe("Algorithms.search", function()
		it("returns lower and upper bounds", function()
			local values = { 1, 2, 2, 2, 4, 8 }
			local Search = luapp.algorithms.search

			expect(Search.LowerBound(values, 2)).to.equal(2)
			expect(Search.UpperBound(values, 2)).to.equal(5)
			expect(Search.binarySearch(values, 4)).to.equal(5)
		end)
	end)

	describe("Algorithms.sort", function()
		it("stably sorts and merges values", function()
			local Sort = luapp.algorithms.sort

			expect(table.concat(Sort.StableSort({ 4, 1, 3, 2 }), ",")).to.equal("1,2,3,4")
			expect(table.concat(Sort.Merge({ 1, 3 }, { 2, 4 }), ",")).to.equal("1,2,3,4")
			expect(Sort.IsSorted({ 1, 2, 3 })).to.equal(true)
		end)
	end)
end
