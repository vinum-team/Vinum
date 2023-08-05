export type skip = () -> ()
export type lifecycleFunctions = "afterAll" | "afterEach" | "beforeAll" | "beforeEach"

export type TestCaseResult = { ok: boolean, err: string? }
export type TestSuiteResult = { [string]: TestCaseResult }
export type TestSuite = {
	[string]: (skip: skip, ...any) -> (),
}

local CrescTest = {}

local lifecycleFunctions = {
	afterAll = true,
	afterEach = true,
	beforeAll = true,
	beforeEach = true,
}

local function empty() end

function CrescTest.runSuite(TestSuite: TestSuite, context: any): TestSuiteResult
	local result: TestSuiteResult = {}
	local afterAll = TestSuite.afterAll or empty
	local afterEach = TestSuite.afterEach or empty
	local beforeAll = TestSuite.beforeAll or empty
	local beforeEach = TestSuite.beforeEach or empty

	beforeAll(empty, context)
	for testCaseName, testCase in TestSuite do
		if not lifecycleFunctions[testCaseName] then
			beforeEach(empty, context)

			local isSkipped
			local isOk, response = pcall(testCase, function()
				isSkipped = true
				error("")
			end, context)

			if isSkipped then
				afterEach(empty, context, true)
				continue
			end

			result[testCaseName] = { ok = isOk, err = response }
			afterEach(empty, context, false)
		end
	end
	afterAll(empty, context)
	return result
end

if script then -- this is roblox, lets setup a bootstrapper for it
	function CrescTest.runRoblox(dirInstance: Folder, context)
		local result = {}

		for _, instance in dirInstance:GetDescendants() do
			if instance:IsA("ModuleScript") and instance.Name:find("spec") then
				result[instance:GetFullName()] = CrescTest.runSuite(require(instance), context)
			end
		end

		local resultString = ""

		for file, testSuiteResult in result do
			local scopedResult = {}
			local scopedError = {}
			for testCase, testResult in testSuiteResult do
				table.insert(scopedResult, `   {testCase} .. {if testResult.ok then "Passed" else "Failed"}`)

				if testResult.err then
					table.insert(scopedError, `\n{testCase}: \n{testResult.err}`)
				end
			end

			resultString ..= `\n{file}: \n {table.concat(scopedResult, "\n ")}\nError: \n {table.concat(scopedError, "\n ")}`			
		end

		print(resultString)
	end
else -- this is in a lune env, lets setup a bootstrapper that depends on fs
	local fs = require("@lune/fs")
	local stdio = require("@lune/stdio")

	local function getDescendents(dir, result)
		local contents = fs.readDir(dir)

		for _, name in contents do
			local path = `{dir}/{name}`

			if fs.isDir(path) then
				getDescendents(path, result)
			else
				result[path] = true
			end
		end

		return result
	end

	function CrescTest.runLune(dir: string, context: any)
		local result = {}

		for path in getDescendents(dir, {}) do
			if not string.find(path, "spec") then
				continue
			end
			result[path] = CrescTest.runSuite(require(`../../{path}`), context)
		end

		local resultString = ""

		for file, testSuiteResult in result do
			local scopedResult = {}
			local scopedError = {}
			for testCase, testResult in testSuiteResult do
				table.insert(
					scopedResult,
					`   {testCase} .. {if testResult.ok
						then stdio.color("green") .. "Passed" .. stdio.color("reset")
						else stdio.color("red") .. "Failed" .. stdio.color("reset")}`
				)

				if testResult.err then
					table.insert(
						scopedError,
						`\n{testCase}: \n{stdio.color("red")}{testResult.err}{stdio.color("reset")}`
					)
				end
			end

			resultString ..= `\n{file}: \n {table.concat(scopedResult, "\n ")}\nError: \n {table.concat(scopedError, "\n ")}`
		end

		print(resultString)
	end
end
function CrescTest.expect(input): any
	return setmetatable({
		_never = false,
	}, {
		__index = function(self, queryName)
			if queryName == "never" then
				self._never = not self._never
			end

			if queryName == "ok" then
				return function()
					local never = self._never
					local result = input ~= nil

					if never then
						result = not result
					end

					assert(
						result,
						`Expected value to{if never then " never" else ""} exist: \ntraceback: {debug.traceback()}`
					)
				end
			end

			if queryName == "equal" or queryName == "equals" then
				return function(expectedValue)
					local never = self._never
					local result = input == expectedValue

					if never then
						result = not result
					end

					assert(
						result,
						`Expected value to{if never then " never" else ""} be equal to {expectedValue}, got {input}: \ntraceback: {debug.traceback()}`
					)
				end
			end

			if queryName == "near" then
				return function(expectedValue)
					local never = self._never
					local result = math.round(input) == math.round(expectedValue)

					if never then
						result = not result
					end

					assert(
						result,
						`Expected value to{if never then " never" else ""} be near to {expectedValue}, got {input}: \ntraceback: {debug.traceback()}`
					)
				end
			end

			if queryName == "a" then
				return function(expectedType)
					local never = self._never
					local result = typeof(input) == expectedType

					if never then
						result = not result
					end

					assert(
						result,
						`Expected value to{if never then " never" else ""} have type of {expectedType}, got {typeof(input)}: \ntraceback: {debug.traceback()}`
					)
				end
			end

			if queryName == "throw" then
				return function()
					local never = self._never
					local isOk = pcall(input)

					local result = not isOk

					if never then
						result = not result
					end

					assert(
						result,
						`Expected value to{if never then " never" else ""} throw: \ntraceback: {debug.traceback()}`
					)
				end
			end
			return self
		end,
	}) :: any
end

return CrescTest