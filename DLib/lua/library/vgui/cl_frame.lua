local DLibFrame = {}

local RNDX = include("library/modules/sh_rndx.lua")

function DLibFrame:Init(x,y)
    self.HeaderName = "Заголовок"
    self.GetMaterialImage = nil
    self.grabXY = false
    self.dragging = false

    self:SetKeyboardInputEnabled(true)
    self:MakePopup()
    self:SetMouseInputEnabled(true)
    self:SetAlpha(0)
    self:AlphaTo(255,0.3,0)
    
    self:SetSize(DLib.Scale(555),DLib.Scale(555))

    self:CreateHeader()
end


function DLibFrame:CreateHeader()
    local parent = self
    self.headerPanel = self:Add("DPanel")
    self.headerPanel:Dock(TOP)
    self.headerPanel:SetHeight(DLib.Scale(40))
    self.headerPanel.Paint = function(panel, w, h)
        RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol("00000050"), RNDX.SHAPE_IOS)
        if parent.HeaderName then
            DLib.text(parent.HeaderName,"Font.ui.18", DLib.Scale(40), DLib.Scale(10))
        end
        if parent.GetMaterialImage then
            RNDX.DrawMaterial(0, DLib.Scale(12), DLib.Scale(12), DLib.Scale(18), DLib.Scale(18), DLib.GetColor("white"), parent.GetMaterialImage)
        end
    end
    
    print(parent.grabXY)

    if self.grabXY then
        self.headerPanel.OnMousePressed = function(panel, code)
            if code == MOUSE_LEFT then
                parent.dragging = true
                parent.dragStartX = gui.MouseX() - parent:GetX()
                parent.dragStartY = gui.MouseY() - parent:GetY()
            end
        end
        
        self.headerPanel.OnMouseReleased = function(panel, code)
            if code == MOUSE_LEFT then
                parent.dragging = false
            end
        end
    end
end


function DLibFrame:Think()
    if self.dragging then
        local x = gui.MouseX() - self.dragStartX
        local y = gui.MouseY() - self.dragStartY
        self:SetPos(x, y)
    end

    if input.IsKeyDown(KEY_ESCAPE) then
        self:AlphaTo(0,0.3,0,function()
            self:Remove()
        end)
    end
end

function DLibFrame:SetGrab()
    self.grabXY = not self.grabXY
    
    if self.grabXY then

        self.headerPanel.OnMousePressed = function(panel, code)
            if code == MOUSE_LEFT then
                self.dragging = true
                self.dragStartX = gui.MouseX() - self:GetX()
                self.dragStartY = gui.MouseY() - self:GetY()
            end
        end
        
        self.headerPanel.OnMouseReleased = function(panel, code)
            if code == MOUSE_LEFT then
                self.dragging = false
            end
        end
    else

        self.dragging = false
        self.headerPanel.OnMousePressed = nil
        self.headerPanel.OnMouseReleased = nil
    end
    
    return self.grabXY
end



function DLibFrame:SetHDN(name)
    self.HeaderName = name
    return self.HeaderName or ""
end

function DLibFrame:HDVisible(stats)
    if self.headerPanel then
        self.headerPanel:SetVisible(stats or true)
    end
end

function DLibFrame:SetHDI(mat)
    self.GetMaterialImage = DLib.GetMaterial(mat)
    return self.GetMaterialImage or DLib.GetMaterial("icon16/heart.png")
end

function DLibFrame:Paint(w,h)
    RNDX.Draw(10, 0, 0, w, h, nil, RNDX.SHAPE_IOS + RNDX.BLUR)
    RNDX.Draw(10, 0, 0, w, h, DLib.GetHexCol("00000050"), RNDX.SHAPE_IOS)
end

vgui.Register("DLib.Frame", DLibFrame,"EditablePanel")

concommand.Add("rD", function()
    for k,v in ipairs(vgui.GetAll()) do

            v:Remove()
    
    end
end)
