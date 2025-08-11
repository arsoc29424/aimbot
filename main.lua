-- Create the main GUI frame
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local AimbotButton = Instance.new("TextButton")

ScreenGui.Name = "AimbotGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.8, 0, 0.7, 0)
Frame.Size = UDim2.new(0.15, 0, 0.1, 0)

AimbotButton.Name = "AimbotButton"
AimbotButton.Parent = Frame
AimbotButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AimbotButton.BorderColor3 = Color3.fromRGB(30, 30, 30)
AimbotButton.Position = UDim2.new(0.1, 0, 0.1, 0)
AimbotButton.Size = UDim2.new(0.8, 0, 0.8, 0)
AimbotButton.Font = Enum.Font.SourceSans
AimbotButton.Text = "AIMBOT: OFF"
AimbotButton.TextColor3 = Color3.fromRGB(255, 50, 50)
AimbotButton.TextSize = 14.000

-- Aimbot variables
local aimbotEnabled = false
local camera = workspace.CurrentCamera
local localPlayer = game.Players.LocalPlayer
local closestPlayer = nil
local aimbotConnection = nil

-- Function to find the closest player
local function findClosestPlayer()
    local closestDistance = math.huge
    local closestChar = nil
    
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - camera.CFrame.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestChar = player.Character
                end
            end
        end
    end
    
    return closestChar
end

-- Function to aim at the closest player
local function aimAtPlayer()
    if not aimbotEnabled then return end
    
    closestPlayer = findClosestPlayer()
    
    if closestPlayer and closestPlayer:FindFirstChild("HumanoidRootPart") then
        local targetPosition = closestPlayer.HumanoidRootPart.Position
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    end
end

-- Toggle aimbot function
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    
    if aimbotEnabled then
        AimbotButton.Text = "AIMBOT: ON"
        AimbotButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Run the aimbot every frame
        aimbotConnection = game:GetService("RunService").RenderStepped:Connect(aimAtPlayer)
    else
        AimbotButton.Text = "AIMBOT: OFF"
        AimbotButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Disconnect the aimbot
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end

-- Connect the button click
AimbotButton.MouseButton1Click:Connect(toggleAimbot)

-- Make the frame draggable
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
