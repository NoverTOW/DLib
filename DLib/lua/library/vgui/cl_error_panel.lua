local ERROR = {}
local RNDX = include("library/modules/sh_rndx.lua")
local ss = DLib.Scale
local errorPanel 
local x, y = ScrW(),ScrH()


surface.CreateFont( "test", {
	font = "Arial", 
	extended = false,
	size = 38,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ERROR:Init()

    self:SetSize(ss(520),ss(220))
    self:SetPos(ss(700),ss(900))
    self:SetAlpha(0)

    self:AlphaTo(255, 0.5, 0)
    
    self.Label = self:Add("DLabel")
    local currentX, currentY = self.Label:GetPos() + 52
    self.Label:SetPos(currentX, ss(100))
    self.Label:SetFont("test")

    self.Label:SetTextColor(DLib.GetColor("black"))
end

function ERROR:remove()
    self:AlphaTo(0, 0.5, 0,function()
        self:Remove()
    end)
end


function ERROR:SetErrorMessage(text)
    if IsValid(self.Label) then
        self.Label:SetText(text)
        self.Label:SizeToContents()
    end
end

function ERROR:CreatePanel(msg)
    if !IsValid(errorPanel) then
        errorPanel = vgui.Create("UI.ERROR.PANEL")
        errorPanel:SetErrorMessage(msg)
    else
        errorPanel:remove()
    end
end
function ERROR:Paint(w,h)
local col = DLib.GetColor("white")
    local alpha = self:GetAlpha()
    
    surface.SetDrawColor(col.r, col.g, col.b, alpha)
    surface.SetMaterial(DLib.GetMaterial("data/Ellipse2.png") or DLib.GetMaterial("icon16/heart.png"))
    surface.DrawTexturedRect(0, 0, w, h)
end

vgui.Register("UI.ERROR.PANEL",ERROR,"PANEL")

concommand.Add("DLib.ERROR", function(ply, cmd, args)
    if #args == 0 then
        print("Вы не ввели сообщение!")
        return
    end

    local message = table.concat(args, " ")

    ERROR:CreatePanel(message)
end)



