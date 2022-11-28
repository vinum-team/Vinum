# Hold

The object responsible for storing pure data.
____

```lua
function Hold<T>(
    ogValue: T,
    updateProcessor: (oldValue: T, newValue: T) -> (boolean)
): Hold<T>
```

Constructs and returns a new Hold object.
_____

# Parameters

* `ogValue: T`
    * The value to be stored initially.
* `updateProcessor: (oldValue: T, newValue: T) -> (boolean)`
    * The function `Hold` uses to determine whether to pass updates or not. `true` will pass while `false` will dismiss.
___

# Object Methods

### get()
```lua
function Hold:get(): T
```
Returns the current stored value.

### set()
```lua
function Hold:set(newValue: T)
```

Changes the current value to `newValue`, and then signal an update if `updateProcessor` returned true.

____

# Example Usage
```lua
local health = Hold(100, Vinum.JustOk)

print(health:get()) -- 100
health:set(20)
print(health:get()) -- 20
```
