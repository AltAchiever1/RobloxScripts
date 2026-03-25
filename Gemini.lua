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
local MaxDistance = 200 -- Updated to 200
local AimPart = "HumanoidRootPart" -- Middle of the ESP box
local AimSmoothness = 0.5 
local AssistStrength = 0.25 -- Power of the heavy assist

local ESPBoxes = {}
local ESPNames = {}
local TracerLines = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AltAsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350) -- Increased size for new toggle
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
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

CreateToggle("Aimbot", false, function(state) AimbotEnabled = state end)
CreateToggle("Aim Assist", false, function(state) AimAssistEnabled = state end)
CreateToggle("ESP (Boxes + Names)", false, function(state) ESPEnabled = state end)
CreateToggle("Tracers", false, function(state) TracersEnabled = state end)

-- [Logic functions for ESP and Closest Player remain optimized for the new 200m limit]

local function GetClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimPart) then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end
            
            local root = plr.Character[AimPart]
            local distFromMe = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if distFromMe > MaxDistance then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if mouseDist < shortest then
                    shortest = mouseDist
                    closest = root
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    -- ESP Update logic includes the 200m check
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPBoxes[plr] then -- (CreateESP logic here) end
            local root = plr.Character.HumanoidRootPart
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude
            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if ESPEnabled and onScreen and dist <= MaxDistance then
                -- Box and Name drawing logic...
                ESPBoxes[plr].Visible = true
                ESPNames[plr].Visible = true
                TracerLines[plr].Visible = TracersEnabled
            else
                if ESPBoxes[plr] then ESPBoxes[plr].Visible = false end
                if ESPNames[plr] then ESPNames[plr].Visible = false end
                if TracerLines[plr] then TracerLines[plr].Visible = false end
            end
        end
    end

    -- AIMBOT & ASSIST LOGIC
    local target = GetClosestPlayer()
    if target then
        local targetPos = Camera:WorldToViewportPoint(target.Position)
        local mousePos = UserInputService:GetMouseLocation()
        
        if AimbotEnabled then
            -- Strong Lock
            mousemoverel((targetPos.X - mousePos.X) * AimSmoothness, (targetPos.Y - mousePos.Y) * AimSmoothness)
        elseif AimAssistEnabled then
            -- Heavy Assist (Only pulls when you are moving or near target)
            local dist = (Vector2.new(targetPos.X, targetPos.Y) - mousePos).Magnitude
            if dist < 150 then -- Trigger area for assist
                mousemoverel((targetPos.X - mousePos.X) * AssistStrength, (targetPos.Y - mousePos.Y) * AssistStrength)
            end
        end
    end
end)

MainFrame.Visible = true
