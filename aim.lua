-- LocalScript: AdvancedAimSystemWithESP.lua
-- Sistema completo de Auto-Aim com GUI elaborada e ESP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CONFIGURAÇÕES DO SISTEMA
local AimSettings = {
    -- Controles
    AimKey = Enum.KeyCode.E,
    AimMode = "Hold", -- "Hold", "Toggle", "Always", "Disabled"
    
    -- Visual
    DrawFOV = true,
    FOVRadius = 150,
    FOVColor = Color3.fromRGB(0, 255, 255),
    
    -- Targeting
    AimPart = "Head", -- "Head", "Torso", "HumanoidRootPart"
    MaxDistance = 500,
    MinDistance = 5,
    
    -- Comportamento
    Smoothness = 0.25,
    AimStrength = 1.0,
    Prediction = 0.1,
    
    -- Filtros
    WallCheck = false,
    TeamCheck = true,
    IgnoreInvisible = true,
    TargetNPCsOnly = false,
    
    -- ESP Settings
    ESP = {
        Enabled = false,
        ShowBox = true,
        ShowLine = true,
        ShowName = true,
        ShowDistance = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        LineColor = Color3.fromRGB(0, 255, 0),
        TextColor = Color3.fromRGB(255, 255, 255),
        MaxDistance = 1000
    }
}

-- LISTA DE TECLAS DISPONÍVEIS
local AvailableKeys = {
    -- Letras
    {Name = "A", Key = Enum.KeyCode.A},
    {Name = "B", Key = Enum.KeyCode.B},
    {Name = "C", Key = Enum.KeyCode.C},
    {Name = "D", Key = Enum.KeyCode.D},
    {Name = "E", Key = Enum.KeyCode.E},
    {Name = "F", Key = Enum.KeyCode.F},
    {Name = "G", Key = Enum.KeyCode.G},
    {Name = "H", Key = Enum.KeyCode.H},
    {Name = "I", Key = Enum.KeyCode.I},
    {Name = "J", Key = Enum.KeyCode.J},
    {Name = "K", Key = Enum.KeyCode.K},
    {Name = "L", Key = Enum.KeyCode.L},
    {Name = "M", Key = Enum.KeyCode.M},
    {Name = "N", Key = Enum.KeyCode.N},
    {Name = "O", Key = Enum.KeyCode.O},
    {Name = "P", Key = Enum.KeyCode.P},
    {Name = "Q", Key = Enum.KeyCode.Q},
    {Name = "R", Key = Enum.KeyCode.R},
    {Name = "S", Key = Enum.KeyCode.S},
    {Name = "T", Key = Enum.KeyCode.T},
    {Name = "U", Key = Enum.KeyCode.U},
    {Name = "V", Key = Enum.KeyCode.V},
    {Name = "W", Key = Enum.KeyCode.W},
    {Name = "X", Key = Enum.KeyCode.X},
    {Name = "Y", Key = Enum.KeyCode.Y},
    {Name = "Z", Key = Enum.KeyCode.Z},
    
    -- Teclas especiais
    {Name = "SHIFT", Key = Enum.KeyCode.LeftShift},
    {Name = "CTRL", Key = Enum.KeyCode.LeftControl},
    {Name = "ALT", Key = Enum.KeyCode.LeftAlt},
    {Name = "TAB", Key = Enum.KeyCode.Tab},
    {Name = "CAPS", Key = Enum.KeyCode.CapsLock},
    {Name = "SPACE", Key = Enum.KeyCode.Space},
    
    -- Mouse
    {Name = "MOUSE1", Key = Enum.UserInputType.MouseButton1},
    {Name = "MOUSE2", Key = Enum.UserInputType.MouseButton2},
    {Name = "MOUSE3", Key = Enum.UserInputType.MouseButton3},
    {Name = "MOUSE5", Key = Enum.UserInputType.MouseButton5},
    
    -- F Keys
    {Name = "F1", Key = Enum.KeyCode.F1},
    {Name = "F2", Key = Enum.KeyCode.F2},
    {Name = "F3", Key = Enum.KeyCode.F3},
    {Name = "F4", Key = Enum.KeyCode.F4},
    {Name = "F5", Key = Enum.KeyCode.F5},
    {Name = "F6", Key = Enum.KeyCode.F6},
    {Name = "F7", Key = Enum.KeyCode.F7},
    {Name = "F8", Key = Enum.KeyCode.F8},
    {Name = "F9", Key = Enum.KeyCode.F9},
    {Name = "F10", Key = Enum.KeyCode.F10},
    {Name = "F11", Key = Enum.KeyCode.F11},
    {Name = "F12", Key = Enum.KeyCode.F12}
}

-- ESTADO DO SISTEMA
local SystemState = {
    isActive = false,
    isToggled = false,
    currentTarget = nil,
    lastUpdate = 0,
    connections = {},
    guiElements = {},
    espElements = {},
    currentKeyIndex = 5 -- Índice da tecla E por padrão
}

-- SISTEMA ESP
local ESPSystem = {
    objects = {},
    connections = {}
}

-- FUNÇÕES DE UTILIDADE
local function getKeyName(key)
    for i, keyData in ipairs(AvailableKeys) do
        if keyData.Key == key then
            return keyData.Name
        end
    end
    return "UNKNOWN"
end

local function isKeyPressed(key)
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        return UserInputService:IsKeyDown(key)
    elseif typeof(key) == "EnumItem" and key.EnumType == Enum.UserInputType then
        return UserInputService:IsMouseButtonPressed(key)
    end
    return false
end

-- SISTEMA DE CLEANUP MELHORADO
local function cleanupSystem()
    print("[System] Iniciando cleanup...")
    
    -- Desconectar todas as conexões
    for name, connection in pairs(SystemState.connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    SystemState.connections = {}
    
    -- Limpar ESP
    for _, espData in pairs(ESPSystem.objects) do
        if espData.box then espData.box:Remove() end
        if espData.line then espData.line:Remove() end
        if espData.nameLabel then espData.nameLabel:Remove() end
    end
    ESPSystem.objects = {}
    
    -- Limpar GUI
    if SystemState.guiElements.screenGui then
        SystemState.guiElements.screenGui:Destroy()
    end
    SystemState.guiElements = {}
    
    -- Reset do estado
    SystemState.isActive = false
    SystemState.isToggled = false
    SystemState.currentTarget = nil
    
    print("[System] Cleanup concluído")
end

-- SISTEMA ESP
local function createESPForPlayer(player)
    if not player.Character or ESPSystem.objects[player] then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local espData = {}
    
    -- Caixa 3D
    if AimSettings.ESP.ShowBox then
        local box = Drawing.new("Square")
        box.Color = AimSettings.ESP.BoxColor
        box.Thickness = 2
        box.Transparency = 0.8
        box.Filled = false
        box.Visible = false
        espData.box = box
    end
    
    -- Linha
    if AimSettings.ESP.ShowLine then
        local line = Drawing.new("Line")
        line.Color = AimSettings.ESP.LineColor
        line.Thickness = 2
        line.Transparency = 0.8
        line.Visible = false
        espData.line = line
    end
    
    -- Nome e distância
    if AimSettings.ESP.ShowName or AimSettings.ESP.ShowDistance then
        local nameLabel = Drawing.new("Text")
        nameLabel.Color = AimSettings.ESP.TextColor
        nameLabel.Size = 16
        nameLabel.Center = true
        nameLabel.Outline = true
        nameLabel.OutlineColor = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = 2
        nameLabel.Visible = false
        espData.nameLabel = nameLabel
    end
    
    ESPSystem.objects[player] = espData
end

local function updateESP()
    if not AimSettings.ESP.Enabled then
        for _, espData in pairs(ESPSystem.objects) do
            if espData.box then espData.box.Visible = false end
            if espData.line then espData.line.Visible = false end
            if espData.nameLabel then espData.nameLabel.Visible = false end
        end
        return
    end
    
    local screenSize = camera.ViewportSize
    local screenCenter = Vector2.new(screenSize.X / 2, screenSize.Y)
    
    for player, espData in pairs(ESPSystem.objects) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if espData.box then espData.box.Visible = false end
            if espData.line then espData.line.Visible = false end
            if espData.nameLabel then espData.nameLabel.Visible = false end
            continue
        end
        
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")
        
        -- Verificações básicas
        if player == localPlayer then continue end
        if AimSettings.TeamCheck and player.Team and localPlayer.Team and player.Team == localPlayer.Team then continue end
        
        local distance = (camera.CFrame.Position - humanoidRootPart.Position).Magnitude
        if distance > AimSettings.ESP.MaxDistance then
            if espData.box then espData.box.Visible = false end
            if espData.line then espData.line.Visible = false end
            if espData.nameLabel then espData.nameLabel.Visible = false end
            continue
        end
        
        -- Projetar pontos para a tela
        local success, rootPos, rootOnScreen = pcall(function()
            return camera:WorldToViewportPoint(humanoidRootPart.Position)
        end)
        
        if not success or not rootOnScreen then
            if espData.box then espData.box.Visible = false end
            if espData.line then espData.line.Visible = false end
            if espData.nameLabel then espData.nameLabel.Visible = false end
            continue
        end
        
        local rootPos2D = Vector2.new(rootPos.X, rootPos.Y)
        
        -- Atualizar linha
        if espData.line then
            espData.line.From = screenCenter
            espData.line.To = rootPos2D
            espData.line.Visible = true
        end
        
        -- Atualizar caixa
        if espData.box and head then
            local success2, headPos, headOnScreen = pcall(function()
                return camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            end)
            
            if success2 and headOnScreen then
                local headPos2D = Vector2.new(headPos.X, headPos.Y)
                local boxHeight = math.abs(rootPos2D.Y - headPos2D.Y) * 1.2
                local boxWidth = boxHeight * 0.6
                
                espData.box.Size = Vector2.new(boxWidth, boxHeight)
                espData.box.Position = Vector2.new(rootPos2D.X - boxWidth/2, headPos2D.Y)
                espData.box.Visible = true
            else
                espData.box.Visible = false
            end
        end
        
        -- Atualizar texto
        if espData.nameLabel then
            local text = ""
            if AimSettings.ESP.ShowName then
                text = player.Name
            end
            if AimSettings.ESP.ShowDistance then
                if text ~= "" then text = text .. " " end
                text = text .. "[" .. math.floor(distance) .. "m]"
            end
            
            espData.nameLabel.Text = text
            espData.nameLabel.Position = Vector2.new(rootPos2D.X, rootPos2D.Y - 40)
            espData.nameLabel.Visible = true
        end
    end
end

-- VALIDAÇÕES DE SEGURANÇA
local function validateEnvironment()
    if not localPlayer or not localPlayer.Parent then
        return false
    end
    
    if not camera or not camera.Parent then
        camera = workspace.CurrentCamera
        if not camera then
            return false
        end
    end
    
    return true
end

-- FUNÇÃO DE TARGETING OTIMIZADA
local function getOptimalTarget()
    if not validateEnvironment() then return nil end
    
    local bestTarget = nil
    local bestScore = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(AimSettings.AimPart)
            if not targetPart then continue end
            
            -- Verificação de time
            if AimSettings.TeamCheck and player.Team and localPlayer.Team 
               and player.Team == localPlayer.Team then
                continue
            end
            
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            -- Calcular posição com predição
            local targetPosition = targetPart.Position
            if AimSettings.Prediction > 0 and humanoidRootPart and humanoidRootPart.Velocity then
                targetPosition = targetPosition + (humanoidRootPart.Velocity * AimSettings.Prediction)
            end
            
            -- Verificar distância 3D
            local distance3D = (camera.CFrame.Position - targetPosition).Magnitude
            if distance3D > AimSettings.MaxDistance or distance3D < AimSettings.MinDistance then
                continue
            end
            
            -- Projetar para tela
            local success, screenPos, onScreen = pcall(function()
                return camera:WorldToViewportPoint(targetPosition)
            end)
            
            if not success or not onScreen then continue end
            
            -- Verificar FOV
            local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
            if screenDistance > AimSettings.FOVRadius then continue end
            
            -- Calcular score (menor é melhor)
            local score = screenDistance + (distance3D * 0.1)
            
            if score < bestScore then
                bestScore = score
                bestTarget = {
                    character = player.Character,
                    part = targetPart,
                    position = targetPosition,
                    distance = distance3D,
                    screenDistance = screenDistance,
                    player = player
                }
            end
        end
    end
    
    return bestTarget
end

-- SISTEMA DE MIRA SUAVIZADA
local function applyAiming(targetData)
    if not targetData or not validateEnvironment() then return end
    
    local success = pcall(function()
        local targetPosition = targetData.position
        local currentCFrame = camera.CFrame
        
        -- Calcular direção suavizada
        local direction = (targetPosition - currentCFrame.Position).Unit
        local currentLook = currentCFrame.LookVector
        
        -- Aplicar suavização e força
        local smoothFactor = AimSettings.Smoothness * AimSettings.AimStrength
        local lerpedDirection = currentLook:Lerp(direction, smoothFactor)
        
        -- Aplicar rotação
        local newCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + lerpedDirection)
        camera.CFrame = newCFrame
    end)
end

-- CRIAÇÃO DA GUI AVANÇADA
local function createAdvancedGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedAimSystem"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    SystemState.guiElements.screenGui = screenGui
    
    -- Frame principal maior e mais elaborado
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 420, 0, 600)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Parent = screenGui
    
    SystemState.guiElements.mainFrame = mainFrame
    
    -- Sombra elegante
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 15)
    shadowCorner.Parent = shadow
    
    -- Cantos do frame principal
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Borda animada
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 200, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.3
    mainStroke.Parent = mainFrame
    
    -- Header elaborado
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    -- Título com ícone
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎯 ADVANCED AIM SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Botões do header
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(1, -80, 0, 7.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 8)
    minimizeCorner.Parent = minimizeBtn
    
    SystemState.guiElements.minimizeBtn = minimizeBtn
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 7.5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    SystemState.guiElements.closeBtn = closeBtn
    
    -- Container principal com tabs
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -70)
    contentFrame.Position = UDim2.new(0, 10, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    SystemState.guiElements.contentFrame = contentFrame
    
    -- Sistema de Tabs
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = contentFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabContainer
    
    -- Função para criar tabs
    local currentTab = 1
    local tabs = {}
    local tabButtons = {}
    
    local function createTab(tabName, tabIcon)
        local tabIndex = #tabs + 1
        
        -- Botão da tab
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName .. "Tab"
        tabBtn.Size = UDim2.new(0, 120, 1, 0)
        tabBtn.BackgroundColor3 = tabIndex == 1 and Color3.fromRGB(0, 123, 255) or Color3.fromRGB(50, 50, 60)
        tabBtn.Text = tabIcon .. " " .. tabName
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.BorderSizePixel = 0
        tabBtn.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        -- Conteúdo da tab
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, -50)
        tabContent.Position = UDim2.new(0, 0, 0, 50)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 8
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = tabIndex == 1
        tabContent.Parent = contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        -- Auto-resize canvas
        contentLayout.Changed:Connect(function(property)
            if property == "AbsoluteContentSize" then
                tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            end
        end)
        
        -- Click handler
        tabBtn.MouseButton1Click:Connect(function()
            -- Atualizar visual das tabs
            for i, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            end
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
            
            -- Mostrar/ocultar conteúdo
            for i, content in ipairs(tabs) do
                content.Visible = (i == tabIndex)
            end
            
            currentTab = tabIndex
        end)
        
        table.insert(tabs, tabContent)
        table.insert(tabButtons, tabBtn)
        
        return tabContent
    end
    
    -- Criar as tabs
    local aimTab = createTab("AIM", "🎯")
    local espTab = createTab("ESP", "👁️")
    local miscTab = createTab("MISC", "⚙️")
    
    -- FUNÇÕES PARA CRIAR ELEMENTOS DA GUI
    
    local function createSection(parent, title)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 35)
        section.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        section.BorderSizePixel = 0
        section.Parent = parent
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = section
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, -20, 1, 0)
        sectionLabel.Position = UDim2.new(0, 10, 0, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = title
        sectionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sectionLabel.TextScaled = true
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Parent = section
        
        return section
    end
    
    local function createToggle(parent, labelText, defaultState, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 45)
        container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -100, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local toggle = Instance.new("Frame")
        toggle.Size = UDim2.new(0, 70, 0, 30)
        toggle.Position = UDim2.new(1, -85, 0.5, -15)
        toggle.BackgroundColor3 = defaultState and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
        toggle.BorderSizePixel = 0
        toggle.Parent = container
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggle
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 26, 0, 26)
        knob.Position = defaultState and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
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
            
            local targetColor = defaultState and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
            local targetPos = defaultState and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
            
            TweenService:Create(toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
            TweenService:Create(knob, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
            
            callback(defaultState)
        end)
        
        return container
    end
    
    local function createSlider(parent, labelText, minVal, maxVal, defaultVal, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 70)
        container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 0, 30)
        label.Position = UDim2.new(0, 15, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.4, -15, 0, 30)
        valueLabel.Position = UDim2.new(0.6, 0, 0, 8)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(defaultVal)
        valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = container
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -30, 0, 8)
        sliderBg.Position = UDim2.new(0, 15, 1, -25)
        sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        sliderBg.BorderSizePixel = 0
        sliderBg.Parent = container
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(1, 0)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBg
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill
        
        local sliderKnob = Instance.new("Frame")
        sliderKnob.Size = UDim2.new(0, 16, 0, 16)
        sliderKnob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderKnob.BorderSizePixel = 0
        sliderKnob.Parent = sliderBg
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = sliderKnob
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBg
        
        local dragging = false
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        sliderButton.MouseMoved:Connect(function()
            if dragging then
                local mouse = UserInputService:GetMouseLocation()
                local sliderPos = sliderBg.AbsolutePosition
                local relativePos = math.clamp((mouse.X - sliderPos.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(minVal + (maxVal - minVal) * relativePos)
                
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                sliderKnob.Position = UDim2.new(relativePos, -8, 0.5, -8)
                valueLabel.Text = tostring(value)
                callback(value)
            end
        end)
        
        return container
    end
    
    local function createDropdown(parent, labelText, options, default, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 80)
        container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -30, 0, 30)
        label.Position = UDim2.new(0, 15, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -30, 0, 35)
        button.Position = UDim2.new(0, 15, 0, 38)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        button.Text = default .. " ▼"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.BorderSizePixel = 0
        button.Parent = container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
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
            button.Text = options[current] .. " ▼"
            callback(options[current])
        end)
        
        return container
    end
    
    local function createKeybind(parent, labelText, currentKey, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 80)
        container.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        container.BorderSizePixel = 0
        container.Parent = parent
        
        local containerCorner = Instance.new("UICorner")
        containerCorner.CornerRadius = UDim.new(0, 8)
        containerCorner.Parent = container
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -30, 0, 30)
        label.Position = UDim2.new(0, 15, 0, 8)
        label.BackgroundTransparency = 1
        label.Text = labelText .. ": " .. getKeyName(currentKey)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -30, 0, 35)
        button.Position = UDim2.new(0, 15, 0, 38)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        button.Text = "Clique para alterar"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.BorderSizePixel = 0
        button.Parent = container
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            button.Text = "Pressione uma tecla..."
            button.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            
            -- Próxima tecla na lista
            SystemState.currentKeyIndex = SystemState.currentKeyIndex + 1
            if SystemState.currentKeyIndex > #AvailableKeys then
                SystemState.currentKeyIndex = 1
            end
            
            local newKey = AvailableKeys[SystemState.currentKeyIndex].Key
            AimSettings.AimKey = newKey
            label.Text = labelText .. ": " .. AvailableKeys[SystemState.currentKeyIndex].Name
            button.Text = "Clique para alterar"
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            callback(newKey)
        end)
        
        return container
    end
    
    -- CRIANDO ELEMENTOS DAS TABS
    
    -- TAB AIM
    createSection(aimTab, "🎯 CONFIGURAÇÕES DE MIRA")
    
    createToggle(aimTab, "Ativar Aimbot", true, function(val)
        if val then
            print("[Aimbot] Ativado")
        else
            print("[Aimbot] Desativado")
            AimSettings.AimMode = "Disabled"
        end
    end)
    
    createKeybind(aimTab, "Tecla do Aimbot", AimSettings.AimKey, function(val)
        AimSettings.AimKey = val
        print("[Aimbot] Nova tecla:", getKeyName(val))
    end)
    
    createDropdown(aimTab, "Modo de Ativação", {"Hold", "Toggle", "Always"}, AimSettings.AimMode, function(val)
        AimSettings.AimMode = val
        print("[Aimbot] Modo alterado para:", val)
    end)
    
    createDropdown(aimTab, "Parte do Corpo", {"Head", "Torso", "HumanoidRootPart"}, AimSettings.AimPart, function(val)
        AimSettings.AimPart = val
        print("[Aimbot] Mirando em:", val)
    end)
    
    createSlider(aimTab, "Raio do FOV", 50, 500, AimSettings.FOVRadius, function(val)
        AimSettings.FOVRadius = val
        if SystemState.guiElements.fovCircle then
            SystemState.guiElements.fovCircle.Size = UDim2.new(0, val * 2, 0, val * 2)
        end
    end)
    
    createSlider(aimTab, "Distância Máxima", 100, 2000, AimSettings.MaxDistance, function(val)
        AimSettings.MaxDistance = val
    end)
    
    createSlider(aimTab, "Suavidade", 1, 100, math.floor(AimSettings.Smoothness * 100), function(val)
        AimSettings.Smoothness = val / 100
    end)
    
    createSlider(aimTab, "Força do Aimbot", 10, 100, math.floor(AimSettings.AimStrength * 100), function(val)
        AimSettings.AimStrength = val / 100
    end)
    
    createToggle(aimTab, "Mostrar FOV", AimSettings.DrawFOV, function(val)
        AimSettings.DrawFOV = val
        if SystemState.guiElements.fovCircle then
            SystemState.guiElements.fovCircle.Visible = val
        end
    end)
    
    createToggle(aimTab, "Verificar Time", AimSettings.TeamCheck, function(val)
        AimSettings.TeamCheck = val
    end)
    
    createToggle(aimTab, "Verificar Parede", AimSettings.WallCheck, function(val)
        AimSettings.WallCheck = val
    end)
    
    -- TAB ESP
    createSection(espTab, "👁️ CONFIGURAÇÕES DO ESP")
    
    createToggle(espTab, "Ativar ESP", AimSettings.ESP.Enabled, function(val)
        AimSettings.ESP.Enabled = val
        if val then
            -- Criar ESP para todos os jogadores
            for _, player in ipairs(Players:GetPlayers()) do
                createESPForPlayer(player)
            end
        else
            -- Limpar ESP
            for player, espData in pairs(ESPSystem.objects) do
                if espData.box then espData.box.Visible = false end
                if espData.line then espData.line.Visible = false end
                if espData.nameLabel then espData.nameLabel.Visible = false end
            end
        end
    end)
    
    createToggle(espTab, "Mostrar Caixas", AimSettings.ESP.ShowBox, function(val)
        AimSettings.ESP.ShowBox = val
    end)
    
    createToggle(espTab, "Mostrar Linhas", AimSettings.ESP.ShowLine, function(val)
        AimSettings.ESP.ShowLine = val
    end)
    
    createToggle(espTab, "Mostrar Nomes", AimSettings.ESP.ShowName, function(val)
        AimSettings.ESP.ShowName = val
    end)
    
    createToggle(espTab, "Mostrar Distância", AimSettings.ESP.ShowDistance, function(val)
        AimSettings.ESP.ShowDistance = val
    end)
    
    createSlider(espTab, "Distância Máxima ESP", 100, 2000, AimSettings.ESP.MaxDistance, function(val)
        AimSettings.ESP.MaxDistance = val
    end)
    
    -- TAB MISC
    createSection(miscTab, "⚙️ CONFIGURAÇÕES GERAIS")
    
    createSlider(miscTab, "Predição de Movimento", 0, 50, math.floor(AimSettings.Prediction * 100), function(val)
        AimSettings.Prediction = val / 100
    end)
    
    createToggle(miscTab, "Apenas NPCs", AimSettings.TargetNPCsOnly, function(val)
        AimSettings.TargetNPCsOnly = val
    end)
    
    createToggle(miscTab, "Ignorar Invisíveis", AimSettings.IgnoreInvisible, function(val)
        AimSettings.IgnoreInvisible = val
    end)
    
    -- Círculo FOV
    if AimSettings.DrawFOV then
        local fovCircle = Instance.new("Frame")
        fovCircle.Name = "FOVCircle"
        fovCircle.Size = UDim2.new(0, AimSettings.FOVRadius * 2, 0, AimSettings.FOVRadius * 2)
        fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        fovCircle.BackgroundTransparency = 1
        fovCircle.BorderSizePixel = 0
        fovCircle.Visible = AimSettings.DrawFOV
        fovCircle.Parent = screenGui
        
        local fovStroke = Instance.new("UIStroke")
        fovStroke.Color = AimSettings.FOVColor
        fovStroke.Thickness = 2
        fovStroke.Transparency = 0.3
        fovStroke.Parent = fovCircle
        
        local fovCorner = Instance.new("UICorner")
        fovCorner.CornerRadius = UDim.new(1, 0)
        fovCorner.Parent = fovCircle
        
        SystemState.guiElements.fovCircle = fovCircle
        SystemState.guiElements.fovStroke = fovStroke
    end
    
    -- Sistema de drag para mover a GUI
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
        
        SystemState.connections.dragBegan = dragHandle.InputBegan:Connect(onInputBegan)
        SystemState.connections.dragChanged = UserInputService.InputChanged:Connect(onInputChanged)
        SystemState.connections.dragEnded = UserInputService.InputEnded:Connect(onInputEnded)
    end
    
    -- Tornar GUI draggable pelo header
    makeDraggable(mainFrame, header)
    
    -- Funcionalidade dos botões
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 420, 0, 50) or UDim2.new(0, 420, 0, 600)
        
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize})
        tween:Play()
        
        minimizeBtn.Text = minimized and "+" or "−"
        contentFrame.Visible = not minimized
        
        -- Efeito de bounce
        minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
        TweenService:Create(minimizeBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 35, 0, 35)}):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        -- Animação de fechamento
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            cleanupSystem()
        end)
        
        -- Efeito no botão
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 30, 0, 30)}):Play()
    end)
    
    -- Efeitos hover nos botões
    local function addHoverEffect(button, hoverColor, normalColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    addHoverEffect(minimizeBtn, Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 193, 7))
    addHoverEffect(closeBtn, Color3.fromRGB(200, 35, 51), Color3.fromRGB(220, 53, 69))
    
    print("[GUI] Interface avançada criada com sucesso!")
end

-- ATUALIZAÇÃO DO SISTEMA PRINCIPAL
local function updateSystem()
    local currentTime = tick()
    local deltaTime = currentTime - SystemState.lastUpdate
    
    -- Limitar taxa de atualização para performance
    if deltaTime < (1/60) then return end
    SystemState.lastUpdate = currentTime
    
    if not validateEnvironment() then
        cleanupSystem()
        return
    end
    
    -- Atualizar ESP
    updateESP()
    
    -- Atualizar FOV visual
    if SystemState.guiElements.fovCircle and AimSettings.DrawFOV then
        local fovCircle = SystemState.guiElements.fovCircle
        fovCircle.Size = UDim2.new(0, AimSettings.FOVRadius * 2, 0, AimSettings.FOVRadius * 2)
        fovCircle.Visible = AimSettings.DrawFOV
    end
    
    -- Determinar se deve ativar a mira
    local shouldAim = false
    if AimSettings.AimMode == "Always" then
        shouldAim = true
    elseif AimSettings.AimMode == "Hold" then
        shouldAim = isKeyPressed(AimSettings.AimKey)
    elseif AimSettings.AimMode == "Toggle" then
        shouldAim = SystemState.isToggled
    elseif AimSettings.AimMode == "Disabled" then
        shouldAim = false
    end
    
    SystemState.isActive = shouldAim
    
    -- Aplicar lógica de mira
    if shouldAim then
        local target = getOptimalTarget()
        SystemState.currentTarget = target
        
        if target then
            applyAiming(target)
            
            -- Feedback visual
            if SystemState.guiElements.fovStroke then
                SystemState.guiElements.fovStroke.Color = Color3.fromRGB(255, 100, 100)
                SystemState.guiElements.fovStroke.Thickness = 3
            end
        else
            -- Sem alvo
            if SystemState.guiElements.fovStroke then
                SystemState.guiElements.fovStroke.Color = AimSettings.FOVColor
                SystemState.guiElements.fovStroke.Thickness = 2
            end
        end
    else
        SystemState.currentTarget = nil
        -- Estado inativo
        if SystemState.guiElements.fovStroke then
            SystemState.guiElements.fovStroke.Color = AimSettings.FOVColor
            SystemState.guiElements.fovStroke.Thickness = 2
        end
    end
end

-- GERENCIAMENTO DE INPUT
local function setupInputHandling()
    SystemState.connections.inputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
            if input.KeyCode == AimSettings.AimKey or input.UserInputType == AimSettings.AimKey then
                if AimSettings.AimMode == "Toggle" then
                    SystemState.isToggled = not SystemState.isToggled
                    print("[Aimbot] Toggle:", SystemState.isToggled)
                    
                    -- Feedback visual do toggle
                    if SystemState.guiElements.fovStroke then
                        local feedbackColor = SystemState.isToggled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                        SystemState.guiElements.fovStroke.Color = feedbackColor
                        
                        task.wait(0.2)
                        if SystemState.guiElements.fovStroke then
                            SystemState.guiElements.fovStroke.Color = AimSettings.FOVColor
                        end
                    end
                end
            end
        end
    end)
end

-- INICIALIZAÇÃO DO SISTEMA
local function initializeSystem()
    print("[System] Inicializando sistema avançado...")
    
    if not validateEnvironment() then
        warn("[System] Ambiente inválido, cancelando inicialização")
        return false
    end
    
    -- Criar GUI avançada
    createAdvancedGUI()
    
    -- Configurar input
    setupInputHandling()
    
    -- Setup ESP
    SystemState.connections.playerAdded = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1) -- Esperar character carregar
            createESPForPlayer(player)
        end)
    end)
    
    SystemState.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        if ESPSystem.objects[player] then
            local espData = ESPSystem.objects[player]
            if espData.box then espData.box:Remove() end
            if espData.line then espData.line:Remove() end
            if espData.nameLabel then espData.nameLabel:Remove() end
            ESPSystem.objects[player] = nil
        end
        
        if player == localPlayer then
            cleanupSystem()
        end
    end)
    
    -- Criar ESP para jogadores existentes
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            createESPForPlayer(player)
        end
    end
    
    -- Loop principal
    SystemState.connections.heartbeat = RunService.Heartbeat:Connect(updateSystem)
    
    -- Cleanup automático
    SystemState.connections.ancestryChanged = SystemState.guiElements.screenGui.AncestryChanged:Connect(function()
        if not SystemState.guiElements.screenGui.Parent then
            cleanupSystem()
        end
    end)
    
    -- Cleanup no fechamento
    game:BindToClose(cleanupSystem)
    
    print("[System] ✅ Sistema avançado inicializado!")
    print("[System] Tecla atual:", getKeyName(AimSettings.AimKey))
    print("[System] Use a GUI para configurar todas as opções!")
    
    return true
end

-- API PÚBLICA PARA CONFIGURAÇÃO
local AdvancedAPI = {}

function AdvancedAPI:SetAimKey(keyCode)
    AimSettings.AimKey = keyCode
    print("[API] Nova tecla:", getKeyName(keyCode))
end

function AdvancedAPI:SetAimMode(mode)
    if mode == "Hold" or mode == "Toggle" or mode == "Always" or mode == "Disabled" then
        AimSettings.AimMode = mode
        print("[API] Novo modo:", mode)
    end
end

function AdvancedAPI:SetFOVRadius(radius)
    AimSettings.FOVRadius = math.clamp(radius, 10, 1000)
    if SystemState.guiElements.fovCircle then
        SystemState.guiElements.fovCircle.Size = UDim2.new(0, AimSettings.FOVRadius * 2, 0, AimSettings.FOVRadius * 2)
    end
    print("[API] Novo raio FOV:", AimSettings.FOVRadius)
end

function AdvancedAPI:SetMaxDistance(distance)
    AimSettings.MaxDistance = math.clamp(distance, 50, 5000)
    print("[API] Nova distância máxima:", AimSettings.MaxDistance)
end

function AdvancedAPI:SetSmoothness(smoothness)
    AimSettings.Smoothness = math.clamp(smoothness, 0.01, 1)
    print("[API] Nova suavidade:", AimSettings.Smoothness)
end

function AdvancedAPI:ToggleESP(enabled)
    AimSettings.ESP.Enabled = enabled
    if not enabled then
        for player, espData in pairs(ESPSystem.objects) do
            if espData.box then espData.box.Visible = false end
            if espData.line then espData.line.Visible = false end
            if espData.nameLabel then espData.nameLabel.Visible = false end
        end
    end
    print("[API] ESP:", enabled and "Ativado" or "Desativado")
end

function AdvancedAPI:SetESPDistance(distance)
    AimSettings.ESP.MaxDistance = math.clamp(distance, 100, 5000)
    print("[API] Nova distância ESP:", AimSettings.ESP.MaxDistance)
end

function AdvancedAPI:GetCurrentTarget()
    return SystemState.currentTarget
end

function AdvancedAPI:IsActive()
    return SystemState.isActive
end

function AdvancedAPI:GetSettings()
    return AimSettings
end

function AdvancedAPI:Shutdown()
    cleanupSystem()
    print("[API] Sistema finalizado")
end

-- COMANDOS DE CONSOLE PARA TESTE
function AdvancedAPI:PrintCommands()
    print("=== COMANDOS DISPONÍVEIS ===")
    print("_G.AdvancedAPI:SetAimKey(Enum.KeyCode.Q) -- Mudar tecla")
    print("_G.AdvancedAPI:SetAimMode('Toggle') -- Mudar modo")
    print("_G.AdvancedAPI:SetFOVRadius(200) -- Mudar FOV")
    print("_G.AdvancedAPI:SetMaxDistance(800) -- Mudar distância")
    print("_G.AdvancedAPI:ToggleESP(true) -- Ativar/Desativar ESP")
    print("_G.AdvancedAPI:GetCurrentTarget() -- Ver alvo atual")
    print("_G.AdvancedAPI:GetSettings() -- Ver todas configurações")
    print("_G.AdvancedAPI:Shutdown() -- Fechar sistema")
end

-- Inicializar automaticamente
if initializeSystem() then
    -- Disponibilizar API globalmente
    _G.AdvancedAPI = AdvancedAPI
    
    print("===========================================")
    print("🎯 ADVANCED AIM SYSTEM - VERSÃO COMPLETA")
    print("===========================================")
    print("✅ Sistema inicializado com sucesso!")
    print("📋 Use _G.AdvancedAPI:PrintCommands() para ver comandos")
    print("🎮 GUI completa com tabs AIM, ESP e MISC")
    print("⚙️ Configurações:")
    print("   • Tecla atual:", getKeyName(AimSettings.AimKey))
    print("   • Modo:", AimSettings.AimMode)
    print("   • FOV:", AimSettings.FOVRadius)
    print("   • Distância máxima:", AimSettings.MaxDistance)
    print("===========================================")
    
    -- Comandos de teste automático
    task.spawn(function()
        wait(2)
        print("💡 Dica: Clique e arraste a GUI pelo cabeçalho para mover!")
        print("💡 Use as abas AIM, ESP e MISC para configurar tudo!")
    end)
else
    warn("❌ Falha na inicialização do sistema avançado")
end

return AdvancedAPI
