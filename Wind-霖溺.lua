local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/KingScriptAE/No-sirve-nada./refs/heads/main/main.lua"))()

function gradient(text, startColor, endColor)
    local result = ""
    local chars = {}
    
    for uchar in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(chars, uchar)
    end
    
    local length = #chars
    
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = startColor.R + (endColor.R - startColor.R) * t
        local g = startColor.G + (endColor.G - startColor.G) * t
        local b = startColor.B + (endColor.B - startColor.B) * t
        
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255), 
            chars[i])
    end
    
    return result
end


local Window = WindUI:CreateWindow({
    Title = gradient("Linni SCRIPT Hub", Color3.fromHex("#000080"), Color3.fromHex("#00FFFF")), 
    Author = gradient("@QIU", Color3.fromHex("#00FFAA"), Color3.fromHex("#00AAFF")),
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Folder = "CloudHub",
    Size = UDim2.fromOffset(300, 270),
    Transparent = true,
    Theme = "Sky",
    SideBarWidth = 200,
     HideSearchBar = false,
    ScrollBarEnabled = true,
--    Background = "rbxassetid://99599917888886",
})

Window:EditOpenButton({
    Title = "打开QIU脚本",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 8.),
    StrokeThickness = 3,
    Color = ColorSequence.new(
        Color3.fromHex("000000"),
        Color3.fromHex("FF0000")
    ),
    Draggable = true,
})
-- Window:SetBackgroundImage("rbxassetid://99599917888886")
-- Window:SetBackgroundImageTransparency(0.9)
local Tabs = {
    InfoTab = Window:Tab({ Title = gradient("Info", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FF9900")), Icon = "info" }),
    MainTab = Window:Tab({ Title = gradient("控件", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FF0000")), Icon = "terminal" }),
    SliderTab = Window:Tab({ Title = gradient("Slider", Color3.fromHex("#FFFFFF"), Color3.fromHex("#00FF00")), Icon = "file-cog" }),
    DropdownTab = Window:Tab({ Title = gradient("列表", Color3.fromHex("#FFFFFF"), Color3.fromHex("#0000FF")), Icon = "user" }),
    ColorpickerTab = Window:Tab({ Title = gradient("Colorpicker", Color3.fromHex("#FFFFFF"), Color3.fromHex("#FF00FF")), Icon = "eye" }),
}


Tabs.InfoTab:Section({Title = "Info信息"})

Tabs.InfoTab:Paragraph({
    Title = "联系:",
    Desc = "919191",
    Image = "https://play-lh.googleusercontent.com/7cIIPlWm4m7AGqVpEsIfyL-HW4cQla4ucXnfalMft1TMIYQIlf2vqgmthlZgbNAQoaQ",
    ImageSize = 42,

    ThumbnailSize = 120
})
Tabs.InfoTab:Paragraph({
    Title = "更新信息",
    Desc = "由QIU更新",
    Image = "https://play-lh.googleusercontent.com/7cIIPlWm4m7AGqVpEsIfyL-HW4cQla4ucXnfalMft1TMIYQIlf2vqgmthlZgbNAQoaQ",
    ImageSize = 42,

    ThumbnailSize = 120
})
Tabs.MainTab:Section({Title = "基础控件"})
Tabs.MainTab:Button({
    Title = "Button",
    Callback = function() 
    
    end
})
Tabs.MainTab:Toggle({
    Title = "Toggle with icon",
    Icon = "check",
    Value = false,
    Callback = function(state) print("Toggle with icon activated: " .. tostring(state)) end
})
Tabs.MainTab:Input({
    Title = "Username",
    Value = "Guest",
    Placeholder = "Enter your username",
    Callback = function(input) print("Username: " .. input) end
})

Tabs.SliderTab:Section({Title = "Slider"})
Tabs.SliderTab:Slider({
    Title = "Slider",
    Value = {Min = 0, Max = 200, Default = 16},
    Callback = function(value) 

    end
})


Tabs.DropdownTab:Section({Title = "列表"})
Tabs.DropdownTab:Dropdown({
    Title = "Choose a Category (Multi)",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option) 
        print("Categories selected: " .. game:GetService("HttpService"):JSONEncode(option)) 
    end
})

