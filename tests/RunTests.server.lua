--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Tests = ReplicatedStorage:WaitForChild("Tests")
local TestEZ = require(Packages:WaitForChild("TestEZ") :: ModuleScript)

local results = TestEZ.TestBootstrap:run({
	Tests,
})

if results.failureCount > 0 then
	error(string.format("%d TestEZ test(s) failed", results.failureCount))
end
