--!strict
export type Trait<T> = { value: T, fn: (T) -> (), type: "trait" }

export type State<Value> = {
	type: string,
	value: Trait<Value>,
	node: Node,
	scope: { [any]: any },
}

export type refState<Value> = {
	type: "refState",
	ref: State<Value>,
}

export type EitherState<Value> = State<Value> | refState<Value>

type MapStruct<K, V> = { [K]: V }

export type Scope<Constructors> = { EitherState<any> | { EitherState<any> } } & Constructors

export type CancelableTask = {
	cancel: (self: CancelableTask) -> (),
	[any]: any,
}

export type Node = {
	owner: any,
	dependents: MapStruct<Node, boolean>,
	cancelableTasks: { CancelableTask },
}

export type Computer<Value> = (Node: Node) -> Trait<Value>

export type Compute<Value> = State<Value> & {
	_computer: Computer<Value>,
	update: (self: Compute<Value>) -> boolean,
}

export type SliceOf = State<any> & {
	_owner: State<{ [any]: any }>,
	_key: any,
	update: (self: SliceOf) -> boolean,
}

return {}
