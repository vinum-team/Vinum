--!strict
local Processors = script.Parent
local LibraryRoot = Processors.Parent
local Types = require(LibraryRoot.types)

return function(processors: { Types.TProcessor<any> })
	return function(key, oldValue, newValue, destroying)
		local shouldBreak = false

		for _, processor in processors do
			shouldBreak = processor(key, oldValue, newValue, destroying)
			if shouldBreak then
				return false
			end
		end

		return true
	end
end
