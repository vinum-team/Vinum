--!strict
local Package = script.Parent.Parent
local Creators = Package.Creators
local types = require(Package.types)
local Value = require(Creators.Value)
local Ref = require(Creators.Ref)

local Internal = Package.Internal
local Node = require(Internal.Node)

local function Channel<T>(scope, sender: (channel: types.State<T>) -> ())
	local self = Value(scope, nil :: any) :: types.State<T> & {_sender: any}
	self._sender = sender 


	self.node = Node.Node(self, function(dependency, dependent)
		dependency.owner._sender(dependency.owner)
	end)

	return Ref(scope, self)
end

return Channel
