--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

local Class = CppLuau.Core.Class

local Entity = Class.new("Entity"):Constructor(function(self, name: string)
	self.Name = name
end)

function Entity:GetName(): string
	return self.Name
end

local Player = Entity:Extend("Player"):Constructor(function(self, name: string, level: number)
	self.Level = level
end)

function Player:GetLevel(): number
	return self.Level
end

local player = Player:Create("Alex", 10)

print(player:GetName())
print(player:GetLevel())
print(player:IsA("Entity"))
