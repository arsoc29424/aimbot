-- LocalScript: AimbotGUIAndLogic.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CONFIGURAÇÕES PADRÃO
local settings = {
    AimKey = Enum.KeyCode.E,
    AimMode = "Hold", -- "Hold", "Toggle", "Always"
    DrawFOV = true,
    FOVRadius = 150,
    AimPart = "Head",
    MaxDistance = 300,
    Smoothness = 0.15,
    TeamCheck = false,
}

-- ESTADO
local aiming = false
local toggled = false
local dragging = false
local dragStartPos = Vector2.new(0, 0)
local guiStartPos = Vector2.new(0, 0)
local guiVisible = true

-- GUI
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "AimbotUI"
screenGui.ResetOnSpawn = false

-- Círculo do FOV
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
fovCircle.Position = UDim2.new(0.5, -settings.FOVRadius, 0.5, -settings.FOVRadius)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
fovCircle.BorderSizePixel = 0
fovCircle.BackgroundTransparency = 0.8
fovCircle.Visible = settings.DrawFOV
fovCircle.ZIndex = 5
fovCircle.Parent = screenGui

local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)

-- GUI de opções
local guiFrame = Instance.new("Frame", screenGui)
guiFrame.Size = UDim2.new(0, 250, 0, 300)
guiFrame.Position = UDim2.new(0, 10, 0, 10)
guiFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
guiFrame.BorderSizePixel = 0
guiFrame.Name = "Settings"
guiFrame.ZIndex = 10

-- Título da GUI
local title = Instance.new("TextLabel", guiFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Aimbot Settings"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.BorderSizePixel = 0
title.ZIndex = 11

-- Botão de fechar (X)
local closeButton = Instance.new("TextButton", title)
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 12

closeButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    guiFrame.Visible = guiVisible
    -- Se estiver fechando, desativa o aimbot
    if not guiVisible then
        aiming = false
        toggled = false
    end
end)

-- Barra de arrastar
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        guiStartPos = Vector2.new(guiFrame.Position.X.Offset, guiFrame.Position.Y.Offset)
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        guiFrame.Position = UDim2.new(0, guiStartPos.X + delta.X, 0, guiStartPos.Y + delta.Y)
    end
end)

-- Botão de minimizar
local minimizeButton = Instance.new("TextButton", title)
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.ZIndex = 12

local contentVisible = true
minimizeButton.MouseButton1Click:Connect(function()
    contentVisible = not contentVisible
    minimizeButton.Text = contentVisible and "-" or "+"
    for _, child in ipairs(guiFrame:GetChildren()) do
        if child ~= title and child ~= minimizeButton and child ~= closeButton then
            child.Visible = contentVisible
        end
    end
    guiFrame.Size = UDim2.new(0, 250, 0, contentVisible and 300 or 30)
end)

-- Container para as opções
local optionsFrame = Instance.new("Frame", guiFrame)
optionsFrame.Size = UDim2.new(1, -20, 1, -40)
optionsFrame.Position = UDim2.new(0, 10, 0, 40)
optionsFrame.BackgroundTransparency = 1
optionsFrame.Name = "Options"
optionsFrame.ZIndex = 11

local uiList = Instance.new("UIListLayout", optionsFrame)
uiList.Padding = UDim.new(0, 8)

-- [...] (O resto do código permanece igual, com as funções createToggle, createDropdown, etc.)

-- Lógica do aimbot melhorada
local function getClosestTarget()
    if not guiVisible then return nil end -- Não mira se a GUI estiver fechada
    
    local closest = nil
    local shortestAngle = math.rad(settings.FOVRadius)
    local mousePos = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            -- Verificação de time
            if settings.TeamCheck and player.Team == localPlayer.Team then
                continue
            end
            
            local part = player.Character:FindFirstChild(settings.AimPart)
            if not part then continue end
            
            -- Verifica se o jogador está vivo
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end
            
            -- Cálculo de distância e ângulo
            local direction = (part.Position - camera.CFrame.Position).Unit
            local angle = math.acos(camera.CFrame.LookVector:Dot(direction))
            local distance = (camera.CFrame.Position - part.Position).Magnitude

            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

            if angle < shortestAngle and distance <= settings.MaxDistance and distToMouse <= settings.FOVRadius then
                -- Verificação de obstáculos
                local ray = Ray.new(camera.CFrame.Position, direction * distance)
                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, camera})

                if hit and part:IsDescendantOf(hit.Parent) then
                    closest = part
                    shortestAngle = angle
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if settings.DrawFOV then
        fovCircle.Position = UDim2.new(0, UserInputService:GetMouseLocation().X, 0, UserInputService:GetMouseLocation().Y)
        fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
    end

    if settings.AimMode == "Always" then
        aiming = guiVisible -- Só mira se a GUI estiver visível
    elseif settings.AimMode == "Hold" then
        aiming = UserInputService:IsKeyDown(settings.AimKey) and guiVisible
    end

    if (aiming or toggled) and guiVisible then
        local target = getClosestTarget()
        if target then
            local direction = (target.Position - camera.CFrame.Position).Unit
            local newLook = camera.CFrame.LookVector:Lerp(direction, settings.Smoothness)
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + newLook)
        end
    end
end)

-- Input para modo Toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not guiVisible then return end
    if input.KeyCode == settings.AimKey and settings.AimMode == "Toggle" then
        toggled = not toggled
    end
end)

-- Hotkey para mostrar/esconder a GUI (F8 por exemplo)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F8 then
        guiVisible = not guiVisible
        guiFrame.Visible = guiVisible
        -- Se estiver fechando, desativa o aimbot
        if not guiVisible then
            aiming = false
            toggled = false
        end
    end
end)
