--!strict
return function(valueChecker: (a: any, b: any) -> boolean, cleaner: (taskItem: any) -> ())
	return function<T>(old: T, new: T, isDestroying: boolean)
		if isDestroying then
			cleaner(old)
			return false
		end

		if valueChecker(old, new) then
			return false
		end

		cleaner(old)
		return true
	end
end
