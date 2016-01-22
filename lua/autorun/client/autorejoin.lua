if game.SinglePlayer() then
	return
end

local mightHaveCrashedConVar = GetConVar("timeout_notice_might_have_crashed")
local probablyRestartingConVar = GetConVar("timeout_notice_probably_restarting")
local countdownConVar = GetConVar("timeout_notice_countdown")
local rejoinxyingConVar = GetConVar("timeout_notice_rejoining")

include("gui/timeoutnotice.lua")
include("util/systimer.lua")

RunConsoleCommand('cl_timeout', 9999)

function makeNotice()
	local notice = vgui.Create("TimeoutNotice")
	notice:SetNoticeTimeouts({
		mightHaveCrashed = mightHaveCrashedConVar:GetInt(),
		probablyRestarting = probablyRestartingConVar:GetInt(),
		countdown = countdownConVar:GetInt(),
		rejoining = rejoiningConVar:GetInt()
	})
	notice:SetSize(350, 120)
	notice:Center()
	notice:SetVisible(false)
	return notice
end

local lastBeat = SysTime()

local isTimingOut = false
local notice
local isFirstBeat = true

function onTimeout()
	if not isTimingOut then
		notice = notice or makeNotice()
		notice:StartNotice()
		systimer.Create("AutoRejoin-Rejoin", rejoiningConVar:GetInt(), 1, function()
			LocalPlayer():ConCommand("retry")
		end)
		isTimingOut = true
	end
end

function onFirstBeat()
	isFirstBeat = false
	systimer.Create("AutoRejoin", 2, 0, onTimeout)
end

net.Receive("AutoRejoinHeartBeat", function()
	if isFirstBeat then
		onFirstBeat()
	end
	lastBeat = SysTime()
	systimer.Adjust("AutoRejoin", 2, 0, onTimeout)
	if isTimingOut and notice then
		notice:EndNotice()
		systimer.Remove("AutoRejoin-Rejoin")
		isTimingOut = false
	end
end)

