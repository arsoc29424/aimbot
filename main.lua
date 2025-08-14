-- 🚀 ULTIMATE AIM ASSIST GUI - A MAIS ÉPICA DO ROBLOX! 🚀
-- Design futurístico com animações insanas e efeitos visuais de outro mundo!

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Mouse = Players.LocalPlayer:GetMouse()

-- Variáveis principais
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configurações do Aim Assist
local aimAssistConfig = {
    aimBot = {
        enabled = false,
        mode = "Toggle",
        targetParts = {"Head"},
        key = Enum.KeyCode.E,
        smoothness = 0.8,
        fov = 200
    },
    autoFire = {
        enabled = false,
        mode = "Toggle",
        delay = 0.1
    },
    autoWall = {
        enabled = false,
        mode = "Toggle",
        penetration = 2
    },
    checkWall = false,
    visuals = {
        enabled = true,
        showFOV = true,
        showTarget = true,
        rainbowMode = false
    }
}

-- Sistema de partículas épico
local function createParticleSystem(parent)
    for i = 1, 15 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
        particle.Position = UDim2.new(0, math.random(0, parent.AbsoluteSize.X), 0, math.random(0, parent.AbsoluteSize.Y))
        particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
        particle.BorderSizePixel = 0
        particle.ZIndex = 100
        particle.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Animação flutuante
        local floatTween = TweenService:Create(particle, 
            TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {
                Position = UDim2.new(0, math.random(0, parent.AbsoluteSize.X), 0, math.random(0, parent.AbsoluteSize.Y)),
                BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
            }
        )
        floatTween:Play()
    end
end

-- Sistema de som épico
local function playSound(soundId, volume)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://sounds/" .. soundId .. ".mp3"
    sound.Volume = volume or 0.5
    sound.Parent = workspace
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- Função para criar a GUI ULTIMATE
local function createUltimateGUI()
    -- ScreenGui com efeitos insanos
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateAimAssistGUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    -- Background com gradiente animado
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.95
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = screenGui
    
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 15, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 30, 15))
    }
    bgGradient.Rotation = 45
    bgGradient.Parent = backgroundFrame
    
    -- Animação do background
    local bgTween = TweenService:Create(bgGradient, 
        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 225}
    )
    bgTween:Play()
    
    -- Frame principal FUTURÍSTICO
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 550, 0, 700)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -350)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradiente principal épico
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 40, 20))
    }
    mainGradient.Rotation = 135
    mainGradient.Parent = mainFrame
    
    -- Cantos arredondados premium
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Borda NEON brilhante
    local neonBorder = Instance.new("UIStroke")
    neonBorder.Color = Color3.fromRGB(0, 255, 255)
    neonBorder.Thickness = 3
    neonBorder.Transparency = 0.3
    neonBorder.Parent = mainFrame
    
    -- Animação da borda neon
    local neonTween = TweenService:Create(neonBorder,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Color = Color3.fromRGB(255, 0, 255)}
    )
    neonTween:Play()
    
    -- Sombra épica 3D
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.7
    shadow.ZIndex = -1
    shadow.Parent = mainFrame
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 25)
    shadowCorner.Parent = shadow
    
    -- Header ULTRA futurístico
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 80)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 20, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 50, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 50))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 20)
    headerCorner.Parent = header
    
    -- Título ÉPICO com efeitos
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -200, 1, 0)
    title.Position = UDim2.new(0, 30, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ ULTIMATE AIM DESTROYER ⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Gradiente no texto
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))
    }
    titleGradient.Parent = title
    
    -- Animação do título
    local titleTween = TweenService:Create(titleGradient,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {Rotation = 360}
    )
    titleTween:Play()
    
    -- Subtítulo animado
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -200, 0, 20)
    subtitle.Position = UDim2.new(0, 30, 1, -25)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🔥 VERSÃO PREMIUM EXCLUSIVA 🔥"
    subtitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Efeito blink no subtítulo
    local blinkTween = TweenService:Create(subtitle,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.5}
    )
    blinkTween:Play()
    
    -- Botões futurísticos
    local function createFuturisticButton(name, text, color, position, parent)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 45, 0, 45)
        button.Position = position
        button.BackgroundColor3 = color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.BorderSizePixel = 0
        button.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 12)
        buttonCorner.Parent = button
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Thickness = 2
        buttonStroke.Transparency = 0.5
        buttonStroke.Parent = button
        
        local buttonGradient = Instance.new("UIGradient")
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, Color3.new(color.R * 1.5, color.G * 1.5, color.B * 1.5))
        }
        buttonGradient.Rotation = 45
        buttonGradient.Parent = button
        
        -- Efeitos hover insanos
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
            playSound("ButtonHover", 0.3)
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        end)
        
        return button
    end
    
    -- Botão minimizar ÉPICO
    local minimizeButton = createFuturisticButton("MinimizeButton", "⬇", Color3.fromRGB(100, 200, 255), UDim2.new(1, -140, 0, 17.5), header)
    
    -- Botão configurações
    local settingsButton = createFuturisticButton("SettingsButton", "⚙", Color3.fromRGB(255, 200, 100), UDim2.new(1, -90, 0, 17.5), header)
    
    -- Botão fechar
    local closeButton = createFuturisticButton("CloseButton", "✕", Color3.fromRGB(255, 100, 100), UDim2.new(1, -40, 0, 17.5), header)
    
    -- Container principal com scroll épico
    local mainContainer = Instance.new("ScrollingFrame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, -20, 1, -100)
    mainContainer.Position = UDim2.new(0, 10, 0, 90)
    mainContainer.BackgroundTransparency = 1
    mainContainer.BorderSizePixel = 0
    mainContainer.ScrollBarThickness = 8
    mainContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 255, 255)
    mainContainer.CanvasSize = UDim2.new(0, 0, 0, 1200)
    mainContainer.Parent = mainFrame
    
    -- Seção AIM ASSIST ÉPICA
    local function createEpicSection(name, icon, yPos)
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Size = UDim2.new(1, -10, 0, 300)
        section.Position = UDim2.new(0, 5, 0, yPos)
        section.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        section.BorderSizePixel = 0
        section.Parent = mainContainer
        
        local sectionGradient = Instance.new("UIGradient")
        sectionGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 90))
        }
        sectionGradient.Rotation = 45
        sectionGradient.Parent = section
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 15)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = Color3.fromRGB(100, 200, 255)
        sectionStroke.Thickness = 2
        sectionStroke.Transparency = 0.6
        sectionStroke.Parent = section
        
        -- Título da seção com efeitos
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "SectionTitle"
        sectionTitle.Size = UDim2.new(1, -20, 0, 50)
        sectionTitle.Position = UDim2.new(0, 10, 0, 10)
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Text = icon .. " " .. string.upper(name)
        sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        sectionTitle.TextScaled = true
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        sectionTitle.Parent = section
        
        local titleGradient = Instance.new("UIGradient")
        titleGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 255, 255))
        }
        titleGradient.Parent = sectionTitle
        
        return section
    end
    
    local aimSection = createEpicSection("AIM ASSIST", "🎯", 10)
    
    -- Função para criar controles ÉPICOS
    local function createEpicControl(name, description, configKey, parent, yPos)
        local controlFrame = Instance.new("Frame")
        controlFrame.Name = name .. "Control"
        controlFrame.Size = UDim2.new(1, -20, 0, 60)
        controlFrame.Position = UDim2.new(0, 10, 0, yPos)
        controlFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        controlFrame.BorderSizePixel = 0
        controlFrame.Parent = parent
        
        local controlCorner = Instance.new("UICorner")
        controlCorner.CornerRadius = UDim.new(0, 10)
        controlCorner.Parent = controlFrame
        
        local controlGradient = Instance.new("UIGradient")
        controlGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 100)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 50, 120))
        }
        controlGradient.Rotation = 90
        controlGradient.Parent = controlFrame
        
        -- Toggle switch ÉPICO
        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.new(0, 60, 0, 30)
        toggleBg.Position = UDim2.new(0, 15, 0, 15)
        toggleBg.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
        toggleBg.BorderSizePixel = 0
        toggleBg.Parent = controlFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBg
        
        local toggleSwitch = Instance.new("Frame")
        toggleSwitch.Size = UDim2.new(0, 26, 0, 26)
        toggleSwitch.Position = UDim2.new(0, 2, 0, 2)
        toggleSwitch.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        toggleSwitch.BorderSizePixel = 0
        toggleSwitch.Parent = toggleBg
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = toggleSwitch
        
        local switchGlow = Instance.new("UIStroke")
        switchGlow.Color = Color3.fromRGB(255, 255, 255)
        switchGlow.Thickness = 3
        switchGlow.Transparency = 0.7
        switchGlow.Parent = toggleSwitch
        
        -- Label com efeitos
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 200, 0, 25)
        label.Position = UDim2.new(0, 90, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = "💫 " .. name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = controlFrame
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(0, 300, 0, 20)
        desc.Position = UDim2.new(0, 90, 0, 30)
        desc.BackgroundTransparency = 1
        desc.Text = "✨ " .. description
        desc.TextColor3 = Color3.fromRGB(200, 200, 255)
        desc.TextSize = 12
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = controlFrame
        
        -- Dropdown FUTURÍSTICO
        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(0, 100, 0, 35)
        dropdown.Position = UDim2.new(1, -115, 0, 12.5)
        dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
        dropdown.Text = "Toggle ▼"
        dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        dropdown.TextScaled = true
        dropdown.Font = Enum.Font.Gotham
        dropdown.BorderSizePixel = 0
        dropdown.Parent = controlFrame
        
        local dropCorner = Instance.new("UICorner")
        dropCorner.CornerRadius = UDim.new(0, 8)
        dropCorner.Parent = dropdown
        
        local dropGradient = Instance.new("UIGradient")
        dropGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 160)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 200))
        }
        dropGradient.Rotation = 45
        dropGradient.Parent = dropdown
        
        -- Sistema de toggle
        local isEnabled = false
        
        local function toggleControl()
            isEnabled = not isEnabled
            aimAssistConfig[configKey].enabled = isEnabled
            
            local targetPos = isEnabled and UDim2.new(0, 32, 0, 2) or UDim2.new(0, 2, 0, 2)
            local targetColor = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
            local targetBgColor = isEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(80, 80, 120)
            
            TweenService:Create(toggleSwitch, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Position = targetPos,
                BackgroundColor3 = targetColor
            }):Play()
            
            TweenService:Create(toggleBg, TweenInfo.new(0.3), {
                BackgroundColor3 = targetBgColor
            }):Play()
            
            -- Efeito de explosão
            if isEnabled then
                playSound("PowerUp", 0.4)
                for i = 1, 5 do
                    local spark = Instance.new("Frame")
                    spark.Size = UDim2.new(0, 4, 0, 4)
                    spark.Position = UDim2.new(0, 45, 0, 15)
                    spark.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
                    spark.BorderSizePixel = 0
                    spark.Parent = controlFrame
                    
                    local sparkCorner = Instance.new("UICorner")
                    sparkCorner.CornerRadius = UDim.new(1, 0)
                    sparkCorner.Parent = spark
                    
                    local angle = math.rad(i * 72)
                    local distance = 30
                    
                    TweenService:Create(spark, TweenInfo.new(0.5), {
                        Position = UDim2.new(0, 45 + math.cos(angle) * distance, 0, 15 + math.sin(angle) * distance),
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 0, 0, 0)
                    }):Play()
                    
                    wait(0.5)
                    spark:Destroy()
                end
            else
                playSound("PowerDown", 0.3)
            end
        end
        
        toggleBg.MouseButton1Click:Connect(toggleControl)
        
        return controlFrame
    end
    
    -- Criar controles épicos
    createEpicControl("AIM BOT", "Lock automático no inimigo", "aimBot", aimSection, 70)
    createEpicControl("AUTO FIRE", "Disparo automático inteligente", "autoFire", aimSection, 140)
    createEpicControl("AUTO WALL", "Penetração de paredes", "autoWall", aimSection, 210)
    
    -- Seção de estatísticas em tempo real
    local statsSection = createEpicSection("BATTLE STATS", "📊", 330)
    
    local function createStatDisplay(name, value, icon, parent, xPos)
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0, 150, 0, 80)
        statFrame.Position = UDim2.new(0, xPos, 0, 70)
        statFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        statFrame.BorderSizePixel = 0
        statFrame.Parent = parent
        
        local statCorner = Instance.new("UICorner")
        statCorner.CornerRadius = UDim.new(0, 12)
        statCorner.Parent = statFrame
        
        local statGradient = Instance.new("UIGradient")
        statGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 40, 120))
        }
        statGradient.Rotation = 135
        statGradient.Parent = statFrame
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(1, 0, 0, 30)
        iconLabel.Position = UDim2.new(0, 0, 0, 5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        iconLabel.TextScaled = true
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = statFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0, 20)
        nameLabel.Position = UDim2.new(0, 0, 0, 35)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.Parent = statFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, 0, 0, 25)
        valueLabel.Position = UDim2.new(0, 0, 0, 50)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = value
        valueLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Parent = statFrame
        
        return valueLabel
    end
    
    local killsLabel = createStatDisplay("KILLS", "0", "💀", statsSection, 10)
    local accuracyLabel = createStatDisplay("ACCURACY", "100%", "🎯", statsSection, 170)
    local streakLabel = createStatDisplay("STREAK", "0", "🔥", statsSection, 330)
    
    -- Seção de configurações visuais
    local visualSection = createEpicSection("VISUAL HACKS", "👁️", 650)
    
    -- FOV Circle ÉPICO
    local fovFrame = Instance.new("Frame")
    fovFrame.Size = UDim2.new(1, -20, 0, 100)
    fovFrame.Position = UDim2.new(0, 10, 0, 70)
    fovFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
    fovFrame.BorderSizePixel = 0
    fovFrame.Parent = visualSection
    
    local fovCorner = Instance.new("UICorner")
    fovCorner.CornerRadius = UDim.new(0, 10)
    fovCorner.Parent = fovFrame
    
    local fovLabel = Instance.new("TextLabel")
    fovLabel.Size = UDim2.new(0, 100, 0, 30)
    fovLabel.Position = UDim2.new(0, 10, 0, 10)
    fovLabel.BackgroundTransparency = 1
    fovLabel.Text = "🎯 FOV SIZE"
    fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fovLabel.TextScaled = true
    fovLabel.Font = Enum.Font.GothamBold
    fovLabel.TextXAlignment = Enum.TextXAlignment.Left
    fovLabel.Parent = fovFrame
    
    -- Slider ÉPICO
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 300, 0, 20)
    sliderBg.Position = UDim2.new(0, 10, 0, 50)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = fovFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 30, 0, 30)
    sliderKnob.Position = UDim2.new(0.5, -15, 0, -5)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local knobGlow = Instance.new("UIStroke")
    knobGlow.Color = Color3.fromRGB(100, 255, 255)
    knobGlow.Thickness = 3
    knobGlow.Parent = sliderKnob
    
    local fovValueLabel = Instance.new("TextLabel")
    fovValueLabel.Size = UDim2.new(0, 50, 0, 30)
    fovValueLabel.Position = UDim2.new(1, -60, 0, 10)
    fovValueLabel.BackgroundTransparency = 1
    fovValueLabel.Text = "200"
    fovValueLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    fovValueLabel.TextScaled = true
    fovValueLabel.Font = Enum.Font.GothamBold
    fovValueLabel.Parent = fovFrame
    
    -- Sistema de minimização ULTRA
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    local function toggleMinimize()
        isMinimized = not isMinimized
        
        local targetSize = isMinimized and UDim2.new(0, 550, 0, 80) or originalSize
        local targetText = isMinimized and "⬆" or "⬇"
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
        
        sizeTween:Play()
        minimizeButton.Text = targetText
        
        mainContainer.Visible = not isMinimized
        
        if isMinimized then
            playSound("Minimize", 0.4)
            -- Efeito de implosão
            for i = 1, 10 do
                local particle = Instance.new("Frame")
                particle.Size = UDim2.new(0, 6, 0, 6)
                particle.Position = UDim2.new(0.5, 0, 0.5, 0)
                particle.BackgroundColor3 = Color3.fromHSV(i/10, 1, 1)
                particle.BorderSizePixel = 0
                particle.Parent = mainFrame
                
                local particleCorner = Instance.new("UICorner")
                particleCorner.CornerRadius = UDim.new(1, 0)
                particleCorner.Parent = particle
                
                local angle = math.rad(i * 36)
                TweenService:Create(particle, TweenInfo.new(0.8), {
                    Position = UDim2.new(0.5 + math.cos(angle) * 2, 0, 0.5 + math.sin(angle) * 2, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                wait(0.8)
                particle:Destroy()
            end
        else
            playSound("Expand", 0.4)
        end
    end
    
    minimizeButton.MouseButton1Click:Connect(toggleMinimize)
    
    -- Funcionalidades do Aim Assist ÉPICAS
    local function getClosestEnemy()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") then
                if otherPlayer.Character.Humanoid.Health > 0 then
                    local distance = (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < aimAssistConfig.aimBot.fov and distance < shortestDistance then
                        -- Check wall if enabled
                        if aimAssistConfig.checkWall then
                            local ray = Ray.new(
                                player.Character.HumanoidRootPart.Position,
                                (otherPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Unit * distance
                            )
                            local hit, position = workspace:FindPartOnRay(ray, player.Character)
                            
                            if hit and hit.Parent ~= otherPlayer.Character then
                                continue -- Skip if there's a wall
                            end
                        end
                        
                        closestPlayer = otherPlayer
                        shortestDistance = distance
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    local function aimAtPlayer(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        
        local targetPart = nil
        for _, partName in pairs(aimAssistConfig.aimBot.targetParts) do
            if targetPlayer.Character:FindFirstChild(partName) then
                targetPart = targetPlayer.Character[partName]
                break
            end
        end
        
        if targetPart then
            local camera = workspace.CurrentCamera
            local targetPosition = targetPart.Position
            
            -- Smooth aiming with prediction
            local targetVelocity = targetPlayer.Character.HumanoidRootPart.Velocity
            local distance = (targetPosition - camera.CFrame.Position).Magnitude
            local timeToTarget = distance / 1000 -- Assuming bullet speed
            local predictedPosition = targetPosition + (targetVelocity * timeToTarget)
            
            local currentLook = camera.CFrame.LookVector
            local targetLook = (predictedPosition - camera.CFrame.Position).Unit
            local smoothedLook = currentLook:lerp(targetLook, aimAssistConfig.aimBot.smoothness)
            
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, camera.CFrame.Position + smoothedLook)
        end
    end
    
    -- Sistema de auto fire
    local function shouldAutoFire(targetPlayer)
        if not aimAssistConfig.autoFire.enabled or not targetPlayer then return false end
        
        local camera = workspace.CurrentCamera
        local ray = camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {player.Character}
        
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
        
        if result and result.Instance.Parent == targetPlayer.Character then
            local hitPart = result.Instance.Name
            return table.find({"Head", "Torso", "UpperTorso", "LowerTorso", "LeftUpperLeg", "RightUpperLeg"}, hitPart) ~= nil
        end
        
        return false
    end
    
    -- Main aimbot loop
    local aimConnection = nil
    local isAiming = false
    
    local function startAiming()
        if isAiming then return end
        isAiming = true
        
        aimConnection = RunService.Heartbeat:Connect(function()
            if not aimAssistConfig.aimBot.enabled then return end
            
            local target = getClosestEnemy()
            if target then
                aimAtPlayer(target)
                
                -- Auto fire
                if shouldAutoFire(target) then
                    mouse1click()
                end
                
                -- Update target indicator
                if aimAssistConfig.visuals.showTarget then
                    -- Visual target indication could go here
                end
            end
        end)
    end
    
    local function stopAiming()
        if not isAiming then return end
        isAiming = false
        
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end
    
    -- Input handling épico
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == aimAssistConfig.aimBot.key then
            if aimAssistConfig.aimBot.mode == "Toggle" then
                if isAiming then
                    stopAiming()
                else
                    startAiming()
                end
            elseif aimAssistConfig.aimBot.mode == "Hold" then
                startAiming()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == aimAssistConfig.aimBot.key and aimAssistConfig.aimBot.mode == "Hold" then
            stopAiming()
        end
    end)
    
    -- Always mode
    RunService.Heartbeat:Connect(function()
        if aimAssistConfig.aimBot.enabled and aimAssistConfig.aimBot.mode == "Always" then
            if not isAiming then
                startAiming()
            end
        end
    end)
    
    -- Sistema de estatísticas em tempo real
    local kills = 0
    local shots = 0
    local hits = 0
    local streak = 0
    
    local function updateStats()
        killsLabel.Text = tostring(kills)
        accuracyLabel.Text = shots > 0 and math.floor((hits/shots) * 100) .. "%" or "100%"
        streakLabel.Text = tostring(streak)
        
        -- Rainbow mode para stats
        if aimAssistConfig.visuals.rainbowMode then
            local time = tick()
            killsLabel.TextColor3 = Color3.fromHSV((time * 0.5) % 1, 1, 1)
            accuracyLabel.TextColor3 = Color3.fromHSV((time * 0.5 + 0.33) % 1, 1, 1)
            streakLabel.TextColor3 = Color3.fromHSV((time * 0.5 + 0.66) % 1, 1, 1)
        end
    end
    
    RunService.Heartbeat:Connect(updateStats)
    
    -- Sistema de partículas na GUI
    createParticleSystem(mainFrame)
    
    -- Sistema de notificações ÉPICAS
    local function createEpicNotification(text, color, icon)
        local notifGui = playerGui:FindFirstChild("EpicNotificationGUI")
        if not notifGui then
            notifGui = Instance.new("ScreenGui")
            notifGui.Name = "EpicNotificationGUI"
            notifGui.Parent = playerGui
            notifGui.ResetOnSpawn = false
        end
        
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 350, 0, 80)
        notification.Position = UDim2.new(1, 0, 0, 100 + (#notifGui:GetChildren() - 1) * 90)
        notification.BackgroundColor3 = color or Color3.fromRGB(40, 40, 80)
        notification.BorderSizePixel = 0
        notification.Parent = notifGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 15)
        notifCorner.Parent = notification
        
        local notifGradient = Instance.new("UIGradient")
        notifGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, Color3.new(color.R * 1.5, color.G * 1.5, color.B * 1.5))
        }
        notifGradient.Rotation = 45
        notifGradient.Parent = notification
        
        local notifStroke = Instance.new("UIStroke")
        notifStroke.Color = Color3.fromRGB(255, 255, 255)
        notifStroke.Thickness = 2
        notifStroke.Transparency = 0.5
        notifStroke.Parent = notification
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 50, 0, 50)
        iconLabel.Position = UDim2.new(0, 15, 0, 15)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon or "🔥"
        iconLabel.TextScaled = true
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.Parent = notification
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -80, 1, 0)
        textLabel.Position = UDim2.new(0, 70, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = text
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextWrapped = true
        textLabel.Parent = notification
        
        -- Animação de entrada ÉPICA
        local tweenIn = TweenService:Create(notification, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -360, 0, 100 + (#notifGui:GetChildren() - 2) * 90)}
        )
        tweenIn:Play()
        
        playSound("Notification", 0.6)
        
        -- Auto-remover
        wait(4)
        local tweenOut = TweenService:Create(notification,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 0, 0, 100 + (#notifGui:GetChildren() - 2) * 90)}
        )
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end
    
    -- Funcionalidade de arrastar ÉPICA
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Botão fechar
    closeButton.MouseButton1Click:Connect(function()
        playSound("Close", 0.5)
        
        -- Efeito de desintegração
        for i = 1, 20 do
            local fragment = Instance.new("Frame")
            fragment.Size = UDim2.new(0, math.random(10, 30), 0, math.random(10, 30))
            fragment.Position = UDim2.new(math.random(), 0, math.random(), 0)
            fragment.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
            fragment.BorderSizePixel = 0
            fragment.Parent = mainFrame
            
            TweenService:Create(fragment, TweenInfo.new(1), {
                Position = UDim2.new(math.random(-1, 2), 0, math.random(-1, 2), 0),
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Rotation = math.random(-180, 180)
            }):Play()
        end
        
        wait(1)
        screenGui:Destroy()
    end)
    
    return screenGui
end

-- Sistema de ativação
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        if playerGui:FindFirstChild("UltimateAimAssistGUI") then
            playerGui.UltimateAimAssistGUI:Destroy()
        else
            createUltimateGUI()
        end
    end
end)

-- Comandos de chat ÉPICOS
local function onChatted(message)
    local lowerMessage = string.lower(message)
    
    if string.find(lowerMessage, "/ultimate") then
        if playerGui:FindFirstChild("UltimateAimAssistGUI") then
            playerGui.UltimateAimAssistGUI:Destroy()
        else
            createUltimateGUI()
        end
    elseif string.find(lowerMessage, "/godmode") then
        aimAssistConfig.aimBot = {
            enabled = true, mode = "Always", targetParts = {"Head", "Torso"}, 
            key = Enum.KeyCode.E, smoothness = 1, fov = 500
        }
        aimAssistConfig.autoFire.enabled = true
        aimAssistConfig.autoWall.enabled = true
        aimAssistConfig.checkWall = false
        createEpicNotification("🔥 GOD MODE ACTIVATED! 🔥", Color3.fromRGB(255, 100, 100), "👑")
    elseif string.find(lowerMessage, "/legit") then
        aimAssistConfig.aimBot = {
            enabled = true, mode = "Toggle", targetParts = {"Head"}, 
            key = Enum.KeyCode.E, smoothness = 0.3, fov = 100
        }
        aimAssistConfig.autoFire.enabled = false
        aimAssistConfig.autoWall.enabled = false
        aimAssistConfig.checkWall = true
        createEpicNotification("✅ Legit Mode Activated", Color3.fromRGB(100, 255, 100), "🎯")
    end
end

if player.Chatted then
    player.Chatted:Connect(onChatted)
end

-- Inicialização ÉPICA
print("🚀🚀🚀 ULTIMATE AIM ASSIST LOADED! 🚀🚀🚀")
print("💫 A GUI MAIS ÉPICA DO UNIVERSO! 💫")
print("⚡ COMANDOS DISPONÍVEIS:")
print("   🔹 INSERT - Abrir/Fechar GUI")
print("   🔹 /ultimate - Toggle GUI via chat")
print("   🔹 /godmode - Ativar modo DESTRUIÇÃO")
print("   🔹 /legit - Modo discreto")
print("🌟 PREPARE-SE PARA DOMINAR! 🌟")

-- Criar GUI automaticamente
createUltimateGUI()

-- Notificação de inicialização
wait(1)
if playerGui:FindFirstChild("UltimateAimAssistGUI") then
    -- Criar notificação épica de inicialização
    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Parent = playerGui
    welcomeGui.ResetOnSpawn = false
    
    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Size = UDim2.new(0, 600, 0, 200)
    welcomeFrame.Position = UDim2.new(0.5, -300, 0.5, -100)
    welcomeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    welcomeFrame.BackgroundTransparency = 0.3
    welcomeFrame.BorderSizePixel = 0
    welcomeFrame.Parent = welcomeGui
    
    local welcomeCorner = Instance.new("UICorner")
    welcomeCorner.CornerRadius = UDim.new(0, 20)
    welcomeCorner.Parent = welcomeFrame
    
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Size = UDim2.new(1, 0, 1, 0)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Text = "🚀 ULTIMATE AIM ASSIST ACTIVATED! 🚀\n💫 PREPARE FOR DOMINATION! 💫"
    welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    welcomeText.TextScaled = true
    welcomeText.Font = Enum.Font.GothamBold
    welcomeText.Parent = welcomeFrame
    
    local textGradient = Instance.new("UIGradient")
    textGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))
    }
    textGradient.Parent = welcomeText
    
    -- Animação de rotação do gradiente
    local rotationTween = TweenService:Create(textGradient,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    rotationTween:Play()
    
    -- Fade out após 5 segundos
    wait(5)
    local fadeOut = TweenService:Create(welcomeFrame,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )
    local textFade = TweenService:Create(welcomeText,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 1}
    )
    
    fadeOut:Play()
    textFade:Play()
    
    fadeOut.Completed:Connect(function()
        welcomeGui:Destroy()
    end)
end
