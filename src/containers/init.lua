--!strict

local module = {
	array = require(script:WaitForChild("array") :: ModuleScript),
	vector = require(script:WaitForChild("vector") :: ModuleScript),
	deque = require(script:WaitForChild("deque") :: ModuleScript),
	list = require(script:WaitForChild("list") :: ModuleScript),
	forwardList = require(script:WaitForChild("forwardList") :: ModuleScript),
	stack = require(script:WaitForChild("stack") :: ModuleScript),
	queue = require(script:WaitForChild("queue") :: ModuleScript),
	priorityQueue = require(script:WaitForChild("priorityQueue") :: ModuleScript),
	hashMap = require(script:WaitForChild("hashMap") :: ModuleScript),
	hashSet = require(script:WaitForChild("hashSet") :: ModuleScript),
	orderedMap = require(script:WaitForChild("orderedMap") :: ModuleScript),
	span = require(script:WaitForChild("span") :: ModuleScript),
	bitSet = require(script:WaitForChild("bitSet") :: ModuleScript),
}

return table.freeze(module)
