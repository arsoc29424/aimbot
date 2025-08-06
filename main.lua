-- LocalScript: AimbotGUIAndLogic.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- CONFIGURAÇÕES PADRÃO
local settings = {
	AimKey = Enum.KeyCode.E,
	AimMode = "Hold", -- "Hold", "Toggle", "Always"
	DrawFOV = true,
	FOVRadius = 150,
	AimPart = "Head",
	MaxDistance = 300,
	Smoothness = 0.15,
}

-- ESTADO
local aiming = false
local toggled = false

-- GUI
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "AimbotUI"
screenGui.ResetOnSpawn = false

-- Círculo do FOV
local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
fovCircle.Position = UDim2.new(0.5, -settings.FOVRadius, 0.5, -settings.FOVRadius)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BorderSizePixel = 1
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = settings.DrawFOV
fovCircle.Parent = screenGui

local uiCorner = Instance.new("UICorner", fovCircle)
uiCorner.CornerRadius = UDim.new(1, 0)

-- GUI de opções
local guiFrame = Instance.new("Frame", screenGui)
guiFrame.Size = UDim2.new(0, 200, 0, 180)
guiFrame.Position = UDim2.new(0, 10, 0, 10)
guiFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
guiFrame.BorderSizePixel = 0
guiFrame.Name = "Settings"

local uiList = Instance.new("UIListLayout", guiFrame)
uiList.Padding = UDim.new(0, 5)

local function createToggle(labelText, defaultState, callback)
	local button = Instance.new("TextButton", guiFrame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = labelText .. ": " .. (defaultState and "ON" or "OFF")
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1,1,1)
	button.MouseButton1Click:Connect(function()
		defaultState = not defaultState
		button.Text = labelText .. ": " .. (defaultState and "ON" or "OFF")
		callback(defaultState)
	end)
end

local function createDropdown(labelText, options, default, callback)
	local label = Instance.new("TextLabel", guiFrame)
	label.Size = UDim2.new(1, -10, 0, 25)
	label.Text = labelText .. ": " .. default
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local button = Instance.new("TextButton", guiFrame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = "Mudar"
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1,1,1)

	local current = 1
	button.MouseButton1Click:Connect(function()
		current = current + 1
		if current > #options then current = 1 end
		label.Text = labelText .. ": " .. options[current]
		callback(options[current])
	end)
end

local function createKeybind(labelText, currentKey, callback)
	local label = Instance.new("TextLabel", guiFrame)
	label.Size = UDim2.new(1, -10, 0, 25)
	label.Text = labelText .. ": " .. currentKey.Name
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local button = Instance.new("TextButton", guiFrame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Text = "Mudar Tecla"
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1,1,1)

	button.MouseButton1Click:Connect(function()
		button.Text = "Pressione..."
		local conn
		conn = UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				settings.AimKey = input.KeyCode
				label.Text = labelText .. ": " .. input.KeyCode.Name
				button.Text = "Mudar Tecla"
				conn:Disconnect()
				callback(input.KeyCode)
			end
		end)
	end)
end

-- Criando opções
createToggle("Mostrar FOV", settings.DrawFOV, function(val)
	settings.DrawFOV = val
	fovCircle.Visible = val
end)

createDropdown("Modo de Mira", {"Hold", "Toggle", "Always"}, "Hold", function(val)
	settings.AimMode = val
end)

createKeybind("Tecla Mira", settings.AimKey, function(val)
	settings.AimKey = val
end)

-- Lógica do aimbot
local function getClosestTarget()
	local closest = nil
	local shortestAngle = math.rad(settings.FOVRadius)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild(settings.AimPart) then
			local part = player.Character[settings.AimPart]
			local direction = (part.Position - camera.CFrame.Position).Unit
			local angle = math.acos(camera.CFrame.LookVector:Dot(direction))
			local distance = (camera.CFrame.Position - part.Position).Magnitude

			local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
			local mousePos = UserInputService:GetMouseLocation()
			local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude

			if angle < shortestAngle and distance <= settings.MaxDistance and distToMouse <= settings.FOVRadius then
				local ray = Ray.new(camera.CFrame.Position, direction * distance)
				local hit = workspace:FindPartOnRay(ray, localPlayer.Character, false, true)

				if hit and part:IsDescendantOf(hit.Parent) then
					closest = part
					shortestAngle = angle
				end
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	if settings.DrawFOV then
		fovCircle.Position = UDim2.new(0, UserInputService:GetMouseLocation().X, 0, UserInputService:GetMouseLocation().Y)
		fovCircle.Size = UDim2.new(0, settings.FOVRadius * 2, 0, settings.FOVRadius * 2)
	end

	if settings.AimMode == "Always" then
		aiming = true
	elseif settings.AimMode == "Hold" then
		aiming = UserInputService:IsKeyDown(settings.AimKey)
	end

	if aiming or toggled then
		local target = getClosestTarget()
		if target then
			local direction = (target.Position - camera.CFrame.Position).Unit
			local newLook = camera.CFrame.LookVector:Lerp(direction, settings.Smoothness)
			camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + newLook)
		end
	end
end)

-- Input para modo Toggle
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == settings.AimKey and settings.AimMode == "Toggle" then
		toggled = not toggled
	end
end)
