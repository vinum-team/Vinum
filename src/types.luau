--!strict
export type State<Value> = {
	type: string,
	value: Value,
	node: RNode,
	scope: any,
}

export type refState<Value> = {
	type: "refState",
	ref: State<Value>,
}

export type EitherState<Value> = State<Value> | refState<Value>

export type MapStruct<K, V> = { [K]: V }

export type Scope<Constructors> = { any } & Constructors

export type Computer<Value> = (RNode: RNode) -> Value

export type Compute<Value> = State<Value> & {
	_computer: Computer<Value>,
	onUpdate: (self: Compute<Value>) -> boolean,
}

export type SliceOf = State<any> & {
	_owner: State<{ [any]: any }>,
	_key: any,
	onUpdate: (self: SliceOf) -> boolean,
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
}
return {}
