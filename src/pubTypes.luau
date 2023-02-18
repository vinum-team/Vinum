local Types = require(script.Parent.types)

export type Hold<T> = Types.TSelfState<"hold", T, true>
export type Observe<T> = Types.TState<"observe", "self", nil, true> & {
	_owner: Types.TAnySelfState<T>,
	_processor: (newValue: T) -> boolean,
	_connections: { [(newValue: T) -> ()]: true },

	onChange: (self: Observe<T>, fn: (newValue: T) -> ()) -> (() -> ()),
	onBind: (self: Observe<T>, fn: (newValue: T) -> ()) -> (() -> ()),
}
export type Group<T> = Types.TCentralState<"group", T, true>
export type Absorb<T> = Types.TSelfState<"absorb", T, boolean> & {
	_caseList: { [any]: Types.union<(any) -> any,Types.TAnySelfState<any>> },
	_isSynced: Types.TAnySelfState<boolean>,
	_toAbsorb: Types.TAnySelfState<any>,
	_use: any
}

export type Compute<T> = Types.TSelfState<"compute", T, boolean> & {
	_use: Types.use<T>,
	_computer: (use: Types.use<T>) -> (T)
}


return {}
