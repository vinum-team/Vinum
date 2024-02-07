# Scopes
Scopes are a foundational tool for managing cleanup.

To create a scope, you use `Scoped`:
```lua
local scope = Scoped()
scope:...()
```

By default, scopes returned from `Scoped` contain a list of constructors which are:
* Derived
* Select
* Source
* Ref
* Map
* InnerScope
* Add

`Add` is a simple function that adds something to the scope manually. Currently, the only supported datatype other than state structs is `functions`. They will run when the scope is cleaned up.

To create a derivedScope, you can use `DerivedScope`, which accepts an already existing `scope` and an optional argument of additional constructors to merge into the constructors of an existing `scope`.


To cleanup a scope, you use `Vinum.Kill` on a scope:
```lua
Kill(scope)
```

Kill loop through the objects in the scope, and will do:
* If a task is a function, run it.
* if a task is a state struct object, perform needed cleanup actions, and call `Kill` on the scope of its dependents if the scope is a different one.