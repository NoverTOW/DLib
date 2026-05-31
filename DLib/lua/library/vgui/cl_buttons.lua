local DLibButton = {}
local RNDX = include("library/modules/sh_rndx.lua")


local ButtonStyles = {
    primary = {
        color = "2196F3",
        hover = "1976D2",
        press = "0D47A1",
        text = "FFFFFF",
        icon = "icon16/accept.png"
    },
    success = {
        color = "4CAF50",
        hover = "388E3C",
        press = "1B5E20",
        text = "FFFFFF",
        icon = "icon16/tick.png"
    },
    danger = {
        color = "F44336",
        hover = "D32F2F",
        press = "B71C1C",
        text = "FFFFFF",
        icon = "icon16/cross.png"
    },
    warning = {
        color = "FF9800",
        hover = "F57C00",
        press = "E65100",
        text = "FFFFFF",
        icon = "icon16/exclamation.png"
    },
    dark = {
        color = "424242",
        hover = "616161",
        press = "212121",
        text = "FFFFFF",
        icon = "icon16/application.png"
    },
    ghost = {
        color = "00000000",
        hover = "FFFFFF20",
        press = "FFFFFF30",
        text = "FFFFFF",
        icon = "icon16/arrow.png"
    },
    glass = {
        color = "FFFFFF20",
        hover = "FFFFFF40",
        press = "FFFFFF60",
        text = "FFFFFF",
        icon = "icon16/heart.png"
    }
}

function DLibButton:Init(x, y)
    self.Style = "primary"
    self.ButtonText = "Кнопка"
    self.ButtonIcon = nil
    self.Hovered = false
    self.Pressed = false
    self.Disabled = false
    self.SoundClick = true
    self.RippleSize = 0
    self.RippleAlpha = 0
    self.ClickFunction = nil
    
    self:SetSize(DLib.Scale(120), DLib.Scale(36))
    self:SetCursor("hand")
end

function DLibButton:SetStyle(style)
    if ButtonStyles[style] then
        self.Style = style
        return true
    end
    return false
end

function DLibButton:SetText(text)
    self.ButtonText = text or "Кнопка"
end

function DLibButton:SetIcon(icon)
    if icon then
        self.ButtonIcon = DLib.GetMaterial(icon)
    end
end

function DLibButton:SetEnabled(enabled)
    self.Disabled = not enabled
    if self.Disabled then
        self:SetCursor("arrow")
    else
        self:SetCursor("hand")
    end
end

function DLibButton:DoClick()
    if self.Disabled then return end
    
    if self.SoundClick then
        surface.PlaySound("ui/buttonclick.wav")
    end
    

    self.Pressed = true
    timer.Simple(0.1, function()
        if IsValid(self) then
            self.Pressed = false
        end
    end)
    
    if self.ClickFunction then
        self.ClickFunction(self)
    end
end

function DLibButton:OnMousePressed(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self.Pressed = true

        self.RippleSize = 5
        self.RippleAlpha = 150
    end
end

function DLibButton:OnMouseReleased(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self:DoClick()
        self.Pressed = false
    end
end

function DLibButton:OnCursorEntered()
    if self.Disabled then return end
    self.Hovered = true
    surface.PlaySound("ui/buttonrollover.wav")
end

function DLibButton:OnCursorExited()
    self.Hovered = false
    self.Pressed = false
end

function DLibButton:Think()

    if self.RippleAlpha > 0 then
        self.RippleSize = self.RippleSize + FrameTime() * 500
        self.RippleAlpha = self.RippleAlpha - FrameTime() * 300
        
        if self.RippleAlpha <= 0 then
            self.RippleSize = 0
            self.RippleAlpha = 0
        end
    end
end

function DLibButton:Paint(w, h)
    local style = ButtonStyles[self.Style]
    if not style then style = ButtonStyles["primary"] end
    

    local bgColor
    if self.Disabled then
        bgColor = DLib.GetHexCol("42424260")
    elseif self.Pressed then
        bgColor = DLib.GetHexCol(style.press)
    elseif self.Hovered then
        bgColor = DLib.GetHexCol(style.hover)
    else
        bgColor = DLib.GetHexCol(style.color)
    end
    

    RNDX.Draw(8, 0, 0, w, h, bgColor, RNDX.SHAPE_IOS)
    

    if self.Hovered and not self.Disabled then
        RNDX.Draw(8, 0, 0, w, h, DLib.GetHexCol("FFFFFF15"), RNDX.SHAPE_IOS)
    end
    

    if self.RippleAlpha > 0 then
        local rippleColor = DLib.GetHexCol("FFFFFF20", self.RippleAlpha / 255)
        RNDX.DrawCircle(w/2, h/2, self.RippleSize, rippleColor)
    end
    

    local textColor = DLib.GetHexCol(style.text)
    local textX = w/2
    
    if self.ButtonIcon then
        local iconSize = DLib.Scale(16)
        local textWidth = DLib.GetTextSize(self.ButtonText, "Font.ui.14")
        local iconX = w/2 - textWidth/2 - iconSize - DLib.Scale(5)
        local iconY = h/2 - iconSize/2
        
        if iconX > 0 then
            RNDX.DrawMaterial(8, iconX, iconY, iconSize, iconSize, textColor, self.ButtonIcon)
            textX = w/2 + iconSize/2 + DLib.Scale(5)
        else

            RNDX.DrawMaterial(8, w/2 - iconSize/2, iconY, iconSize, iconSize, textColor, self.ButtonIcon)
            textX = w/2
        end
    end
    
    if self.ButtonText and self.ButtonText ~= "" then
        DLib.text(self.ButtonText, "Font.ui.14", textX, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    

    -- if self.Hovered and not self.Disabled then
    --     surface.SetDrawColor(DLib.GetHexCol("FFFFFF30"))
    --     surface.DrawOutlinedRect(0, 0, w, h)
    -- end
end

vgui.Register("DLib.Button", DLibButton)


local DLibBigButton = {}

function DLibBigButton:Init(x, y)
    self:SetSize(DLib.Scale(200), DLib.Scale(80))
    self.Style = "primary"
    self.ButtonText = "Кнопка"
    self.ButtonIcon = nil
    self.Hovered = false
    self.Pressed = false
    self.Disabled = false
    self.SoundClick = true
    self.ClickFunction = nil
    
    self:SetCursor("hand")
end

function DLibBigButton:SetStyle(style)
    if ButtonStyles[style] then
        self.Style = style
        return true
    end
    return false
end

function DLibBigButton:SetText(text)
    self.ButtonText = text or "Кнопка"
end

function DLibBigButton:SetIcon(icon)
    if icon then
        self.ButtonIcon = DLib.GetMaterial(icon)
    end
end

function DLibBigButton:SetEnabled(enabled)
    self.Disabled = not enabled
    if self.Disabled then
        self:SetCursor("arrow")
    else
        self:SetCursor("hand")
    end
end

function DLibBigButton:DoClick()
    if self.Disabled then return end
    
    if self.SoundClick then
        surface.PlaySound("ui/buttonclick.wav")
    end
    
    self.Pressed = true
    timer.Simple(0.1, function()
        if IsValid(self) then
            self.Pressed = false
        end
    end)
    
    if self.ClickFunction then
        self.ClickFunction(self)
    end
end

function DLibBigButton:OnMousePressed(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self.Pressed = true
    end
end

function DLibBigButton:OnMouseReleased(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self:DoClick()
        self.Pressed = false
    end
end

function DLibBigButton:OnCursorEntered()
    if self.Disabled then return end
    self.Hovered = true
    surface.PlaySound("ui/buttonrollover.wav")
end

function DLibBigButton:OnCursorExited()
    self.Hovered = false
    self.Pressed = false
end

function DLibBigButton:Paint(w, h)
    local style = ButtonStyles[self.Style]
    if not style then style = ButtonStyles["primary"] end
    
    local bgColor
    if self.Disabled then
        bgColor = DLib.GetHexCol("42424260")
    elseif self.Pressed then
        bgColor = DLib.GetHexCol(style.press)
    elseif self.Hovered then
        bgColor = DLib.GetHexCol(style.hover)
    else
        bgColor = DLib.GetHexCol(style.color)
    end
    
    RNDX.Draw(12, 0, 0, w, h, bgColor, RNDX.SHAPE_IOS)
    
    if self.Hovered and not self.Disabled then
        RNDX.Draw(12, 0, 0, w, h, DLib.GetHexCol("FFFFFF15"), RNDX.SHAPE_IOS)
    end
    

    local iconSize = DLib.Scale(32)
    
    if self.ButtonIcon then
        RNDX.DrawMaterial(12, w/2 - iconSize/2, DLib.Scale(15), iconSize, iconSize, DLib.GetHexCol(style.text), self.ButtonIcon)
        if self.ButtonText and self.ButtonText ~= "" then
            DLib.text(self.ButtonText, "Font.ui.18", w/2, h - DLib.Scale(25), DLib.GetHexCol(style.text), TEXT_ALIGN_CENTER)
        end
    else
        if self.ButtonText and self.ButtonText ~= "" then
            DLib.text(self.ButtonText, "Font.ui.18", w/2, h/2, DLib.GetHexCol(style.text), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

vgui.Register("DLib.BigButton", DLibBigButton)


local DLibToggleButton = {}

function DLibToggleButton:Init(x, y)
    self.Style = "primary"
    self.ButtonText = "Кнопка"
    self.ButtonIcon = nil
    self.Hovered = false
    self.Pressed = false
    self.Disabled = false
    self.Toggled = false
    self.SoundClick = true
    self.ClickFunction = nil
    
    self:SetSize(DLib.Scale(150), DLib.Scale(36))
    self:SetCursor("hand")
end

function DLibToggleButton:SetStyle(style)
    if ButtonStyles[style] then
        self.Style = style
        return true
    end
    return false
end

function DLibToggleButton:SetText(text)
    self.ButtonText = text or "Кнопка"
end

function DLibToggleButton:SetEnabled(enabled)
    self.Disabled = not enabled
    if self.Disabled then
        self:SetCursor("arrow")
    else
        self:SetCursor("hand")
    end
end

function DLibToggleButton:DoClick()
    if self.Disabled then return end
    self.Toggled = not self.Toggled
    self.Pressed = true
    
    if self.SoundClick then
        surface.PlaySound("ui/buttonclick.wav")
    end
    
    timer.Simple(0.1, function()
        if IsValid(self) then
            self.Pressed = false
            if self.ClickFunction then
                self.ClickFunction(self, self.Toggled)
            end
        end
    end)
end

function DLibToggleButton:OnMousePressed(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self.Pressed = true
    end
end

function DLibToggleButton:OnMouseReleased(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self:DoClick()
        self.Pressed = false
    end
end

function DLibToggleButton:OnCursorEntered()
    if self.Disabled then return end
    self.Hovered = true
    surface.PlaySound("ui/buttonrollover.wav")
end

function DLibToggleButton:OnCursorExited()
    self.Hovered = false
    self.Pressed = false
end

function DLibToggleButton:Paint(w, h)
    local style = ButtonStyles[self.Style]
    if not style then style = ButtonStyles["primary"] end
    
    local bgColor
    if self.Disabled then
        bgColor = DLib.GetHexCol("42424260")
    elseif self.Toggled then
        bgColor = DLib.GetHexCol(style.color)
    elseif self.Pressed then
        bgColor = DLib.GetHexCol(style.press)
    elseif self.Hovered then
        bgColor = DLib.GetHexCol(style.hover)
    else
        bgColor = DLib.GetHexCol(style.color .. "60")
    end
    
    RNDX.Draw(8, 0, 0, w, h, bgColor, RNDX.SHAPE_IOS)
    

    if self.Toggled then
        RNDX.Draw(8, w - DLib.Scale(25), h/2 - DLib.Scale(6), DLib.Scale(12), DLib.Scale(12), DLib.GetHexCol("4CAF50"), RNDX.SHAPE_IOS)
    else
        RNDX.Draw(8, w - DLib.Scale(25), h/2 - DLib.Scale(6), DLib.Scale(12), DLib.Scale(12), DLib.GetHexCol("F44336"), RNDX.SHAPE_IOS)
    end
    
    local textColor = DLib.GetHexCol(style.text)
    if self.ButtonText and self.ButtonText ~= "" then
        DLib.text(self.ButtonText, "Font.ui.14", DLib.Scale(15), h/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

vgui.Register("DLib.ToggleButton", DLibToggleButton)


local DLibIconButton = {}

function DLibIconButton:Init(x, y)
    self:SetSize(DLib.Scale(36), DLib.Scale(36))
    self.Style = "dark"
    self.ButtonIcon = nil
    self.Hovered = false
    self.Pressed = false
    self.Disabled = false
    self.SoundClick = true
    self.ClickFunction = nil
    
    self:SetCursor("hand")
end

function DLibIconButton:SetStyle(style)
    if ButtonStyles[style] then
        self.Style = style
        return true
    end
    return false
end

function DLibIconButton:SetIcon(icon)
    if icon then
        self.ButtonIcon = DLib.GetMaterial(icon)
    end
end

function DLibIconButton:SetEnabled(enabled)
    self.Disabled = not enabled
    if self.Disabled then
        self:SetCursor("arrow")
    else
        self:SetCursor("hand")
    end
end

function DLibIconButton:DoClick()
    if self.Disabled then return end
    
    if self.SoundClick then
        surface.PlaySound("ui/buttonclick.wav")
    end
    
    self.Pressed = true
    timer.Simple(0.1, function()
        if IsValid(self) then
            self.Pressed = false
        end
    end)
    
    if self.ClickFunction then
        self.ClickFunction(self)
    end
end

function DLibIconButton:OnMousePressed(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self.Pressed = true
    end
end

function DLibIconButton:OnMouseReleased(code)
    if self.Disabled then return end
    if code == MOUSE_LEFT then
        self:DoClick()
        self.Pressed = false
    end
end

function DLibIconButton:OnCursorEntered()
    if self.Disabled then return end
    self.Hovered = true
    surface.PlaySound("ui/buttonrollover.wav")
end

function DLibIconButton:OnCursorExited()
    self.Hovered = false
    self.Pressed = false
end

function DLibIconButton:Paint(w, h)
    local style = ButtonStyles[self.Style]
    if not style then style = ButtonStyles["dark"] end
    
    local bgColor
    if self.Disabled then
        bgColor = DLib.GetHexCol("42424260")
    elseif self.Pressed then
        bgColor = DLib.GetHexCol(style.press)
    elseif self.Hovered then
        bgColor = DLib.GetHexCol(style.hover)
    else
        bgColor = DLib.GetHexCol(style.color)
    end
    
    RNDX.Draw(6, 0, 0, w, h, bgColor, RNDX.SHAPE_CIRCLE)
    
    if self.ButtonIcon then
        local iconSize = DLib.Scale(20)
        RNDX.DrawMaterial(6, w/2 - iconSize/2, h/2 - iconSize/2, iconSize, iconSize, DLib.GetHexCol(style.text), self.ButtonIcon)
    end
end

vgui.Register("DLib.IconButton", DLibIconButton)


function DLib.CreateButton(parent, text, style, onClick)
    local btn = vgui.Create("DLib.Button", parent)
    btn:SetText(text)
    if style then btn:SetStyle(style) end
    if onClick then btn.ClickFunction = onClick end
    return btn
end

function DLib.CreateBigButton(parent, text, icon, style, onClick)
    local btn = vgui.Create("DLib.BigButton", parent)
    btn:SetText(text)
    if icon then btn:SetIcon(icon) end
    if style then btn:SetStyle(style) end
    if onClick then btn.ClickFunction = onClick end
    return btn
end

function DLib.CreateToggleButton(parent, text, style, onClick)
    local btn = vgui.Create("DLib.ToggleButton", parent)
    btn:SetText(text)
    if style then btn:SetStyle(style) end
    if onClick then btn.ClickFunction = onClick end
    return btn
end

function DLib.CreateIconButton(parent, icon, style, onClick)
    local btn = vgui.Create("DLib.IconButton", parent)
    if icon then btn:SetIcon(icon) end
    if style then btn:SetStyle(style) end
    if onClick then btn.ClickFunction = onClick end
    return btn
end

print("[DLib] Button system loaded successfully!")

-- local frame = vgui.Create("DLib.Frame")
-- frame:SetSize(500,500)
-- local btn = DLib.CreateButton(frame, "Нажми меня", "success", function()
--     print("Button clicked!")
-- end)
-- btn:SetPos(10, 50)

-- local bigBtn = DLib.CreateBigButton(frame, "Купить", "icon16/cart.png", "primary")
-- bigBtn:SetPos(10, 100)

-- local toggle = DLib.CreateToggleButton(frame, "Авто-обнов222ление", "ghost")
-- toggle:SetPos(10, 200)
-- toggle.ClickFunction = function(btn, state)
--     print("Toggle state:", state)
-- end

-- local iconBtn = DLib.CreateIconButton(frame, "icon16/cog.png", "dark")
-- iconBtn:SetPos(10, 260)
-- iconBtn.ClickFunction = function() print("Settings") end