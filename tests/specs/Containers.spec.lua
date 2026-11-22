--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Containers = CppLuau.Containers

return function()
	describe("Array and Vector", function()
		it("provides fixed and dynamic indexed storage", function()
			local array = Containers.Array.new(3, 0)
			array:Set(2, 5)

			expect(array:Get(2)).to.equal(5)
			expect(array:Size()).to.equal(3)

			local vector = Containers.Vector.new({ 1, 3 })
			vector:Insert(2, 2):PushBack(4)

			expect(vector:At(2)).to.equal(2)
			expect(vector:Erase(3)).to.equal(3)
			expect(vector:Back()).to.equal(4)
		end)
	end)

	describe("Deque", function()
		it("pushes and pops from both ends", function()
			local deque = Containers.Deque.new({ 1, 2, 3 })

			expect(deque:PopFront()).to.equal(1)
			deque:PushFront(0):PushBack(4)

			expect(deque:Front()).to.equal(0)
			expect(deque:Back()).to.equal(4)
			expect(deque:PopBack()).to.equal(4)
		end)
	end)

	describe("List", function()
		it("inserts and erases linked nodes", function()
			local list = Containers.List.new({ 1, 3 })
			list:Insert(2, 2)
			list:PushFront(0)

			expect(list:At(3)).to.equal(2)
			expect(list:Erase(2)).to.equal(1)
			expect(table.concat(list:ToArray(), ",")).to.equal("0,2,3")
			expect(list:PopBack()).to.equal(3)
		end)
	end)

	describe("ForwardList", function()
		it("inserts after nodes and erases successors", function()
			local list = Containers.ForwardList.new({ 1, 3 })
			list:InsertAfter(1, 2)

			expect(table.concat(list:ToArray(), ",")).to.equal("1,2,3")
			expect(list:EraseAfter(1)).to.equal(2)
			expect(table.concat(list:ToArray(), ",")).to.equal("1,3")
		end)
	end)

	describe("Stack and Queue", function()
		it("preserves their ordering rules", function()
			local stack = Containers.Stack.new()
			stack:Push("first"):Push("second")

			expect(stack:Pop()).to.equal("second")
			expect(stack:Pop()).to.equal("first")

			local queue = Containers.Queue.new({ "first" })
			queue:Enqueue("second")

			expect(queue:Dequeue()).to.equal("first")
			expect(queue:Dequeue()).to.equal("second")
		end)
	end)

	describe("PriorityQueue", function()
		it("returns values in priority order", function()
			local queue = Containers.PriorityQueue.new({ 3, 1, 5, 2 })

			expect(queue:Pop()).to.equal(5)
			expect(queue:Pop()).to.equal(3)
			expect(queue:Pop()).to.equal(2)
			expect(queue:Pop()).to.equal(1)
		end)
	end)

	describe("HashMap and HashSet", function()
		it("stores values and tracks membership", function()
			local map = Containers.HashMap.new()
			map:Set("Enabled", false):Set("Count", 2)

			expect(map:Has("Enabled")).to.equal(true)
			expect(map:Get("Enabled")).to.equal(false)
			expect(map:Remove("Count")).to.equal(true)
			expect(map:Size()).to.equal(1)

			local set = Containers.HashSet.new({ 1, 2, 2, 3 })
			expect(set:Size()).to.equal(3)
			expect(set:Contains(2)).to.equal(true)
			expect(set:Intersection(Containers.HashSet.new({ 2, 4 })):Contains(2)).to.equal(true)
		end)
	end)

	describe("Span", function()
		it("views and writes through an array range", function()
			local source = { 10, 20, 30, 40 }
			local span = Containers.Span.new(source, 2, 2)

			span:Set(1, 99)

			expect(span:Get(1)).to.equal(99)
			expect(source[2]).to.equal(99)
			expect(table.concat(span:ToArray(), ",")).to.equal("99,30")
		end)
	end)

	describe("BitSet", function()
		it("sets, flips, and counts bits", function()
			local bits = Containers.BitSet.new(35)
			bits:Set(1):Set(32):Set(35)

			expect(bits:Count()).to.equal(3)
			expect(bits:Test(35)).to.equal(true)

			bits:Flip(32)
			expect(bits:Test(32)).to.equal(false)
			expect(bits:ToArray()[2]).to.equal(35)
		end)
	end)
end
