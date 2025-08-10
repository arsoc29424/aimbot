-- aimbot.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Aimbot = {}
Aimbot.Enabled = false
Aimbot.FOV = 90 -- padrão (depois ajustar pela UI)

function Aimbot:GetClosestTarget()
    local closestPlayer = nil
    local closestDistance = math.huge
    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).magnitude
                    if distance <= self.FOV and distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

function Aimbot:AimAt(target)
    if not target or not target.Character then return end
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    -- 0 smooth = trava direto a mira no alvo
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, rootPart.Position)
end

function Aimbot:Start()
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end

        local target = self:GetClosestTarget()
        if target then
            self:AimAt(target)
        end
    end)
end

function Aimbot:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

return Aimbot
