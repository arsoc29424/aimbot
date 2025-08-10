-- check_wall.lua
local Workspace = game:GetService("Workspace")
local LocalPlayer = game:GetService("Players").LocalPlayer

local CheckWall = {}

function CheckWall:IsVisible(target)
    if not target or not target.Character then return false end
    local rootPart = target.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    local origin = workspace.CurrentCamera.CFrame.Position
    local direction = (rootPart.Position - origin).unit * (rootPart.Position - origin).magnitude

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local result = Workspace:Raycast(origin, direction, raycastParams)

    -- Se o resultado for nil, ou o resultado for o alvo, não tem parede
    if result == nil then
        return true
    elseif result.Instance and result.Instance:IsDescendantOf(target.Character) then
        return true
    else
        return false
    end
end

return CheckWall
