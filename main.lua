-- GUI Script para Roblox - Aim Assist
-- Criado com design moderno e funcionalidades completas

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Mouse = Players.LocalPlayer:GetMouse()

-- Variáveis principais
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações do Aim Assist
local aimAssistConfig = {
    aimBot = {
        enabled = false,
        mode = "Toggle", -- "Toggle", "Hold", "Always"
        targetParts = {"Head"}, -- Partes do corpo selecionadas
        key = Enum.KeyCode.E -- Tecla padrão
    },
    autoFire = {
        enabled = false,
        mode = "Toggle"
    },
    autoWall = {
        enabled = false,
        mode = "Toggle"
    },
    checkWall = false
}

-- Função para criar a GUI principal
local function createMainGUI()
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimAssistGUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Adicionar cantos arredondados
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = mainFrame
    
    -- Adicionar sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 50)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎯 AIM ASSIST CONTROLLER"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Botão fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Seção Aim Assist
    local aimAssistSection = Instance.new("Frame")
    aimAssistSection.Name = "AimAssistSection"
    aimAssistSection.Size = UDim2.new(1, -20, 0, 520)
    aimAssistSection.Position = UDim2.new(0, 10, 0, 60)
    aimAssistSection.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    aimAssistSection.BorderSizePixel = 0
    aimAssistSection.Parent = mainFrame
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = aimAssistSection
    
    -- Título da seção
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, -20, 0, 40)
    sectionTitle.Position = UDim2.new(0, 10, 0, 10)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = "🎯 AIM ASSIST"
    sectionTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    sectionTitle.TextScaled = true
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = aimAssistSection
    
    -- Container para os controles
    local controlsContainer = Instance.new("ScrollingFrame")
    controlsContainer.Name = "ControlsContainer"
    controlsContainer.Size = UDim2.new(1, -20, 1, -60)
    controlsContainer.Position = UDim2.new(0, 10, 0, 50)
    controlsContainer.BackgroundTransparency = 1
    controlsContainer.BorderSizePixel = 0
    controlsContainer.ScrollBarThickness = 6
    controlsContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    controlsContainer.CanvasSize = UDim2.new(0, 0, 0, 800)
    controlsContainer.Parent = aimAssistSection
    
    local yPosition = 0
    
    -- Função para criar controle com dropdown
    local function createControl(name, description, configKey, hasTargetParts, hasKeyBind)
        local controlFrame = Instance.new("Frame")
        controlFrame.Name = name .. "Control"
        controlFrame.Size = UDim2.new(1, -10, 0, hasTargetParts and 180 or (hasKeyBind and 140 or 100))
        controlFrame.Position = UDim2.new(0, 5, 0, yPosition)
        controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        controlFrame.BorderSizePixel = 0
        controlFrame.Parent = controlsContainer
        
        local controlCorner = Instance.new("UICorner")
        controlCorner.CornerRadius = UDim.new(0, 6)
        controlCorner.Parent = controlFrame
        
        -- Checkbox
        local checkbox = Instance.new("TextButton")
        checkbox.Name = "Checkbox"
        checkbox.Size = UDim2.new(0, 20, 0, 20)
        checkbox.Position = UDim2.new(0, 10, 0, 10)
        checkbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        checkbox.Text = ""
        checkbox.BorderSizePixel = 0
        checkbox.Parent = controlFrame
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 3)
        checkCorner.Parent = checkbox
        
        local checkMark = Instance.new("TextLabel")
        checkMark.Size = UDim2.new(1, 0, 1, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Text = "✓"
        checkMark.TextColor3 = Color3.fromRGB(100, 255, 100)
        checkMark.TextScaled = true
        checkMark.Font = Enum.Font.GothamBold
        checkMark.Visible = false
        checkMark.Parent = checkbox
        
        -- Label
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(0, 150, 0, 20)
        label.Position = UDim2.new(0, 40, 0, 10)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = controlFrame
        
        -- Dropdown para modo
        local modeDropdown = Instance.new("TextButton")
        modeDropdown.Name = "ModeDropdown"
        modeDropdown.Size = UDim2.new(0, 120, 0, 25)
        modeDropdown.Position = UDim2.new(0, 200, 0, 7.5)
        modeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        modeDropdown.Text = "Toggle ▼"
        modeDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        modeDropdown.TextScaled = true
        modeDropdown.Font = Enum.Font.Gotham
        modeDropdown.BorderSizePixel = 0
        modeDropdown.Parent = controlFrame
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, 4)
        dropdownCorner.Parent = modeDropdown
        
        -- Menu dropdown
        local dropdownMenu = Instance.new("Frame")
        dropdownMenu.Name = "DropdownMenu"
        dropdownMenu.Size = UDim2.new(0, 120, 0, 90)
        dropdownMenu.Position = UDim2.new(0, 200, 0, 35)
        dropdownMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        dropdownMenu.BorderSizePixel = 0
        dropdownMenu.Visible = false
        dropdownMenu.ZIndex = 10
        dropdownMenu.Parent = controlFrame
        
        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 4)
        menuCorner.Parent = dropdownMenu
        
        local modes = {"Toggle", "Hold", "Always"}
        for i, mode in ipairs(modes) do
            local modeButton = Instance.new("TextButton")
            modeButton.Size = UDim2.new(1, 0, 0, 30)
            modeButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            modeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            modeButton.Text = mode
            modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            modeButton.TextScaled = true
            modeButton.Font = Enum.Font.Gotham
            modeButton.BorderSizePixel = 0
            modeButton.Parent = dropdownMenu
            
            modeButton.MouseButton1Click:Connect(function()
                aimAssistConfig[configKey].mode = mode
                modeDropdown.Text = mode .. " ▼"
                dropdownMenu.Visible = false
            end)
        end
        
        -- Seleção de partes do corpo (apenas para Aim Bot)
        if hasTargetParts then
            local partsLabel = Instance.new("TextLabel")
            partsLabel.Size = UDim2.new(1, -20, 0, 20)
            partsLabel.Position = UDim2.new(0, 10, 0, 40)
            partsLabel.BackgroundTransparency = 1
            partsLabel.Text = "Partes do Corpo:"
            partsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            partsLabel.TextScaled = true
            partsLabel.Font = Enum.Font.Gotham
            partsLabel.TextXAlignment = Enum.TextXAlignment.Left
            partsLabel.Parent = controlFrame
            
            local bodyParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            local partsFrame = Instance.new("Frame")
            partsFrame.Size = UDim2.new(1, -20, 0, 60)
            partsFrame.Position = UDim2.new(0, 10, 0, 65)
            partsFrame.BackgroundTransparency = 1
            partsFrame.Parent = controlFrame
            
            for i, part in ipairs(bodyParts) do
                local partCheck = Instance.new("TextButton")
                partCheck.Size = UDim2.new(0, 15, 0, 15)
                partCheck.Position = UDim2.new(0, ((i-1) % 3) * 130, 0, math.floor((i-1) / 3) * 25)
                partCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                partCheck.Text = ""
                partCheck.BorderSizePixel = 0
                partCheck.Parent = partsFrame
                
                local partCorner = Instance.new("UICorner")
                partCorner.CornerRadius = UDim.new(0, 2)
                partCorner.Parent = partCheck
                
                local partMark = Instance.new("TextLabel")
                partMark.Size = UDim2.new(1, 0, 1, 0)
                partMark.BackgroundTransparency = 1
                partMark.Text = "✓"
                partMark.TextColor3 = Color3.fromRGB(100, 255, 100)
                partMark.TextScaled = true
                partMark.Font = Enum.Font.GothamBold
                partMark.Visible = part == "Head"
                partMark.Parent = partCheck
                
                local partLabel = Instance.new("TextLabel")
                partLabel.Size = UDim2.new(0, 100, 0, 15)
                partLabel.Position = UDim2.new(0, ((i-1) % 3) * 130 + 20, 0, math.floor((i-1) / 3) * 25)
                partLabel.BackgroundTransparency = 1
                partLabel.Text = part
                partLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                partLabel.TextSize = 12
                partLabel.Font = Enum.Font.Gotham
                partLabel.TextXAlignment = Enum.TextXAlignment.Left
                partLabel.Parent = partsFrame
                
                partCheck.MouseButton1Click:Connect(function()
                    local isSelected = partMark.Visible
                    partMark.Visible = not isSelected
                    
                    if not isSelected then
                        if not table.find(aimAssistConfig[configKey].targetParts, part) then
                            table.insert(aimAssistConfig[configKey].targetParts, part)
                        end
                    else
                        local index = table.find(aimAssistConfig[configKey].targetParts, part)
                        if index then
                            table.remove(aimAssistConfig[configKey].targetParts, index)
                        end
                    end
                end)
            end
        end
        
        -- Configuração de tecla (apenas para Aim Bot)
        if hasKeyBind then
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0, 80, 0, 20)
            keyLabel.Position = UDim2.new(0, 10, 0, hasTargetParts and 135 or 40)
            keyLabel.BackgroundTransparency = 1
            keyLabel.Text = "Tecla:"
            keyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            keyLabel.TextScaled = true
            keyLabel.Font = Enum.Font.Gotham
            keyLabel.TextXAlignment = Enum.TextXAlignment.Left
            keyLabel.Parent = controlFrame
            
            local keyButton = Instance.new("TextButton")
            keyButton.Size = UDim2.new(0, 60, 0, 25)
            keyButton.Position = UDim2.new(0, 100, 0, hasTargetParts and 132.5 or 37.5)
            keyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            keyButton.Text = "E"
            keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            keyButton.TextScaled = true
            keyButton.Font = Enum.Font.Gotham
            keyButton.BorderSizePixel = 0
            keyButton.Parent = controlFrame
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 4)
            keyCorner.Parent = keyButton
            
            keyButton.MouseButton1Click:Connect(function()
                keyButton.Text = "Press..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                        aimAssistConfig[configKey].key = input.KeyCode
                        keyButton.Text = input.KeyCode.Name
                        connection:Disconnect()
                    end
                end)
            end)
        end
        
        -- Eventos
        checkbox.MouseButton1Click:Connect(function()
            aimAssistConfig[configKey].enabled = not aimAssistConfig[configKey].enabled
            checkMark.Visible = aimAssistConfig[configKey].enabled
            checkbox.BackgroundColor3 = aimAssistConfig[configKey].enabled and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 80)
        end)
        
        modeDropdown.MouseButton1Click:Connect(function()
            dropdownMenu.Visible = not dropdownMenu.Visible
        end)
        
        yPosition = yPosition + controlFrame.Size.Y.Offset + 10
        return controlFrame
    end
    
    -- Criar controles
    createControl("Aim Bot", "Gruda a mira no alvo", "aimBot", true, true)
    createControl("Auto Fire", "Atira automaticamente no alvo", "autoFire", false, false)
    createControl("Auto Wall", "Atira através de paredes quebráveis", "autoWall", false, false)
    
    -- Check Wall (sem dropdown)
    local checkWallFrame = Instance.new("Frame")
    checkWallFrame.Name = "CheckWallControl"
    checkWallFrame.Size = UDim2.new(1, -10, 0, 60)
    checkWallFrame.Position = UDim2.new(0, 5, 0, yPosition)
    checkWallFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    checkWallFrame.BorderSizePixel = 0
    checkWallFrame.Parent = controlsContainer
    
    local wallCorner = Instance.new("UICorner")
    wallCorner.CornerRadius = UDim.new(0, 6)
    wallCorner.Parent = checkWallFrame
    
    local wallCheckbox = Instance.new("TextButton")
    wallCheckbox.Name = "Checkbox"
    wallCheckbox.Size = UDim2.new(0, 20, 0, 20)
    wallCheckbox.Position = UDim2.new(0, 10, 0, 10)
    wallCheckbox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    wallCheckbox.Text = ""
    wallCheckbox.BorderSizePixel = 0
    wallCheckbox.Parent = checkWallFrame
    
    local wallCheckCorner = Instance.new("UICorner")
    wallCheckCorner.CornerRadius = UDim.new(0, 3)
    wallCheckCorner.Parent = wallCheckbox
    
    local wallCheckMark = Instance.new("TextLabel")
    wallCheckMark.Size = UDim2.new(1, 0, 1, 0)
    wallCheckMark.BackgroundTransparency = 1
    wallCheckMark.Text = "✓"
    wallCheckMark.TextColor3 = Color3.fromRGB(100, 255, 100)
    wallCheckMark.TextScaled = true
    wallCheckMark.Font = Enum.Font.GothamBold
    wallCheckMark.Visible = false
    wallCheckMark.Parent = wallCheckbox
    
    local wallLabel = Instance.new("TextLabel")
    wallLabel.Name = "Label"
    wallLabel.Size = UDim2.new(1, -50, 0, 20)
    wallLabel.Position = UDim2.new(0, 40, 0, 10)
    wallLabel.BackgroundTransparency = 1
    wallLabel.Text = "Check Wall"
    wallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    wallLabel.TextScaled = true
    wallLabel.Font = Enum.Font.Gotham
    wallLabel.TextXAlignment = Enum.TextXAlignment.Left
    wallLabel.Parent = checkWallFrame
    
    local wallDesc = Instance.new("TextLabel")
    wallDesc.Size = UDim2.new(1, -20, 0, 25)
    wallDesc.Position = UDim2.new(0, 10, 0, 30)
    wallDesc.BackgroundTransparency = 1
    wallDesc.Text = "Desativa todas as funções se o inimigo estiver atrás de parede"
    wallDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    wallDesc.TextSize = 10
    wallDesc.Font = Enum.Font.Gotham
    wallDesc.TextWrapped = true
    wallDesc.TextXAlignment = Enum.TextXAlignment.Left
    wallDesc.Parent = checkWallFrame
    
    wallCheckbox.MouseButton1Click:Connect(function()
        aimAssistConfig.checkWall = not aimAssistConfig.checkWall
        wallCheckMark.Visible = aimAssistConfig.checkWall
        wallCheckbox.BackgroundColor3 = aimAssistConfig.checkWall and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(60, 60, 80)
    end)
    
    -- Funcionalidade de arrastar
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Fechar GUI
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    return screenGui
end

-- Funções do Aim Assist
local function raycast(origin, direction, distance)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    return raycastResult
end

local function isWallBreakable(part)
    -- Verifica se a parede é quebrável
    if part and part.Parent then
        return part.CanCollide == false or part.Transparency > 0.5 or part.Material == Enum.Material.Glass
    end
    return false
end

local function checkWallBetweenTargets(start, target)
    local direction = (target - start).Unit
    local distance = (target - start).Magnitude
    
    local raycastResult = raycast(start, direction, distance)
    
    if raycastResult then
        if aimAssistConfig.autoWall.enabled then
            return not isWallBreakable(raycastResult.Instance)
        else
            return true -- Há parede
        end
    end
    
    return false -- Sem parede
end

local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
            local character = targetPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                local distance = (humanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                -- Verificar se há parede entre o jogador e o alvo
                if aimAssistConfig.checkWall then
                    local hasWall = checkWallBetweenTargets(
                        player.Character.HumanoidRootPart.Position,
                        humanoidRootPart.Position
                    )
                    
                    if hasWall then
                        continue -- Pular este alvo se há parede
                    end
                end
                
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = character
                end
            end
        end
    end
    
    return closestTarget
end

local function aimAtTarget(target)
    if not target then return end
    
    for _, partName in ipairs(aimAssistConfig.aimBot.targetParts) do
        local targetPart = target:FindFirstChild(partName)
        if targetPart then
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
            break
        end
    end
end

local function shouldAutoFire(target)
    if not target or not aimAssistConfig.autoFire.enabled then return false end
    
    local camera = workspace.CurrentCamera
    local ray = camera:ScreenPointToRay(Mouse.X, Mouse.Y)
    
    local raycastResult = raycast(ray.Origin, ray.Direction, 1000)
    
    if raycastResult and raycastResult.Instance then
        local hitCharacter = raycastResult.Instance.Parent
        if hitCharacter == target then
            local hitPart = raycastResult.Instance.Name
            return table.find({"Head", "Torso", "Left Leg", "Right Leg"}, hitPart) ~= nil
        end
    end
    
    return false
end

-- Sistema principal de aimbot
local isAiming = false
local aimConnection = nil

local function startAiming()
    if isAiming then return end
    isAiming = true
    
    aimConnection = RunService.Heartbeat:Connect(function()
        if not aimAssistConfig.aimBot.enabled then return end
        
        local target = getClosestTarget()
        if target then
            aimAtTarget(target)
            
            -- Auto Fire
            if shouldAutoFire(target) then
                Mouse1Click()
            end
        end
    end)
end

local function stopAiming()
    if not isAiming then return end
    isAiming = false
    
    if aimConnection then
        aimConnection:Disconnect()
        aimConnection = nil
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == aimAssistConfig.aimBot.key then
        if aimAssistConfig.aimBot.mode == "Toggle" then
            if isAiming then
                stopAiming()
            else
                startAiming()
            end
        elseif aimAssistConfig.aimBot.mode == "Hold" then
            startAiming()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == aimAssistConfig.aimBot.key and aimAssistConfig.aimBot.mode == "Hold" then
        stopAiming()
    end
end)

-- Always On mode
RunService.Heartbeat:Connect(function()
    if aimAssistConfig.aimBot.enabled and aimAssistConfig.aimBot.mode == "Always" then
        if not isAiming then
            startAiming()
        end
    elseif aimAssistConfig.aimBot.mode ~= "Always" and isAiming and aimAssistConfig.aimBot.mode ~= "Hold" then
        -- Para modos que não são Always, para o aimbot se não estiver em toggle ativo
    end
end)

-- Função para ativar/desativar GUI com tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then -- Tecla INSERT para abrir/fechar GUI
        if playerGui:FindFirstChild("AimAssistGUI") then
            playerGui.AimAssistGUI:Destroy()
        else
            createMainGUI()
        end
    end
end)

-- Sistema de notificações
local function createNotification(text, color)
    local notifGui = playerGui:FindFirstChild("NotificationGUI")
    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "NotificationGUI"
        notifGui.Parent = playerGui
        notifGui.ResetOnSpawn = false
    end
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, -320, 0, 20 + (#notifGui:GetChildren() - 1) * 70)
    notification.BackgroundColor3 = color or Color3.fromRGB(40, 40, 55)
    notification.BorderSizePixel = 0
    notification.Parent = notifGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextScaled = true
    notifText.Font = Enum.Font.Gotham
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Animação de entrada
    notification.Position = UDim2.new(1, 0, 0, 20 + (#notifGui:GetChildren() - 2) * 70)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 20 + (#notifGui:GetChildren() - 2) * 70)
    })
    tweenIn:Play()
    
    -- Auto-remover após 3 segundos
    wait(3)
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 0, 0, 20 + (#notifGui:GetChildren() - 2) * 70)
    })
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        notification:Destroy()
        
        -- Reposicionar outras notificações
        for i, child in ipairs(notifGui:GetChildren()) do
            if child:IsA("Frame") then
                local newPos = UDim2.new(1, -320, 0, 20 + (i-1) * 70)
                TweenService:Create(child, TweenInfo.new(0.2), {Position = newPos}):Play()
            end
        end
    end)
end

-- Sistema de status e feedback
local statusConnection = nil

local function updateStatus()
    if statusConnection then
        statusConnection:Disconnect()
    end
    
    statusConnection = RunService.Heartbeat:Connect(function()
        local gui = playerGui:FindFirstChild("AimAssistGUI")
        if not gui then return end
        
        local header = gui.MainFrame.Header
        
        -- Atualizar cor do header baseado no status
        if aimAssistConfig.aimBot.enabled and isAiming then
            header.BackgroundColor3 = Color3.fromRGB(50, 100, 50) -- Verde quando ativo
        elseif aimAssistConfig.aimBot.enabled then
            header.BackgroundColor3 = Color3.fromRGB(100, 100, 50) -- Amarelo quando habilitado mas não ativo
        else
            header.BackgroundColor3 = Color3.fromRGB(35, 35, 50) -- Padrão
        end
    end)
end

-- Validação de configurações
local function validateConfig()
    -- Validar se pelo menos uma parte do corpo está selecionada
    if aimAssistConfig.aimBot.enabled and #aimAssistConfig.aimBot.targetParts == 0 then
        createNotification("⚠️ Selecione pelo menos uma parte do corpo!", Color3.fromRGB(200, 100, 50))
        aimAssistConfig.aimBot.targetParts = {"Head"}
        return false
    end
    
    -- Validar conflitos de configuração
    if aimAssistConfig.checkWall and aimAssistConfig.autoWall.enabled then
        createNotification("⚠️ Check Wall e Auto Wall são conflitantes!", Color3.fromRGB(200, 100, 50))
    end
    
    return true
end

-- Sistema de profiles/presets
local presets = {
    legit = {
        aimBot = {enabled = true, mode = "Toggle", targetParts = {"Head"}, key = Enum.KeyCode.E},
        autoFire = {enabled = false, mode = "Toggle"},
        autoWall = {enabled = false, mode = "Toggle"},
        checkWall = true
    },
    rage = {
        aimBot = {enabled = true, mode = "Always", targetParts = {"Head", "Torso"}, key = Enum.KeyCode.E},
        autoFire = {enabled = true, mode = "Always"},
        autoWall = {enabled = true, mode = "Always"},
        checkWall = false
    },
    safe = {
        aimBot = {enabled = true, mode = "Hold", targetParts = {"Torso"}, key = Enum.KeyCode.E},
        autoFire = {enabled = false, mode = "Toggle"},
        autoWall = {enabled = false, mode = "Toggle"},
        checkWall = true
    }
}

-- Função para aplicar preset
local function applyPreset(presetName)
    if presets[presetName] then
        for key, value in pairs(presets[presetName]) do
            aimAssistConfig[key] = value
        end
        createNotification("✅ Preset '" .. presetName .. "' aplicado!", Color3.fromRGB(50, 200, 50))
        
        -- Atualizar GUI se estiver aberta
        local gui = playerGui:FindFirstChild("AimAssistGUI")
        if gui then
            gui:Destroy()
            createMainGUI()
        end
    end
end

-- Comandos de chat para presets
local function onChatted(message)
    local lowerMessage = string.lower(message)
    
    if string.find(lowerMessage, "/preset legit") then
        applyPreset("legit")
    elseif string.find(lowerMessage, "/preset rage") then
        applyPreset("rage")
    elseif string.find(lowerMessage, "/preset safe") then
        applyPreset("safe")
    elseif string.find(lowerMessage, "/aimgui") then
        if playerGui:FindFirstChild("AimAssistGUI") then
            playerGui.AimAssistGUI:Destroy()
        else
            createMainGUI()
        end
    end
end

if player.Chatted then
    player.Chatted:Connect(onChatted)
end

-- Sistema de segurança anti-detecção
local function randomizeValues()
    -- Adiciona pequenas variações aleatórias para evitar detecção
    wait(math.random(1, 3) / 100) -- Delay aleatório muito pequeno
end

-- Override da função de aim para incluir randomização
local originalAimAtTarget = aimAtTarget
aimAtTarget = function(target)
    randomizeValues()
    originalAimAtTarget(target)
end

-- Inicialização
print("🎯 AIM ASSIST LOADED SUCCESSFULLY!")
print("📋 Comandos disponíveis:")
print("   • INSERT - Abrir/Fechar GUI")
print("   • /aimgui - Toggle GUI via chat")
print("   • /preset legit - Aplicar preset legítimo")
print("   • /preset rage - Aplicar preset agressivo")
print("   • /preset safe - Aplicar preset seguro")
print("✨ Criado para Roblox - Use com responsabilidade!")

-- Criar GUI inicialmente
createMainGUI()
updateStatus()

-- Função de limpeza ao sair
game.Players.PlayerRemoving:Connect(function(removedPlayer)
    if removedPlayer == player then
        if statusConnection then
            statusConnection:Disconnect()
        end
        if aimConnection then
            aimConnection:Disconnect()
        end
    end
end)
