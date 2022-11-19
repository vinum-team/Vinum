return function(self)
    return function(state)
        state._graph:addDependent(self)
        self._graph:addDependency(state)

        return state:get()
    end
end