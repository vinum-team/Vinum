return function(state, firstArg: string | any, secondArg: any)
	if state.behavior == "center" then
		state:_setValue(firstArg, secondArg)
	else
		state:_setValue(firstArg)
	end
end
