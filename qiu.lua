
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/finendss/VowLibrary/refs/heads/main/WINDUI.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local AimEnabled = false
local AuraEnabled = false
local InfiniteJump = false
local AimRadius = 180
local AuraRadius = 25
local AimSmooth = 0.15
local WalkSpeed = 16

local Highlights = {}
local OriginalSpeed = 16

local Window = WindUI:CreateWindow({
    Title = "QIU-监狱人生",
    Icon = "shield",
    Author = "QIU",
    Size = UDim2.fromOffset(580, 420),
    Transparent = true,
    Theme = "Dark",
    HideSearchBar = false,
    ScrollBarEnabled = true,
    Resizable = true
})

Window:EditOpenButton({
    Title = "QIU-监狱人生",
    Icon = "shield",
    CornerRadius = UDim.new(0, 12),
    Draggable = true
})

local PlayerTab = Window:Tab({
    Title = "玩家",
    Icon = "user"
})

local CombatTab = Window:Tab({
    Title = "战斗演示",
    Icon = "crosshair"
})

local VisualTab = Window:Tab({
    Title = "视觉",
    Icon = "eye"
})

local function GetHumanoid()
    local Character = Player.Character
    return Character and Character:FindFirstChildOfClass("Humanoid")
end

PlayerTab:Section({Title = "移动设置"})

PlayerTab:Slider({
    Title = "移动速度",
    Value = {Min = 16, Max = 200, Default = 16},
    Increment = 1,
    Callback = function(Value)
        WalkSpeed = Value
        local Humanoid = GetHumanoid()
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:Toggle({
    Title = "无限跳跃",
    Default = false,
    Callback = function(Value)
        InfiniteJump = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if InfiniteJump then
        local Humanoid = GetHumanoid()
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:Button({
    Title = "还原玩家设置",
    Callback = function()
        WalkSpeed = 16
        local Humanoid = GetHumanoid()
        if Humanoid then
            Humanoid.WalkSpeed = 16
        end
        InfiniteJump = false
        WindUI:Notify({
            Title = "QIU",
            Content = "玩家设置已还原",
            Duration = 3
        })
    end
})

CombatTab:Section({
    Title = "训练假人自瞄",
    TextXAlignment = "Left"
})

CombatTab:Paragraph({
    Title = "训练模式",
    Desc = "只识别 Workspace.QIU_TrainingDummies 文件夹中的训练假人，不锁定真实玩家。"
})

CombatTab:Toggle({
    Title = "训练假人自瞄",
    Default = false,
    Callback = function(Value)
        AimEnabled = Value
    end
})

CombatTab:Slider({
    Title = "自瞄范围",
    Value = {Min = 50, Max = 500, Default = 180},
    Increment = 5,
    Callback = function(Value)
        AimRadius = Value
    end
})

CombatTab:Slider({
    Title = "自瞄平滑度",
    Value = {Min = 1, Max = 100, Default = 15},
    Increment = 1,
    Callback = function(Value)
        AimSmooth = Value / 100
    end
})

CombatTab:Section({
    Title = "杀戮光环演示"
})

CombatTab:Paragraph({
    Title = "安全演示",
    Desc = "仅检测训练假人并显示范围高亮，不会造成伤害，也不会调用游戏攻击 RemoteEvent。"
})

CombatTab:Toggle({
    Title = "训练假人光环",
    Default = false,
    Callback = function(Value)
        AuraEnabled = Value
    end
})

CombatTab:Slider({
    Title = "光环范围",
    Value = {Min = 5, Max = 100, Default = 25},
    Increment = 1,
    Callback = function(Value)
        AuraRadius = Value
    end
})

local function GetDummies()
    local Folder = Workspace:FindFirstChild("QIU_TrainingDummies")
    if not Folder then
        return {}
    end

    local Results = {}

    for _, Model in ipairs(Folder:GetChildren()) do
        if Model:IsA("Model") then
            local Humanoid = Model:FindFirstChildOfClass("Humanoid")
            local Root = Model:FindFirstChild("HumanoidRootPart")

            if Humanoid and Root and Humanoid.Health > 0 then
                table.insert(Results, Model)
            end
        end
    end

    return Results
end

local function GetClosestDummy()
    local Closest = nil
    local Shortest = AimRadius

    for _, Model in ipairs(GetDummies()) do
        local Part = Model:FindFirstChild("Head")
            or Model:FindFirstChild("HumanoidRootPart")

        if Part then
            local Position, Visible =
                Camera:WorldToViewportPoint(Part.Position)

            if Visible then
                local Center = Camera.ViewportSize / 2
                local Distance = (
                    Vector2.new(Position.X, Position.Y) - Center
                ).Magnitude

                if Distance < Shortest then
                    Shortest = Distance
                    Closest = Part
                end
            end
        end
    end

    return Closest
end

local function UpdateAura()
    local Active = {}

    local Character = Player.Character
    local MyRoot = Character and Character:FindFirstChild("HumanoidRootPart")

    if not MyRoot then
        return
    end

    for _, Model in ipairs(GetDummies()) do
        local Root = Model:FindFirstChild("HumanoidRootPart")

        if Root then
            local Distance = (Root.Position - MyRoot.Position).Magnitude

            if Distance <= AuraRadius then
                Active[Model] = true

                if not Highlights[Model] then
                    local Highlight = Instance.new("Highlight")
                    Highlight.FillColor = Color3.fromRGB(170, 70, 255)
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Highlight.FillTransparency = 0.65
                    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    Highlight.Parent = Model

                    Highlights[Model] = Highlight
                end
            end
        end
    end

    for Model, Highlight in pairs(Highlights) do
        if not Active[Model] or not AuraEnabled then
            Highlight:Destroy()
            Highlights[Model] = nil
        end
    end
end

VisualTab:Section({
    Title = "训练视觉"
})

VisualTab:Paragraph({
    Title = "训练假人识别",
    Desc = "通过紫色高亮显示光环范围内的训练假人。"
})

VisualTab:Button({
    Title = "清除全部高亮",
    Callback = function()
        for Model, Highlight in pairs(Highlights) do
            Highlight:Destroy()
            Highlights[Model] = nil
        end
    end
})

RunService.RenderStepped:Connect(function()
    if AimEnabled then
        local Target = GetClosestDummy()

        if Target then
            local Current = Camera.CFrame
            local Desired = CFrame.lookAt(
                Current.Position,
                Target.Position
            )

            Camera.CFrame = Current:Lerp(
                Desired,
                AimSmooth
            )
        end
    end

    if AuraEnabled then
        UpdateAura()
    else
        for Model, Highlight in pairs(Highlights) do
            Highlight:Destroy()
            Highlights[Model] = nil
        end
    end
end)

Player.CharacterAdded:Connect(function()
    task.wait(1)

    local Humanoid = GetHumanoid()
    if Humanoid then
        Humanoid.WalkSpeed = WalkSpeed
    end
end)

WindUI:Notify({
    Title = "QIU-监狱人生",
    Content = "训练版加载完成",
    Duration = 4
})