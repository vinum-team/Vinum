--!strict
export type maybeStringOrNumber = string? | number?

export type TState<K, B, VT, SD> = {
	type: "state",
	kind: K,
	behavior: B,

	_isWritable: boolean?,
	_isYieldable: boolean?,
	_static: SD?,

	_update: (self: TState<K, B, VT, SD> & any) -> (boolean, boolean),
}

export type TProcessor<T> = (key: maybeStringOrNumber, old: T, new: T, destroying: boolean) -> boolean

export type TGraphNode = {
	type: "utils",
	kind: "graph",
	owner: TState<any, any, any, any>?,
	dependencySet: { [TGraphNode]: true? },
	dependentSet: { [TGraphNode]: true? },
	active: boolean,
}

export type TSelfState<K, VT, SD> = TState<K, "self", VT, SD> & {
	_value: VT,
	_graph: TGraphNode,
	_processor: TProcessor<VT>,

	_setValue: (self: TSelfState<K, VT, SD>, newValue: VT) -> boolean,
}

export type TCentralState<K, VT, SD> = TState<K, "central", any, SD> & {
	_values: { [maybeStringOrNumber]: any },
	_graphs: { [maybeStringOrNumber]: TGraphNode },
	_processor: TProcessor<any>,

	_setValue: (self: TCentralState<K, VT, SD>, key: maybeStringOrNumber, value: any) -> boolean,
}

export type TAnyState<T> = TState<any, any, T, any>
export type TAnySelfState<T> = TSelfState<any, T, any>
export type TAnyCentralState<T> = TCentralState<any, T, any>
export type CanBeState<T> = TAnySelfState<T> | T

export type use<T> = (dependency: CanBeState<T> | TAnyCentralState<T>) -> T
export type union<a, b> = a | b

return {}
