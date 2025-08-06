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
    WallCheck = true,
    TeamCheck = true
}

-- ESTADO
local aiming = false
local toggled = false
local connections = {}

-- Sistema de cleanup
local function cleanup()
    print("Cleanup iniciado...")
    for _, connection in pairs(connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    connections = {}
    aiming = false
    toggled = false
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

print("GUI criada e adicionada ao PlayerGui")

-- Círculo do FOV
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
fovCircle.Position = UDim2.new(0.5, -settings.FOVRadius, 0.5, -settings.FOVRadius)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = settings.DrawFOV
fovCircle.Parent = screenGui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 255, 255)
fovStroke.Thickness = 2
fovStroke.Transparency = 0.3
fovStroke.Parent = fovCircle

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

-- GUI Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 350)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

print("Frame principal criado")

-- Sombra
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 6, 1, 6)
shadow.Position = UDim2.new(0, -3, 0, -3)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.7
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Cantos do frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 200, 255)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 AIMBOT PRO"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = header

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

-- Botão fechar
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Container de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -50)
contentFrame.Position = UDim2.new(0, 10, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
scrollFrame.Parent = contentFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 8)
scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
scrollLayout.Parent = scrollFrame

print("Estrutura básica da GUI criada")

-- Função para criar toggles
local function createToggle(labelText, defaultState, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    container.BorderSizePixel = 0
    container.Parent = scrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 60, 0, 25)
    toggle.Position = UDim2.new(1, -70, 0.5, -12.5)
    toggle.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    toggle.BorderSizePixel = 0
    toggle.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 21, 0, 21)
    knob.Position = defaultState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = container
    
    button.MouseButton1Click:Connect(function()
        defaultState = not defaultState
        
        local targetColor = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        local targetPos = defaultState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        callback(defaultState)
    end)
    
    return container
end

-- Função para criar dropdowns
local function createDropdown(labelText, options, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    container.BorderSizePixel = 0
    container.Parent = scrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.Text = default
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 4)
    buttonCorner.Parent = button
    
    local current = 1
    for i, option in ipairs(options) do
        if option == default then
            current = i
            break
        end
    end
    
    button.MouseButton1Click:Connect(function()
        current = current + 1
        if current > #options then current = 1 end
        button.Text = options[current]
        callback(options[current])
    end)
    
    return container
end

-- Função para criar sliders
local function createSlider(labelText, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    container.BorderSizePixel = 0
    container.Parent = scrollFrame
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 6)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -10, 0, 25)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 1, -20)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local draggingSlider = false
    
    sliderButton.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    sliderButton.MouseMoved:Connect(function()
        if draggingSlider then
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition
            local relativePos = math.clamp((mouse.X - sliderPos.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(minVal + (maxVal - minVal) * relativePos)
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
    
    return container
end

print("Funções de criação de elementos definidas")

-- Criando as opções
createToggle("Mostrar FOV", settings.DrawFOV, function(val)
    settings.DrawFOV = val
    fovCircle.Visible = val
end)

createDropdown("Modo de Mira", {"Hold", "Toggle", "Always"}, settings.AimMode, function(val)
    settings.AimMode = val
end)

createDropdown("Parte do Corpo", {"Head", "Torso", "HumanoidRootPart"}, settings.AimPart, function(val)
    settings.AimPart = val
end)

createSlider("Raio FOV", 50, 300, settings.FOVRadius, function(val)
    settings.FOVRadius = val
    fovCircle.Size = UDim2.new(0, val * 2, 0, val * 2)
end)

createSlider("Suavidade", 1, 20, math.floor(settings.Smoothness * 100), function(val)
    settings.Smoothness = val / 100
end)

createSlider("Distância Máxima", 100, 1000, settings.MaxDistance, function(val)
    settings.MaxDistance = val
end)

createToggle("Verificar Parede", settings.WallCheck, function(val)
    settings.WallCheck = val
end)

createToggle("Verificar Time", settings.TeamCheck, function(val)
    settings.TeamCheck = val
end)

print("Elementos da GUI criados")

-- Atualizar tamanho do scroll
scrollLayout.Changed:Connect(function(property)
    if property == "AbsoluteContentSize" then
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end
end)

-- Sistema de drag
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end
    
    local function onInputChanged(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end
    
    connections[#connections + 1] = dragHandle.InputBegan:Connect(onInputBegan)
    connections[#connections + 1] = UserInputService.InputChanged:Connect(onInputChanged)
    connections[#connections + 1] = UserInputService.InputEnded:Connect(onInputEnded)
end

-- Tornar GUI draggable
makeDraggable(mainFrame, header)

-- Botões
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 350)
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    minimizeBtn.Text = minimized and "+" or "-"
    contentFrame.Visible = not minimized
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.3)
    cleanup()
    if screenGui then
        screenGui:Destroy()
    end
end)

print("Sistema de botões configurado")

-- Lógica do aimbot
local function getClosestTarget()
    if not localPlayer.Parent or not camera or not camera.Parent then
        return nil
    end
    
    local closest = nil
    local shortestDistance = math.huge
    
    local success, mousePos = pcall(function()
        return UserInputService:GetMouseLocation()
    end)
    
    if not success then return nil end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild(settings.AimPart) then
            if settings.TeamCheck and player.Team == localPlayer.Team then
                continue
            end
            
            local part = player.Character[settings.AimPart]
            local success2, screenPos, onScreen = pcall(function()
                return camera:WorldToViewportPoint(part.Position)
            end)
            
            if not success2 or not onScreen then continue end
            
            local distance = (camera.CFrame.Position - part.Position).Magnitude
            if distance > settings.MaxDistance then continue end
            
            local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distToMouse > settings.FOVRadius then continue end
            
            if settings.WallCheck then
                local success3, ray = pcall(function()
                    return workspace:Raycast(camera.CFrame.Position, part.Position - camera.CFrame.Position)
                end)
                
                if success3 and ray and not ray.Instance:IsDescendantOf(player.Character) then
                    continue
                end
            end
            
            if distToMouse < shortestDistance then
                closest = part
                shortestDistance = distToMouse
            end
        end
    end
    
    return closest
end

-- Loop principal
connections[#connections + 1] = RunService.RenderStepped:Connect(function()
    if not screenGui or not screenGui.Parent or not localPlayer.Parent then
        cleanup()
        return
    end
    
    if not camera or not camera.Parent then
        camera = workspace.CurrentCamera
        if not camera then return end
    end
    
    -- Atualizar FOV
    if settings.DrawFOV and fovCircle and fovCircle.Parent then
        local success, mousePos = pcall(function()
            return UserInputService:GetMouseLocation()
        end)
        
        if success then
            fovCircle.Position = UDim2.new(0, mousePos.X - settings.FOVRadius, 0, mousePos.Y - settings.FOVRadius)
            fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
        end
    end
    
    -- Determinar se deve mirar
    local shouldAim = false
    if settings.AimMode == "Always" then
        shouldAim = true
    elseif settings.AimMode == "Hold" then
        local success = pcall(function()
            shouldAim = UserInputService:IsKeyDown(settings.AimKey)
        end)
        if not success then shouldAim = false end
    elseif settings.AimMode == "Toggle" then
        shouldAim = toggled
    end
    
    -- Aplicar aimbot
    if shouldAim then
        local target = getClosestTarget()
        if target and camera and camera.Parent then
            local success = pcall(function()
                local direction = (target.Position - camera.CFrame.Position).Unit
                local newLook = camera.CFrame.LookVector:Lerp(direction, settings.Smoothness)
                camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + newLook)
            end)
            
            if success and fovStroke and fovStroke.Parent then
                fovStroke.Color = Color3.fromRGB(255, 100, 100)
            end
        elseif fovStroke and fovStroke.Parent then
            fovStroke.Color = Color3.fromRGB(0, 255, 255)
        end
    elseif fovStroke and fovStroke.Parent then
        fovStroke.Color = Color3.fromRGB(0, 255, 255)
    end
end)

-- Input para Toggle
connections[#connections + 1] = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not localPlayer.Parent or not screenGui or not screenGui.Parent then
        return
    end
    
    if input.KeyCode == settings.AimKey and settings.AimMode == "Toggle" then
        toggled = not toggled
    end
end)

-- Cleanup automático
connections[#connections + 1] = Players.PlayerRemoving:Connect(function(player)
    if player == localPlayer then
        cleanup()
    end
end)

connections[#connections + 1] = screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        cleanup()
    end
end)

script.AncestryChanged:Connect(function()
    if not script.Parent then
        cleanup()
    end
end)

game:BindToClose(cleanup)

print("Aimbot GUI carregado com sucesso!")
