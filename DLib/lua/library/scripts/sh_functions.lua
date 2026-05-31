DLib = DLib or {} 
DLib.MaterialCache = DLib.MaterialCache or {}

local DLib = DLib
local white = Color(255,255,255)
local red = Color(255,50,50)

DLib.text = draw.SimpleText
DLib.Cooldowns = DLib.Cooldowns or {}

local baseW, baseH = 1920, 1080

function DLib.Scale(size)

    return size * (ScrW() / baseW)

end

local function CheckCooldown(id, delay)
    local cur = CurTime()
    if (DLib.Cooldowns[id] or 0) > cur then return false end
    DLib.Cooldowns[id] = cur + delay
    return true
end

DLib.ColorTable = {
    ["black"] = Color(0, 0, 0),
    ["white"] = Color(255, 255, 255),
    ["red"] = Color(255,35,35),
    ["green"] = Color(130,255,28),
    ["blue"] = Color(59,95,255),
    ["yellow"] = Color(251,255,1),
    
}


function DLib.Paint(tbl,round,x,y,w,h,col,blur)
    function tbl:Paint(self,w,h)
        RNDX.Draw(round,x,y,w,h,col)
        if blur then
            RNDX.Draw(round,x,y,w,h,col,RNDX.BLUR)
        end
    end
end


function DLib.GetMaterial(matName)
    if IsColor(matName) or type(matName) == "IMaterial" then return matName end
    
    if DLib.MaterialCache[matName] then
        return DLib.MaterialCache[matName]
    end

    local mat = Material(matName, "noclamp smooth")
    
    if mat:IsError() then
        
        if CheckCooldown("err_mat_" .. matName, 2) then
            DLib.Error("Материал не найден: " .. tostring(matName))
            DLib.ShowError("Материал не найден: " .. tostring(matName))
        end
        return mat
    end

    DLib.MaterialCache[matName] = mat
    return mat
end


function DLib.DrawMaterial(matName, x, y, w, h, col)
    local mat = DLib.GetMaterial(matName)
    if not mat then return end

    surface.SetMaterial(mat)
    surface.SetDrawColor(col or color_white)
    surface.DrawTexturedRect(x, y, w, h)
end


function DLib.ShowError(msg)
   
    if not CheckCooldown("show_error_ui", 1) then return end

    if IsValid(DLib.ErrorPanel) then 
        DLib.ErrorPanel:SetErrorMessage(msg)
    else
        DLib.ErrorPanel = vgui.Create("UI.ERROR.PANEL")
        if IsValid(DLib.ErrorPanel) then
            DLib.ErrorPanel:SetErrorMessage(msg)
            timer.Simple(5, function()
                if IsValid(DLib.ErrorPanel) then DLib.ErrorPanel:Remove() end
            end)
        end
    end
end


function DLib.Error(msg)
    if not CheckCooldown("log_error_" .. msg, 3) then return end

    chat.AddText(red, "[DLib] ", white, msg) 
    MsgC(red, "[DLib] ")
    MsgN(msg)
    return msg
end


function DLib.GetHexCol(hex)

    hex = hex:gsub("#", "") 
    local r = tonumber(hex:sub(1, 2), 16) or 255
    local g = tonumber(hex:sub(3, 4), 16) or 255
    local b = tonumber(hex:sub(5, 6), 16) or 255
    local a = tonumber(hex:sub(7, 8), 16) or 255
    return Color(r, g, b, a)
end


function DLib.IsValidHex(hex)
    if type(hex) ~= "string" then return false end
    local cleanHex = hex:gsub("#", "")
    local len = #cleanHex
    if (len == 6 or len == 8) and cleanHex:match("^[0-9a-fA-F]+$") then
        return true
    end
    

    if CheckCooldown("valid_hex_err", 5) then
        DLib.Error("Внимание! Не существует такого hexColor: ".. tostring(hex))
    end
    return false
end


function DLib.GetColor(color)
    if type(color) == "string" then
        if DLib.ColorTable[color] then
            return DLib.ColorTable[color]
        else
            
            if CheckCooldown("get_color_err", 5) then
                DLib.Error("Цвет не найден: ".. tostring(color))
                DLib.ShowError("Цвет не найден: ".. tostring(color))
            end
            return white
        end
    end
    return color or white
end


