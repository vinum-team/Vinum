local processArgs = process.args
local pathForSourceDir = processArgs[1] or ""
local version = processArgs[2] or ""

local function assert(condition, err)
	if not condition then
		error(err, 2)
	end
end
-- ensure that the required arguments are given
assert(fs.isDir(pathForSourceDir), `"${pathForSourceDir}" doesn't point at a directory.`)

-- find the source path for the given
local sourceCodePath = `{pathForSourceDir}/{stdio.prompt("text", "Please put the name for the source code directory")}`

-- ask for build mode
local buildMode =
	stdio.prompt("select", "Please choose the build mode for this process.", { "integrated", "standalone" })

-- call the needed builder 
print(buildMode)
