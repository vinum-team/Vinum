local processors = require(script.processors)

--[=[
	@class Vinum

	The interface to Vinum's tools.
]=]
local Vinum = {}
--[=[
	@prop Hold () -> (Hold)
	@within Vinum

	Hold's constructor.
]=]
Vinum.Hold = require(script.Hold)
--[=[
	@prop Observe () -> (Observe)
	@within Vinum

	Observe's constructor.
]=]
Vinum.Observe = require(script.Observe)
--[=[
	@prop Calc () -> (Calc)
	@within Vinum

	Calc's constructor.
]=]
Vinum.Calc = require(script.Calc)
--[=[
	@prop Match () -> (Match)
	@within Vinum

	Match's constructor.
]=]
Vinum.Match = require(script.Match)
--[=[
	@prop Group () -> (Group)
	@within Vinum

	Group's constructor.
]=]
Vinum.Group = require(script.Group)
--[=[
	@prop Mirror () -> (Mirror)
	@within Vinum

	Mirror's constructor.
]=]
Vinum.Mirror = require(script.Mirror)
--[=[
	@prop Wrap () -> (Wrap)
	@within Vinum

	Wrap's constructor.
]=]
Vinum.Wrap = require(script.Wrap)
--[=[
	@prop Reflect () -> (Reflect)
	@within Vinum

	Reflect's constructor.
]=]
Vinum.Reflect = require(script.Reflect)
--[=[
	@prop Record () -> (Record)
	@within Vinum

	Record's constructor.
]=]
Vinum.Record = require(script.Record)

Vinum.Progress = require(script.Progress)

--[=[
	@prop Version {Major: number, Minor: number, Patch: number}
	@within Vinum

	The version that this build is based of.
]=]
Vinum.Version = {
	Major = 0,
	Minor = 2,
	Patch = 0,
}
--[=[
	@prop Destroy (stateObj) -> ()
	@within Vinum

	Destroys the given state object.
]=]
Vinum.Destroy = require(script.utils.deconstruct)

Vinum.Staticify = require(script.Staticify)

--[=[
	@prop read (stateObj, keyName: string?) -> (any)
	@within Vinum

	A way for standardized reading across state objects.
]=]
Vinum.read = require(script.utils.read)

--[=[
	@prop write (state, firstArg: string | any, secondArg: any) -> ()
	@within Vinum

	A standardized way of writing across state objects
]=]
Vinum.write = require(script.utils.write)

Vinum.Processors = processors

return Vinum
