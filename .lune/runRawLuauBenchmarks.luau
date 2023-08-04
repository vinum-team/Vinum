--!optimize 2
local function noOp()
end

local function microOrMili(num)
	local MiliVersion = num * 1_000

	return if MiliVersion < 1 then tostring(num * 1_000_000) .. "us" else tostring(MiliVersion) .. "ms"
end

local resultString = "Benchmark Results:"
local tbl = require("testResult")
for path, benchmarks in tbl  do
    benchmarks = benchmarks()
	resultString ..= `\n {path}`

	for index, benchmarkInfo in benchmarks do
		local name = benchmarkInfo.name
		local calls = benchmarkInfo.calls

		local preRun = benchmarkInfo.preRun or noOp
		local run = benchmarkInfo.run
		local postRun = benchmarkInfo.postRun or noOp

		local state = preRun()

		local rawResult = {}
		local start = os.clock()
		for n = 1, calls do
			run(state)
		end
		local final = os.clock()
		print("yes")
		postRun(state)

		local caseResult = final - start

		resultString ..= `\n  {name} .. {microOrMili(caseResult)}`
	end
	print(path)
end

print(resultString)