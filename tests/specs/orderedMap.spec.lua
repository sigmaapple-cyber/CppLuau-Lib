--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)
local orderedMap = luapp.containers.orderedMap

return function()
	describe("containers.orderedMap", function()
		it("preserves insertion order when values are updated", function()
			local map = orderedMap.new()
			map:Set("first", 1):Set("second", 2):Set("third", 3)
			map:Set("second", 20)

			expect(table.concat(map:Keys(), ",")).to.equal("first,second,third")
			expect(table.concat(map:Values(), ",")).to.equal("1,20,3")
			expect(map:Get("second")).to.equal(20)
		end)

		it("moves a removed key to the end when inserted again", function()
			local map = orderedMap.new()
			map:Set("a", 1):Set("b", 2):Set("c", 3)
			map:Remove("b")
			map:Set("b", 4)

			expect(table.concat(map:Keys(), ",")).to.equal("a,c,b")
			expect(map:Size()).to.equal(3)
		end)

		it("iterates over a stable key snapshot", function()
			local map = orderedMap.new()
			map:Set("a", 1):Set("b", 2)

			local visited = {}
			map:ForEach(function(key)
				table.insert(visited, key)
				if key == "a" then
					map:Remove("b")
					map:Set("c", 3)
				end
			end)

			expect(table.concat(visited, ",")).to.equal("a")
		end)
	end)
end
