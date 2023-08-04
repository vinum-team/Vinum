--[=[
    @class Vinum

    The public interface to the Vinum API.
]=]

return {
	Hold = require("Objects/Hold"),
	KeyOf = require("Objects/KeyOf"),
	Compute = require("Objects/Compute"),
	Absorb = require("Objects/Absorb"),
	Listen = require("Objects/Listen"),
	graph = require("Utils/graph"),
	unpack = require("Utils/unpack"),
	async = require("Utils/async"),
	wrapSource = require("Utils/wrapSource"),
	sourceObject = require("Utils/sourceObject"),
	equals = require("Utils/equals"),
	clean = require("Utils/clean"),
	alwaysTrue = require("Utils/alwaysTrue"),
	createProcessor = require("Utils/createProcessor"),
	destroyObject = require("Utils/destroyObject"),
	willYield = require("Modifiers/willYield"),
	isWritable = require("Modifiers/isWritable"),

	Version = {MAJOR = 0, MINOR = 3, PATCH = 0}
}
