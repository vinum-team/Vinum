
--[=[
	@within Vinum
	@interface Graph 
	.type "graph"
	.owner any
	.dependencies { [Graph]: any }
	.dependents { [Graph]: any }
	.asyncOperations { any }
	
	A general type used to represent a graph Object.
]=]

export type Graph = {
	type: "graph",
	owner: any,
	dependencies: { [Graph]: any },
	dependents: { [Graph]: any },
	asyncOperations: { any },
}

--[=[
	@within Vinum
	@interface AsyncOperation<data>
	.isFinished boolean
	.listener ((data) -> ())?
	.data data?
	.coroutine thread

	.cancel (self: AsyncOperation<data>) -> ()
	.on (self: AsyncOperation<data>, fn: (...any) -> data) -> ()

	A common object used to store useful information about an async operation.
]=]
export type AsyncOperation<data> = {
	isFinished: boolean,
	listener: ((data) -> ())?,
	data: data?,
	coroutine: thread,

	cancel: (self: AsyncOperation<data>) -> (),
	on: (self: AsyncOperation<data>, fn: (...any) -> data) -> (),
}


--[=[
	@within Vinum
	@type Processor<T> (old: T, new: T, destroying: boolean) -> boolean
]=]
export type Processor<T> = (old: T, new: T, destroying: boolean) -> boolean

--[=[
	@within Vinum
	@interface StateObj<M, T>
	.meta M
	.static boolean
	._value T
	._graph Graph
	._writable boolean

	._processor Processor<T>
	._update (self: StateObj<M, T>) -> ()
	.set (self: StateObj<M, T>, newValue: T) -> ()
	.get (self: StateObj<M, T>) -> T
]=]
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

return {}
