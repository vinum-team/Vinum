--!strict
export type iListener = () -> ()

export type ReactiveObject<Value> = {
	dependents: { [ReactiveObject<Value> | iListener]: boolean }?,
	cTasks: { CTask }?,
	_computer: ((RNode: ReactiveObject<Value>) -> Value)?,
	value: Value,
	scope: any,
	type: "reactiveState",
}

export type refState<Value> = {
	type: "refState",
	ref: ReactiveObject<Value>,
}

export type EitherState<Value> = ReactiveObject<Value> | refState<Value>

export type Scope<T> = { [number]: any } & T

export type Computer<Value> = (RNode: ReactiveObject<Value>) -> Value

export type CTask = {
	cancel: (self: CTask) -> (),
	[any]: any,
}

return {}
