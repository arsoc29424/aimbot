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

-- Canto arredondado principal
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Criar barra lateral
local SideBar = Instance.new("Frame")
SideBar.Parent = MainFrame
SideBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SideBar.Size = UDim2.new(0, 130, 1, 0)
SideBar.BorderSizePixel = 0

-- Canto arredondado da barra
local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0, 12)
SideCorner.Parent = SideBar

-- Padding interno na barra lateral
local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = SideBar
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)

-- Layout da barra lateral
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

    -- Efeito de hover
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

-- Conteúdo das abas
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 140, 0, 0)
ContentFrame.Size = UDim2.new(1, -140, 1, 0)

-- Criar páginas
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

-- Exibir primeira aba por padrão
Pages["Aim Assist"].Visible = true

-- Função para trocar páginas
local function ShowPage(name)
    for n, p in pairs(Pages) do
        p.Visible = (n == name)
    end
end

-- Eventos de clique
AimAssistTab.MouseButton1Click:Connect(function()
    ShowPage("Aim Assist")
end)

VisualTab.MouseButton1Click:Connect(function()
    ShowPage("Visual")
end)

MiscTab.MouseButton1Click:Connect(function()
    ShowPage("Misc")
end)

-- Exemplo de conteúdo da aba "Aim Assist"
local Title = Instance.new("TextLabel")
Title.Parent = AimPage
Title.Text = "Configurações de Aim Assist"
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
