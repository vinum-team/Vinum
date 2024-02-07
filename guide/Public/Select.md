# Selects
Selects are state structs that select a key to "capture" from a state struct that holds a table.

```lua
local store = scope:Source({
    hi = 10
})

local hiSelection = scope:Select(store, "hi")
```

From now, you can use all operators that work on `Sources` on `hiSelection`:
* `Read` - returns the value of hiSelection, which in this case `10`.
* `On` - listens for changes.
* `Write` - writes to hiSelection's selected state struct (in this case, `store`), which then updates `hiSelection`'s value with the new value.