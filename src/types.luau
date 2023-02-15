--!strict
export type maybeStringOrNumber = string? | number?

export type TState<K, B, VT, SD> = {
	type: "state",
	kind: K,
	behavior: B,

	_isWritable: boolean?,
	_isYieldable: boolean?,
	_static: SD,

	_update: (self: TState<K, B, VT, SD> & any) -> (boolean, boolean),
}

export type TGraph = {
	type: "utils",
	kind: "graph",
	owner: TState<string, string, any, boolean>,
	dependencySet: { [TGraph]: true? },
	dependentSet: { [TGraph]: true? },
	active: boolean,

	updateDependents: (self: TGraph) -> (),
	disableDependencies: (self: TGraph) -> (),
	simplifyDependencies: (self: TGraph) -> (),
	update: (self: TGraph) -> boolean,
}

export type TSelfState<K, VT, SD> = TState<K, "self", VT, SD> & {
	_value: VT,
	_graph: TGraph,
	_processor: (oldValue: VT, newValue: VT) -> boolean,

	_setValue: (self: TSelfState<K, VT, SD>, newValue: VT) -> boolean,
}

export type TCentralState<K, VT, SD> = TState<K, "central", any, SD> & {
	_values: { [maybeStringOrNumber]: any },
	_graphs: { [maybeStringOrNumber]: TGraph },
	_processor: (key: maybeStringOrNumber, oldValue: any, newValue: any) -> boolean,

	_setValue: (self: TCentralState<K,VT,SD>, key: maybeStringOrNumber, value: any) -> boolean,
}

export type TAnyState<T> = TState<any, any, T, any>
export type TAnySelfState<T> = TSelfState<any, T, any>
export type TAnyCentralState<T> = TCentralState<any, T,any>
export type CanBeState<T> = TAnySelfState<T> | T

return {}
