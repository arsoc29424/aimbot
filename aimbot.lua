local Aimbot = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

function Aimbot.UpdateFOV(fov)
    print("[AIMBOT] FOV atualizado para:", fov)
    Aimbot.FOV = fov
end

Aimbot.FOV = 90
Aimbot.Enabled = false

local function findClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Aimbot.FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local screenPoint, visible = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                if visible then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local pointPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mousePos - pointPos).Magnitude
                    
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(target)
    if not target or not target.Character then return end
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    
    local camera = workspace.CurrentCamera
    camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
end

RunService.Heartbeat:Connect(function()
    if not Aimbot.Enabled then return end
    
    local closest = findClosestPlayer()
    if closest then
        aimAt(closest)
    end
end)

function Aimbot.Toggle(state)
    Aimbot.Enabled = state
    print("[AIMBOT] Estado:", state and "ATIVADO" or "DESATIVADO")
end

return Aimbot
