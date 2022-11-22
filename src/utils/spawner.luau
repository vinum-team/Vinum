local freeThread -- Thread reusage

local function Passer(fn, ...)
	local acquiredThread = freeThread
	freeThread = nil
	fn(...)
	freeThread = acquiredThread
end

local function yielder()
	while true do
		Passer(coroutine.yield())
	end
end

local function SpawnWithReuse(fn, ...)
	if not freeThread then
		freeThread = coroutine.create(yielder)
		coroutine.resume(freeThread)
	end
	task.spawn(freeThread, fn, ...)
end

return SpawnWithReuse