local Vinum = require(game.ReplicatedStorage.Vinum)

local Wrap = Vinum.Wrap

return {
	{
		name = "creating wraps over luau-signal",
		calls = 50000,

		preRun = function()
			local throwawaySignal = {
				_connections = {},
			}

			function throwawaySignal:Connect(fn)
				self._connections[fn] = true
			end

			function throwawaySignal:fire(...)
				for fn in self._connections do
					fn(...)
				end
			end

			return throwawaySignal
		end,
		run = function(t)
			Wrap(t, { 1 }, function(...)
				return ...
			end)
		end,
	},
	{
		name = "updating luau-signal wraps",
		calls = 50000,
		preRun = function()
			local throwawaySignal = {
				_connections = {},
			}

			function throwawaySignal:Connect(fn)
				self._connections[fn] = true
			end

			function throwawaySignal:fire(...)
				for fn in self._connections do
					fn(...)
				end
			end

			Wrap(throwawaySignal, { 1 }, function(...)
				return ...
			end)

			return throwawaySignal
		end,
		run = function(t)
			t:fire(0)
		end,
	},
}
