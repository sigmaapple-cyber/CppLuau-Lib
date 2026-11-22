--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

local data = CppLuau.Binary.Buffer.new()

data:WriteU8(1)
	:WriteU16(250)
	:WriteF32(3.5)
	:WriteString("Luau")

data:Seek(0)

local version = data:ReadU8()
local count = data:ReadU16()
local scale = data:ReadF32()
local label = data:ReadString(4)

print(version, count, scale, label)
