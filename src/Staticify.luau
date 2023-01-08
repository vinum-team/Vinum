local read = require(script.Parent.utils.read)
return function(state)
    state._isStaticDependency = true
    state._use = read
    return state
end