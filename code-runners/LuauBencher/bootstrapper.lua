local Utils = script.Parent.Utils

local readDir = require(Utils.readDir)
local stringifyResult = require(Utils.stringifyResult)

local bootstrapper = {}

type configuration = {
	directories: { Instance },
}

function bootstrapper.run(options: configuration)
	local finalString = "\n\nBenchmarks:"
	for _, directory: Instance in options.directories do
		finalString ..= "\n[>] " .. directory.Name
		finalString ..= stringifyResult(readDir(directory), "    ")
	end

	print(finalString)
end

return bootstrapper
