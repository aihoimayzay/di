local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIGradient = Instance.new("UIGradient")
local Title = Instance.new("TextLabel")
local SpeedLabel = Instance.new("TextLabel")
local SliderBackground = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local NoclipButton = Instance.new("TextButton")
local NoclipCorner = Instance.new("UICorner")
local AimbotButton = Instance.new("TextButton")
local AimbotCorner = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0.02, 0, 0.1, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.Text = "ẨN MENU"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 14

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 265)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 42, 86)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 132, 227))
}
UIGradient.Parent = MainFrame

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SPEED HUB PREMIUM ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

SpeedLabel.Parent = MainFrame
SpeedLabel.Position = UDim2.new(0, 0, 0.18, 0)
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ hiện tại: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.GothamSemibold
SpeedLabel.TextSize = 14

SliderBackground.Parent = MainFrame
SliderBackground.Position = UDim2.new(0.1, 0, 0.33, 0)
SliderBackground.Size = UDim2.new(0.8, 0, 0, 12)
SliderBackground.BackgroundColor3 = Color3.fromRGB(45, 52, 54)

local SliderBGCorner = Instance.new("UICorner")
SliderBGCorner.CornerRadius = UDim.new(0, 6)
SliderBGCorner.Parent = SliderBackground

SliderButton.Parent = SliderBackground
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(0, 0, -0.3, 0)
SliderButton.BackgroundColor3 = Color3.fromRGB(253, 203, 110)
SliderButton.Text = ""

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

NoclipButton.Name = "NoclipButton"
NoclipButton.Parent = MainFrame
NoclipButton.Position = UDim2.new(0.1, 0, 0.50, 0)
NoclipButton.Size = UDim2.new(0.8, 0, 0, 35)
NoclipButton.BackgroundColor3 = Color3.fromRGB(214, 48, 49)
NoclipButton.Text = "NOCLIP: TẮT"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.GothamBold
NoclipButton.TextSize = 13

NoclipCorner.CornerRadius = UDim.new(0, 8)
NoclipCorner.Parent = NoclipButton

AimbotButton.Name = "AimbotButton"
AimbotButton.Parent = MainFrame
AimbotButton.Position = UDim2.new(0.1, 0, 0.72, 0)
AimbotButton.Size = UDim2.new(0.8, 0, 0, 35)
AimbotButton.BackgroundColor3 = Color3.fromRGB(214, 48, 49)
AimbotButton.Text = "AIM & SHOOT (HOLD E): TẮT"
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.Font = Enum.Font.GothamBold
AimbotButton.TextSize = 13

AimbotCorner.CornerRadius = UDim.new(0, 8)
AimbotCorner.Parent = AimbotButton

local UserInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

local minSpeed = 16
local maxSpeed = 250
local currentSpeed = minSpeed
local dragging = false
local noclip = false
local aimbotActive = false
local holdingAimKey = false
local aimKey = Enum.KeyCode.E

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            if player.Team ~= localPlayer.Team or localPlayer.Team == nil then
                local pos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePosition).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

runService.RenderStepped:Connect(function()
    if localPlayer.Character then
        if localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = currentSpeed
        end
        if noclip then
            for _, part in pairs(localPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
    
    if aimbotActive and holdingAimKey then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
            mouse1click()
        end
    end
end)

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = input.Position.X
        local sliderPos = SliderBackground.AbsolutePosition.X
        local sliderWidth = SliderBackground.AbsoluteSize.X
        
        local percentage = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        SliderButton.Position = UDim2.new(percentage, -10, -0.3, 0)
        
        currentSpeed = math.floor(minSpeed + (percentage * (maxSpeed - minSpeed)))
        SpeedLabel.Text = "Tốc độ hiện tại: " .. tostring(currentSpeed)
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        NoclipButton.Text = "NOCLIP: BẬT"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        NoclipButton.Text = "NOCLIP: TẮT"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(214, 48, 49)
    end
end)

AimbotButton.MouseButton1Click:Connect(function()
    aimbotActive = not aimbotActive
    if aimbotActive then
        AimbotButton.Text = "AIM & SHOOT (HOLD E): BẬT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        AimbotButton.Text = "AIM & SHOOT (HOLD E): TẮT"
        AimbotButton.BackgroundColor3 = Color3.fromRGB(214, 48, 49)
        holdingAimKey = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == aimKey then
        holdingAimKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == aimKey then
        holdingAimKey = false
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleButton.Text = "ẨN MENU"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    else
        ToggleButton.Text = "HIỆN MENU"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end
end)
