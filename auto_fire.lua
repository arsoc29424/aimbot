local AutoFire = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

AutoFire.Enabled = false

local function isMouseDown()
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
end

local function fire()
    if not AutoFire.Enabled then return end
    
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("RemoteFunction")
        if remote then
            remote:FireServer("Fire", Mouse.Hit)
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if AutoFire.Enabled and isMouseDown() then
        fire()
    end
end)

function AutoFire.Toggle(state)
    AutoFire.Enabled = state
    print("[AUTO FIRE] Estado:", state and "ATIVADO" or "DESATIVADO")
end

return AutoFire
