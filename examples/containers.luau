--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

local Containers = luapp.containers
local Math = luapp.math

local scores = Containers.Vector.new({ 10, 20, 30 })
scores:PushBack(40)

local byName = Containers.HashMap.new()
byName:Set("Alex", 100):Set("Sam", 85)

local order = Containers.PriorityQueue.new({ 20, 5, 12 })
local random = Math.Random.new(2026)

print(scores:Size())
print(byName:Get("Alex"))
print(order:Pop())
print(random:NextInteger(1, 100))
