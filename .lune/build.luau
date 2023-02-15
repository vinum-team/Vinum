local args = process.args

local path = args[1]
local version = args[2]
local isInteg = args[3]

local function assert(condition, err)
	if not condition then
		console.error(err)
		process.exit(0)
		task.wait()
	end
end

--check if the given path is a dir or not.
assert(fs.isDir(path or ""), "The given path doesn't point at a directory.")

local final = if fs.isDir(string.format("%*/src", path))
	then "src"
	elseif fs.isDir(string.format("%*/lib", path)) then "lib"
	else nil

assert(final ~= nil, "There is no src or lib folder in your given path")

if isInteg == true then
	require(".lune/buildModes/integ")(path, final, version)
end