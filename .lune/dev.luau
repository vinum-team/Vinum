local serde = require("@lune/serde")
-- util
local function reporter(condition, err)
	if not condition then
		error(`dev.luau encountered an error while executing: \n {err}`)
	end
end

-- ensure that a project.json file is provided
reporter(fs.isFile(process.args[1] or "dev.project.json"), "The given path doesn't point at a file.")

local dependency = serde.decode("toml", fs.readFile(`wally.toml`)).dependencies
local shouldInstall = false

for _ in dependency do
	shouldInstall = true
	break
end

if shouldInstall then
	-- install all dependencies spceifcied in wally.toml
	print("Wally dependencies are installed")
	local wallyResult = process.spawn("wally", { "install" })
	reporter(wallyResult.ok, wallyResult.stderr)
end
-- run rojo serve
print("Rojo started!")
local result = process.spawn("rojo", { "serve", process.args[1] or "dev.project.json" })
reporter(result.ok, result.stderr)
