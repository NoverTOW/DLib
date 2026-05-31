
local loaderConfig = {
    root = "library", 
    color = Color(255, 51, 51),
    prefix = "[DLib] "
}


local function Log(msg)
    MsgC(loaderConfig.color, loaderConfig.prefix, Color(255, 255, 255), msg .. "\n")
end

local function LoadFile(path)
    local fileName = string.GetFileFromFilename(path)
    

    local isShared = fileName:StartWith("sh_")
    local isServer = fileName:StartWith("sv_")
    local isClient = fileName:StartWith("cl_")


    if not (isShared or isServer or isClient) then return end

 
    if isShared then
        AddCSLuaFile(path)
        local status, err = pcall(include, path)
        Log((status and "Loaded Shared: " or "ERROR Shared: ") .. fileName)
        if not status then ErrorNoHalt(err .. "\n") end

    elseif isServer then
        if SERVER then
            local status, err = pcall(include, path)
            Log((status and "Loaded Server: " or "ERROR Server: ") .. fileName)
            if not status then ErrorNoHalt(err .. "\n") end
        end


    elseif isClient then
        AddCSLuaFile(path)
        if CLIENT then
            local status, err = pcall(include, path)
            Log((status and "Loaded Client: " or "ERROR Client: ") .. fileName)
            if not status then ErrorNoHalt(err .. "\n") end
        end
    end
end

local function RecursiveLoader(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

    for _, f in ipairs(files) do
        LoadFile(dir .. "/" .. f)
    end

    for _, folder in ipairs(folders) do
        RecursiveLoader(dir .. "/" .. folder)
    end
end



RecursiveLoader(loaderConfig.root)
