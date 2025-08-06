-- LocalScript: ImprovedAutoAimSystem.lua
-- Sistema de Auto-Aim para desenvolvimento de jogos próprios

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
    MinDistance = 5, -- Evitar targets muito próximos
    
    -- Comportamento
    Smoothness = 0.25,
    AimStrength = 1.0,
    Prediction = 0.1,
    
    -- Filtros
    WallCheck = false,
    TeamCheck = true,
    IgnoreInvisible = true,
    TargetNPCsOnly = false, -- Para jogos PvE
    
    -- Performance
    UpdateRate = 60, -- FPS do sistema
    MaxTargetsToCheck = 20 -- Limite de alvos para otimização
}

-- ESTADO DO SISTEMA
local SystemState = {
    isActive = false,
    isToggled = false,
    currentTarget = nil,
    lastUpdate = 0,
    connections = {},
    guiElements = {}
}

-- SISTEMA DE CLEANUP MELHORADO
local function cleanupSystem()
    print("[AutoAim] Iniciando cleanup...")
    
    -- Desconectar todas as conexões
    for name, connection in pairs(SystemState.connections) do
        if connection and connection.Connected then
            connection:Disconnect()
            print("[AutoAim] Desconectado:", name)
        end
    end
    SystemState.connections = {}
    
    -- Limpar GUI
    if SystemState.guiElements.screenGui then
        SystemState.guiElements.screenGui:Destroy()
    end
    SystemState.guiElements = {}
    
    -- Reset do estado
    SystemState.isActive = false
    SystemState.isToggled = false
    SystemState.currentTarget = nil
    
    print("[AutoAim] Cleanup concluído")
end

-- VALIDAÇÕES DE SEGURANÇA
local function validateEnvironment()
    if not localPlayer or not localPlayer.Parent then
        warn("[AutoAim] Jogador local inválido")
        return false
    end
    
    if not camera or not camera.Parent then
        camera = workspace.CurrentCamera
        if not camera then
            warn("[AutoAim] Câmera inválida")
            return false
        end
    end
    
    return true
end

-- FUNÇÃO DE TARGETING OTIMIZADA
local function getOptimalTarget()
    if not validateEnvironment() then return nil end
    
    local potentialTargets = {}
    local playerCount = 0
    
    -- Coletar alvos potenciais
    for _, player in ipairs(Players:GetPlayers()) do
        if playerCount >= AimSettings.MaxTargetsToCheck then break end
        
        if player ~= localPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(AimSettings.AimPart)
            if not targetPart then continue end
            
            -- Verificação de time
            if AimSettings.TeamCheck and player.Team and localPlayer.Team 
               and player.Team == localPlayer.Team then
                continue
            end
            
            -- Verificação de NPCs apenas
            if AimSettings.TargetNPCsOnly and Players:GetPlayerFromCharacter(player.Character) then
                continue
            end
            
            -- Verificação de visibilidade
            if AimSettings.IgnoreInvisible then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= 0 then continue end
            end
            
            table.insert(potentialTargets, {
                player = player,
                character = player.Character,
                targetPart = targetPart
            })
            playerCount = playerCount + 1
        end
    end
    
    if #potentialTargets == 0 then return nil end
    
    -- Avaliar e selecionar o melhor alvo
    local bestTarget = nil
    local bestScore = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, target in ipairs(potentialTargets) do
        local targetPart = target.targetPart
        local humanoidRootPart = target.character:FindFirstChild("HumanoidRootPart")
        
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
        
        -- Verificação de parede (opcional)
        if AimSettings.WallCheck then
            local rayDirection = targetPosition - camera.CFrame.Position
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {localPlayer.Character}
            
            local success2, rayResult = pcall(function()
                return workspace:Raycast(camera.CFrame.Position, rayDirection, raycastParams)
            end)
            
            if success2 and rayResult then
                local hitPart = rayResult.Instance
                if not hitPart:IsDescendantOf(target.character) then
                    continue
                end
            end
        end
        
        -- Calcular score (menor é melhor)
        local score = screenDistance + (distance3D * 0.1)
        
        if score < bestScore then
            bestScore = score
            bestTarget = {
                character = target.character,
                part = targetPart,
                position = targetPosition,
                distance = distance3D,
                screenDistance = screenDistance,
                player = target.player
            }
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
    
    if not success then
        warn("[AutoAim] Erro ao aplicar mira")
    end
end

-- CRIAÇÃO DA GUI OTIMIZADA
local function createImprovedGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoAimSystem"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    
    SystemState.guiElements.screenGui = screenGui
    
    -- Círculo FOV
    if AimSettings.DrawFOV then
        local fovCircle = Instance.new("Frame")
        fovCircle.Name = "FOVCircle"
        fovCircle.Size = UDim2.new(0, AimSettings.FOVRadius * 2, 0, AimSettings.FOVRadius * 2)
        fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
        fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
        fovCircle.BackgroundTransparency = 1
        fovCircle.BorderSizePixel = 0
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
    
    -- Indicador de status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 200, 0, 30)
    statusLabel.Position = UDim2.new(0, 20, 0, 20)
    statusLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    statusLabel.BackgroundTransparency = 0.3
    statusLabel.Text = "Auto-Aim: Desativado"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = screenGui
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusLabel
    
    SystemState.guiElements.statusLabel = statusLabel
    
    print("[AutoAim] GUI criada com sucesso")
end

-- ATUALIZAÇÃO DO SISTEMA PRINCIPAL
local function updateSystem()
    local currentTime = tick()
    local deltaTime = currentTime - SystemState.lastUpdate
    
    -- Limitar taxa de atualização para performance
    if deltaTime < (1 / AimSettings.UpdateRate) then return end
    SystemState.lastUpdate = currentTime
    
    if not validateEnvironment() then
        cleanupSystem()
        return
    end
    
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
        local success = pcall(function()
            return UserInputService:IsKeyDown(AimSettings.AimKey)
        end)
        shouldAim = success and UserInputService:IsKeyDown(AimSettings.AimKey)
    elseif AimSettings.AimMode == "Toggle" then
        shouldAim = SystemState.isToggled
    elseif AimSettings.AimMode == "Disabled" then
        shouldAim = false
    end
    
    SystemState.isActive = shouldAim
    
    -- Atualizar status visual
    if SystemState.guiElements.statusLabel then
        local statusText = "Auto-Aim: " .. (shouldAim and "ATIVO" or "Desativado")
        if shouldAim and SystemState.currentTarget then
            statusText = statusText .. " | Alvo: " .. SystemState.currentTarget.player.Name
        end
        SystemState.guiElements.statusLabel.Text = statusText
        SystemState.guiElements.statusLabel.TextColor3 = shouldAim and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
    end
    
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
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == AimSettings.AimKey and AimSettings.AimMode == "Toggle" then
                SystemState.isToggled = not SystemState.isToggled
                print("[AutoAim] Toggle:", SystemState.isToggled)
                
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
    end)
end

-- INICIALIZAÇÃO DO SISTEMA
local function initializeSystem()
    print("[AutoAim] Inicializando sistema...")
    
    -- Validar ambiente
    if not validateEnvironment() then
        warn("[AutoAim] Ambiente inválido, cancelando inicialização")
        return false
    end
    
    -- Criar GUI
    createImprovedGUI()
    
    -- Configurar input
    setupInputHandling()
    
    -- Loop principal
    SystemState.connections.heartbeat = RunService.Heartbeat:Connect(updateSystem)
    
    -- Cleanup automático
    SystemState.connections.playerRemoving = Players.PlayerRemoving:Connect(function(player)
        if player == localPlayer then
            cleanupSystem()
        end
    end)
    
    SystemState.connections.ancestryChanged = SystemState.guiElements.screenGui.AncestryChanged:Connect(function()
        if not SystemState.guiElements.screenGui.Parent then
            cleanupSystem()
        end
    end)
    
    -- Cleanup no fechamento
    game:BindToClose(cleanupSystem)
    
    print("[AutoAim] Sistema inicializado com sucesso!")
    print("[AutoAim] Tecla de controle:", AimSettings.AimKey.Name)
    print("[AutoAim] Modo:", AimSettings.AimMode)
    
    return true
end

-- API PÚBLICA PARA CONFIGURAÇÃO
local AutoAimAPI = {}

function AutoAimAPI:SetAimKey(keyCode)
    AimSettings.AimKey = keyCode
    print("[AutoAim] Nova tecla:", keyCode.Name)
end

function AutoAimAPI:SetAimMode(mode)
    if mode == "Hold" or mode == "Toggle" or mode == "Always" or mode == "Disabled" then
        AimSettings.AimMode = mode
        print("[AutoAim] Novo modo:", mode)
    else
        warn("[AutoAim] Modo inválido:", mode)
    end
end

function AutoAimAPI:SetFOVRadius(radius)
    AimSettings.FOVRadius = math.clamp(radius, 10, 1000)
    print("[AutoAim] Novo raio FOV:", AimSettings.FOVRadius)
end

function AutoAimAPI:SetSmoothness(smoothness)
    AimSettings.Smoothness = math.clamp(smoothness, 0.01, 1)
    print("[AutoAim] Nova suavidade:", AimSettings.Smoothness)
end

function AutoAimAPI:ToggleWallCheck(enabled)
    AimSettings.WallCheck = enabled
    print("[AutoAim] Verificação de parede:", enabled)
end

function AutoAimAPI:GetCurrentTarget()
    return SystemState.currentTarget
end

function AutoAimAPI:IsActive()
    return SystemState.isActive
end

function AutoAimAPI:Shutdown()
    cleanupSystem()
end

-- Inicializar automaticamente
if initializeSystem() then
    -- Disponibilizar API globalmente para outros scripts
    _G.AutoAimAPI = AutoAimAPI
    
    print("[AutoAim] ✅ Sistema pronto para uso!")
    print("[AutoAim] Use _G.AutoAimAPI para configurações avançadas")
else
    warn("[AutoAim] ❌ Falha na inicialização")
end

return AutoAimAPI
