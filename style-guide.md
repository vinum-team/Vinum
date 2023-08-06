#  Vinum Style Code
This style guide aims to unify as much Luau code in Vinum as possible under the same style and conventions.

The rules and guidelines set out here are derived from Roblox's style guide, which can be found here: https://roblox.github.io/lua-style-guide, additionally, there are certian blocks that were inspired/taken from Fusion's style guide which can be found here: https://github.com/dphfox/Fusion/blob/main/style-guide.md.

## Guiding Principles
* The purpose of a style guide is to avoid arguments
    * There's no one right answer to how to format code, but consistency is important, so we agree to accept this one, somewhat arbitrary standard so we can spend more time writing code and less time arguing about formatting details in the review.
* Optimize code for reading, not writing.
    *You will write your code once. Many people will need to read it, from the reviewers, to any one else that touches the code, to you when you come back to it in six months.
    * All else being equal, consider what the diffs might look like. It's much easier to read a diff that doesn't involve moving things between lines. Clean diffs make it easier to get your code reviewed.
* Avoid magic, such as surprising or dangerous Lua features:
    * Magical code is really nice to use, until something goes wrong. Then no one knows why it broke or how to fix it.
    * Metatables are a good example of a powerful feature that should be used with care.
* Be consistent with idiomatic Luau when appropriate.

## Folder Structure
Each file is under a specific folder in Vinum's source codebase depending on factors like their behavior.

## File Structure
Files should consist of these things (if present) in order:
1. A comment like `!strict` and other similar command like comments
2. An optional block comment specificing why this file exists.
3. Services used by the file, using `GetService`
4. Module Imports, using `require`
5. Imported Module-level constants
6. Script-Level Constants
7. Script-Level variables and functions
8. The entity the module returns 
9. a return statement

## Requires
* `require` calls should be at the top of the file, making dependencies static.
    * If there's an issue with two modules requiring each other cyclically, the structure of that code needs to be reconsidered.
* When requiring a module inside Fusion's source code, use relative paths. To keep these paths clean, use a variable called Package to store where the root of the library is.
    * This makes it clear where to find the source of the module within the source code.
```lua
local Package = script.Parent.Parent
local Foo = require(Package.Utils.Foo)
local Bar = require(Package.Reactive.Bar)
```
* Elsewhere, prefer absolute paths when requiring modules:
```lua
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local Foo = require(ReplicatedStorage.Foo)
```

## Metatables
Metatables are an incredibly powerful Lua feature that can be used to overload operators, implement prototypical inheritance, and tinker with limited object lifecycle. 

However, due to the nature of Metatables, the code that makes use of them is usually regarded as magic code, unless they used in cases like:
* OOP classes
* Guarding against typos - though Vinum doesnt make use of this, as such, this use case isnt documented here.

### OOP
Vinum has a very specific design for writing classes. Which is separating constructors from the class tables.

To create a `Math` class, define a `class` table, and a meta table with an `__index` metamethod that points at class:
```lua
local class = {}
local meta = {__index = class}
```

Now, lets create few methods for our class:
```lua
local function class:add(a, b)
    return a + b
end
```

Now, lets create our constructor function. To keep everything simple, the constructor's name should be `Math`:
```lua
local function Math()
    local self = setmetatable({
        -- some members that can be added directly
    }, meta)

    -- add some members that usually depend on another member
    self.hi = self.x + 2

    -- return the object!
    return self
end
```

While this is everything, Vinum generally enforces a rule where all classes should have manually written type definitons, as such, you need to do the following to your constructor:
```lua
local function Math()
    local self = setmetatable({
        -- some members that can be added directly
    }, meta) :: any

    -- add some members that usually depend on another member
    self.hi = self.x + 2

    -- return the object!
    return self :: ClassTypes.Math
end
```


Further additions you can make to your class as needed:
* Add a `meta` string to objects of your class - this is used to differentiate objects of different class types

## General Punctuation
* Don't use semicolons (;). They are generally only useful to separate multiple statements on a single line, but you shouldn't be putting multiple statements on a single line anyway.
    * This includes using semicolons in tables; prefer to use commas (,) to delimit values in tables.
* In comments and other documentation, use backticks when referencing code, and indentation when embedding longer blocks of code
```lua
 -- `foo` will be set to `5 + os.clock()`
 local foo = 5 + os.clock()

 --[[
 	An example implementation of a function using `os.clock()`:

 		local function getMinutes()
 			local now = os.clock()

 			return math.floor(now / 60)
 		end

 	The above code returns the integer number of minutes since the epoch.
 ]]
```