--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DevPackages = ReplicatedStorage:WaitForChild("DevPackages")
local Tests = ReplicatedStorage:WaitForChild("Tests")
local TestEZ = require(DevPackages:WaitForChild("TestEZ") :: ModuleScript)

local results = TestEZ.TestBootstrap:run({
	Tests,
})

if results.failureCount > 0 then
	error(string.format("%d TestEZ test(s) failed", results.failureCount))
end
