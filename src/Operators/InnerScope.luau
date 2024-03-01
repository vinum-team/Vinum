--!strict

local Package = script.Parent.Parent
local types = require(Package.types)
local Memory = Package.Memory
local Internal = Package.Internal
local Kill = require(Memory.Kill)
local DerivedScope = require(Memory.DerivedScope)
local AddCTask = require(Internal.AddCTask)

type ReactiveObject = types.ReactiveObject<any, any>

local function cancel(myScope)
	return function(self)
		if self.cleanable then
			Kill(myScope)
			self.cleanable = false
		end
	end
end

local function InnerScope<T, U>(scope: types.Scope<T>, Node: ReactiveObject, additionalConstructors: U?): types.Scope<T & U>
	local myScope = DerivedScope(scope, additionalConstructors)

	AddCTask(Node, {
		cancel = cancel(myScope),
		cleanable = true,
	})

	return myScope
end

return InnerScope
