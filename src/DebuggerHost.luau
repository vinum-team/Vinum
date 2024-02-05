local DebuggerHost = {}

function DebuggerHost.onAddCTask(RNode, CTask) end

function DebuggerHost.onAddDependent(Dependency, Dependent) end

function DebuggerHost.onRNode(RNode) end

function DebuggerHost.onShouldCacheValue(RNode, ShouldCache) end

function DebuggerHost.onFirstPass(DependentQueue, Length) end

function DebuggerHost.onSecondPass(DependentQueue, Length) end

function DebuggerHost.onThirdPass(DependentQueue, Length) end

return DebuggerHost
