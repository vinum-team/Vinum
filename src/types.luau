--!strict
export type iListener = () -> ()

export type ReactiveObject<Value, additionalArg> = {
	dependents: { [ReactiveObject<Value, additionalArg> | iListener]: boolean }?,
	cTasks: { CTask }?,
	_computer: ((RNode: ReactiveObject<Value, additionalArg>, arg: additionalArg) -> Value)?,
	_arg: additionalArg?,
	value: Value,
	scope: any,
	type: "reactiveState",
}

export type refState<Value> = {
	type: "refState",
	ref: ReactiveObject<Value, any>,
}

export type EitherState<Value> = ReactiveObject<Value, any> | refState<Value>

export type Scope<T> = { [number]: any } & T

export type Computer<Value, arg> = (RNode: ReactiveObject<Value, arg>, arg: arg) -> Value

export type CTask = {
	cancel: (self: CTask) -> (),
	[any]: any,
}

return {}
