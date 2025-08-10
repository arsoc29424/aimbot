local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Color palette
local Colors = {
    Background = Color3.fromRGB(18, 18, 18),
    Secondary = Color3.fromRGB(30, 30, 30),
    Tertiary = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(240, 240, 240),
    Disabled = Color3.fromRGB(100, 100, 100)
}

-- Animation settings
local TweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Create ScreenGui with ZIndexBehavior
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main container with drop shadow
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 400) -- Increased height
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.8
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Title bar with gradient
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40) -- Increased height
TitleBar.BackgroundColor3 = Colors.Secondary
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
})
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MODERN GUI"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.TextColor3 = Colors.Text
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 24, 0, 24)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Colors.Text
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Text = "X"
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Close button animations
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo, {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag functionality
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Sidebar with tabs
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 140, 1, -40) -- Wider sidebar
SideBar.Position = UDim2.new(0, 0, 0, 40)
SideBar.BackgroundColor3 = Colors.Secondary
SideBar.Parent = MainFrame
SideBar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = SideBar
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = SideBar
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 10)

-- Tab button function with animations
local function CreateTab(name, icon)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Colors.Tertiary
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Text = "   "..name
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    
    -- Tab icon
    if icon then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 10, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = icon
        Icon.ImageColor3 = Colors.Text
        Icon.Parent = Button
    end
    
    -- Animations
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Colors.Tertiary}):Play()
    end)
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    Button.Parent = SideBar
    return Button
end

-- Create tabs with icons (using emoji as placeholder)
local AimAssistTab = CreateTab("Aim Assist", "rbxassetid://3926305904") -- Target icon
local VisualTab = CreateTab("Visual", "rbxassetid://3926307971") -- Eye icon
local MiscTab = CreateTab("Misc", "rbxassetid://3926307971") -- Gear icon
local SettingsTab = CreateTab("Settings", "rbxassetid://3926307971") -- Settings icon

-- Content frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -140, 1, -40)
ContentFrame.Position = UDim2.new(0, 140, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Page system
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Colors.Accent
    Page.Parent = ContentFrame
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Page
    Layout.Padding = UDim.new(0, 15)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    
    local Padding = Instance.new("UIPadding")
    Padding.Parent = Page
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    
    -- Auto-update canvas size
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 30)
    end)
    
    Pages[name] = Page
    return Page
end

local AimPage = CreatePage("Aim Assist")
local VisualPage = CreatePage("Visual")
local MiscPage = CreatePage("Misc")
local SettingsPage = CreatePage("Settings")

-- Show first page by default
Pages["Aim Assist"].Visible = true

local function ShowPage(name)
    for n, p in pairs(Pages) do
        p.Visible = (n == name)
    end
    
    -- Update tab colors
    AimAssistTab.BackgroundColor3 = (name == "Aim Assist") and Colors.Accent or Colors.Tertiary
    VisualTab.BackgroundColor3 = (name == "Visual") and Colors.Accent or Colors.Tertiary
    MiscTab.BackgroundColor3 = (name == "Misc") and Colors.Accent or Colors.Tertiary
    SettingsTab.BackgroundColor3 = (name == "Settings") and Colors.Accent or Colors.Tertiary
    
    -- Animate tab change
    if name == "Aim Assist" then
        TweenService:Create(AimAssistTab, TweenInfo, {BackgroundColor3 = Colors.Accent}):Play()
    else
        TweenService:Create(AimAssistTab, TweenInfo, {BackgroundColor3 = Colors.Tertiary}):Play()
    end
    
    -- Repeat for other tabs...
end

-- Connect tab buttons
AimAssistTab.MouseButton1Click:Connect(function()
    ShowPage("Aim Assist")
end)

VisualTab.MouseButton1Click:Connect(function()
    ShowPage("Visual")
end)

MiscTab.MouseButton1Click:Connect(function()
    ShowPage("Misc")
end)

SettingsTab.MouseButton1Click:Connect(function()
    ShowPage("Settings")
end)

-- Section creator function
local function CreateSection(parent, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Section
    Layout.Padding = UDim.new(0, 10)
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.BackgroundTransparency = 1
    Title.Text = string.upper(title)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextColor3 = Colors.Accent
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Section
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.BackgroundColor3 = Colors.Tertiary
    Divider.BorderSizePixel = 0
    Divider.Parent = Section
    
    return Section
end

-- Enhanced checkbox with toggle animation
local function CreateCheckboxOption(parent, text, default)
    local OptionFrame = Instance.new("Frame")
    OptionFrame.Size = UDim2.new(1, 0, 0, 24)
    OptionFrame.BackgroundTransparency = 1
    OptionFrame.Parent = parent
    
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Position = UDim2.new(0, 0, 0, 2)
    Box.BackgroundColor3 = Colors.Tertiary
    Box.BorderSizePixel = 0
    Box.Parent = OptionFrame
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box
    
    local Check = Instance.new("ImageLabel")
    Check.Size = UDim2.new(1, -4, 1, -4)
    Check.Position = UDim2.new(0, 2, 0, 2)
    Check.BackgroundTransparency = 1
    Check.Image = "rbxassetid://3926309567" -- Checkmark icon
    Check.ImageColor3 = Colors.Text
    Check.ScaleType = Enum.ScaleType.Fit
    Check.Visible = default or false
    Check.Parent = Box
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -28, 1, 0)
    Label.Position = UDim2.new(0, 28, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Colors.Text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = text
    Label.Parent = OptionFrame
    
    local Checked = default or false
    
    -- Toggle animation
    local function toggle()
        Checked = not Checked
        if Checked then
            TweenService:Create(Box, TweenInfo, {BackgroundColor3 = Colors.Accent}):Play()
            Check.Visible = true
        else
            TweenService:Create(Box, TweenInfo, {BackgroundColor3 = Colors.Tertiary}):Play()
            Check.Visible = false
        end
    end
    
    OptionFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggle()
            if OptionFrame.OnChanged then
                OptionFrame.OnChanged(Checked)
            end
        end
    end)
    
    function OptionFrame:GetValue()
        return Checked
    end
    
    function OptionFrame:SetValue(value)
        Checked = value
        if Checked then
            Box.BackgroundColor3 = Colors.Accent
            Check.Visible = true
        else
            Box.BackgroundColor3 = Colors.Tertiary
            Check.Visible = false
        end
    end
    
    -- Initialize
    OptionFrame:SetValue(default or false)
    
    return OptionFrame
end

-- Enhanced slider with smooth dragging
local function CreateSlider(parent, text, min, max, default, decimal)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 40)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent
    
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 20)
    Top.BackgroundTransparency = 1
    Top.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Top
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Text = tostring(default)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextColor3 = Colors.Accent
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(0.5, -10, 1, 0)
    ValueLabel.Position = UDim2.new(0.5, 10, 0, 0)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Top
    
    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(1, 0, 0, 6)
    BarBackground.Position = UDim2.new(0, 0, 0, 30)
    BarBackground.BackgroundColor3 = Colors.Tertiary
    BarBackground.Parent = SliderFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = BarBackground
    
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = Colors.Accent
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBackground
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = BarFill
    
    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 16, 0, 16)
    Handle.Position = UDim2.new(0, 0, 0.5, -8)
    Handle.BackgroundColor3 = Colors.Text
    Handle.Parent = BarBackground
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(0, 8)
    HandleCorner.Parent = Handle
    
    local dragging = false
    local currentValue = default or min
    
    local function setValue(value)
        value = math.clamp(value, min, max)
        currentValue = decimal and math.floor(value * 10) / 10 or math.floor(value)
        
        local percent = (currentValue - min) / (max - min)
        BarFill.Size = UDim2.new(percent, 0, 1, 0)
        Handle.Position = UDim2.new(percent, -8, 0.5, -8)
        
        ValueLabel.Text = decimal and string.format("%.1f", currentValue) or tostring(currentValue)
    end
    
    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    Handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - BarBackground.AbsolutePosition.X
            local percent = math.clamp(relativeX / BarBackground.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * percent
            setValue(value)
            
            if SliderFrame.OnChanged then
                SliderFrame.OnChanged(currentValue)
            end
        end
    end)
    
    -- Initialize
    setValue(default or min)
    
    function SliderFrame:GetValue()
        return currentValue
    end
    
    function SliderFrame:SetValue(value)
        setValue(value)
    end
    
    return SliderFrame
end

-- Color picker with preview and RGB sliders
local function CreateColorPicker(parent, text, defaultColor)
    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.new(1, 0, 0, 0)
    PickerFrame.AutomaticSize = Enum.AutomaticSize.Y
    PickerFrame.BackgroundTransparency = 1
    PickerFrame.Parent = parent
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = PickerFrame
    Layout.Padding = UDim.new(0, 10)
    
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 24)
    Top.BackgroundTransparency = 1
    Top.Parent = PickerFrame
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -34, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Top
    
    local Preview = Instance.new("Frame")
    Preview.Size = UDim2.new(0, 24, 0, 24)
    Preview.Position = UDim2.new(1, -24, 0, 0)
    Preview.BackgroundColor3 = defaultColor or Color3.fromRGB(255, 255, 255)
    Preview.Parent = Top
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 4)
    PreviewCorner.Parent = Preview
    
    -- RGB sliders
    local RedSlider = CreateSlider(PickerFrame, "Red", 0, 255, (defaultColor or Color3.new(1,1,1)).R * 255, false)
    local GreenSlider = CreateSlider(PickerFrame, "Green", 0, 255, (defaultColor or Color3.new(1,1,1)).G * 255, false)
    local BlueSlider = CreateSlider(PickerFrame, "Blue", 0, 255, (defaultColor or Color3.new(1,1,1)).B * 255, false)
    
    local function updateColor()
        local color = Color3.fromRGB(
            RedSlider:GetValue(),
            GreenSlider:GetValue(),
            BlueSlider:GetValue()
        )
        Preview.BackgroundColor3 = color
        
        if PickerFrame.OnChanged then
            PickerFrame.OnChanged(color)
        end
    end
    
    RedSlider.OnChanged = updateColor
    GreenSlider.OnChanged = updateColor
    BlueSlider.OnChanged = updateColor
    
    function PickerFrame:GetValue()
        return Color3.fromRGB(
            RedSlider:GetValue(),
            GreenSlider:GetValue(),
            BlueSlider:GetValue()
        )
    end
    
    function PickerFrame:SetValue(color)
        RedSlider:SetValue(math.floor(color.R * 255))
        GreenSlider:SetValue(math.floor(color.G * 255))
        BlueSlider:SetValue(math.floor(color.B * 255))
    end
    
    return PickerFrame
end

-- Dropdown selector
local function CreateDropdown(parent, text, options, default)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = parent
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = DropdownFrame
    Layout.Padding = UDim.new(0, 5)
    
    local MainButton = Instance.new("TextButton")
    MainButton.Size = UDim2.new(1, 0, 0, 32)
    MainButton.BackgroundColor3 = Colors.Tertiary
    MainButton.TextColor3 = Colors.Text
    MainButton.Font = Enum.Font.Gotham
    MainButton.TextSize = 14
    MainButton.Text = text..": "..(options[default] or "")
    MainButton.TextXAlignment = Enum.TextXAlignment.Left
    MainButton.TextTruncate = Enum.TextTruncate.AtEnd
    MainButton.Parent = DropdownFrame
    
    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.Parent = MainButton
    ButtonPadding.PaddingLeft = UDim.new(0, 10)
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = MainButton
    
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -20, 0.5, -8)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://3926307971" -- Down arrow
    Arrow.ImageColor3 = Colors.Text
    Arrow.Rotation = 90
    Arrow.Parent = MainButton
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, -10, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 5, 0, 37)
    OptionsFrame.BackgroundColor3 = Colors.Tertiary
    OptionsFrame.Visible = false
    OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.Parent = OptionsFrame
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 4)
    OptionsCorner.Parent = OptionsFrame
    
    local selectedIndex = default or 1
    local optionButtons = {}
    
    local function toggleDropdown()
        OptionsFrame.Visible = not OptionsFrame.Visible
        Arrow.Rotation = OptionsFrame.Visible and 270 or 90
    end
    
    local function selectOption(index)
        selectedIndex = index
        MainButton.Text = text..": "..options[index]
        OptionsFrame.Visible = false
        Arrow.Rotation = 90
        
        if DropdownFrame.OnChanged then
            DropdownFrame.OnChanged(index, options[index])
        end
    end
    
    -- Create option buttons
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.BackgroundColor3 = Colors.Tertiary
        OptionButton.TextColor3 = Colors.Text
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = 14
        OptionButton.Text = option
        OptionButton.TextXAlignment = Enum.TextXAlignment.Left
        OptionButton.AutoButtonColor = false
        OptionButton.Parent = OptionsFrame
        
        local OptionPadding = Instance.new("UIPadding")
        OptionPadding.Parent = OptionButton
        OptionPadding.PaddingLeft = UDim.new(0, 10)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo, {BackgroundColor3 = Colors.Tertiary}):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectOption(i)
        end)
        
        table.insert(optionButtons, OptionButton)
    end
    
    MainButton.MouseButton1Click:Connect(toggleDropdown)
    
    function DropdownFrame:GetValue()
        return selectedIndex, options[selectedIndex]
    end
    
    function DropdownFrame:SetValue(index)
        if options[index] then
            selectOption(index)
        end
    end
    
    return DropdownFrame
end

-- Button with animation
local function CreateButton(parent, text)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = Colors.Accent
    Button.TextColor3 = Colors.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Text = text
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = Button
    
    -- Animations
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 140, 240)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Colors.Accent}):Play()
    end)
    
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 100, 180)}):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 140, 240)}):Play()
    end)
    
    return Button
end

-- Keybind selector
local function CreateKeybind(parent, text, defaultKey)
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Size = UDim2.new(1, 0, 0, 24)
    KeybindFrame.BackgroundTransparency = 1
    KeybindFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Colors.Text
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = KeybindFrame
    
    local KeyButton = Instance.new("TextButton")
    KeyButton.Size = UDim2.new(0.4, 0, 1, 0)
    KeyButton.Position = UDim2.new(0.6, 0, 0, 0)
    KeyButton.BackgroundColor3 = Colors.Tertiary
    KeyButton.TextColor3 = Colors.Text
    KeyButton.Font = Enum.Font.GothamBold
    KeyButton.TextSize = 14
    KeyButton.Text = defaultKey and defaultKey.Name or "None"
    KeyButton.Parent = KeybindFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = KeyButton
    
    local listening = false
    local currentKey = defaultKey
    
    local function setKey(key)
        currentKey = key
        KeyButton.Text = key and key.Name or "None"
        
        if KeybindFrame.OnChanged then
            KeybindFrame.OnChanged(key)
        end
    end
    
    KeyButton.MouseButton1Click:Connect(function()
        listening = true
        KeyButton.Text = "..."
        KeyButton.BackgroundColor3 = Colors.Accent
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                setKey(input.KeyCode)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                setKey(Enum.KeyCode.MouseButton1)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                setKey(Enum.KeyCode.MouseButton2)
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                setKey(Enum.KeyCode.MouseButton3)
            end
            listening = false
            KeyButton.BackgroundColor3 = Colors.Tertiary
        end
    end)
    
    function KeybindFrame:GetValue()
        return currentKey
    end
    
    function KeybindFrame:SetValue(key)
        setKey(key)
    end
    
    return KeybindFrame
end

-- Setup Aim Assist page
local AimSection = CreateSection(AimPage, "Aim Settings")
local aimbotOption = CreateCheckboxOption(AimSection, "Enable Aimbot", false)
local silentAimOption = CreateCheckboxOption(AimSection, "Silent Aim", false)
local fovSlider = CreateSlider(AimSection, "Aimbot FOV", 1, 360, 90, false)
local smoothnessSlider = CreateSlider(AimSection, "Smoothness", 1, 100, 50, false)
local hitChanceSlider = CreateSlider(AimSection, "Hit Chance %", 0, 100, 100, false)

local TargetSection = CreateSection(AimPage, "Target Settings")
local targetPartDropdown = CreateDropdown(TargetSection, "Target Part", {"Head", "Torso", "Closest"}, 1)
local ignoreWallsOption = CreateCheckboxOption(TargetSection, "Ignore Walls", false)
local teamCheckOption = CreateCheckboxOption(TargetSection, "Team Check", true)
local visibilityCheckOption = CreateCheckboxOption(TargetSection, "Visibility Check", true)

-- Setup Visual page
local ESPsection = CreateSection(VisualPage, "ESP Settings")
local espToggle = CreateCheckboxOption(ESPsection, "Enable ESP", false)
local espBoxToggle = CreateCheckboxOption(ESPsection, "Box ESP", false)
local espNameToggle = CreateCheckboxOption(ESPsection, "Show Names", true)
local espHealthToggle = CreateCheckboxOption(ESPsection, "Show Health", true)
local espDistanceToggle = CreateCheckboxOption(ESPsection, "Show Distance", true)
local espColorPicker = CreateColorPicker(ESPsection, "ESP Color", Color3.fromRGB(255, 0, 0))

local ChamsSection = CreateSection(VisualPage, "Chams Settings")
local chamsToggle = CreateCheckboxOption(ChamsSection, "Enable Chams", false)
local chamsColorPicker = CreateColorPicker(ChamsSection, "Chams Color", Color3.fromRGB(0, 255, 255))
local chamsTransparencySlider = CreateSlider(ChamsSection, "Transparency", 0, 100, 50, false)

-- Setup Misc page
local MovementSection = CreateSection(MiscPage, "Movement")
local bhopToggle = CreateCheckboxOption(MovementSection, "Bunny Hop", false)
local speedSlider = CreateSlider(MovementSection, "Speed Multiplier", 1, 300, 100, false)
local jumpPowerSlider = CreateSlider(MovementSection, "Jump Power", 1, 200, 50, false)

local OtherSection = CreateSection(MiscPage, "Other")
local noRecoilToggle = CreateCheckboxOption(OtherSection, "No Recoil", false)
local noSpreadToggle = CreateCheckboxOption(OtherSection, "No Spread", false)
local infiniteAmmoToggle = CreateCheckboxOption(OtherSection, "Infinite Ammo", false)
local rapidFireToggle = CreateCheckboxOption(OtherSection, "Rapid Fire", false)

-- Setup Settings page
local UISection = CreateSection(SettingsPage, "UI Settings")
local uiThemeDropdown = CreateDropdown(UISection, "Theme", {"Dark", "Light", "Blue", "Red"}, 1)
local uiScaleSlider = CreateSlider(UISection, "UI Scale", 50, 200, 100, false)
local uiOpacitySlider = CreateSlider(UISection, "UI Opacity", 50, 100, 100, false)

local ConfigSection = CreateSection(SettingsPage, "Configurations")
local configDropdown = CreateDropdown(ConfigSection, "Config", {"Default", "Legit", "Rage", "Custom 1"}, 1)
local saveConfigButton = CreateButton(ConfigSection, "Save Config")
local loadConfigButton = CreateButton(ConfigSection, "Load Config")

local KeybindSection = CreateSection(SettingsPage, "Keybinds")
local menuKeybind = CreateKeybind(KeybindSection, "Menu Toggle", Enum.KeyCode.RightShift)
local aimbotKeybind = CreateKeybind(KeybindSection, "Aimbot Toggle", Enum.KeyCode.Q)

-- UI scale functionality
uiScaleSlider.OnChanged = function(value)
    local scale = value / 100
    MainFrame.Size = UDim2.new(0, 520 * scale, 0, 400 * scale)
    MainFrame.Position = UDim2.new(0.5, -260 * scale, 0.5, -200 * scale)
end

-- UI opacity functionality
uiOpacitySlider.OnChanged = function(value)
    local transparency = 1 - (value / 100)
    ScreenGui.DisplayOrder = value == 100 and 1 or 999 -- Bring to front when not fully opaque
    Shadow.ImageTransparency = 0.8 - (transparency * 0.8)
end

-- Theme changer
uiThemeDropdown.OnChanged = function(index, theme)
    local newColors = {
        Dark = {
            Background = Color3.fromRGB(18, 18, 18),
            Secondary = Color3.fromRGB(30, 30, 30),
            Tertiary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(240, 240, 240)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 240),
            Secondary = Color3.fromRGB(220, 220, 220),
            Tertiary = Color3.fromRGB(200, 200, 200),
            Accent = Color3.fromRGB(0, 120, 215),
            Text = Color3.fromRGB(30, 30, 30)
        },
        Blue = {
            Background = Color3.fromRGB(10, 20, 30),
            Secondary = Color3.fromRGB(20, 40, 60),
            Tertiary = Color3.fromRGB(30, 60, 90),
            Accent = Color3.fromRGB(0, 150, 255),
            Text = Color3.fromRGB(220, 240, 255)
        },
        Red = {
            Background = Color3.fromRGB(30, 10, 10),
            Secondary = Color3.fromRGB(60, 20, 20),
            Tertiary = Color3.fromRGB(90, 30, 30),
            Accent = Color3.fromRGB(255, 50, 50),
            Text = Color3.fromRGB(255, 220, 220)
        }
    }
    
    local themeColors = newColors[theme] or newColors.Dark
    
    -- Apply theme colors
    TweenService:Create(MainFrame, TweenInfo, {BackgroundColor3 = themeColors.Background}):Play()
    TweenService:Create(TitleBar, TweenInfo, {BackgroundColor3 = themeColors.Secondary}):Play()
    TweenService:Create(SideBar, TweenInfo, {BackgroundColor3 = themeColors.Secondary}):Play()
    
    -- Update global colors
    Colors = themeColors
    
    -- Update all UI elements (this would need to be implemented for all elements)
    TitleLabel.TextColor3 = themeColors.Text
    CloseButton.TextColor3 = themeColors.Text
    
    -- Note: For a complete implementation, you'd need to update all other elements
    -- This would require storing references to all UI elements and updating them
end

-- Menu toggle functionality
local menuVisible = true
menuKeybind.OnChanged = function(key)
    if key then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == key then
                menuVisible = not menuVisible
                MainFrame.Visible = menuVisible
                
                -- Animation could be added here
            end
        end)
    end
end

-- Config saving/loading (placeholder functionality)
saveConfigButton.MouseButton1Click:Connect(function()
    -- This would save all current settings
    print("Config saved!")
end)

loadConfigButton.MouseButton1Click:Connect(function()
    -- This would load the selected config
    print("Config loaded!")
end)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Text = "MODERN GUI | v1.0 | FPS: 60"
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextColor3 = Colors.Text
Watermark.BackgroundColor3 = Colors.Secondary
Watermark.Size = UDim2.new(0, 0, 0, 24)
Watermark.AutomaticSize = Enum.AutomaticSize.X
Watermark.Position = UDim2.new(0, 10, 0, 10)
Watermark.Parent = ScreenGui

local WatermarkCorner = Instance.new("UICorner")
WatermarkCorner.CornerRadius = UDim.new(0, 4)
WatermarkCorner.Parent = Watermark

local WatermarkPadding = Instance.new("UIPadding")
WatermarkPadding.Parent = Watermark
WatermarkPadding.PaddingLeft = UDim.new(0, 10)
WatermarkPadding.PaddingRight = UDim.new(0, 10)

-- FPS counter
local lastUpdate = tick()
local frames = 0

RunService.Heartbeat:Connect(function()
    frames = frames + 1
    if tick() - lastUpdate >= 1 then
        Watermark.Text = "MODERN GUI | v1.0 | FPS: "..frames
        frames = 0
        lastUpdate = tick()
    end
end)
