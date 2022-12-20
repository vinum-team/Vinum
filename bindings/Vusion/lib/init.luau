return function(Fusion, Vinum)
	local Vusion = {}

	function Vusion.toVinum(fusionObj, writable: boolean)
		local holder = Vinum.Hold(fusionObj:get(false), Vinum.RefuseIfSimilar)
		Fusion.Observer(fusionObj):onChange(function()
			holder:set(fusionObj:get(false))
		end)

		return if writable then holder else Vinum.Reflect(holder)
	end

	function Vusion.VSpring(...)
		return Vusion.toVinum(Fusion.Spring(...), false)
	end

	function Vusion.VTween(...)
		return Vusion.toVinum(Fusion.Tween(...), false)
	end

	Vusion.Key = {
		type = "SpecialKey",
		kind = "VusionKey",
		stage = "self",

		apply = function(self, values, applyTo, cleanupTasks)
			for propName, stateObj in values do
				local valueType = type(stateObj)

				if valueType == "table" and stateObj.type == "state" then
					local observer = Vinum.Observe(stateObj, Vinum.AlwaysTrue)
					observer:onBind(function(newValue)
						applyTo[propName] = newValue or "hi"
					end)

					table.insert(cleanupTasks, function()
						Vinum.Destroy(observer)
					end)
				elseif valueType ~= "table" then
					applyTo[propName] = stateObj
				end
			end
		end
	}

	return Vusion
end