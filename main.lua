-- Sistema Básico de Assistência de Mira para ROBLOX
-- LocalScript (deve ser colocado em StarterPlayerScripts)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- Configurações
local Config = {
    assistEnabled = false,
    maxDistance = 100, -- distância máxima para assistência
    smoothness = 5, -- suavidade da assistência (menor = mais suave)
    fov = 60, -- campo de visão para detecção
    targetTag = "Enemy", -- tag dos alvos (você pode usar Teams ou outros critérios)
}

-- Variáveis
local currentTarget = nil
local connection = nil

-- Função para verificar se um jogador está na equipe inimiga
local function isEnemy(targetPlayer)
    if not targetPlayer or targetPlayer == player then
        return false
    end
    
    -- Exemplo usando times diferentes
    if player.Team and targetPlayer.Team then
        return player.Team ~= targetPlayer.Team
    end
    
    -- Ou você pode usar uma pasta/tag específica
    local character = targetPlayer.Character
    if character and character:FindFirstChild(Config.targetTag) then
        return true
    end
    
    return false
end

-- Função para calcular distância 2D na tela
local function getScreenDistance(pos1, pos2)
    return math.sqrt((pos1.X - pos2.X)^2 + (pos1.Y - pos2.Y)^2)
end

-- Função para encontrar o alvo mais próximo
local function findClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if isEnemy(targetPlayer) then
            local character = targetPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local head = character:FindFirstChild("Head")
                
                if head then
                    -- Verifica distância 3D
                    local distance3D = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if distance3D <= Config.maxDistance then
                        
                        -- Converte posição 3D para 2D na tela
                        local screenPos, onScreen = camera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local screenDistance = getScreenDistance(screenCenter, Vector2.new(screenPos.X, screenPos.Y))
                            
                            -- Verifica se está dentro do FOV
                            if screenDistance <= Config.fov and screenDistance < closestDistance then
                                closestTarget = head
                                closestDistance = screenDistance
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Função de assistência suave
local function smoothAim(targetPosition)
    if not targetPosition then return end
    
    local screenPos = camera:WorldToScreenPoint(targetPosition)
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetScreenPos = Vector2.new(screenPos.X, screenPos.Y)
    
    -- Calcula a diferença
    local diff = targetScreenPos - screenCenter
    
    -- Aplica suavização
    local smoothDiff = diff / Config.smoothness
    
    -- Move o mouse gradualmente (simulação básica)
    -- Nota: Em ROBLOX, você precisará usar técnicas específicas para mover a câmera
    local currentCFrame = camera.CFrame
    local targetDirection = (targetPosition - currentCFrame.Position).Unit
    local newCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + targetDirection)
    
    -- Interpolação suave
    camera.CFrame = currentCFrame:Lerp(newCFrame, 1 / Config.smoothness)
end

-- Loop principal
local function aimAssistLoop()
    if Config.assistEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        currentTarget = findClosestTarget()
        
        if currentTarget then
            smoothAim(currentTarget.Position)
        end
    end
end

-- Toggle do sistema
local function toggleAimAssist()
    Config.assistEnabled = not Config.assistEnabled
    
    if Config.assistEnabled then
        print("Assistência de mira ATIVADA")
        connection = RunService.Heartbeat:Connect(aimAssistLoop)
    else
        print("Assistência de mira DESATIVADA")
        if connection then
            connection:Disconnect()
            connection = nil
        end
        currentTarget = nil
    end
end

-- Bind da tecla CapsLock
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.CapsLock then
        toggleAimAssist()
    end
end)

-- Interface básica de configuração
local function createConfigGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimAssistConfig"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 200)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "Aim Assist Config"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Adicione mais elementos de UI conforme necessário
end

-- Inicialização
spawn(function()
    wait(2) -- Espera o jogo carregar
    createConfigGui()
    print("Sistema de Assistência de Mira carregado!")
    print("Pressione CapsLock para ativar/desativar")
end)
