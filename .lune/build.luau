local p = require("commandParser")

type ProcessedInfo = {
	mainPath: string,
	version: string?,
	pathForSourceDir: string?,
	buildMode: string?,
}
local subCommand, processedArgs: ProcessedInfo = p(process.args)
local mainPath = processedArgs.mainPath or process.cwd
local version = processedArgs.version or ""
local sourceCodePath = processedArgs.pathForSourceDir
local buildMode = processedArgs.buildMode

if subCommand == "help" then
	print(
		`{stdio.style("bold")} Syntax: lune build [SUBCOMMAND] [FLAGS] {stdio.style("reset")} \n\n[SUBCOMMANDS] \n	help -- prints this message \n[FLAGS]`,
		"\n	==mainPath string? -- defaults to cwd",
		"\n	==version string? -- i.e 0.2.0",
		"\n	==pathForSourceDir string? -- i.e src",
		"\n	==buildMove integrated | standalone? -- i.e standalone",
		"\n	[NOTE] every flag that is not ==mainPath will eventually be asked for in a prompt in the CLI- aka, not ideal for CI machines."
	)
	return
end

local function assert(condition, err)
	if not condition then
		error(err, 2)
	end
end
-- ensure that the required arguments are given
assert(fs.isDir(mainPath), `"${mainPath}" doesn't point at a directory.`)

-- find the source path for the given
local sourceCodeFolder = sourceCodePath or stdio.prompt("text", "Please put the name for the source code directory")
-- ask for build mode
buildMode = buildMode and buildMode
	or if stdio.prompt("select", "Please choose the build mode for this process.", { "integrated", "standalone" })
			== 2
		then "standalone"
		else "integrated"

if net.decode("toml", fs.readFile(`{mainPath}wally.toml`)).dependencies and buildMode ~= "standalone" then
	buildMode = "standalone"
	warn("Switched to standalone since there is no dependencies definied.")
end
-- call the needed builder
if buildMode == "integrated" then
	-- install all dependencies spceifcied in wally.toml
	print("Wally dependencies are installed")
	local wallyResult = process.spawn("wally", { "install" }, { cwd = mainPath })
	assert(wallyResult.ok, wallyResult.stderr)

	local t = string.split(mainPath, "\\")
	t = t[#t]:split("/")[1]
	-- create Release.project.json
	fs.writeFile(
		`{mainPath}/Release.project.json`,
		string.format(
			[[
			{
				"name": "%*",

				"tree": {
					"$path": "Packages",
					"%*": {
						"$path": "%*"
					}
				}
			}
		]],
			`{t}@{version}`,
			t,
			sourceCodeFolder
		)
	)

	-- finally build using rojo

	print("Rojo is building")
	local rojoResult = process.spawn(
		"rojo",
		{ "build", `-o {t}@{version}.rbxm`, "Release.project.json" },
		{ cwd = mainPath }
	)
	assert(rojoResult.ok, rojoResult.stderr)

	-- handle cleanup
	fs.removeDir(`{mainPath}/Packages`)
	fs.removeFile(`{mainPath}/Release.project.json`)
else
	local t = string.split(mainPath, "\\")
	t = t[#t]:split("/")[1]
	print(t)
	-- create Release.project.json
	fs.writeFile(
		`{mainPath}/Release.project.json`,
		string.format(
			[[
			{
				"name": "%*",

				"tree": {
				   "$path": "%*"
				}
			}
		]],
			`{t}@{version}`,
			sourceCodeFolder
		)
	)

	-- finally build using rojo

	print("Rojo is building")
	local rojoResult = process.spawn(
		"rojo",
		{ "build", `-o {t}@{version}.rbxm`, "Release.project.json" },
		{ cwd = mainPath }
	)
	assert(rojoResult.ok, rojoResult.stderr)

	-- handle cleanup
	fs.removeFile(`{mainPath}/Release.project.json`)
end
