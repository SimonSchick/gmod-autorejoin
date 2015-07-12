local systimer = {
	timers = {}
}

_G.systimer = systimer

function systimer.Create(indentifier, interval, reps, func)
	systimer.timers[indentifier] = {reps, interval, SysTime()+interval, func}
end

function systimer.Remove(indentifier)
	systimer.timers[indentifier] = nil
end

systimer.Adjust = systimer.Create

hook.Add("Think", "SASysTimer", function()
	local t = SysTime()
	local isok, res
	for indentifier, tbl in next, systimer.timers do
		if(tbl[3] <= t) then
			tbl[1] = tbl[1] - 1
			isok, res = pcall(tbl[4], tbl[1])
			if(not isok) then
				error(
					string.format(
						"Timer '%s' failed with error %s",
						tostring(indentifier),
						res
					)
				)
			end
			if(tbl[1] == 0) then
				systimer.timers[indentifier] = nil
				continue
			end
			tbl[3] = t + tbl[2]
		end
	end
end)

