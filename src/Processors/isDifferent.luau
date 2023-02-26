--!strict
return function<T>(_, oldValue: T, newValue: T, destroying: boolean): boolean
	if destroying then
		return true
	end

	return oldValue ~= newValue or type(oldValue or newValue) == "table"
end
