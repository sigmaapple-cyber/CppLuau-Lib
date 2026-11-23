--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

local heap = luapp.algorithms.heap
local values = { 8, 3, 12, 1, 5 }

heap.MakeHeap(values)
print(values[1])

table.insert(values, 20)
heap.PushHeap(values)
heap.PopHeap(values)
print(table.remove(values))

heap.SortHeap(values)
print(table.concat(values, ", "))
