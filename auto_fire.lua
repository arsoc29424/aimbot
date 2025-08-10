local AutoFire = {}

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configurações
AutoFire.Enabled = false
AutoFire.RequireHeadshot = true -- Só atira se estiver mirando na cabeça
AutoFire.FireDelay = 0.1 -- Delay entre os tiros (em segundos)
AutoFire.LastFireTime = 0

-- Verifica se o mouse está pressionado
local function isMouseDown()
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

-- Verifica se está mirando na cabeça do alvo
local function isAimingAtHead()
    if not AutoFire.RequireHeadshot then return true end
    
    local targetPart = workspace:FindPartOnRayWithIgnoreList(
        Ray.new(
            Camera.CFrame.Position,
            Camera.CFrame.LookVector * 1000
        ),
        {LocalPlayer.Character}
    )
    
    return targetPart and targetPart.Name == "Head" and targetPart.Parent:FindFirstChildOfClass("Humanoid")
end

-- Função principal de disparo
local function fire()
    if not AutoFire.Enabled then return end
    if not isMouseDown() then return end
    if AutoFire.RequireHeadshot and not isAimingAtHead() then return end
    if tick() - AutoFire.LastFireTime < AutoFire.FireDelay then return end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
        if remote then
            remote:FireServer("Fire", Camera.CFrame.LookVector * 1000)
            AutoFire.LastFireTime = tick()
        end
    end
end

-- Loop de execução
RunService.Heartbeat:Connect(fire)

-- Controles
function AutoFire.Toggle(state)
    AutoFire.Enabled = state
    print("[AUTO FIRE] " .. (state and "ATIVADO" or "DESATIVADO"))
end

return AutoFire
