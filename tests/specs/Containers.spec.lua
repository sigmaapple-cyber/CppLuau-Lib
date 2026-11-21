--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Containers = CppLuau.Containers

return function()
	describe("Array", function()
		it("keeps a fixed size and supports indexed writes", function()
			local array = Containers.Array.new(3, 0)

			array:Set(2, 5)

			expect(array:Size()).to.equal(3)
			expect(array:Get(1)).to.equal(0)
			expect(array:Get(2)).to.equal(5)
			expect(array:Get(3)).to.equal(0)
		end)
	end)

	describe("Vector", function()
		it("supports indexed sequence operations", function()
			local vector = Containers.Vector.new({ 1, 3 })

			vector:Insert(2, 2)
			vector:PushBack(4)

			expect(vector:Size()).to.equal(4)
			expect(vector:At(2)).to.equal(2)
			expect(vector:Erase(3)).to.equal(3)
			expect(vector:Back()).to.equal(4)
		end)

		it("resizes with an explicit fill value", function()
			local vector = Containers.Vector.new({ 1 })
			vector:Resize(3, 0)

			expect(vector:Size()).to.equal(3)
			expect(vector:At(3)).to.equal(0)
			expect(function()
				vector:Resize(5)
			end).to.throw()
		end)
	end)

	describe("Deque", function()
		it("pushes and pops from both ends", function()
			local deque = Containers.Deque.new({ 1, 2, 3 })

			expect(deque:PopFront()).to.equal(1)
			deque:PushFront(0):PushBack(4)

			expect(deque:Front()).to.equal(0)
			expect(deque:Back()).to.equal(4)
			expect(deque:At(3)).to.equal(3)
			expect(deque:PopBack()).to.equal(4)
		end)

		it("grows its circular buffer", function()
			local deque = Containers.Deque.new()

			for idx = 1, 20 do
				deque:PushBack(idx)
			end

			for idx = 1, 10 do
				expect(deque:PopFront()).to.equal(idx)
			end

			for idx = 21, 35 do
				deque:PushBack(idx)
			end

			expect(deque:Size()).to.equal(25)
			expect(deque:Front()).to.equal(11)
			expect(deque:Back()).to.equal(35)
		end)
	end)

	describe("Stack", function()
		it("uses last-in, first-out order", function()
			local stack = Containers.Stack.new()

			stack:Push("first"):Push("second")

			expect(stack:Top()).to.equal("second")
			expect(stack:Pop()).to.equal("second")
			expect(stack:Pop()).to.equal("first")
			expect(stack:Empty()).to.equal(true)
		end)
	end)

	describe("Queue", function()
		it("uses first-in, first-out order", function()
			local queue = Containers.Queue.new({ "first", "second" })

			queue:Enqueue("third")

			expect(queue:Dequeue()).to.equal("first")
			expect(queue:Front()).to.equal("second")
			expect(queue:Back()).to.equal("third")
			expect(queue:Dequeue()).to.equal("second")
			expect(queue:Dequeue()).to.equal("third")
			expect(queue:Empty()).to.equal(true)
			expect(queue:Dequeue()).to.equal(nil)
		end)

		it("can be reused after becoming empty", function()
			local queue = Containers.Queue.new({ 1 })

			expect(queue:Dequeue()).to.equal(1)

			queue:Enqueue(2)

			expect(queue:Size()).to.equal(1)
			expect(queue:Dequeue()).to.equal(2)
		end)
	end)

	describe("PriorityQueue", function()
		it("returns the highest priority value", function()
			local queue = Containers.PriorityQueue.new({ 3, 1, 5, 2 })

			expect(queue:Top()).to.equal(5)
			expect(queue:Pop()).to.equal(5)
			expect(queue:Pop()).to.equal(3)
			expect(queue:Pop()).to.equal(2)
			expect(queue:Pop()).to.equal(1)
			expect(queue:Empty()).to.equal(true)
		end)

		it("supports a custom comparator", function()
			local queue = Containers.PriorityQueue.new({ 3, 1, 5 }, function(a, b)
				return a < b
			end)

			expect(queue:Top()).to.equal(1)
			expect(queue:Pop()).to.equal(1)
		end)
	end)

	describe("Map", function()
		it("stores, updates, and removes keys", function()
			local map = Containers.Map.new()

			map:Set("Enabled", false)
			map:Set("Count", 2)

			expect(map:Has("Enabled")).to.equal(true)
			expect(map:Get("Enabled")).to.equal(false)
			expect(map:Size()).to.equal(2)
			expect(map:Remove("Count")).to.equal(true)
			expect(map:Size()).to.equal(1)
		end)
	end)

	describe("Set", function()
		it("stores only unique values", function()
			local set = Containers.Set.new({ 1, 2, 2, 3 })

			expect(set:Size()).to.equal(3)
			expect(set:Contains(2)).to.equal(true)
		end)

		it("supports set operations", function()
			local left = Containers.Set.new({ 1, 2, 3 })
			local right = Containers.Set.new({ 3, 4 })

			expect(left:Union(right):Size()).to.equal(4)
			expect(left:Intersection(right):Contains(3)).to.equal(true)
			expect(left:Difference(right):Contains(3)).to.equal(false)
			expect(Containers.Set.new({ 1, 2 }):IsSubsetOf(left)).to.equal(true)
		end)
	end)
end
