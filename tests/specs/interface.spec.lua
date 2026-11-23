--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)
local Interface = luapp.core.interface

return function()
	describe("Core.interface", function()
		it("validates required methods", function()
			local Drawable = Interface.new("Drawable", { "Draw", "Destroy" })
			local valid, missing = Drawable:Validate({
				Draw = function() end,
				Destroy = function() end,
			})

			expect(valid).to.equal(true)
			expect(#missing).to.equal(0)
			expect(Drawable:HasMethod("Draw")).to.equal(true)
		end)

		it("reports missing methods", function()
			local Drawable = Interface.new("Drawable", { "Draw", "Destroy" })
			local valid, missing = Drawable:Validate({ Draw = function() end })

			expect(valid).to.equal(false)
			expect(missing[1]).to.equal("Destroy")
		end)
	end)
end
