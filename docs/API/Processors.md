# Processors

A set of functions that are the "standard" default Processors.
_____

# Functions

### Vinum.JustOk()
```lua
function Vinum.JustOk(): true
```
Returns true, therefore, accepts any and every update.

### Vinum.RefuseIfSimilar()
```lua
function Vinum.RefuseIfSimilar(oldValue: T, newValue: T) : boolean
```

Returns false if similar, and true if otherwise.

### Vinum.RefuseIfSimilarAndCleanup()
```lua
function Vinum.RefuseIfSimilarAndCleanup(oldValue: T, newValue: T) : boolean
```
Returns false if similar, and true if otherwise. Additionally, when true, it tries to cleanup the oldValue.

### Vinum.RefuseIfSimilarInGroup()
```lua
function Vinum.RefuseIfSimilarInGroup(keyName: string,oldValue: T, newValue: T) : boolean
```
Same as `RefuseIfSimilar`, but it is just a port to `Groups`.

### Vinum.RefuseIfSimilarAndCleanupInGroup()
```lua
function Vinum.RefuseIfSimilarAndCleanupInGroup(keyName: string,oldValue: T, newValue: T) : boolean
```
Same as `RefuseIfSimilarAndCleanup`, but it is just a port to `Groups`.