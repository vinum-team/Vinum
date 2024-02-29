--!strict

local Package = script.Parent.Parent
local types = require(Package.types)
local Memory = Package.Memory
local Internal = Package.Internal
local Kill = require(Memory.Kill)
local DerivedScope = require(Memory.DerivedScope)
local AddCTask = require(Internal.AddCTask)

local function InnerScope<T, U>(scope: types.Scope<T>, Node: types.ReactiveObject<any>, additionalConstructors: U?): types.Scope<T & U>
	local myScope = DerivedScope(scope, additionalConstructors)

	AddCTask(Node, {
		cancel = function()
			Kill(myScope)
		end,
		cleanable = true,
	})

	return myScope
end

return InnerScope
