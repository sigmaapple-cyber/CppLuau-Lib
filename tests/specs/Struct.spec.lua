--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Struct = CppLuau.Struct

return function()
	describe("Struct", function()
		it("creates values using schema defaults", function()
			local PlayerData = Struct.new("PlayerData", {
				Coins = 0,
				Level = 1,
			})

			local data = PlayerData:Create()

			expect(data.Coins).to.equal(0)
			expect(data.Level).to.equal(1)
		end)

		it("overrides defaults with supplied values", function()
			local PlayerData = Struct.new("PlayerData", {
				Coins = 0,
				Level = 1,
			})

			local data = PlayerData:Create({
				Coins = 50,
			})

			expect(data.Coins).to.equal(50)
			expect(data.Level).to.equal(1)
		end)

		it("creates independent nested defaults", function()
			local PlayerData = Struct.new("PlayerData", {
				Stats = {
					XP = 0,
				},
			})

			local first = PlayerData:Create()
			local second = PlayerData:Create()

			first.Stats.XP = 100

			expect(second.Stats.XP).to.equal(0)
		end)

		it("reports schema fields", function()
			local PlayerData = Struct.new("PlayerData", {
				Coins = 0,
			})

			expect(PlayerData:HasField("Coins")).to.equal(true)
			expect(PlayerData:HasField("Level")).to.equal(false)
		end)
	end)
end
