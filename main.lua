-- Advanced Cheat GUI for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local TabButtons = Instance.new("Frame")
local AimbotTabButton = Instance.new("TextButton")
local MovementTabButton = Instance.new("TextButton")
local Tabs = Instance.new("Frame")

ScreenGui.Name = "AdvancedCheatGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

-- Title Bar
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)

Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.0
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "Nexus Cheats v2.0"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 14.000
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
CloseButton.Size = UDim2.new(0.1, 0, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(220, 220, 220)
CloseButton.TextSize = 14.000

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Buttons
TabButtons.Name = "TabButtons"
TabButtons.Parent = MainFrame
TabButtons.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0.085, 0)
TabButtons.Size = UDim2.new(1, 0, 0, 30)

AimbotTabButton.Name = "AimbotTabButton"
AimbotTabButton.Parent = TabButtons
AimbotTabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
AimbotTabButton.BorderSizePixel = 0
AimbotTabButton.Size = UDim2.new(0.5, 0, 1, 0)
AimbotTabButton.Font = Enum.Font.GothamSemibold
AimbotTabButton.Text = "AIMBOT"
AimbotTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
AimbotTabButton.TextSize = 12.000

MovementTabButton.Name = "MovementTabButton"
MovementTabButton.Parent = TabButtons
MovementTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MovementTabButton.BorderSizePixel = 0
MovementTabButton.Position = UDim2.new(0.5, 0, 0, 0)
MovementTabButton.Size = UDim2.new(0.5, 0, 1, 0)
MovementTabButton.Font = Enum.Font.GothamSemibold
MovementTabButton.Text = "MOVEMENT"
MovementTabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
MovementTabButton.TextSize = 12.000

-- Tabs Container
Tabs.Name = "Tabs"
Tabs.Parent = MainFrame
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Tabs.BorderSizePixel = 0
Tabs.Position = UDim2.new(0, 0, 0.17, 0)
Tabs.Size = UDim2.new(1, 0, 0.83, 0)

-- Aimbot Tab
local AimbotTab = Instance.new("Frame")
local AimbotToggle = Instance.new("TextButton")
local AimbotStatus = Instance.new("TextLabel")
local SilentAimToggle = Instance.new("TextButton")
local SilentAimStatus = Instance.new("TextLabel")
local FOVCircle = Instance.new("Frame")
local FOVText = Instance.new("TextLabel")

AimbotTab.Name = "AimbotTab"
AimbotTab.Parent = Tabs
AimbotTab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AimbotTab.BorderSizePixel = 0
AimbotTab.Size = UDim2.new(1, 0, 1, 0)
AimbotTab.Visible = true

-- Aimbot Toggle
AimbotToggle.Name = "AimbotToggle"
AimbotToggle.Parent = AimbotTab
AimbotToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
AimbotToggle.Size = UDim2.new(0.45, 0, 0.1, 0)
AimbotToggle.Font = Enum.Font.GothamSemibold
AimbotToggle.Text = "AIMBOT"
AimbotToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
AimbotToggle.TextSize = 12.000

AimbotStatus.Name = "AimbotStatus"
AimbotStatus.Parent = AimbotTab
AimbotStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AimbotStatus.BackgroundTransparency = 1.0
AimbotStatus.Position = UDim2.new(0.55, 0, 0.05, 0)
AimbotStatus.Size = UDim2.new(0.4, 0, 0.1, 0)
AimbotStatus.Font = Enum.Font.GothamSemibold
AimbotStatus.Text = "OFF"
AimbotStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
AimbotStatus.TextSize = 12.000
AimbotStatus.TextXAlignment = Enum.TextXAlignment.Right

-- Silent Aim Toggle
SilentAimToggle.Name = "SilentAimToggle"
SilentAimToggle.Parent = AimbotTab
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SilentAimToggle.BorderSizePixel = 0
SilentAimToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
SilentAimToggle.Size = UDim2.new(0.45, 0, 0.1, 0)
SilentAimToggle.Font = Enum.Font.GothamSemibold
SilentAimToggle.Text = "SILENT AIM"
SilentAimToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
SilentAimToggle.TextSize = 12.000

SilentAimStatus.Name = "SilentAimStatus"
SilentAimStatus.Parent = AimbotTab
SilentAimStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SilentAimStatus.BackgroundTransparency = 1.0
SilentAimStatus.Position = UDim2.new(0.55, 0, 0.2, 0)
SilentAimStatus.Size = UDim2.new(0.4, 0, 0.1, 0)
SilentAimStatus.Font = Enum.Font.GothamSemibold
SilentAimStatus.Text = "OFF"
SilentAimStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
SilentAimStatus.TextSize = 12.000
SilentAimStatus.TextXAlignment = Enum.TextXAlignment.Right

-- FOV Circle (Visual)
FOVCircle.Name = "FOVCircle"
FOVCircle.Parent = AimbotTab
FOVCircle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
FOVCircle.BorderSizePixel = 0
FOVCircle.Position = UDim2.new(0.05, 0, 0.35, 0)
FOVCircle.Size = UDim2.new(0.9, 0, 0.3, 0)

FOVText.Name = "FOVText"
FOVText.Parent = FOVCircle
FOVText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FOVText.BackgroundTransparency = 1.0
FOVText.Size = UDim2.new(1, 0, 1, 0)
FOVText.Font = Enum.Font.GothamSemibold
FOVText.Text = "FOV: 120°"
FOVText.TextColor3 = Color3.fromRGB(220, 220, 220)
FOVText.TextSize = 14.000

-- Movement Tab
local MovementTab = Instance.new("Frame")
local BHOPToggle = Instance.new("TextButton")
local BHOPStatus = Instance.new("TextLabel")
local SpeedToggle = Instance.new("TextButton")
local SpeedStatus = Instance.new("TextLabel")
local SpeedSlider = Instance.new("Frame")
local SpeedText = Instance.new("TextLabel")

MovementTab.Name = "MovementTab"
MovementTab.Parent = Tabs
MovementTab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MovementTab.BorderSizePixel = 0
MovementTab.Size = UDim2.new(1, 0, 1, 0)
MovementTab.Visible = false

-- BHop Toggle
BHOPToggle.Name = "BHOPToggle"
BHOPToggle.Parent = MovementTab
BHOPToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
BHOPToggle.BorderSizePixel = 0
BHOPToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
BHOPToggle.Size = UDim2.new(0.45, 0, 0.1, 0)
BHOPToggle.Font = Enum.Font.GothamSemibold
BHOPToggle.Text = "BUNNY HOP"
BHOPToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
BHOPToggle.TextSize = 12.000

BHOPStatus.Name = "BHOPStatus"
BHOPStatus.Parent = MovementTab
BHOPStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BHOPStatus.BackgroundTransparency = 1.0
BHOPStatus.Position = UDim2.new(0.55, 0, 0.05, 0)
BHOPStatus.Size = UDim2.new(0.4, 0, 0.1, 0)
BHOPStatus.Font = Enum.Font.GothamSemibold
BHOPStatus.Text = "OFF"
BHOPStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
BHOPStatus.TextSize = 12.000
BHOPStatus.TextXAlignment = Enum.TextXAlignment.Right

-- Speed Hack Toggle
SpeedToggle.Name = "SpeedToggle"
SpeedToggle.Parent = MovementTab
SpeedToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SpeedToggle.BorderSizePixel = 0
SpeedToggle.Position = UDim2.new(0.05, 0, 0.2, 0)
SpeedToggle.Size = UDim2.new(0.45, 0, 0.1, 0)
SpeedToggle.Font = Enum.Font.GothamSemibold
SpeedToggle.Text = "SPEED HACK"
SpeedToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedToggle.TextSize = 12.000

SpeedStatus.Name = "SpeedStatus"
SpeedStatus.Parent = MovementTab
SpeedStatus.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedStatus.BackgroundTransparency = 1.0
SpeedStatus.Position = UDim2.new(0.55, 0, 0.2, 0)
SpeedStatus.Size = UDim2.new(0.4, 0, 0.1, 0)
SpeedStatus.Font = Enum.Font.GothamSemibold
SpeedStatus.Text = "OFF"
SpeedStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
SpeedStatus.TextSize = 12.000
SpeedStatus.TextXAlignment = Enum.TextXAlignment.Right

-- Speed Slider (Visual)
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Parent = MovementTab
SpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Position = UDim2.new(0.05, 0, 0.35, 0)
SpeedSlider.Size = UDim2.new(0.9, 0, 0.3, 0)

SpeedText.Name = "SpeedText"
SpeedText.Parent = SpeedSlider
SpeedText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedText.BackgroundTransparency = 1.0
SpeedText.Size = UDim2.new(1, 0, 1, 0)
SpeedText.Font = Enum.Font.GothamSemibold
SpeedText.Text = "SPEED: 16"
SpeedText.TextColor3 = Color3.fromRGB(220, 220, 220)
SpeedText.TextSize = 14.000

-- Tab Switching
AimbotTabButton.MouseButton1Click:Connect(function()
    AimbotTab.Visible = true
    MovementTab.Visible = false
    AimbotTabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    MovementTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
end)

MovementTabButton.MouseButton1Click:Connect(function()
    AimbotTab.Visible = false
    MovementTab.Visible = true
    AimbotTabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    MovementTabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
end)

-- Cheat Functionality
local aimbotEnabled = false
local silentAimEnabled = false
local bhopEnabled = false
local speedEnabled = false
local speedValue = 16

-- Aimbot Function
local function findClosestPlayer()
    local closestDistance = math.huge
    local closestChar = nil
    local fov = 120
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(0.5, 0.5)).Magnitude
                    if distance < closestDistance and distance < (fov / 360) then
                        closestDistance = distance
                        closestChar = player.Character
                    end
                end
            end
        end
    end
    
    return closestChar
end

local function aimAtPlayer()
    if not aimbotEnabled then return end
    
    local closestPlayer = findClosestPlayer()
    
    if closestPlayer and closestPlayer:FindFirstChild("HumanoidRootPart") then
        local targetPosition = closestPlayer.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    end
end

-- Silent Aim Function
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if silentAimEnabled and method == "FindPartOnRayWithIgnoreList" and not checkcaller() then
        local closestPlayer = findClosestPlayer()
        if closestPlayer and closestPlayer:FindFirstChild("Head") then
            args[1] = Ray.new(Camera.CFrame.Position, (closestPlayer.Head.Position - Camera.CFrame.Position).Unit * 1000)
            return oldNamecall(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- BHop and Speed Function
local function handleMovement()
    if not (bhopEnabled or speedEnabled) then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- BHop
    if bhopEnabled and humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    -- Speed Hack
    if speedEnabled then
        humanoid.WalkSpeed = speedValue
    else
        humanoid.WalkSpeed = 16 -- Default speed
    end
end

-- Toggle Functions
AimbotToggle.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotStatus.Text = "ON"
        AimbotStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        AimbotStatus.Text = "OFF"
        AimbotStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

SilentAimToggle.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    if silentAimEnabled then
        SilentAimStatus.Text = "ON"
        SilentAimStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        SilentAimStatus.Text = "OFF"
        SilentAimStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

BHOPToggle.MouseButton1Click:Connect(function()
    bhopEnabled = not bhopEnabled
    if bhopEnabled then
        BHOPStatus.Text = "ON"
        BHOPStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        BHOPStatus.Text = "OFF"
        BHOPStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

SpeedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedStatus.Text = "ON"
        SpeedStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        SpeedStatus.Text = "OFF"
        SpeedStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Connections
RunService.RenderStepped:Connect(aimAtPlayer)
RunService.Heartbeat:Connect(handleMovement)
