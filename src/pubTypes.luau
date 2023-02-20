local Types = require(script.Parent.types)

export type Hold<T> = Types.TSelfState<"hold", T, true>
export type Observe<T> = Types.TState<"observe", "self", nil, true> & {
	_owner: Types.TAnySelfState<T>,
	_processor: (newValue: T) -> boolean,
	_connections: { [(newValue: T) -> ()]: true },
	_numOfConnections: number,

	onChange: (self: Observe<T>, fn: (newValue: T) -> ()) -> (() -> ()),
	onBind: (self: Observe<T>, fn: (newValue: T) -> ()) -> (() -> ()),
}
export type Group<T> = Types.TCentralState<"group", T, true>
export type Absorb<T, U, D> = Types.TSelfState<"absorb", U, boolean> & {
	_caseList: { [D | "default"]: Types.union<(use: Types.use<T>) -> U, Types.TAnySelfState<U>> },
	_isSynced: Types.TAnySelfState<boolean>,
	_toAbsorb: Types.TAnySelfState<D>,
	_use: any,
}

export type Compute<T> = Types.TSelfState<"compute", T, boolean> & {
	_use: Types.use<T>,
	_computer: (use: Types.use<T>) -> T,
}

return {}
