local DLibScrollPanel = {}

local RNDX = include("library/modules/sh_rndx.lua")

function DLibScrollPanel:Init(x,y)
    self.Canvas = nil
    self.ScrollValue = 0
    self.TargetScrollValue = 0
    self.EnableVerticalScroll = true
    self.dragging = false
    self.dragStartY = 0
    self.startScrollValue = 0
    self.scrollSpeed = 20
    
    -- Анимация
    self.animSpeed = 0.2
    self.velocity = 0
    self.lastScrollTime = 0
    self.inertia = 0.95
    self.bounce = 0.3
    self.isBouncing = false
    self.bounceStart = 0
    self.bounceTarget = 0
    
    self:SetSize(DLib.Scale(400), DLib.Scale(300))
    
    self:CreateCanvas()
    self:CreateScrollBar()
end

function DLibScrollPanel:CreateCanvas()
    self.Canvas = self:Add("DPanel")
    self.Canvas:SetPos(0, 0)
    self.Canvas:SetSize(self:GetWide(), 0)
    self.Canvas.Paint = function(panel, w, h) end
end

function DLibScrollPanel:CreateScrollBar()

    self.ScrollBar = self:Add("DPanel")
    self.ScrollBar:SetWide(DLib.Scale(16))
    self.ScrollBar:SetPos(self:GetWide() - self.ScrollBar:GetWide(), 0)
    self.ScrollBar.Paint = function(panel, w, h)
        RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol("00000050"), RNDX.SHAPE_IOS)
    end
    

    self.ScrollUp = self.ScrollBar:Add("DButton")
    self.ScrollUp:SetSize(self.ScrollBar:GetWide(), DLib.Scale(20))
    self.ScrollUp:SetPos(0, 0)
    self.ScrollUp:SetText("")
    self.ScrollUp.Paint = function(panel, w, h)
        local col = panel:IsHovered() and "ffffff80" or "ffffff50"
        RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol(col), RNDX.SHAPE_IOS)
        draw.SimpleText("▲", "Font.ui.14", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.ScrollUp.DoClick = function()
        self:AddVelocity(-25)
    end
    

    self.ScrollDown = self.ScrollBar:Add("DButton")
    self.ScrollDown:SetSize(self.ScrollBar:GetWide(), DLib.Scale(20))
    self.ScrollDown:SetText("")
    self.ScrollDown.Paint = function(panel, w, h)
        local col = panel:IsHovered() and "ffffff80" or "ffffff50"
        RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol(col), RNDX.SHAPE_IOS)
        draw.SimpleText("▼", "Font.ui.14", w/2, h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    self.ScrollDown.DoClick = function()
        self:AddVelocity(25)
    end
    

    self.ScrollGrip = self.ScrollBar:Add("DPanel")
    self.ScrollGrip:SetWide(self.ScrollBar:GetWide())
    self.ScrollGrip:SetTall(DLib.Scale(40))
    self.ScrollGrip.Paint = function(panel, w, h)
        local col = panel:IsHovered() and "ffffff80" or "ffffff50"
        RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol(col), RNDX.SHAPE_IOS)
    end
    

    self.ScrollGrip.OnMousePressed = function(panel, code)
        if code == MOUSE_LEFT then
            self.dragging = true
            self.velocity = 0
            self.dragStartY = gui.MouseY()
            self.startScrollValue = self.ScrollValue
            return true
        end
    end
    

    self.ScrollBar.OnMousePressed = function(panel, code)
        if code == MOUSE_LEFT and not self.dragging then
            local panelX, panelY = panel:GetPos() 
            local mouseY = gui.MouseY() - panelY
            local gripX, gripY = self.ScrollGrip:GetPos()
            local gripTall = self.ScrollGrip:GetTall()
            
            if mouseY < gripY then
                self:ScrollToWithBounce(self.ScrollValue - self:GetTall())
            elseif mouseY > gripY + gripTall then
                self:ScrollToWithBounce(self.ScrollValue + self:GetTall())
            end
        end
    end
end


function DLibScrollPanel:AddVelocity(vel)
    self.velocity = self.velocity + vel
    self.TargetScrollValue = self.ScrollValue
end


function DLibScrollPanel:ScrollToWithBounce(target)
    local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
    target = math.Clamp(target, 0, maxScroll)
    
    if target ~= self.ScrollValue then
        self.TargetScrollValue = target
        self.animSpeed = 0.15
    end
end

function DLibScrollPanel:ApplyBounce()
    local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
    
    if self.ScrollValue < 0 then
        self.isBouncing = true
        self.bounceStart = self.ScrollValue
        self.bounceTarget = 0
        self.velocity = 0
    elseif self.ScrollValue > maxScroll then
        self.isBouncing = true
        self.bounceStart = self.ScrollValue
        self.bounceTarget = maxScroll
        self.velocity = 0
    else
        self.isBouncing = false
    end
    
    if self.isBouncing then
        self.ScrollValue = self.ScrollValue + (self.bounceTarget - self.ScrollValue) * self.bounce
        if math.abs(self.ScrollValue - self.bounceTarget) < 1 then
            self.ScrollValue = self.bounceTarget
            self.isBouncing = false
        end
        self.TargetScrollValue = self.ScrollValue
    end
end


function DLibScrollPanel:UpdateAnimation()
    if self.dragging then 
        self.velocity = 0
        return 
    end
    
    local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
    

    if math.abs(self.velocity) > 1 then
        self.TargetScrollValue = self.TargetScrollValue + self.velocity
        self.velocity = self.velocity * self.inertia
    else
        self.velocity = 0
    end
    

    self.TargetScrollValue = math.Clamp(self.TargetScrollValue, -20, maxScroll + 20)
    

    local diff = self.TargetScrollValue - self.ScrollValue
    if math.abs(diff) < 0.5 then
        if self.ScrollValue ~= self.TargetScrollValue then
            self.ScrollValue = self.TargetScrollValue
            self.velocity = 0
        end
    else
        self.ScrollValue = self.ScrollValue + diff * self.animSpeed
    end
    

    self:ApplyBounce()
    

    self.Canvas:SetPos(0, -self.ScrollValue)
end

function DLibScrollPanel:Think()
    if not self.ScrollBar then return end
    

    if self.dragging and not input.IsMouseDown(MOUSE_LEFT) then
        self.dragging = false
    end
    

    self:UpdateAnimation()
    

    local trackHeight = self:GetTall() - self.ScrollUp:GetTall() - self.ScrollDown:GetTall()
    local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
    
    if maxScroll > 0 and trackHeight > 0 then
        self.ScrollBar:SetVisible(true)
        

        local gripHeight = math.max(DLib.Scale(30), (self:GetTall() / self.Canvas:GetTall()) * trackHeight)
        self.ScrollGrip:SetTall(math.min(gripHeight, trackHeight))
        

        local gripY = self.ScrollUp:GetTall() + (self.ScrollValue / maxScroll) * (trackHeight - self.ScrollGrip:GetTall())
        gripY = math.Clamp(gripY, self.ScrollUp:GetTall(), self:GetTall() - self.ScrollDown:GetTall() - self.ScrollGrip:GetTall())
        self.ScrollGrip:SetPos(0, gripY)
    else
        self.ScrollBar:SetVisible(false)
    end
    

    if self.dragging then
        local deltaY = gui.MouseY() - self.dragStartY
        local trackHeight = self:GetTall() - self.ScrollUp:GetTall() - self.ScrollDown:GetTall()
        local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
        
        if maxScroll > 0 and trackHeight > self.ScrollGrip:GetTall() then
            local scrollDelta = (deltaY / (trackHeight - self.ScrollGrip:GetTall())) * maxScroll
            local newValue = self.startScrollValue + scrollDelta
            newValue = math.Clamp(newValue, 0, maxScroll)
            self.ScrollValue = newValue
            self.TargetScrollValue = newValue
            self.Canvas:SetPos(0, -self.ScrollValue)
        end
    end
end

function DLibScrollPanel:PerformLayout(w, h)
    if self.Canvas then
        self.Canvas:SetSize(w - (self.ScrollBar and self.ScrollBar:GetWide() or 0), self.Canvas:GetTall())
    end
    
    if self.ScrollBar then
        self.ScrollBar:SetPos(w - self.ScrollBar:GetWide(), 0)
        self.ScrollBar:SetTall(h)
        
        if self.ScrollDown then
            self.ScrollDown:SetPos(0, h - self.ScrollDown:GetTall())
        end
    end
    
    self:UpdateCanvasHeight()
end

function DLibScrollPanel:AddItem(panel)
    if not self.Canvas then return end
    
    panel:SetParent(self.Canvas)
    panel:Dock(TOP)
    panel:SetWide(self.Canvas:GetWide())
    

    panel:SetAlpha(0)
    panel:SetPos(0, panel:GetTall())
    panel:MoveTo(0, 0, 0.3, 0, 0.5)
    panel:AlphaTo(255, 0.3, 0)
    
    self:UpdateCanvasHeight()
    
    return panel
end

function DLibScrollPanel:UpdateCanvasHeight()
    if not self.Canvas then return end
    
    local totalHeight = 0
    local children = self.Canvas:GetChildren()
    
    for k, v in ipairs(children) do
        totalHeight = totalHeight + v:GetTall()
    end
    
    local oldHeight = self.Canvas:GetTall()
    self.Canvas:SetTall(totalHeight)
    
    if totalHeight ~= oldHeight then
        self.TargetScrollValue = self.ScrollValue
    end
end

function DLibScrollPanel:Clear()
    if not self.Canvas then return end
    
    for k, v in ipairs(self.Canvas:GetChildren()) do
        v:Remove()
    end
    
    self.Canvas:SetTall(0)
    self.ScrollValue = 0
    self.TargetScrollValue = 0
    self.velocity = 0
    self.dragging = false
    self:SetScrollValue(0)
end

function DLibScrollPanel:SetVerticalScroll(enabled)
    self.EnableVerticalScroll = enabled
    if self.ScrollBar then
        self.ScrollBar:SetVisible(enabled)
    end
end

function DLibScrollPanel:SetScrollSpeed(speed)
    self.scrollSpeed = speed or 20
end

function DLibScrollPanel:SetAnimationSpeed(speed)
    self.animSpeed = math.Clamp(speed or 0.2, 0.05, 0.5)
end

function DLibScrollPanel:SetInertia(inertia)
    self.inertia = math.Clamp(inertia or 0.95, 0.8, 0.99)
end

function DLibScrollPanel:OnMouseWheeled(delta)
    if not self.EnableVerticalScroll then return end
    if self.ScrollBar and not self.ScrollBar:IsVisible() then return end
    

    local wheelVelocity = -delta * self.scrollSpeed * 2
    self:AddVelocity(wheelVelocity)
    self.TargetScrollValue = self.ScrollValue
    
    return true
end

function DLibScrollPanel:SetScrollValue(value)
    local maxScroll = math.max(0, self.Canvas:GetTall() - self:GetTall())
    self.ScrollValue = math.Clamp(value, 0, maxScroll)
    self.TargetScrollValue = self.ScrollValue
    self.velocity = 0
    self.Canvas:SetPos(0, -self.ScrollValue)
end

function DLibScrollPanel:Paint(w, h)
    RNDX.Draw(10, 0, 0, w, h, nil, RNDX.SHAPE_IOS + RNDX.BLUR)
    RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol("00000050"), RNDX.SHAPE_IOS)
    

    render.SetScissorRect(self:GetX(), self:GetY(), self:GetX() + w, self:GetY() + h, true)
end

function DLibScrollPanel:OnRemove()
    render.SetScissorRect(0, 0, 0, 0, false)
end

vgui.Register("DLib.ScrollPanel", DLibScrollPanel)

-- local scrollFrame = vgui.Create("DLib.Frame")
-- scrollFrame:SetSize(450, 550)
-- scrollFrame:SetHDN("Красивая прокрутка")
-- scrollFrame:Center()
-- scrollFrame:SetHDI("icon16/heart.png")
-- scrollFrame:MakePopup()

-- local scrollPanel = vgui.Create("DLib.ScrollPanel", scrollFrame)
-- scrollPanel:Dock(FILL)
-- scrollPanel:SetScrollSpeed(25)
-- scrollPanel:SetAnimationSpeed(0.2)
-- scrollPanel:SetInertia(0.42)


-- local colors = {
--     Color(255, 100, 100, 100),
--     Color(100, 255, 100, 100),
--     Color(100, 100, 255, 100),
--     Color(255, 255, 100, 100),
--     Color(255, 100, 255, 100),
-- }

-- for i = 1, 25 do
--     local item = vgui.Create("DPanel")
--     item:SetTall(DLib.Scale(60))
--     local col = colors[(i % #colors) + 1]
--     item.Paint = function(panel, w, h)
--         local hover = panel:IsHovered() and 0.3 or 0
--         RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol(string.format("%02x%02x%02x80", col.r, col.g, col.b)), RNDX.SHAPE_IOS)
--         draw.SimpleText("Элемент " .. i, "Font.ui.18", DLib.Scale(15), h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
--         draw.SimpleText("Описание элемента с красивой анимацией", "Font.ui.12", DLib.Scale(15), h/2 + 15, Color(200,200,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
--     end
--     scrollPanel:AddItem(item)
-- end