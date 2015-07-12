include("gui/timeoutnotice.lua")
AddCSLuaFile("gui/timeoutnotice.lua")

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
local isFirstBeat = true

function onFirstBeat()
	isFirstBeat = false
	timer.Create("AutoRejoin", 2, 0, function()
		if not isTimingOut then
			notice = notice or makeNotice()
			notice:StartNotice()
			isTimingOut = true
		end
	end)
end

net.Receive("AutoRejoinHeartBeat", function()
	onFirstBeat()
	lastBeat = SysTime()
	timer.Adjust("AutoRejoin", 2, 0)
	if isTimingOut and notice then
		notice:EndNotice()
		isTimingOut = false
	end
end)

