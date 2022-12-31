local function Processor(units)
	return function(firstArg, secondArg, thirdArg)
		for _, unit in units do
			local ok = unit(firstArg, secondArg, thirdArg)

			if not ok then
				return false
			end
		end

		return true
	end
end

return Processor
