local types = require(script.Parent.types)

export type inject<T> = (types.StateObj<any, T>) -> T

export type Hold<T> = types.StateObj<"Hold", T>

export type KeyOf<T, k> = types.Extends<types.StateObj<"KeyOf", T>, {
	_key: k,
	_obj: types.StateObj<any, any>,
}>

export type Compute<T, U> = types.Extends<types.StateObj<"Compute", T>, {
	_computer: (inject: inject<U>) -> T,
	_inject: inject<U>,
	_asyncInject: any,
	_staticInject: (boolean) -> (),
	_becomeInject: (value: T) -> (),
}>

export type Absorb<T, U> = types.Extends<types.StateObj<"Absorb", T>, {
	_toAbsorb: types.StateObj<any, U>,
	_cases: { [U | "default"]: types.StateObj<any, T> },
	_lastArm: types.Graph,
}>

export type Listen<T> = types.Extends<types.StateObj<"Listen", T>, {
	connect: (self: Listen<T>, fn: (old: T, new: T) -> ()) -> (),
	bind: (self: Listen<T>, fn: (old: T, new: T?) -> ()) -> (),
	_dependency: types.StateObj<any, T>,
	_connections: { [(any) -> ()]: true },
	_canYield: boolean,
}>

return {}
