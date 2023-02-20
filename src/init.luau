return {
	Utils = {
		Read = require(script.Utils.read),
		Write = require(script.Utils.write),
		WriteIndex = require(script.Utils.writeIndex),
		Grapher = require(script.Utils.grapher),
		Modify = require(script.Utils.modify)
	},
	Objects = {
		Hold = require(script.Objects.Hold),
		Observe = require(script.Objects.Observe),
		Group = require(script.Objects.Group),
		Absorb = require(script.Objects.Absorb),
		Compute = require(script.Objects.Compute),
	},
	Types = require(script.types),
}
