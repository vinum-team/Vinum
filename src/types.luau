--!strict
export type State<Value> = {
	type: string,
	value: Value,
	node: RNode,
	scope: Scope<any>,
}

export type refState<Value> = {
	type: "refState",
	ref: State<Value>,
}

export type EitherState<Value> = State<Value> | refState<Value>

export type Scope<T> = { [number]: any } & T

export type Computer<Value> = (RNode: RNode) -> Value

export type Derived<Value> = State<Value> & {
	_computer: Computer<Value>,
	onUpdate: (self: Derived<Value>) -> boolean,
}

export type Select = State<any> & {
	_owner: State<{ [any]: any }>,
	_key: any,
	onUpdate: (self: Select) -> boolean,
}

export type CTask = {
	cancel: (self: CTask) -> (),
	[any]: any,
}

export type Owner = {
	onUpdate: ((self: Owner) -> ())?,
	[any]: any,
}

export type RNode = {
	owner: Owner,
	dependents: { [RNode]: boolean }?,
	cancelableTasks: { CTask }?,
	onDependentAdded: ((self: RNode, dependent: RNode) -> ())?,
	numOfDependents: number,
}
return {}
