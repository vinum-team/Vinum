--!strict
-- taken from https://github.com/Someone-dQw4w9WgXcQ/Lua-ThreadPool
local threadIndex = 1000 -- How many threads to pre-allocate
local threads = table.create(threadIndex)

local function passer(toRun, ...)
	toRun(...)
end
local function runner(thread: thread): never
	while true do
		-- Get function and parameters
		-- Run the function
		passer(coroutine.yield())

		-- Done, make this thread available
		threadIndex += 1
		threads[threadIndex] = thread
	end
end

for i = 1, threadIndex do
	local thread = coroutine.create(runner)
	coroutine.resume(thread, thread)
	threads[i] = thread
end

return function<_, params>(func: (params) -> (), ...: params): thread
	if threadIndex ~= 0 then
		-- Thread available
		local thread = threads[threadIndex]

		-- Remove as available
		threads[threadIndex] = nil
		threadIndex -= 1

		return task.spawn(thread, func, ...)
	else
		local thread = coroutine.create(runner)
		coroutine.resume(thread, thread)

		return task.spawn(thread, func, ...)
	end
end
