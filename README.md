<img align = "center" width="400" src="gh-assets/Banner.svg">

_______

# What is Vinum?
Vinum is a declarative library that focuses on making describing relations between
different data sources easy and scalable, and most importantly, fun!

## Code Example
```lua
-- x = 2y/z
local y = scope:Source(10)
local z = scope:Source(2)

local x = Scope:Derived(function(RNode)
    return 2 * Use(RNode, y) / Use(RNode, z)
end)

print(Read(x)) --> 10
```

## Features
### Performance Oriented 
Vinum is designed with performance in mind, and it's API is oriented towards performance, so you will naturally find yourself writing efficient code with it.

### Type Safety
Vinum is 100% written with Luau's strict typing in consideration, and recommends the usage of strict mode when writing Vinum code.

### Enforces Strict Code Conventions
Vinum enforces certain code "rules" so that Vinum code is stable, such as the requirement for a data source to contain a value at all times during a computation.

### Explicit Syntax
One of Vinum's core goals is explicit syntax, since such syntax allows for no confusions to happen and often allows for greater performance gains.

### Memory Management Supercharged
Vinum forces standard and *useful* manual memory tools to achieve predictability and eliminate most (if not all!) edge cases. 

### Dependencies Supercharged
Vinum manages dependencies for you in a very optimized and stable way so that bugs that relate to dependencies are often non-existent.