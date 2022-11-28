# Processors

Processors in Vinum are pure functions that give you control whether you want updates to pass or not. Additionally, they are the best places to include logic such as destruction, middleware, and various mechanisms such as `Vinum.RefuseIfSimilar`. 

## *Stateful* State Objects VS *Stateless* State Objects

In Vinum, there are two section of state objects, one that is `Stateful` and the other one is `Stateless`, and you already got introduced to most of them. `Stateful` state objects are objects that quite simply, manage and contain their own state such as `Hold` and `Calc`, while `Stateless` state objects are objects that simply don't have their "own" state, such as `Observe`.

*Stateful* state objects have totally different "best practices" for their processors since they are the ones that are the managers of their own state after all.

The general rule of thumb for stateful state objects' processors is that you should use them for the management of the said object's state, such as dismissing updates when `newValue` is the same as `oldValue`.

The "standard" processors for *stateful* state objects are `Vinum.RefuseIfSimilar`. It is a processor that will dismiss any update that doesn't result in a different value, and accounts for Calc's creation. Additionally, a "general" processor is `Vinum.JustOk`, which is just a processor that accepts every update.

Unlike *stateful* state object processors, *stateless* processors aren't tied to a standard, as they normally depend on your codebase foundation.
