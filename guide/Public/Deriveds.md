# Deriveds
Deriveds are state structs used for "deriving" computations from input state structs. 

They allow you to:
* Use other state structs as dependencies using `Use`. `Use` operator also calls `Read` on the second argument which is the dependency state struct.
```lua
local mySource = scope:Source(10)
local myDerived = scope:Derived(function(RNode)
    return Use(RNode, mySource) / 2
end)
```
* Read from them using `Read` operator
```lua
print(Read(myDerived)) --> 5
```
* Observe them for updates using `On` operator.
```lua
On(myDerivied, function()
    print(Read(myDerivied))
end)
Write(mySource, 20) -- 10 is printed
```
* Allow to create innerscopes to be cleaned whenever a new value is expected to be recomputed, or the current value is de-cached. This uses `InnerScope` operator that is exposed by `Scope`.
```lua
local mySource = scope:Source(10)
local myDerived = scope:Derived(function(RNode)
    scope:InnerScope(RNode):Add(function()
        print("I am destroyed!")
    end)
    return Use(RNode, mySource) / 2
end)

Write(mySource, ...)
-- "I am destroyed!" was printed
```

### Deriveds with `use` injected.
```lua
local function CoolDeriveds(scope : any, computer)
    local myRNode
    local function use(dependency)
        return Use(myRNode, dependency)
    end
    return scope:Derived(function(RNode)
        myRNode = RNode
        return computer(RNode, use)
    end)
end
```
You can use `DerivedScope` and `Scoped` to integrate `CoolDeriveds` into the rest of Vinum:
```lua
local function bScoped()
    return DerivedScope(Scoped(), {
        CoolDeriveds = CoolDeriveds
    })
end
```