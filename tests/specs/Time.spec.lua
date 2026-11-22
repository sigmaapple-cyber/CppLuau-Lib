--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CppLuau = require(ReplicatedStorage:WaitForChild("CppLuauLib") :: ModuleScript)

return function()
	describe("Time.Duration", function()
		it("converts and combines durations", function()
			local Duration = CppLuau.Time.Duration
			local elapsed = Duration.new(30):Add(Duration.new(15))

			expect(elapsed:Seconds()).to.equal(45)
			expect(elapsed:Milliseconds()).to.equal(45000)
			expect(elapsed:Minutes()).to.equal(0.75)
		end)
	end)

	describe("Time.Timer", function()
		it("starts, stops, and resets", function()
			local timer = CppLuau.Time.Timer.new()

			expect(timer:IsRunning()).to.equal(false)
			timer:Start()
			expect(timer:IsRunning()).to.equal(true)
			expect(timer:Stop() >= 0).to.equal(true)
			timer:Reset()

			expect(timer:Elapsed()).to.equal(0)
		end)
	end)

	describe("Time.Clock", function()
		it("measures a callback", function()
			local elapsed, result = CppLuau.Time.Clock.Measure(function()
				return "complete"
			end)

			expect(elapsed >= 0).to.equal(true)
			expect(result).to.equal("complete")
			expect(CppLuau.Time.Clock.Unix() > 0).to.equal(true)
		end)
	end)
end
