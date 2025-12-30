-- console.lua

local Console = {}
Console.__index = Console

-- dependencies
local BeautyTable = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/TableBeauty/master/repr.lua"))()
local ConsoleUI =
    (getthreadidentity and getthreadidentity() < 7)
    and loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/RBX-ImGui/main/RBXImGui3.lua"))()
    or loadstring(game:HttpGet("https://raw.githubusercontent.com/Sigmanic/RBX-ImGui/main/RBXImGuiSource.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- colors
local Typelist = {
    Info  = Color3.fromRGB(255, 255, 255),
    Warn  = Color3.fromRGB(255, 230, 30),
    Error = Color3.fromRGB(255, 0, 0),
}

-- constructor
function Console.new()
    local self = setmetatable({}, Console)

    self.Window = ConsoleUI.new({
        text = "ADS - AFK Defense Simulator",
        size = Vector2.new(700, 420),
        shadow = 1,
        rounding = 1,
        transparency = 0.2,
        font = Enum.Font.SourceSansBold,
        position = UDim2.new(0,500,0,100),
    })
    self.Window.open()

    self.ConsoleTab = self.Window.new({
        text = "Console Output",
        autoscrolling = true,
        forcescrollbotom = true,
        font = Enum.Font.SourceSansBold,
    })

    return self
end

-- core printer
function Console:Print(Color, Type, ...)
    Color = typeof(Color) == "Color3" and Color or Typelist.Info
    Type = type(Type) == "string" and Type or "Info"

    local String = ""

    if Type == "Table" then
        local index = 1
        for _, v in next, {...} do
            if type(v) ~= "table" then
                v = { v }
            end
            String ..= (index > 1 and "\n" or "") .. BeautyTable(v)
            index += 1
        end
    else
        local parts = {...}
        for i, v in ipairs(parts) do
            parts[i] = tostring(v)
        end
        String = table.concat(parts, " ")
    end

    for i, line in ipairs(string.split(String, "\n")) do
        self.ConsoleTab.new("label", {
            text = (i == 1 and ("["..os.date("%X").."]["..Type.."] ") or "") .. line,
            color = Typelist[Type],
            font = Enum.Font.Ubuntu,
        })
    end

    if Type == "Info" then
        print("["..os.date("%X").."][Info] "..String)
    elseif Type == "Warn" then
        warn("["..os.date("%X").."][Warn] "..String)
    elseif Type == "Error" then
        error("["..os.date("%X").."][Error] "..String)
    end
end

-- public API
function Console:Info(...)
    self:Print(Typelist.Info, "Info", ...)
end

function Console:Warn(...)
    self:Print(Typelist.Warn, "Warn", ...)
end

function Console:Error(...)
    self:Print(Typelist.Error, "Error", ...)
end

function Console:Table(...)
    self:Print(Typelist.Info, "Table", ...)
end

-- return library
return function()
    return Console.new()
end
