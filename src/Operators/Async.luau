--!strict
local Package = script.Parent.Parent
local Internal = Package.Internal
local AddCTask = require(Internal.AddCTask)
local types = require(Package.types)

type ReactiveObject<T> = types.ReactiveObject<T, any>

local coroutine_pool: { [number]: thread } = {}

local function yielder()
	while true do
		local callback, thread = coroutine.yield()
		callback()
		table.insert(coroutine_pool, thread)
	end
end

-- get_free_coroutine returns a coroutine owned by the caller, meaning that until
-- the caller actually uses this coroutine using run_coroutine, the pool won't be
-- able to retrieve it.
local function get_free_coroutine()
	local free_coroutine = coroutine_pool[#coroutine_pool]
	if free_coroutine then
		coroutine_pool[#coroutine_pool] = nil
		return free_coroutine
	end

	free_coroutine = coroutine.create(yielder)
	coroutine.resume(free_coroutine :: any)

	return free_coroutine :: any
end

local function run_coroutine(my_coroutine, callback, argument: any)
	coroutine.resume(my_coroutine, callback, my_coroutine, argument)
end

function cancel(self)
	if coroutine.status(self.co) == "dead" then
		return
	end
	coroutine.close(self.co)
end

local function Async<T>(self: ReactiveObject<T>, fn: () -> ())
	local co = get_free_coroutine()

	local CTask = {
		cancel = cancel,
		co = co,
	}

	AddCTask(self, CTask :: any)
	run_coroutine(co, fn)
	return CTask
end

return Async
