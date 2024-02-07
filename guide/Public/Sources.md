# Sources

Sources are simple structs that allow you to:
* Read from them using `Read` operator
```lua
local mySource = Scoped():Source(10)

print(Read(mySource)) --> 10
```
* Write to them using `Write` operator
```lua
local mySource = Scoped():Source(10)

Write(mySource, 5)
print(Read(mySource)) --> 5
```
* Observe them for updates using `On` operator.
```lua
local mySource = Scoped():Source(10)

On(mySource, function()
    print(Read(mySource))
end)

Write(mySource, 5) --> 5 is printed.
```