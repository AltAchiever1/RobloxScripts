local CoreGui = game:GetService("CoreGui")
for _, child in pairs(CoreGui:GetChildren()) do
    if child:IsA("ScreenGui") and (child.Name:find("AltA") or child.Name:find("FPS")) then
        child:Destroy()
    end
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AltAs_FPS_Spoof_V1"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -120)
MainFrame.Size = UDim2.new(0, 300, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "AltA's FPS Spoof"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local grad = Instance.new("UIGradient", Title)
local phases = {
    {L = Color3.fromRGB(255, 255, 255), R = Color3.fromRGB(150, 150, 150)}, 
    {L = Color3.fromRGB(150, 150, 150), R = Color3.fromRGB(255, 255, 255)},
}

task.spawn(function()
    local RS = game:GetService("RunService")
    local step, progress = 1, 0
    while ScreenGui.Parent do
        progress = progress + 0.03
        if progress >= 1 then 
            progress = 0 
            step = (step % #phases) + 1 
        end
        local nextStep = (step % #phases) + 1
        
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, phases[step].L:Lerp(phases[nextStep].L, progress)),
            ColorSequenceKeypoint.new(1, phases[step].R:Lerp(phases[nextStep].R, progress))
        })
        RS.RenderStepped:Wait()
    end
end)

local function CreateAltABtn(text, pos, isSecondary)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Text = text
    btn.Size = UDim2.new(0.85, 0, 0, 42)
    btn.Position = pos
    
    if isSecondary then
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local FPSInput = Instance.new("TextBox", MainFrame)
FPSInput.PlaceholderText = "Input Desired FPS..."
FPSInput.Text = "240"
FPSInput.Size = UDim2.new(0.85, 0, 0, 42)
FPSInput.Position = UDim2.new(0.075, 0, 0.25, 0)
FPSInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FPSInput.TextColor3 = Color3.new(1, 1, 1)
FPSInput.Font = Enum.Font.GothamSemibold
FPSInput.BorderSizePixel = 1
FPSInput.BorderColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", FPSInput).CornerRadius = UDim.new(0, 6)

local ApplyBtn = CreateAltABtn("SPOOF FPS", UDim2.new(0.075, 0, 0.48, 0), false)
local HideBtn = CreateAltABtn("COLLAPSE", UDim2.new(0.075, 0, 0.73, 0), true)

local FloatBtn = Instance.new("TextButton", ScreenGui)
FloatBtn.Size = UDim2.new(0, 60, 0, 35)
FloatBtn.Position = UDim2.new(0, 10, 0.1, 0)
FloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatBtn.BorderSizePixel = 1
FloatBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Text = "AltA"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Visible = false
FloatBtn.Draggable = true
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 14
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 5)

local originalPrimaryColor = ApplyBtn.BackgroundColor3
local originalPrimaryText = ApplyBtn.TextColor3

ApplyBtn.MouseButton1Click:Connect(function()
    local val = tonumber(FPSInput.Text)
    if val and val > 0 then
        if setfpscap then 
            setfpscap(val) 
            ApplyBtn.Text = "SPOOFED"
            ApplyBtn.BackgroundColor3 = Color3.new(0,0,0)
            ApplyBtn.TextColor3 = Color3.new(1,1,1)
        else
            ApplyBtn.Text = "UNSUPPORTED"
            ApplyBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        end
        task.wait(1.5)
        ApplyBtn.Text = "SPOOF FPS"
        ApplyBtn.BackgroundColor3 = originalPrimaryColor
        ApplyBtn.TextColor3 = originalPrimaryText
    else
        ApplyBtn.Text = "INVALID INPUT"
        task.wait(1.5)
        ApplyBtn.Text = "SPOOF FPS"
    end
end)

HideBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = false 
    FloatBtn.Visible = true 
end)

FloatBtn.MouseButton1Click:Connect(function() 
    MainFrame.Visible = true 
    FloatBtn.Visible = false 
end)
