--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Enum = CppLuau.Core.Enum

return function()
	describe("Core.Enum", function()
		it("creates list and dictionary enums", function()
			local State = Enum.new("State", { "Idle", "Running" })
			local ErrorCode = Enum.new("ErrorCode", { None = 0, Missing = 404 })

			expect(State:Get("Idle")).to.equal(1)
			expect(State:Get("Running")).to.equal(2)
			expect(ErrorCode:Get("Missing")).to.equal(404)
			expect(State:Has("Missing")).to.equal(false)
		end)

		it("rejects duplicate entries and empty enums", function()
			expect(function()
				Enum.new("State", { "Idle", "Idle" })
			end).to.throw()

			expect(function()
				Enum.new("Empty", {})
			end).to.throw()
		end)
	end)
end
