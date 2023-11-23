--!strict

export type State<Value> = {
    type: string,
    value: Value,
    node: Node
}

export type refState<Value> = {
    type: "refState",
    ref: State<Value>
}

export type EitherState<Value> = State<Value> | refState<Value>

type MapStruct<K, V> = {[K]: V}

export type Node = {
    owner: any,
    dependents: MapStruct<Node, boolean>,
    cancelableTasks: {any}
}

export type Computer<Value> = (Node: Node) -> Value

export type Compute<Value> = State<Value> & {
    _computer: Computer<Value>,
    update: (self: Compute<Value>) -> boolean
}

export type Listen<Value> = State<Value> & {
    _connections: {() -> ()},
    update: (self: Listen<Value>) -> boolean
}


export type SliceOf = State<any> & {
    _owner: State<{[any]: any}>,
    _key: any,
    update: (self: SliceOf) -> boolean,
}
return {}