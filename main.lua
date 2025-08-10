-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Configurações
local aimbotEnabled = false
local autofireEnabled = false
local aimKey = Enum.KeyCode.CapsLock

-- GUI simples com Dropdown para ativar/desativar aimbot e autofire
local ScreenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "AimbotGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0

local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Ativar Aimbot:"
TextLabel.TextColor3 = Color3.new(1,1,1)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 18
TextLabel.Position = UDim2.new(0, 0, 0, 0)

local Dropdown = Instance.new("TextButton", Frame)
Dropdown.Size = UDim2.new(1, -20, 0, 30)
Dropdown.Position = UDim2.new(0, 10, 0, 40)
Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Dropdown.TextColor3 = Color3.new(1,1,1)
Dropdown.Font = Enum.Font.SourceSans
Dropdown.TextSize = 16
Dropdown.Text = "Desativado"

local options = {"Desativado", "Aimbot + Autofire"}
local dropdownOpen = false

Dropdown.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        local list = Instance.new("Frame", Frame)
        list.Name = "List"
        list.BackgroundColor3 = Color3.fromRGB(50,50,50)
        list.Size = UDim2.new(1, -20, 0, #options * 30)
        list.Position = UDim2.new(0, 10, 0, 70)

        for i, option in ipairs(options) do
            local btn = Instance.new("TextButton", list)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.SourceSans
            btn.TextSize = 16
            btn.Text = option

            btn.MouseButton1Click:Connect(function()
                Dropdown.Text = option
                aimbotEnabled = (option ~= "Desativado")
                autofireEnabled = aimbotEnabled -- os dois ativam juntos
                dropdownOpen = false
                list:Destroy()
            end)
        end
    else
        local list = Frame:FindFirstChild("List")
        if list then
            list:Destroy()
        end
    end
end)

-- Função para encontrar o alvo mais próximo no campo de visão (FOV)
local function getClosestTarget(maxDistance)
    local closestPlayer = nil
    local shortestDistance = maxDistance or 1000

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local headPos = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position)
            local distance = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    return closestPlayer
end

-- Função para mirar no inimigo
local aiming = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == aimKey and aimbotEnabled then
        aiming = not aiming
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == aimKey then
        aiming = false
    end
end)

RunService.RenderStepped:Connect(function()
    if aiming and aimbotEnabled then
        local target = getClosestTarget(100) -- 100 pixels de FOV
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            -- Move a mira do mouse para a cabeça do inimigo
            mousemoverel = mousemoverel or (function(dx, dy)
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:Button1Down(Vector2.new(0,0))
                virtualUser:MoveMouseRelative(dx, dy)
                virtualUser:Button1Up(Vector2.new(0,0))
            end)

            local camera = workspace.CurrentCamera
            local cameraPos = camera.CFrame.Position
            local screenPos, onScreen = camera:WorldToScreenPoint(headPos)
            if onScreen then
                local dx = screenPos.X - mouse.X
                local dy = screenPos.Y - mouse.Y
                -- Ajuste fino para suavizar o movimento
                mousemoverel(dx * 0.5, dy * 0.5)

                -- Autofire
                if autofireEnabled then
                    mouse1click = mouse1click or function()
                        local virtualUser = game:GetService("VirtualUser")
                        virtualUser:Button1Down(Vector2.new(0,0))
                        wait(0.01)
                        virtualUser:Button1Up(Vector2.new(0,0))
                    end
                    mouse1click()
                end
            end
        end
    end
end)
