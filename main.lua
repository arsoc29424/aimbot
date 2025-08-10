-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Constants
local COLOR = {
    BACKGROUND = Color3.fromRGB(20, 20, 20),
    TITLEBAR = Color3.fromRGB(30, 30, 30),
    BUTTON = Color3.fromRGB(45, 45, 45),
    BUTTON_HOVER = Color3.fromRGB(60, 60, 60),
    TEXT = Color3.fromRGB(255, 255, 255),
    CHECKBOX = Color3.fromRGB(60, 60, 60)
}

local FONT = {
    TITLE = Enum.Font.GothamBold,
    BUTTON = Enum.Font.GothamBold,
    TEXT = Enum.Font.Gotham
}

local SIZES = {
    WINDOW = UDim2.new(0, 520, 0, 360),
    TITLEBAR = UDim2.new(1, 0, 0, 36),
    SIDEBAR = UDim2.new(0, 130, 1, -36),
    BUTTON = UDim2.new(1, 0, 0, 38)
}

local CORNER_RADIUS = {
    WINDOW = 12,
    BUTTON = 8,
    CHECKBOX = 4,
    COLOR_PICKER = 6
}

-- Utility Functions
local function create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        instance[prop] = value
    end
    return instance
end

local function tween(object, properties, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main UI Creation
local ModernUI = {}
ModernUI.__index = ModernUI

function ModernUI.new(title)
    local self = setmetatable({}, ModernUI)
    
    self.LocalPlayer = Players.LocalPlayer
    self.PlayerGui = self.LocalPlayer:WaitForChild("PlayerGui")
    self.ActivePage = nil
    self.Pages = {}
    self.Components = {}
    
    self:CreateMainWindow(title)
    self:SetupDragging()
    self:CreateSidebar()
    
    return self
end

function ModernUI:CreateMainWindow(title)
    -- ScreenGui
    self.ScreenGui = create("ScreenGui", {
        Name = "ModernUI",
        Parent = self.PlayerGui,
        ResetOnSpawn = false
    })
    
    -- Main Window Frame
    self.MainFrame = create("Frame", {
        Size = SIZES.WINDOW,
        Position = UDim2.new(0.5, -260, 0.5, -180),
        BackgroundColor3 = COLOR.BACKGROUND,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.WINDOW),
        Parent = self.MainFrame
    })
    
    -- Title Bar
    self.TitleBar = create("Frame", {
        Size = SIZES.TITLEBAR,
        BackgroundColor3 = COLOR.TITLEBAR,
        Parent = self.MainFrame
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.WINDOW),
        Parent = self.TitleBar
    })
    
    self.TitleLabel = create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Modern GUI",
        Font = FONT.TITLE,
        TextSize = 18,
        TextColor3 = COLOR.TEXT,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
    -- Content Area
    self.ContentFrame = create("Frame", {
        Size = UDim2.new(1, -130, 1, -36),
        Position = UDim2.new(0, 130, 0, 36),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
end

function ModernUI:SetupDragging()
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function ModernUI:CreateSidebar()
    self.SideBar = create("Frame", {
        Size = SIZES.SIDEBAR,
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = COLOR.TITLEBAR,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.WINDOW),
        Parent = self.SideBar
    })
    
    create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = self.SideBar
    })
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = self.SideBar
    })
end

function ModernUI:CreateTab(name)
    local button = create("TextButton", {
        Size = SIZES.BUTTON,
        BackgroundColor3 = COLOR.BUTTON,
        TextColor3 = COLOR.TEXT,
        Font = FONT.BUTTON,
        TextSize = 14,
        Text = name,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = self.SideBar
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.BUTTON),
        Parent = button
    })
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        tween(button, {BackgroundColor3 = COLOR.BUTTON_HOVER})
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {BackgroundColor3 = COLOR.BUTTON})
    end)
    
    return button
end

function ModernUI:CreatePage(name)
    local page = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.ContentFrame
    })
    
    -- Setup layout for the page
    create("UIListLayout", {
        Parent = page,
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })
    
    create("UIPadding", {
        Parent = page,
        PaddingTop = UDim.new(0, 25),
        PaddingLeft = UDim.new(0, 15)
    })
    
    self.Pages[name] = page
    return page
end

function ModernUI:ShowPage(name)
    if self.ActivePage then
        self.ActivePage.Visible = false
    end
    
    self.ActivePage = self.Pages[name]
    if self.ActivePage then
        self.ActivePage.Visible = true
    end
end

function ModernUI:CreateCheckboxOption(parent, text, callback)
    local optionFrame = create("Frame", {
        Size = UDim2.new(0, 220, 0, 24),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local box = create("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = COLOR.CHECKBOX,
        BorderSizePixel = 0,
        Parent = optionFrame
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.CHECKBOX),
        Parent = box
    })
    
    local check = create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = COLOR.TEXT,
        Font = FONT.TITLE,
        TextSize = 16,
        Text = "",
        Parent = box
    })
    
    local label = create("TextLabel", {
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = COLOR.TEXT,
        Font = FONT.TEXT,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = text,
        Parent = optionFrame
    })
    
    local checked = false
    
    local function toggle()
        checked = not checked
        check.Text = checked and "✓" or ""
        if callback then
            callback(checked)
        end
        return checked
    end
    
    optionFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
        end
    end)
    
    return {
        Frame = optionFrame,
        Toggle = toggle,
        IsChecked = function() return checked end,
        SetChecked = function(value)
            checked = value
            check.Text = checked and "✓" or ""
        end
    }
end

function ModernUI:CreateColorPicker(parent, initialColor, callback)
    local pickerFrame = create("Frame", {
        Size = UDim2.new(0, 24, 0, 24),
        BackgroundColor3 = initialColor or COLOR.TEXT,
        BorderSizePixel = 0,
        Parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, CORNER_RADIUS.COLOR_PICKER),
        Parent = pickerFrame
    })
    
    local colors = {
        Color3.fromRGB(255, 0, 0),    -- Red
        Color3.fromRGB(0, 255, 0),    -- Green
        Color3.fromRGB(0, 0, 255),    -- Blue
        Color3.fromRGB(255, 255, 0),  -- Yellow
        Color3.fromRGB(255, 0, 255),  -- Magenta
        Color3.fromRGB(0, 255, 255),  -- Cyan
        Color3.fromRGB(255, 255, 255),-- White
        Color3.fromRGB(128, 128, 128),-- Gray
        Color3.fromRGB(255, 165, 0),  -- Orange
        Color3.fromRGB(75, 0, 130)    -- Indigo
    }
    
    local currentIndex = 1
    
    pickerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            currentIndex = currentIndex + 1
            if currentIndex > #colors then currentIndex = 1 end
            pickerFrame.BackgroundColor3 = colors[currentIndex]
            if callback then
                callback(colors[currentIndex])
            end
        end
    end)
    
    return {
        Frame = pickerFrame,
        GetColor = function() return pickerFrame.BackgroundColor3 end,
        SetColor = function(color)
            pickerFrame.BackgroundColor3 = color
        end
    }
end

function ModernUI:CreateColorOption(parent, label, initialColor)
    local container = create("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local checkbox = self:CreateCheckboxOption(container, label)
    checkbox.Frame.Position = UDim2.new(0, 0, 0, 0)
    
    local colorPicker = self:CreateColorPicker(container, initialColor)
    colorPicker.Frame.Position = UDim2.new(0, 160, 0, 2)
    
    return {
        Checkbox = checkbox,
        ColorPicker = colorPicker
    }
end

function ModernUI:CreateSlider(parent, label, min, max, defaultValue, callback)
    local sliderFrame = create("Frame", {
        Size = UDim2.new(0, 220, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local label = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = COLOR.TEXT,
        Font = FONT.TEXT,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = label,
        Parent = sliderFrame
    })
    
    local valueLabel = create("TextLabel", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = COLOR.TEXT,
        Font = FONT.TEXT,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = tostring(defaultValue or min),
        Parent = sliderFrame
    })
    
    local track = create("Frame", {
        Size = UDim2.new(1, 0, 0, 4),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = COLOR.CHECKBOX,
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })
    
    local fill = create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = COLOR.TEXT,
        BorderSizePixel = 0,
        Parent = track
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })
    
    local thumb = create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 0, 0.5, -6),
        BackgroundColor3 = COLOR.TEXT,
        BorderSizePixel = 0,
        Parent = track
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = thumb
    })
    
    local dragging = false
    local value = math.clamp(defaultValue or min, min, max)
    
    local function updateValue(newValue)
        value = math.clamp(newValue, min, max)
        local ratio = (value - min) / (max - min)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        thumb.Position = UDim2.new(ratio, -6, 0.5, -6)
        valueLabel.Text = string.format("%.1f", value)
        if callback then
            callback(value)
        end
    end
    
    updateValue(value)
    
    local function updateFromInput(input)
        local x = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        x = math.clamp(x, 0, 1)
        updateValue(min + (max - min) * x)
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {
        Frame = sliderFrame,
        GetValue = function() return value end,
        SetValue = function(newValue) updateValue(newValue) end
    }
end

function ModernUI:Destroy()
    self.ScreenGui:Destroy()
    for k, v in pairs(self) do
        self[k] = nil
    end
end

-- Example Usage
local ui = ModernUI.new("Modern GUI Example")

-- Create tabs and pages
local aimTab = ui:CreateTab("Aim Assist")
local visualTab = ui:CreateTab("Visual")
local miscTab = ui:CreateTab("Misc")

local aimPage = ui:CreatePage("Aim Assist")
local visualPage = ui:CreatePage("Visual")
local miscPage = ui:CreatePage("Misc")

-- Connect tabs to pages
aimTab.MouseButton1Click:Connect(function()
    ui:ShowPage("Aim Assist")
end)

visualTab.MouseButton1Click:Connect(function()
    ui:ShowPage("Visual")
end)

miscTab.MouseButton1Click:Connect(function()
    ui:ShowPage("Misc")
end)

-- Show initial page
ui:ShowPage("Aim Assist")

-- Add content to pages
-- Aim Assist Page
ui:CreateCheckboxOption(aimPage, "Enable Aimbot", function(checked)
    print("Aimbot:", checked)
end)

ui:CreateCheckboxOption(aimPage, "Auto Fire", function(checked)
    print("Auto Fire:", checked)
end)

ui:CreateCheckboxOption(aimPage, "Check Wall", function(checked)
    print("Check Wall:", checked)
end)

ui:CreateSlider(aimPage, "Aimbot FOV", 1, 360, 90, function(value)
    print("Aimbot FOV:", value)
end)

-- Visual Page
local espOption = ui:CreateColorOption(visualPage, "ESP", Color3.fromRGB(255, 0, 0))
local espBoxOption = ui:CreateColorOption(visualPage, "ESP Box", Color3.fromRGB(0, 255, 0))
local espLineOption = ui:CreateColorOption(visualPage, "ESP Line", Color3.fromRGB(0, 0, 255))

espOption.Checkbox.Toggle = function()
    local checked = espOption.Checkbox.Toggle()
    print("ESP:", checked, "Color:", espOption.ColorPicker.GetColor())
end

-- Misc Page
ui:CreateCheckboxOption(miscPage, "Bunny Hop", function(checked)
    print("Auto Reload:", checked)
end)
