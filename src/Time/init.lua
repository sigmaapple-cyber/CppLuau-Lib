--!strict
--[[
	Time points, durations, and timers.
]]

local module = {
	Clock = require(script:WaitForChild("Clock") :: ModuleScript),
	Duration = require(script:WaitForChild("Duration") :: ModuleScript),
	Timer = require(script:WaitForChild("Timer") :: ModuleScript),
}

return table.freeze(module)
