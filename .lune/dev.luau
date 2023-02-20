-- util
local function reporter(condition, err)
    if not condition then
        error(`dev.luau encountered an error while executing: \n {err}`)
    end
end

-- ensure that a project.json file is provided
reporter(fs.isFile(process.args[1] or "dev.project.json"), "The given path doesn't point at a file.")

-- install all dependencies spceifcied in wally.toml
print("Wally dependencies are installed")
local wallyResult = process.spawn("wally", {"install"})
reporter(wallyResult.ok, wallyResult.stderr)

-- run rojo serve
print("Rojo started!")
local result = process.spawn('rojo', {"serve", process.args[1] or "dev.project.json"})
reporter(result.ok, result.stderr)
