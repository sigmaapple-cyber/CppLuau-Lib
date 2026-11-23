--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

local text = luapp.text
local source = "Luau ✓"

print(text.utf8.Length(source))
print(text.utf8.Sub(source, 6))
print(table.concat(text.utf8.Codepoints(source), ", "))
