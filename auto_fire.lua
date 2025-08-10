-- auto_fire.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AutoFire = {}
AutoFire.Enabled = false
AutoFire.Target = nil
AutoFire.Tool = nil

function AutoFire:GetCurrentTool()
    local character = LocalPlayer.Character
    if not character then return nil end
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            return tool
        end
    end
    return nil
end

function AutoFire:IsTargetInCrosshair(target)
    if not target or not target.Character then return false end
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    if not onScreen then return false end

    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).magnitude

    -- Você pode ajustar o valor de threshold para quanto perto do centro é "no alvo"
    return distance < 30
end

function AutoFire:Fire()
    local tool = self:GetCurrentTool()
    if tool and tool:FindFirstChild("Activate") then
        tool:Activate()
    elseif tool and tool:IsA("Tool") then
        tool:Activate()
    end
end

function AutoFire:Start()
    self.Connection = RunService.RenderStepped:Connect(function()
        if not self.Enabled then return end
        self.Tool = self:GetCurrentTool()
        if not self.Tool then return end

        -- Tente encontrar o alvo mais próximo no centro da tela
        local target = nil
        local closestDistance = math.huge
        local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).magnitude
                        if dist < closestDistance and dist < 30 then
                            closestDistance = dist
                            target = player
                        end
                    end
                end
            end
        end

        if target then
            self:Fire()
        end
    end)
end

function AutoFire:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

return AutoFire
