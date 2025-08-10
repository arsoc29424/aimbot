-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "ModernUI"

-- Criar Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Criar barra lateral
local SideBar = Instance.new("Frame")
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SideBar.Size = UDim2.new(0, 130, 1, 0)
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

-- Função para criar botão de aba
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

-- Criar abas
local AimAssistTab = CreateTab("Aim Assist")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")

-- Conteúdo principal
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 140, 0, 0)
ContentFrame.Size = UDim2.new(1, -140, 1, 0)

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("Frame")
    Page.Parent = ContentFrame
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
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
    OptionFrame.Parent = parent
    OptionFrame.Size = UDim2.new(0, 180, 0, 24)
    OptionFrame.BackgroundTransparency = 1

    -- Caixa
    local Box = Instance.new("Frame")
    Box.Parent = OptionFrame
    Box.Size = UDim2.new(0, 20, 0, 20)
    Box.Position = UDim2.new(0, 0, 0, 2)
    Box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Box.BorderSizePixel = 0

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    -- Marca
    local Check = Instance.new("TextLabel")
    Check.Parent = Box
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.Font = Enum.Font.GothamBold
    Check.TextSize = 16
    Check.Text = ""

    -- Texto
    local Label = Instance.new("TextLabel")
    Label.Parent = OptionFrame
    Label.Size = UDim2.new(1, -28, 1, 0)
    Label.Position = UDim2.new(0, 28, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = text

    local Checked = false

    OptionFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Checked = not Checked
            Check.Text = Checked and "✓" or ""
            print(text .. " -> " .. tostring(Checked))
        end
    end)

    return OptionFrame
end

-- Layout da aba Aim Assist
local AimLayout = Instance.new("UIListLayout")
AimLayout.Parent = AimPage
AimLayout.Padding = UDim.new(0, 10)
AimLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
AimLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local AimPadding = Instance.new("UIPadding")
AimPadding.Parent = AimPage
AimPadding.PaddingTop = UDim.new(0, 25)
AimPadding.PaddingLeft = UDim.new(0, 15)

-- Criar checkboxes
CreateCheckboxOption(AimPage, "Aimbot")
CreateCheckboxOption(AimPage, "AutoFire")
CreateCheckboxOption(AimPage, "Check Wall")
