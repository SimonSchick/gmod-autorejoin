include("gui/timeoutnotice.lua")

function makeNotice()
	local notice = vgui.Create("TimeoutNotice")
	notice:SetSize(350, 120)
	notice:Center()
	notice:SetVisible(false)
	return notice
end

		
local lastBeat = SysTime()

local isTimingOut = false
local notice
net.Receive("AutoRejoinHeartBeat", function()
	lastBeat = SysTime()
	timer.Adjust("AutoRejoin", 1, 0)
	if isTimingOut and notice then
		notice:EndNotice()
		isTimingOut = false
	end
end)

timer.Create("AutoRejoin", 1, 0, function()
	if not isTimingOut then
		print("test")
		notice = notice or makeNotice()
		notice:StartNotice()
		isTimingOut = true
	end
end)
