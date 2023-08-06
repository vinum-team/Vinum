local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function noOp()
end

local function microOrMili(num)
	local MiliVersion = num * 1_000

	return if MiliVersion < 1 then tostring(num * 1_000_000) .. "us" else tostring(MiliVersion) .. "ms"
end

local function getBenchmarks()
    local result = {}
    for _, instance in ReplicatedStorage.benchmarks:GetDescendants() do
        if instance:IsA("ModuleScript") and instance.Name:find("bench") then
            result[instance:GetFullName()] = require(instance)
        end
    end

    return result
end

task.wait(5)
print("Starting!")
local resultString = "Benchmark Results:"
local tbl = getBenchmarks()
for path, benchmarks in tbl  do
	resultString ..= `\n {path}`

    task.wait()
	for index, benchmarkInfo in benchmarks do
		local name = benchmarkInfo.name
		local calls = benchmarkInfo.calls

		local preRun = benchmarkInfo.preRun or noOp
		local run = benchmarkInfo.run
		local postRun = benchmarkInfo.postRun or noOp


		local rawResult = {}
		for n = 1, calls do
            local state = preRun()
            local start = os.clock()
			run(state)
            local final = os.clock()
            table.insert(rawResult, final - start)
            postRun(state)
		end

        table.sort(rawResult)

		resultString ..= `\n  {name} .. {microOrMili(rawResult[#rawResult * 0.5])}`
	end
end

print(resultString)