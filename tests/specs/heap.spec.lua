--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)
local heap = luapp.algorithms.heap

return function()
	describe("algorithms.heap", function()
		it("builds and validates a max heap", function()
			local values = { 3, 1, 8, 2, 7, 4 }

			heap.MakeHeap(values)

			expect(heap.IsHeap(values)).to.equal(true)
			expect(values[1]).to.equal(8)
		end)

		it("restores heap order after insertion and removal", function()
			local values = { 9, 5, 7, 1 }
			heap.MakeHeap(values)

			table.insert(values, 11)
			heap.PushHeap(values)
			expect(values[1]).to.equal(11)

			heap.PopHeap(values)
			expect(values[#values]).to.equal(11)
			table.remove(values)

			expect(heap.IsHeap(values)).to.equal(true)
			expect(values[1]).to.equal(9)
		end)

		it("sorts a heap in ascending order", function()
			local values = { 4, 1, 7, 3, 9, 2 }

			heap.SortHeap(values)

			expect(table.concat(values, ",")).to.equal("1,2,3,4,7,9")
		end)
	end)
end
