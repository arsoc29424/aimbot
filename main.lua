local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernGUI"
ScreenGui.Parent = PlayerGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 360)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Modern GUI"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Drag para mover a GUI
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

-- Barra lateral com abas
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, 130, 1, -36)
SideBar.Position = UDim2.new(0, 0, 0, 36)
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SideBar.Parent = MainFrame
SideBar.BorderSizePixel = 0

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = SideBar
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = SideBar
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding = UDim.new(0, 8)

-- Função para criar botão da aba
local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Text = name
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    Button.Parent = SideBar
    return Button
end

local AimAssistTab = CreateTab("Aim Assist")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")

-- Frame do conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -130, 1, -36)
ContentFrame.Position = UDim2.new(0, 130, 0, 36)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Criar páginas das abas
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("Frame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Position = UDim2.new(0, 0, 0, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.Parent = ContentFrame
    Pages[name] = Page
    return Page
end

local AimPage = CreatePage("Aim Assist")
local VisualPage = CreatePage("Visual")
local MiscPage = CreatePage("Misc")

Pages["Aim Assist"].Visible = true

local function ShowPage(name)
    for n, p in pairs(Pages) do
        p.Visible = (n == name)
    end
end

AimAssistTab.MouseButton1Click:Connect(function()
    ShowPage("Aim Assist")
end)
VisualTab.MouseButton1Click:Connect(function()
    ShowPage("Visual")
end)
MiscTab.MouseButton1Click:Connect(function()
    ShowPage("Misc")
end)

-- Função para criar checkbox estilizado
local function CreateCheckboxOption(parent, text)
    local OptionFrame = Instance.new("Frame")
    OptionFrame.Size = UDim2.new(0, 220, 0, 24)
    OptionFrame.BackgroundTransparency = 1
    OptionFrame.Parent = parent

    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Position = UDim2.new(0, 0, 0, 2)
    Box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Box.BorderSizePixel = 0
    Box.Parent = OptionFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.Font = Enum.Font.GothamBold
    Check.TextSize = 16
    Check.Text = ""
    Check.Parent = Box

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -28, 1, 0)
    Label.Position = UDim2.new(0, 28, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = text
    Label.Parent = OptionFrame

    local Checked = false

    OptionFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Checked = not Checked
            Check.Text = Checked and "✓" or ""
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
        Check.Text = Checked and "✓" or ""
    end

    return OptionFrame
end

-- Função para criar slider de FOV 0-10
local function CreateFovSlider(parent)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0, 180, 0, 24)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Text = "FOV: 0.0"
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0, 60, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(1, -65, 0, 6)
    BarBackground.Position = UDim2.new(0, 65, 0, 9)
    BarBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    BarBackground.Parent = SliderFrame
    BarBackground.ClipsDescendants = true

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = BarBackground

    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 14, 0, 14)
    Handle.Position = UDim2.new(0, 0, 0.5, -7)
    Handle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Handle.Parent = BarBackground

    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(0, 7)
    HandleCorner.Parent = Handle

    local dragging = false
    local currentValue = 0

    local function setPosition(x)
        x = math.clamp(x, 0, BarBackground.AbsoluteSize.X)
        Handle.Position = UDim2.new(0, x - Handle.AbsoluteSize.X / 2, 0.5, -7)
        local value = (x / BarBackground.AbsoluteSize.X) * 10
        Label.Text = string.format("FOV: %.1f", value)
        currentValue = value
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
            setPosition(relativeX)
        end
    end)

    BarBackground:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        setPosition(0)
    end)

    local enabled = true

    local function setEnabled(value)
        enabled = value
        if enabled then
            Handle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            BarBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Handle.Active = true
            Handle.Selectable = true
        else
            Handle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Handle.Active = false
            Handle.Selectable = false
        end
    end

    setEnabled(false)

    function SliderFrame:GetValue()
        return currentValue
    end

    function SliderFrame:SetEnabled(value)
        setEnabled(value)
    end

    return SliderFrame
end

-- Layout padrão para páginas
local function SetupPageLayout(page)
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Top

    local padding = Instance.new("UIPadding")
    padding.Parent = page
    padding.PaddingTop = UDim.new(0, 25)
    padding.PaddingLeft = UDim.new(0, 15)
    return layout
end

-- Setup Aim Assist
SetupPageLayout(AimPage)

local aimbotOption = CreateCheckboxOption(AimPage, "Aimbot")
local autofireOption = CreateCheckboxOption(AimPage, "AutoFire")
local checkWallOption = CreateCheckboxOption(AimPage, "Check Wall")
local drawFovOption = CreateCheckboxOption(AimPage, "Draw Fov")
local fovSlider = CreateFovSlider(AimPage)

local function updateSliderState()
    local enabled = aimbotOption:GetValue()
    fovSlider:SetEnabled(enabled)
end

-- Atualiza o slider ao clicar em Aimbot e Draw Fov
aimbotOption.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wait(0.1)
        updateSliderState()
    end
end)
drawFovOption.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        wait(0.1)
        updateSliderState()
    end
end)

-- Setup Visual
SetupPageLayout(VisualPage)
CreateCheckboxOption(VisualPage, "ESP")
CreateCheckboxOption(VisualPage, "ESP BOX")
CreateCheckboxOption(VisualPage, "ESP LINE")
CreateCheckboxOption(VisualPage, "Check Wall")

-- Setup Misc
SetupPageLayout(MiscPage)
CreateCheckboxOption(MiscPage, "Bunny Hop")

-- World Modulation com seletor de cor
local function CreateColorPicker(parent, initialColor)
    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.new(0, 24, 0, 24)
    PickerFrame.BackgroundColor3 = initialColor or Color3.fromRGB(255, 255, 255)
    PickerFrame.BorderSizePixel = 0
    PickerFrame.Parent = parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = PickerFrame

    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(128, 128, 128),
    }

    local currentIndex = 1

    PickerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            currentIndex = currentIndex + 1
            if currentIndex > #colors then currentIndex = 1 end
            PickerFrame.BackgroundColor3 = colors[currentIndex]
            print("Cor selecionada:", colors[currentIndex])
        end
    end)

    return PickerFrame, function() return PickerFrame.BackgroundColor3 end
end

local WorldModContainer = Instance.new("Frame")
WorldModContainer.Size = UDim2.new(1, 0, 0, 24)
WorldModContainer.BackgroundTransparency = 1
WorldModContainer.Parent = MiscPage

local bunnyHopOption = CreateCheckboxOption(MiscPage, "Bunny Hop")
local worldModCheckbox = CreateCheckboxOption(WorldModContainer, "World Modulation")
worldModCheckbox.Position = UDim2.new(0, 0, 0, 0)

local worldModColorPicker, _ = CreateColorPicker(WorldModContainer)
worldModColorPicker.Position = UDim2.new(0, 160, 0, 2)
