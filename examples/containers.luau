--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

local Containers = CppLuau.Containers

local scores = Containers.Vector.new({ 10, 20, 30 })
scores:PushBack(40)

local pending = Containers.Queue.new()
pending:Enqueue("Load")
pending:Enqueue("Save")

local uniqueIds = Containers.Set.new({ 10, 20, 10, 30 })
local priorities = Containers.PriorityQueue.new({ 2, 5, 1 })

print(scores:Size())
print(pending:Dequeue())
print(uniqueIds:Size())
print(priorities:Pop())
