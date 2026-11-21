--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Containers = CppLuau.Containers

return function()
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
