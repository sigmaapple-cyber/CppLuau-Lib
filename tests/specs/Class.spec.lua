--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)
local Class = CppLuau.Class

return function()
	describe("Class", function()
		it("creates a class and an instance", function()
			local Entity = Class.new("Entity")
			local entity = Entity:Create()

			expect(Entity:GetName()).to.equal("Entity")
			expect(entity:GetClass()).to.equal(Entity)
			expect(entity:GetClassName()).to.equal("Entity")
		end)

		it("inherits methods from base classes", function()
			local Entity = Class.new("Entity")

			function Entity:GetName()
				return self.Name
			end

			local Player = Entity:Extend("Player")
				:Constructor(function(self, name)
					self.Name = name
				end)

			local player = Player:Create("Alex")

			expect(player:GetName()).to.equal("Alex")
		end)

		it("allows child classes to override inherited methods", function()
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
			local Entity = Class.new("Entity")
				:Constructor(function(self)
					self.Order = { "Entity" }
				end)

			local Player = Entity:Extend("Player")
				:Constructor(function(self)
					table.insert(self.Order, "Player")
				end)

			local Admin = Player:Extend("Admin")
				:Constructor(function(self)
					table.insert(self.Order, "Admin")
				end)

			local admin = Admin:Create()

			expect(table.concat(admin.Order, ",")).to.equal("Entity,Player,Admin")
		end)

		it("passes the same arguments to every constructor", function()
			local Entity = Class.new("Entity")
				:Constructor(function(self, name)
					self.Name = name
				end)

			local Player = Entity:Extend("Player")
				:Constructor(function(self, name, level)
					self.Level = level
				end)

			local player = Player:Create("Alex", 10)

			expect(player.Name).to.equal("Alex")
			expect(player.Level).to.equal(10)
		end)

		it("recognizes class names and exact class objects", function()
			local Entity = Class.new("Entity")
			local Player = Entity:Extend("Player")
			local player = Player:Create()
			local OtherEntity = Class.new("Entity")

			expect(player:IsA("Player")).to.equal(true)
			expect(player:IsA("Entity")).to.equal(true)
			expect(player:IsA(Entity)).to.equal(true)
			expect(Player:IsA(Entity)).to.equal(true)
			expect(player:IsA(OtherEntity)).to.equal(false)
			expect(player:IsA("Missing")).to.equal(false)
		end)

		it("returns false for an invalid IsA target", function()
			local Entity = Class.new("Entity")
			local entity = Entity:Create()

			expect(entity:IsA({} :: any)).to.equal(false)
			expect(entity:IsA(true :: any)).to.equal(false)
		end)

		it("rejects empty class names", function()
			expect(function()
				Class.new("")
			end).to.throw()
		end)

		it("rejects invalid base classes", function()
			expect(function()
				Class.new("Invalid", {} :: any)
			end).to.throw()
		end)
	end)
end
