--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local luapp = require(ReplicatedStorage:WaitForChild("luapp") :: ModuleScript)

return function()
	describe("Time.duration", function()
		it("converts and combines durations", function()
			local Duration = luapp.time.duration
			local elapsed = Duration.new(30):Add(Duration.new(15))

			expect(elapsed:Seconds()).to.equal(45)
			expect(elapsed:Milliseconds()).to.equal(45000)
			expect(elapsed:Minutes()).to.equal(0.75)
		end)
	end)

	describe("Time.timer", function()
		it("starts, stops, and resets", function()
			local timer = luapp.time.timer.new()

			expect(timer:IsRunning()).to.equal(false)
			timer:Start()
			expect(timer:IsRunning()).to.equal(true)
			expect(timer:Stop() >= 0).to.equal(true)
			timer:Reset()

			expect(timer:Elapsed()).to.equal(0)
		end)
	end)

	describe("Time.clock", function()
		it("measures a callback", function()
			local elapsed, result = luapp.time.clock.Measure(function()
				return "complete"
			end)

			expect(elapsed >= 0).to.equal(true)
			expect(result).to.equal("complete")
			expect(luapp.time.clock.Unix() > 0).to.equal(true)
		end)
	end)
end
