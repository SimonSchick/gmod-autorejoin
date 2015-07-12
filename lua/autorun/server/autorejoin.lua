AddCSLuaFile("gui/timeoutnotice.lua")
AddCSLuaFile("util/systimer.lua")

util.AddNetworkString("AutoRejoinHeartBeat")
timer.Create("AutoRejoinHeartBeat", 1, 0, function()
	net.Start("AutoRejoinHeartBeat")
	net.Broadcast()
end)



