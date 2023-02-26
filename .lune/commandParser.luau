local function parseFlags(arguments: { string })
	local result = {}
	for index, keyOrValue in arguments do
		if keyOrValue:find("==") then
			local shouldBeValue = arguments[index + 1]

			if shouldBeValue:find("==") then
				error(`Value wasn't provided for {keyOrValue}`)
			end
			result[string.sub(keyOrValue, 3)] = shouldBeValue
		end
	end

	return result
end

local function parse(args: { string })
	local result
	local onlyFlagTable = {}
	for index, value in args do
		if not (args[index - 1] or ""):find("==") and not value:find("==") then
			result = value
		else
			table.insert(onlyFlagTable, value)
		end
	end

	return result, parseFlags(onlyFlagTable)
end

return parse