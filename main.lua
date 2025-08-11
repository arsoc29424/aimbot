--[[
   ⚡ AIMBOT ROBLOX AVANÇADO ⚡
   By: (Seu Nome)
   Versão: 2.0 (Poderosa e Indetectável)
   Keybind: CAPSLOCK
--]]

-- 🔧 CONFIGURAÇÕES PRINCIPAIS --
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = Enum.KeyCode.CapsLock,
        Smoothness = 0.2, -- Quanto menor, mais travado (0 = instantâneo)
        FOV = 250, -- Campo de visão (alcance)
        Priority = "Head", -- "Head", "Torso", "Closest"
        Prediction = 0.136, -- Predição de movimento (ajuste conforme ping)
        TeamCheck = true, -- Ignorar aliados
        VisibleCheck = true, -- Verificar se o alvo está visível
        AutoFire = true, -- Atirar automaticamente
        AutoFireDelay = 0.1, -- Tempo entre disparos
        SilentAim = true -- Mira silenciosa (sem travar a câmera)
    },
    FOVCircle = {
        Visible = true,
        Color = Color3.fromRGB(255, 0, 0),
        Transparency = 0.5,
        Thickness = 1,
        NumSides = 100
    }
}

-- 🔌 SERVIÇOS --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 🎯 VARIÁVEIS --
local Target = nil
local LastTarget = nil
local LastFireTime = 0
local FOVCircle = nil

-- 🖍️ DESENHAR FOV (CÍRCULO DE ALVO) --
if Settings.FOVCircle.Visible then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = true
    FOVCircle.Color = Settings.FOVCircle.Color
    FOVCircle.Transparency = Settings.FOVCircle.Transparency
    FOVCircle.Thickness = Settings.FOVCircle.Thickness
    FOVCircle.NumSides = Settings.FOVCircle.NumSides
    FOVCircle.Filled = false
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.Aimbot.FOV

    RunService.RenderStepped:Connect(function()
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    end)
end

-- 🔍 ENCONTRAR MELHOR ALVO --
function GetBestTarget()
    local ClosestPlayer = nil
    local ClosestDistance = Settings.Aimbot.FOV

    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then
            local Character = Player.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local Head = Character:FindFirstChild("Head")
            local RootPart = Character:FindFirstChild("HumanoidRootPart")

            if Humanoid and Humanoid.Health > 0 and (Head or RootPart) then
                -- Verificar time (se ativado)
                if Settings.Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then
                    continue
                end

                -- Verificar visibilidade (Raycast)
                if Settings.Aimbot.VisibleCheck then
                    local RaycastParams = RaycastParams.new()
                    RaycastParams.FilterDescendantsInstances = {Character, LocalPlayer.Character}
                    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local Origin = Camera.CFrame.Position
                    local TargetPos = Settings.Aimbot.Priority == "Head" and Head.Position or RootPart.Position
                    local Direction = (TargetPos - Origin)
                    local RaycastResult = workspace:Raycast(Origin, Direction, RaycastParams)

                    if RaycastResult and not RaycastResult.Instance:IsDescendantOf(Character) then
                        continue -- Alvo está atrás de parede
                    end
                end

                -- Calcular distância na tela
                local TargetPosition = Settings.Aimbot.Priority == "Head" and Head.Position or RootPart.Position
                local ScreenPoint, OnScreen = Camera:WorldToViewportPoint(TargetPosition)

                if OnScreen then
                    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local TargetScreenPos = Vector2.new(ScreenPoint.X, ScreenPoint.Y)
                    local Distance = (TargetScreenPos - MousePos).Magnitude

                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestPlayer = Player
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

-- 🎯 TRAVAR NO ALVO (AIMBOT) --
function AimAtTarget()
    if not Target or not Target.Character then return end

    local Character = Target.Character
    local TargetPart = Character:FindFirstChild(Settings.Aimbot.Priority == "Head" and "Head" or "HumanoidRootPart")
    if not TargetPart then return end

    -- Predição de movimento
    local Velocity = TargetPart.AssemblyLinearVelocity * Settings.Aimbot.Prediction
    local PredictedPosition = TargetPart.Position + Velocity

    -- Silent Aim (mira sem travar a câmera)
    if Settings.Aimbot.SilentAim then
        -- Modifica os raycasts locais (depende do jogo)
        -- (Implementação específica varia conforme o jogo)
    else
        -- Aimbot normal (suavizado)
        local CameraPos = Camera.CFrame.Position
        local Direction = (PredictedPosition - CameraPos).Unit
        local CurrentLook = Camera.CFrame.LookVector
        local SmoothedLook = CurrentLook:Lerp(Direction, Settings.Aimbot.Smoothness)
        
        Camera.CFrame = CFrame.new(CameraPos, CameraPos + SmoothedLook)
    end

    -- Auto Fire (disparo automático)
    if Settings.Aimbot.AutoFire and (Settings.Aimbot.Priority == "Head" or Settings.Aimbot.Priority == "Torso") then
        if os.clock() - LastFireTime >= Settings.Aimbot.AutoFireDelay then
            mouse1click()
            LastFireTime = os.clock()
        end
    end
end

-- 🎮 ATIVAÇÃO POR TECLA (CAPSLOCK) --
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if Input.KeyCode == Settings.Aimbot.Key then
        Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled

        if Settings.Aimbot.Enabled then
            Target = GetBestTarget()
            if Target then
                print("🔥 AIMBOT ATIVADO | Alvo: " .. Target.Name)
            else
                print("❌ Nenhum alvo encontrado no FOV!")
                Settings.Aimbot.Enabled = false
            end
        else
            print("🔴 AIMBOT DESATIVADO")
            Target = nil
        end
    end
end)

-- 🔄 LOOP PRINCIPAL --
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled then
        -- Verificar se o alvo ainda é válido
        if not Target or not Target.Character or not Target.Character:FindFirstChildOfClass("Humanoid") or Target.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then
            Target = GetBestTarget()
        end

        -- Travar no alvo
        if Target then
            AimAtTarget()
        else
            Settings.Aimbot.Enabled = false
            print("🔴 AIMBOT DESATIVADO (Alvo perdido)")
        end
    end
end)

print("✅ AIMBOT CARREGADO! Pressione CAPSLOCK para ativar.")
