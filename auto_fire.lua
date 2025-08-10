local Aimbot = {}

-- Configurações
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis ajustáveis
Aimbot.FOV = 90
Aimbot.Smoothing = 0.5 -- Suavização do movimento (0 = instantâneo, 1 = muito lento)
Aimbot.TargetPart = "Head" -- Pode ser "Head", "HumanoidRootPart", etc.
Aimbot.VisibilityCheck = true -- Verifica se o alvo está visível
Aimbot.TeamCheck = true -- Ignora aliados
Aimbot.Enabled = false

-- Função para verificar visibilidade
local function isVisible(targetPart)
    if not Aimbot.VisibilityCheck then return true end
    local origin = Camera.CFrame.Position
    local target = targetPart.Position
    local direction = (target - origin).Unit * (origin - target).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return not raycastResult or raycastResult.Instance:IsDescendantOf(targetPart.Parent)
end

-- Função para encontrar o melhor alvo
local function findBestTarget()
    local bestTarget = nil
    local closestDistance = Aimbot.FOV
    local myTeam = LocalPlayer.Team if Aimbot.TeamCheck else nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local targetPart = player.Character:FindFirstChild(Aimbot.TargetPart)
            
            if humanoid and humanoid.Health > 0 and targetPart then
                -- Verifica time (se TeamCheck estiver ativo)
                if not Aimbot.TeamCheck or player.Team ~= myTeam then
                    -- Verifica visibilidade
                    if isVisible(targetPart) then
                        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local mousePos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                            local distance = (mousePos - targetPos).Magnitude
                            
                            if distance < closestDistance then
                                closestDistance = distance
                                bestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- Função para mirar suavemente
local function smoothAim(targetPart)
    local currentCFrame = Camera.CFrame
    local targetPosition = targetPart.Position
    local newCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    
    -- Aplica suavização
    Camera.CFrame = currentCFrame:Lerp(newCFrame, 1 - Aimbot.Smoothing)
end

-- Loop principal
RunService.Heartbeat:Connect(function()
    if not Aimbot.Enabled then return end
    
    local target = findBestTarget()
    if target then
        smoothAim(target)
    end
end)

-- Controles
function Aimbot.Toggle(state)
    Aimbot.Enabled = state
    print("[AIMBOT] " .. (state and "ATIVADO" or "DESATIVADO"))
end

function Aimbot.UpdateFOV(newFOV)
    Aimbot.FOV = newFOV
    print("[AIMBOT] FOV atualizado para:", newFOV)
end

return Aimbot
