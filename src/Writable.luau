local function Writable(state)
	state._isWritable = true
	return state
end

return Writable
