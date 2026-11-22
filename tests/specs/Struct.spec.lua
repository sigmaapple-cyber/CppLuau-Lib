--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Struct = CppLuau.Core.Struct

return function()
	describe("Core.Struct", function()
		it("creates values from schema defaults and overrides", function()
			local PlayerData = Struct.new("PlayerData", {
				Coins = 0,
				Level = 1,
			})

			local data = PlayerData:Create({ Coins = 50 })

			expect(data.Coins).to.equal(50)
			expect(data.Level).to.equal(1)
			expect(PlayerData:HasField("Coins")).to.equal(true)
			expect(PlayerData:HasField("Missing")).to.equal(false)
		end)

		it("clones nested defaults between values", function()
			local PlayerData = Struct.new("PlayerData", {
				Stats = { XP = 0 },
			})

			local first = PlayerData:Create()
			local second = PlayerData:Create()
			first.Stats.XP = 100

			expect(second.Stats.XP).to.equal(0)
		end)
	end)
end
