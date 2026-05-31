
function DLib.CreateFont(name, size, refW, fontFamily, weight)
    refW = refW or 1920
    fontFamily = fontFamily or "Gilroy"
    weight = weight or 500
    
    local scale = ScrW() / refW
    local finalSize = math.max(8, math.floor(size * scale))
    
    surface.CreateFont(name, {
        font = fontFamily,
        size = finalSize,
        weight = weight,
        antialias = true,
        additive = false,
        shadow = false,
        outline = false
    })
    
    return finalSize
end


function DLib.SetupFonts()
    local neededFonts = {12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 48, 56, 64}
    for _, size in ipairs(neededFonts) do
        DLib.CreateFont("Font.ui." .. size, size)
    end
end


function DLib.CreateFontWeighted(name, size, weight, refW)
    refW = refW or 1920
    local scale = ScrW() / refW
    local finalSize = math.max(8, math.floor(size * scale))
    
    local weights = {
        thin = 100,
        light = 300,
        regular = 400,
        medium = 500,
        semibold = 600,
        bold = 700,
        extrabold = 800,
        black = 900
    }
    
    local finalWeight = weights[weight] or weight or 500
    
    surface.CreateFont(name, {
        font = "Gilroy",
        size = finalSize,
        weight = finalWeight,
        antialias = true
    })
    
    return finalSize
end


function DLib.CreateMonoFont(name, size, refW)
    refW = refW or 1920
    local scale = ScrW() / refW
    local finalSize = math.max(8, math.floor(size * scale))
    
    surface.CreateFont(name, {
        font = "JetBrains Mono",
        size = finalSize,
        weight = 400,
        antialias = true
    })
end


function DLib.GetFontSize(name)
    local fontData = surface.GetFontData(name)
    return fontData and fontData.size or 14
end


function DLib.RefreshFonts()
    DLib.SetupFonts()
    DLib.CreateMonoFont("Font.mono.14", 14)
    DLib.CreateMonoFont("Font.mono.16", 16)
    DLib.CreateFontWeighted("Font.ui.bold.18", 18, "bold")
    DLib.CreateFontWeighted("Font.ui.bold.24", 24, "bold")
end


function DLib.CreateCustomFonts()

    DLib.CreateFontWeighted("Font.title.24", 24, "bold")
    DLib.CreateFontWeighted("Font.title.32", 32, "extrabold")
    

    DLib.CreateFont("Font.text.14", 14)
    DLib.CreateFont("Font.text.16", 16)
    
    DLib.CreateFontWeighted("Font.button.16", 16, "medium")
    DLib.CreateFontWeighted("Font.button.18", 18, "semibold")
    

    DLib.CreateMonoFont("Font.code.12", 12)
    DLib.CreateMonoFont("Font.code.14", 14)
end


DLib.SetupFonts()
DLib.CreateCustomFonts()
DLib.CreateMonoFont("Font.mono.14", 14)

function DLib.GetTextSize(text, font)
    surface.SetFont(font)
    local w, h = surface.GetTextSize(text)
    return w, h
end


function DLib.TruncateText(text, font, maxWidth, truncateStr)
    truncateStr = truncateStr or "..."
    surface.SetFont(font)
    
    local textWidth = surface.GetTextSize(text)
    if textWidth <= maxWidth then
        return text
    end
    
    local truncated = text
    while #truncated > 0 and surface.GetTextSize(truncated .. truncateStr) > maxWidth do
        truncated = truncated:sub(1, -2)
    end
    
    return truncated .. truncateStr
end


function DLib.DrawMultilineText(text, font, x, y, maxWidth, lineHeight, color)
    lineHeight = lineHeight or 20
    surface.SetFont(font)
    
    local words = {}
    for word in string.gmatch(text, "%S+") do
        table.insert(words, word)
    end
    
    local lines = {}
    local currentLine = ""
    
    for _, word in ipairs(words) do
        local testLine = currentLine == "" and word or currentLine .. " " .. word
        local testWidth = surface.GetTextSize(testLine)
        
        if testWidth <= maxWidth then
            currentLine = testLine
        else
            table.insert(lines, currentLine)
            currentLine = word
        end
    end
    
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end
    
    for i, line in ipairs(lines) do
        draw.SimpleText(line, font, x, y + (i-1) * lineHeight, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end
    
    return #lines * lineHeight
end