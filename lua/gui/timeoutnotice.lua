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

function PANEL:PerformLayout(w, h)
	self._text:Center()
end

function PANEL:UpdateText(msg)
	self._text:SetText(msg)
	self._text:SizeToContents()
	self._text:Center()
end

function PANEL:UpdateMessage(ticksLeft)
	if ticksLeft == 6 then
		self:UpdateText("Server Crash Possible...")
	elseif ticksLeft == 4 then
		self:UpdateText("Server Restarting...")
	elseif ticksLeft == 3 then
		self._restartTime = SysTime() + 12
		self._showRestartCountDown = true
	elseif ticksLeft == 0 then
		self._showRestartCountDown = false
		self:UpdateText("Rejoining...")
		LocalPlayer():ConCommand("retry")
	end
end

function PANEL:Think()
	if self._showRestartCountDown then
		self:UpdateText(
			string.format("Rejoin in: %05.2f seconds", self._restartTime - SysTime())
		)
	end
end

function PANEL:StartNotice()
	self:SetAlpha(0)
	self:AlphaTo(255, 2, 0)
	self:SetVisible(true)
	local ticksLeft = 8
	timer.Create("AutoRejoinPanel", 4, 8, function()
		ticksLeft = ticksLeft - 1
		self:UpdateMessage(ticksLeft)
	end)

	self:UpdateText("Connection Problem...")
end


function PANEL:EndNotice()
	self:AlphaTo(0, 1, 0, function(anim, pnl)
		pnl:SetVisible(false)
	end)
	self._showRestartCountDown = false
	timer.Remove("AutoRejoinPanel")
	self:UpdateText("Nevermind...")
end

function PANEL:Paint()
	Derma_DrawBackgroundBlur( self, self.createdTime )
end


vgui.Register("TimeoutNotice", PANEL, "DPanel")