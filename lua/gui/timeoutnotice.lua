surface.CreateFont(
	"AutoRejoin",
	{
		font = "Trebuchet24",
		size = 25,
		weight = 400,
		antialias = true,
		additive = false,
	}
)
local PANEL = {}

function PANEL:Init()
	self._text = vgui.Create("DLabel", self)
	self._text:SetFont("AutoRejoin")
	self._text:SetColor(Color(220, 220, 220, 255))
	self.createdTime = SysTime()
end

function PANEL:SetNoticeTimeouts(timeouts)
	self.timeouts = {
		mightHaveCrashed = timeouts.mightHaveCrashed,
		probablyRestarting = timeouts.probablyRestarting,
		countdown = timeouts.countdown,
		rejoining = timeouts.rejoining
	}
end

function PANEL:PerformLayout(w, h)
	self._text:Center()
end

function PANEL:UpdateText(msg)
	self._text:SetText(msg)
	self._text:SizeToContents()
	self._text:Center()
end

function PANEL:UpdateMessage(secondsRunning)
	if secondsRunning == self.timeouts.mightHaveCrashed then
		self:UpdateText("Server might have Crashed...")
	elseif secondsRunning == self.timeouts.probablyRestarting then
		self:UpdateText("Server is Restarting...")
	elseif secondsRunning == self.countdown then
		self._restartTime = SysTime() + (self.timeouts.rejoining - timeouts.countdown)
		self._showRestartCountDown = true
	elseif secondsRunning == self.timeouts.rejoining then
		self._showRestartCountDown = false
		self:UpdateText("Rejoining...")
	end
end

function PANEL:Think()
	if self._showRestartCountDown then
		self:UpdateText(
			string.format("Rejoining in: %05.2f seconds", math.min(self._restartTime - SysTime(), 0))
		)
	end
end

function PANEL:StartNotice()
	if not self.timeouts then
		error("No timeout intervals set!")
	end
	self:SetAlpha(0)
	self:AlphaTo(255, 2, 0)
	self:SetVisible(true)
	local secondsPassed = 0
	systimer.Create("AutoRejoinPanel", 1, 0, function()
		secondsPassed = secondsPassed + 1
		self:UpdateMessage(secondsPassed)
	end)

	self:UpdateText("Connection Problem...")
end


function PANEL:EndNotice()
	self:AlphaTo(0, 1, 0, function(anim, pnl)
		pnl:SetVisible(false)
	end)
	self._showRestartCountDown = false
	systimer.Remove("AutoRejoinPanel")
	self:UpdateText("Nevermind...")
end

function PANEL:Paint()
	Derma_DrawBackgroundBlur( self, self.createdTime )
end


vgui.Register("TimeoutNotice", PANEL, "DPanel")
