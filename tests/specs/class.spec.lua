--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)
local Class = luapp.core.class

return function()
	describe("Core.class", function()
		it("creates a class and an instance", function()
			local Entity = Class.new("Entity")
			local entity = Entity:Create()

			expect(Entity:GetName()).to.equal("Entity")
			expect(entity:GetClass()).to.equal(Entity)
			expect(entity:GetClassName()).to.equal("Entity")
		end)

		it("inherits and overrides methods", function()
			local Entity = Class.new("Entity")
			function Entity:GetType()
				return "Entity"
			end

			local Player = Entity:Extend("Player")
			function Player:GetType()
				return "Player"
			end

			expect(Player:Create():GetType()).to.equal("Player")
		end)

		it("runs constructors from base to derived", function()
			local Entity = Class.new("Entity"):Constructor(function(self)
				self.Order = { "Entity" }
			end)

			local Player = Entity:Extend("Player"):Constructor(function(self)
				table.insert(self.Order, "Player")
			end)

			local Admin = Player:Extend("Admin"):Constructor(function(self)
				table.insert(self.Order, "Admin")
			end)

			expect(table.concat(Admin:Create().Order, ",")).to.equal("Entity,Player,Admin")
		end)

		it("checks class identity across inheritance", function()
			local Entity = Class.new("Entity")
			local Player = Entity:Extend("Player")
			local player = Player:Create()

			expect(player:IsA("Entity")).to.equal(true)
			expect(player:IsA(Entity)).to.equal(true)
			expect(player:IsA(Class.new("Entity"))).to.equal(false)
		end)
	end)
end
