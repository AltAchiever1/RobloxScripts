-- This Is The One Made By Grok Edited By Gemini As I'll Keep Looking But I Believe They Are The Only 2 That Will Allow You To Make Cheats

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local AimAssistEnabled = false
local ESPEnabled = false
local TracersEnabled = false
local TeamCheck = true
local MaxDistance = 200 -- 200 Meters/Studs
local AimPart = "HumanoidRootPart" -- Middle of the ESP Box
local AimSmoothness = 0.5 
local AssistStrength = 0.2 -- Heavy but smooth pull

local ESPBoxes = {}
local ESPNames = {}
local TracerLines = {}

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AltAsGUI_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true -- Ensure it's visible on start
MainFrame.Parent = ScreenGui

local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(0, 10)
UICorner1.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "AltAs GUI v2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = Content

-- Helper for Toggles
local function CreateToggle(name, default, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
    ToggleBtn.Text = name .. ": " .. (default and "ON" or "OFF")
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = Content

    local UIC = Instance.new("UICorner")
    UIC.CornerRadius = UDim.new(0, 6)
    UIC.Parent = ToggleBtn

    local enabled = default
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        ToggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(40, 40, 40)
        ToggleBtn.Text = name .. ": " .. (enabled and "ON" or "OFF")
        callback(enabled)
    end)
end

CreateToggle("Aimbot", false, function(s) AimbotEnabled = s end)
CreateToggle("Aim Assist", false, function(s) AimAssistEnabled = s end)
CreateToggle("ESP", false, function(s) ESPEnabled = s end)
CreateToggle("Tracers", false, function(s) TracersEnabled = s end)

-- Re-open Button
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.8, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OpenBtn.Text = "OPEN"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Core Functions
local function GetClosestPlayer()
    local target, shortest = nil, math.huge
    local mouse = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimPart) then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end
            
            local part = plr.Character[AimPart]
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude
            
            if dist <= MaxDistance then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
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

-- ESP Drawing Setup
local function CreateVisuals(plr)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Visible = false

    ESPBoxes[plr], ESPNames[plr], TracerLines[plr] = box, name, tracer
end

RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPBoxes[plr] then CreateVisuals(plr) end
            
            local root = plr.Character.HumanoidRootPart
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if ESPEnabled and onScreen and dist <= MaxDistance then
                ESPBoxes[plr].Size = Vector2.new(2000/screenPos.Z, 3000/screenPos.Z)
                ESPBoxes[plr].Position = Vector2.new(screenPos.X - ESPBoxes[plr].Size.X/2, screenPos.Y - ESPBoxes[plr].Size.Y/2)
                ESPBoxes[plr].Color = (plr.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                ESPBoxes[plr].Visible = true

                ESPNames[plr].Text = plr.Name .. " [" .. math.floor(dist) .. "m]"
                ESPNames[plr].Position = Vector2.new(screenPos.X, screenPos.Y - ESPBoxes[plr].Size.Y/2 - 15)
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
    local target = GetClosestPlayer()
    if target then
        local tPos = Camera:WorldToViewportPoint(target.Position)
        local mPos = UserInputService:GetMouseLocation()
        local diff = (Vector2.new(tPos.X, tPos.Y) - mPos)

        if AimbotEnabled then
            mousemoverel(diff.X * AimSmoothness, diff.Y * AimSmoothness)
        elseif AimAssistEnabled then
            -- Heavy Pull logic
            mousemoverel(diff.X * AssistStrength, diff.Y * AssistStrength)
        end
    end
end)
