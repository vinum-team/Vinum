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
}>

export type Absorb<T, U> = types.Extends<types.StateObj<"Absorb", T>, {
	_handler: (self: Absorb<T, U>) -> T,
	_inject: inject<U>,
	_toAbsorb: types.StateObj<any, any>,
	_cases: { [any]: any },
}>

export type Listen<T> = types.Extends<types.StateObj<"Listen", T>, {
	Connect: (self: Listen<T>, fn: (any) -> ()) -> (),
	_dependency: types.StateObj<any, T>,
	_connections: { [(any) -> ()]: true },
	_canYield: boolean
}>

return {}
