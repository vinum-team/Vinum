local value = {
	Utils = {
		read = require(script.Utils.read),
		write = require(script.Utils.write),
		writeIndex = require(script.Utils.writeIndex),
		grapher = require(script.Utils.grapher),
		modify = require(script.Utils.modify),
		deconstruct = require(script.Utils.deconstruct),
	},
	Objects = {
		Hold = require(script.Objects.Hold),
		Observe = require(script.Objects.Observe),
		Group = require(script.Objects.Group),
		Absorb = require(script.Objects.Absorb),
		Compute = require(script.Objects.Compute),
		Wrap = require(script.Objects.Wrap)
	},
	Processors = {
		AlwaysTrue = require(script.Processors.alwaysTrue),
		Combine = require(script.Processors.combine),
		IsDifferent = require(script.Processors.isDifferent),
	},
	Types = require(script.types),
}

return value
