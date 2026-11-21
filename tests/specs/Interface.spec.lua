--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Interface = CppLuau.Interface

return function()
	describe("Interface", function()
		it("validates required methods", function()
			local Drawable = Interface.new("Drawable", {
				"Draw",
				"Destroy",
			})

			local object = {
				Draw = function() end,
				Destroy = function() end,
			}

			local valid, missing = Drawable:Validate(object)

			expect(valid).to.equal(true)
			expect(#missing).to.equal(0)
			expect(Drawable:HasMethod("Draw")).to.equal(true)
		end)

		it("returns missing method names", function()
			local Drawable = Interface.new("Drawable", {
				"Draw",
				"Destroy",
			})

			local valid, missing = Drawable:Validate({
				Draw = function() end,
			})

			expect(valid).to.equal(false)
			expect(#missing).to.equal(1)
			expect(missing[1]).to.equal("Destroy")
		end)

		it("rejects invalid targets", function()
			local Drawable = Interface.new("Drawable", { "Draw" })
			local valid, missing = Drawable:Validate(12)

			expect(valid).to.equal(false)
			expect(#missing).to.equal(1)
		end)
	end)
end
