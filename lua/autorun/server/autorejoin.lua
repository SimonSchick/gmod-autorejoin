if game.SinglePlayer() then
	print("Not loading autorejoin addon")
	return
end

CreateConVar("timeout_notice_might_have_crashed", 5, flags, "When to show the first timeout message")
CreateConVar("timeout_notice_probably_restarting", 20, flags, "When to show the second timeout message")
CreateConVar("timeout_notice_countdown", 30, flags, "When to show the countdown")
 CreateConVar("timeout_notice_rejoining", 45, flags, "When to rejoin")

AddCSLuaFile("autorun/client/autorejoin.lua")
AddCSLuaFile("gui/timeoutnotice.lua")
AddCSLuaFile("util/systimer.lua")

util.AddNetworkString("AutoRejoinHeartBeat")
timer.Create("AutoRejoinHeartBeat", 1, 0, function()
	net.Start("AutoRejoinHeartBeat")
	net.Broadcast()
end)



