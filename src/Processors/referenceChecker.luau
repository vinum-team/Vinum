--!strict

return function<T>(old: T, new: T, isdestroying: boolean)
	if not isdestroying then
		if type(old) == "table" then
			return true
		end

		return old ~= new
	end

	return true
end
