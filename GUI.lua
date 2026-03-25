-- I Cant Code Lua For the Life Of Me So Im Gonna Test What AI's Do it Best This Is Grok

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local ESPEnabled = false
local TracersEnabled = false
local TeamCheck = true
local AimPart = "Head"
local AimSmoothness = 0.5

local ESPBoxes = {}
local ESPNames = {}
local TracerLines = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AltAsGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 300)
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

CreateToggle("Aimbot", false, function(state) AimbotEnabled = state end)
CreateToggle("ESP (Boxes + Names)", false, function(state) ESPEnabled = state end)
CreateToggle("Tracers", false, function(state) TracersEnabled = state end)

local menuVisible = true
CollapseBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    Content.Visible = menuVisible
    MainFrame.Size = menuVisible and UDim2.new(0, 250, 0, 300) or UDim2.new(0, 250, 0, 50)
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

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

local function GetTeamColor(plr)
    if TeamCheck and plr.Team == LocalPlayer.Team then
        return Color3.fromRGB(100, 100, 100)
    end
    return Color3.fromRGB(180, 180, 180)
end

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1

    local name = Drawing.new("Text")
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(240, 240, 240)

    local tracer = Drawing.new("Line")
    tracer.Thickness = 2
    tracer.Transparency = 0.7

    ESPBoxes[plr] = box
    ESPNames[plr] = name
    TracerLines[plr] = tracer
end

local function UpdateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPBoxes[plr] then CreateESP(plr) end

            local root = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChild("Humanoid")

            local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if ESPEnabled and onScreen then
                local top = Camera:WorldToViewportPoint((head or root).Position + Vector3.new(0, 2.5, 0))
                local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = bottom.Y - top.Y
                local width = height / 2

                local box = ESPBoxes[plr]
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2 + 5)
                box.Color = GetTeamColor(plr)
                box.Visible = true

                local name = ESPNames[plr]
                name.Text = plr.Name .. (humanoid and " ["..math.floor(humanoid.Health).."]" or "")
                name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 15)
                name.Visible = true

                if TracersEnabled then
                    local tracer = TracerLines[plr]
                    tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Color = GetTeamColor(plr)
                    tracer.Visible = true
                else
                    TracerLines[plr].Visible = false
                end
            else
                if ESPBoxes[plr] then ESPBoxes[plr].Visible = false end
                if ESPNames[plr] then ESPNames[plr].Visible = false end
                if TracerLines[plr] then TracerLines[plr].Visible = false end
            end
        end
    end
end

local function GetClosestPlayer()
    local closest = nil
    local shortest = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(AimPart) then
            if TeamCheck and plr.Team == LocalPlayer.Team then continue end

            local part = plr.Character[AimPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if distance < shortest then
                shortest = distance
                closest = part
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    UpdateESP()

    if AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local current = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            local direction = (Vector2.new(targetPos.X, targetPos.Y) - current) * AimSmoothness
            mousemoverel(direction.X, direction.Y)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPBoxes[plr] then ESPBoxes[plr]:Remove() end
    if ESPNames[plr] then ESPNames[plr]:Remove() end
    if TracerLines[plr] then TracerLines[plr]:Remove() end
end)

MainFrame.Visible = true
