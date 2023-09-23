export type Graph = {
	type: "graph",
	owner: any,
	dependencies: { [Graph]: any },
	dependents: { [Graph]: any },
	asyncOperations: { any },
}

export type AsyncOperation<data> = {
	isFinished: boolean,
	listener: ((data) -> ())?,
	data: data?,
	coroutine: thread,

	cancel: (self: AsyncOperation<data>) -> (),
	on: (self: AsyncOperation<data>, fn: (...any) -> data) -> (),
}

export type Processor<T> = (old: T, new: T, destroying: boolean) -> boolean

export type StateObj<M, T> = {
	meta: M,
	static: boolean,
	_value: T,
	_graph: Graph,
	_update: (self: StateObj<M, T>) -> ()?,
	_writable: boolean,

	set: (self: StateObj<M, T>, newValue: T) -> (),
	get: (self: StateObj<M, T>) -> T,
	_processor: Processor<T>,
}

export type Extends<base, other> = base & other

export type CanBeState<T> = T | StateObj<string, T>

export type union<t1, t2, t3> = t1 | t2 | t3

export type DesTrait<T> = {value: T, clean: (self: DesTrait<T>) -> ()}

return {}
