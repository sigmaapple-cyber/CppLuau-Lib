--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Enum = CppLuau.Enum

return function()
	describe("Enum", function()
		it("creates named values from a list", function()
			local State = Enum.new("State", {
				"Idle",
				"Running",
			})

			expect(State:Get("Idle")).to.equal(1)
			expect(State:Get("Running")).to.equal(2)
		end)

		it("keeps explicit dictionary values", function()
			local State = Enum.new("State", {
				Idle = 0,
				Running = 1,
			})

			expect(State:Get("Idle")).to.equal(0)
			expect(State:Get("Running")).to.equal(1)
		end)

		it("checks whether a named value exists", function()
			local State = Enum.new("State", {
				"Idle",
				"Running",
			})

			expect(State:Has("Idle")).to.equal(true)
			expect(State:Has("Missing")).to.equal(false)
		end)

		it("rejects duplicate list entries", function()
			expect(function()
				Enum.new("State", {
					"Idle",
					"Idle",
				})
			end).to.throw()
		end)

		it("rejects empty enums", function()
			expect(function()
				Enum.new("State", {})
			end).to.throw()
		end)
	end)
end
