-- This Is The One Made By Grok Edited By Gemini As I'll Keep Looking But I Believe They Are The Only 2 That Will Allow You To Make Cheats

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- PREVENT DUPLICATES: Destroys old GUI if it exists
if LocalPlayer.PlayerGui:FindFirstChild("AltAsGUI") then
    LocalPlayer.PlayerGui:FindFirstChild("AltAsGUI"):Destroy()
end

local AimbotEnabled = false
local AimAssistEnabled = false
local ESPEnabled = false
local TracersEnabled = false
local TeamCheck = true
local AimPart = "HumanoidRootPart" -- Middle of ESP
local AimSmoothness = 0.5
local MaxDistance = 200
local FOVRadius = 100

local ESPBoxes = {}
local ESPNames = {}
local TracerLines = {}

-- FOV Circle Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Visible = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AltAsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350) -- Adjusted for extra toggles
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 12)
UICorner1.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "AltAs GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -35, 0, 5)
CollapseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
CollapseBtn.Text = "-"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextScaled = true
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.Parent = MainFrame

local CollapseCorner = Instance.new("UICorner")
CollapseCorner.CornerRadius = UDim.new(0, 8)
CollapseCorner.Parent = CollapseBtn

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Content

local function CreateToggle(name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Parent = Content

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextScaled = true
    Label.Parent = ToggleFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -80, 0.5, -15)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = default and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextScaled = true
    ToggleBtn.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ToggleBtn

    local enabled = default
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
        ToggleBtn.Text = enabled and "ON" or "OFF"
        callback(enabled)
    end)
end

CreateToggle("Aimbot", false, function(s) AimbotEnabled = s FOVCircle.Visible = s end)
CreateToggle("Aim Assist", false, function(s) AimAssistEnabled = s end)
CreateToggle("ESP", false, function(s) ESPEnabled = s end)
CreateToggle("Tracers", false, function(s) TracersEnabled = s end)

local menuVisible = true
CollapseBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    Content.Visible = menuVisible
    MainFrame.Size = menuVisible and UDim2.new(0, 250, 0, 350) or UDim2.new(0, 250, 0, 50)
    CollapseBtn.Text = menuVisible and "-" or "+"
end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
OpenBtn.Text = ">"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextScaled = true
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true end)

local function GetClosestPlayer()
    local target, shortest = nil, FOVRadius
    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimPart) then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local part = plr.Character[AimPart]
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
            
            if dist <= MaxDistance then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    -- Correcting for Topbar offset (36px)
                    local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                    if mouseDist < shortest then
                        shortest = mouseDist
                        target = part
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local mouseLoc = UserInputService:GetMouseLocation()
    FOVCircle.Position = mouseLoc
    FOVCircle.Radius = FOVRadius

    -- Visuals loop
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPBoxes[plr] then
                local box = Drawing.new("Square")
                box.Thickness = 2
                local name = Drawing.new("Text")
                name.Size = 16
                name.Center = true
                name.Outline = true
                local tracer = Drawing.new("Line")
                ESPBoxes[plr], ESPNames[plr], TracerLines[plr] = box, name, tracer
            end

            local root = plr.Character.HumanoidRootPart
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if ESPEnabled and onScreen and dist <= MaxDistance then
                local height = 3000 / screenPos.Z
                local width = height / 1.5
                ESPBoxes[plr].Size = Vector2.new(width, height)
                ESPBoxes[plr].Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
                ESPBoxes[plr].Color = (plr.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                ESPBoxes[plr].Visible = true
                ESPNames[plr].Text = plr.Name .. " [" .. math.floor(dist) .. "]"
                ESPNames[plr].Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 20)
                ESPNames[plr].Visible = true
                if TracersEnabled then
                    TracerLines[plr].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    TracerLines[plr].To = Vector2.new(screenPos.X, screenPos.Y)
                    TracerLines[plr].Visible = true
                else TracerLines[plr].Visible = false end
            else
                ESPBoxes[plr].Visible = false
                ESPNames[plr].Visible = false
                TracerLines[plr].Visible = false
            end
        end
    end

    -- Aim Logic
    if (AimbotEnabled or AimAssistEnabled) and typeof(mousemoverel) == "function" then
        local target = GetClosestPlayer()
        if target then
            local tPos = Camera:WorldToViewportPoint(target.Position)
            local diff = (Vector2.new(tPos.X, tPos.Y) - mouseLoc)
            
            if AimbotEnabled then
                mousemoverel(diff.X * AimSmoothness, diff.Y * AimSmoothness)
            elseif AimAssistEnabled then
                mousemoverel(diff.X * 0.2, diff.Y * 0.2)
            end
        end
    end
end)
