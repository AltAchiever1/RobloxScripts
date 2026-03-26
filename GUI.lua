local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AltAsGUI")
if oldGui then oldGui:Destroy() end

local AimbotEnabled = false
local ESPEnabled = false
local TracersEnabled = false
local FOVEnabled = true
local TeamCheck = true
local AimPart = "Head"
local AimSmoothness = 0.15
local FOVRadius = 120

local ESPBoxes = {}
local ESPNames = {}
local TracerLines = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 100
FOVCircle.Radius = FOVRadius
FOVCircle.Filled = false
FOVCircle.Visible = FOVEnabled
FOVCircle.Color = Color3.fromRGB(200, 200, 200)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AltAsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "AltAs GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Content

local function CreateToggle(txt, def, cb)
    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(1, 0, 0, 40)
    Tgl.BackgroundColor3 = def and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
    Tgl.Text = txt .. ": " .. (def and "ON" or "OFF")
    Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tgl.Font = Enum.Font.GothamBold
    Tgl.TextSize = 14
    Tgl.Parent = Content
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Tgl
    
    local state = def
    Tgl.MouseButton1Click:Connect(function()
        state = not state
        Tgl.BackgroundColor3 = state and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
        Tgl.Text = txt .. ": " .. (state and "ON" or "OFF")
        cb(state)
    end)
end

CreateToggle("Aimbot", false, function(s) AimbotEnabled = s end)
CreateToggle("Draw FOV", true, function(s) FOVEnabled = s end)
CreateToggle("ESP Boxes", false, function(s) ESPEnabled = s end)
CreateToggle("Tracers", false, function(s) TracersEnabled = s end)
CreateToggle("Team Check", true, function(s) TeamCheck = s end)

local function GetGrey(p)
    if TeamCheck and p.Team == LocalPlayer.Team then return Color3.fromRGB(100, 100, 100) end
    return Color3.fromRGB(180, 180, 180)
end

local function ClearESP(p)
    if ESPBoxes[p] then ESPBoxes[p]:Remove() ESPBoxes[p] = nil end
    if ESPNames[p] then ESPNames[p]:Remove() ESPNames[p] = nil end
    if TracerLines[p] then TracerLines[p]:Remove() TracerLines[p] = nil end
end

local function GetClosest()
    local target = nil
    local dist = FOVRadius
    local mouse = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(AimPart) and p.Character:FindFirstChild("Humanoid") then
            if TeamCheck and p.Team == LocalPlayer.Team then continue end
            if p.Character.Humanoid.Health <= 0 then continue end

            local pos, vis = Camera:WorldToViewportPoint(p.Character[AimPart].Position)
            if vis then
                local mag = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if mag < dist then
                    dist = mag
                    target = p.Character[AimPart]
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    local mLoc = UserInputService:GetMouseLocation()
    FOVCircle.Position = mLoc
    FOVCircle.Visible = FOVEnabled
    FOVCircle.Radius = FOVRadius

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head")
            local hum = p.Character:FindFirstChild("Humanoid")
            local pos, vis = Camera:WorldToViewportPoint(root.Position)

            if ESPEnabled and vis and hum.Health > 0 then
                if not ESPBoxes[p] then
                    ESPBoxes[p] = Drawing.new("Square")
                    ESPNames[p] = Drawing.new("Text")
                    TracerLines[p] = Drawing.new("Line")
                end

                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
                local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local h = bot.Y - top.Y
                local w = h * 0.6

                local box = ESPBoxes[p]
                box.Visible = true
                box.Size = Vector2.new(w, h)
                box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
                box.Color = GetGrey(p)
                box.Thickness = 2

                local name = ESPNames[p]
                name.Visible = true
                name.Text = p.Name .. " [" .. math.floor(hum.Health) .. "]"
                name.Position = Vector2.new(pos.X, pos.Y - h/2 - 15)
                name.Center = true
                name.Outline = true
                name.Color = Color3.new(1, 1, 1)
                name.Size = 16

                local tr = TracerLines[p]
                tr.Visible = TracersEnabled
                tr.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                tr.To = Vector2.new(pos.X, pos.Y)
                tr.Color = GetGrey(p)
                tr.Thickness = 2
            else
                ClearESP(p)
            end
        else
            ClearESP(p)
        end
    end

    if AimbotEnabled then
        local t = GetClosest()
        if t then
            local tPos = Camera:WorldToViewportPoint(t.Position)
            if mousemoverel then
                mousemoverel((tPos.X - mLoc.X) * AimSmoothness, (tPos.Y - mLoc.Y) * AimSmoothness)
            end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

Players.PlayerRemoving:Connect(ClearESP)
