local configSection = createSupremeSection("CONFIGURAÇÕES", "⚙️", 800, 300)
    local statsSection = createSupremeSection("BATTLE STATS", "📊", 1120, 280)
    
    -- Função para criar controles ULTRA SUPREMOS
    local function createSupremeControl(name, description, configPath, parent, yPos, controlType)
        local controlFrame = Instance.new("Frame")
        controlFrame.Name = name .. "Control"
        controlFrame.Size = UDim2.new(1, -20, 0, controlType == "slider" and 120 or 80)
        controlFrame.Position = UDim2.new(0, 10, 0, yPos)
        controlFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
        controlFrame.BorderSizePixel = 0
        controlFrame.Parent = parent
        
        local controlCorner = Instance.new("UICorner")
        controlCorner.CornerRadius = UDim.new(0, 12)
        controlCorner.Parent = controlFrame
        
        local controlGradient = Instance.new("UIGradient")
        controlGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 60)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 30, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 60, 30))
        }
        controlGradient.Rotation = 45
        controlGradient.Parent = controlFrame
        
        local controlStroke = Instance.new("UIStroke")
        controlStroke.Color = Color3.fromRGB(80, 160, 255)
        controlStroke.Thickness = 1
        controlStroke.Transparency = 0.7
        controlStroke.Parent = controlFrame
        
        if controlType == "toggle" then
            -- Toggle switch ULTRA SUPREMO
            local toggleContainer = Instance.new("Frame")
            toggleContainer.Size = UDim2.new(0, 80, 0, 40)
            toggleContainer.Position = UDim2.new(0, 15, 0, 20)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(60, 60, 120)
            toggleContainer.BorderSizePixel = 0
            toggleContainer.Parent = controlFrame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggleContainer
            
            local toggleGradient = Instance.new("UIGradient")
            toggleGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 140)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 180))
            }
            toggleGradient.Rotation = 90
            toggleGradient.Parent = toggleContainer
            
            local toggleSwitch = Instance.new("Frame")
            toggleSwitch.Size = UDim2.new(0, 34, 0, 34)
            toggleSwitch.Position = UDim2.new(0, 3, 0, 3)
            toggleSwitch.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            toggleSwitch.BorderSizePixel = 0
            toggleSwitch.Parent = toggleContainer
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = toggleSwitch
            
            local switchGlow = Instance.new("UIStroke")
            switchGlow.Color = Color3.fromRGB(255, 255, 255)
            switchGlow.Thickness = 3
            switchGlow.Transparency = 0.5
            switchGlow.Parent = toggleSwitch
            
            -- Indicador ON/OFF
            local statusIndicator = Instance.new("TextLabel")
            statusIndicator.Size = UDim2.new(0, 40, 0, 20)
            statusIndicator.Position = UDim2.new(0, 100, 0, 30)
            statusIndicator.BackgroundTransparency = 1
            statusIndicator.Text = "OFF"
            statusIndicator.TextColor3 = Color3.fromRGB(255, 80, 80)
            statusIndicator.TextScaled = true
            statusIndicator.Font = Enum.Font.GothamBold
            statusIndicator.Parent = controlFrame
            
            -- Label principal
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 300, 0, 30)
            label.Position = UDim2.new(0, 150, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = "💫 " .. name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = controlFrame
            
            local labelGradient = Instance.new("UIGradient")
            labelGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 255, 255))
            }
            labelGradient.Parent = label
            
            -- Descrição
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(0, 400, 0, 25)
            desc.Position = UDim2.new(0, 150, 0, 35)
            desc.BackgroundTransparency = 1
            desc.Text = "✨ " .. description
            desc.TextColor3 = Color3.fromRGB(180, 180, 255)
            desc.TextSize = 14
            desc.Font = Enum.Font.Gotham
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = controlFrame
            
            -- Sistema de toggle
            local isEnabled = false
            
            local function getValue(path)
                local keys = string.split(path, ".")
                local current = supremeConfig
                for _, key in ipairs(keys) do
                    current = current[key]
                end
                return current
            end
            
            local function setValue(path, value)
                local keys = string.split(path, ".")
                local current = supremeConfig
                for i = 1, #keys - 1 do
                    current = current[keys[i]]
                end
                current[keys[#keys]] = value
            end
            
            local function toggleControl()
                isEnabled = not isEnabled
                setValue(configPath, isEnabled)
                
                local targetPos = isEnabled and UDim2.new(0, 43, 0, 3) or UDim2.new(0, 3, 0, 3)
                local switchColor = isEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
                local containerColor = isEnabled and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(60, 60, 120)
                local statusText = isEnabled and "ON" or "OFF"
                local statusColor = isEnabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
                
                TweenService:Create(toggleSwitch, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
                    Position = targetPos,
                    BackgroundColor3 = switchColor
                }):Play()
                
                TweenService:Create(toggleContainer, TweenInfo.new(0.3), {
                    BackgroundColor3 = containerColor
                }):Play()
                
                TweenService:Create(statusIndicator, TweenInfo.new(0.3), {
                    TextColor3 = statusColor
                }):Play()
                
                statusIndicator.Text = statusText
                
                -- Efeitos visuais SUPREMOS
                if isEnabled then
                    playSupremeSound("activate", 0.6)
                    
                    -- Efeito de explosão
                    for i = 1, 12 do
                        local spark = Instance.new("Frame")
                        spark.Size = UDim2.new(0, 6, 0, 6)
                        spark.Position = UDim2.new(0, 55, 0, 40)
                        spark.BackgroundColor3 = Color3.fromHSV(i/12, 1, 1)
                        spark.BorderSizePixel = 0
                        spark.ZIndex = 10
                        spark.Parent = controlFrame
                        
                        local sparkCorner = Instance.new("UICorner")
                        sparkCorner.CornerRadius = UDim.new(1, 0)
                        sparkCorner.Parent = spark
                        
                        local angle = math.rad(i * 30)
                        local distance = 50
                        
                        TweenService:Create(spark, TweenInfo.new(0.8), {
                            Position = UDim2.new(0, 55 + math.cos(angle) * distance, 0, 40 + math.sin(angle) * distance),
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 0, 0, 0),
                            Rotation = 360
                        }):Play()
                        
                        game:GetService("Debris"):AddItem(spark, 0.8)
                    end
                    
                    -- Flash effect
                    local flash = Instance.new("Frame")
                    flash.Size = UDim2.new(1, 0, 1, 0)
                    flash.Position = UDim2.new(0, 0, 0, 0)
                    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    flash.BackgroundTransparency = 0.7
                    flash.BorderSizePixel = 0
                    flash.ZIndex = 5
                    flash.Parent = controlFrame
                    
                    local flashCorner = Instance.new("UICorner")
                    flashCorner.CornerRadius = UDim.new(0, 12)
                    flashCorner.Parent = flash
                    
                    TweenService:Create(flash, TweenInfo.new(0.3), {
                        BackgroundTransparency = 1
                    }):Play()
                    
                    game:GetService("Debris"):AddItem(flash, 0.3)
                else
                    playSupremeSound("deactivate", 0.4)
                end
                
                -- Pulse effect no stroke
                TweenService:Create(controlStroke, TweenInfo.new(0.2), {
                    Transparency = 0,
                    Thickness = 3
                }):Play()
                
                wait(0.2)
                TweenService:Create(controlStroke, TweenInfo.new(0.3), {
                    Transparency = 0.7,
                    Thickness = 1
                }):Play()
            end
            
            toggleContainer.MouseButton1Click:Connect(toggleControl)
            
            -- Dropdown para modo
            local dropdown = Instance.new("TextButton")
            dropdown.Size = UDim2.new(0, 120, 0, 35)
            dropdown.Position = UDim2.new(1, -135, 0, 22.5)
            dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            dropdown.Text = "Toggle ▼"
            dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdown.TextScaled = true
            dropdown.Font = Enum.Font.Gotham
            dropdown.BorderSizePixel = 0
            dropdown.Parent = controlFrame
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 10)
            dropCorner.Parent = dropdown
            
            local dropGradient = Instance.new("UIGradient")
            dropGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 60, 150))
            }
            dropGradient.Rotation = 45
            dropGradient.Parent = dropdown
            
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = Color3.fromRGB(120, 180, 255)
            dropStroke.Thickness = 1
            dropStroke.Transparency = 0.6
            dropStroke.Parent = dropdown
            
            -- Menu dropdown
            local dropdownMenu = Instance.new("Frame")
            dropdownMenu.Size = UDim2.new(0, 120, 0, 105)
            dropdownMenu.Position = UDim2.new(1, -135, 0, 60)
            dropdownMenu.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
            dropdownMenu.BorderSizePixel = 0
            dropdownMenu.Visible = false
            dropdownMenu.ZIndex = 20
            dropdownMenu.Parent = controlFrame
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = dropdownMenu
            
            local menuStroke = Instance.new("UIStroke")
            menuStroke.Color = Color3.fromRGB(120, 180, 255)
            menuStroke.Thickness = 2
            menuStroke.Parent = dropdownMenu
            
            local modes = {"Toggle", "Hold", "Always"}
            for i, mode in ipairs(modes) do
                local modeButton = Instance.new("TextButton")
                modeButton.Size = UDim2.new(1, -4, 0, 33)
                modeButton.Position = UDim2.new(0, 2, 0, (i-1) * 35 + 2)
                modeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 85)
                modeButton.Text = mode
                modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                modeButton.TextScaled = true
                modeButton.Font = Enum.Font.Gotham
                modeButton.BorderSizePixel = 0
                modeButton.ZIndex = 21
                modeButton.Parent = dropdownMenu
                
                local modeCorner = Instance.new("UICorner")
                modeCorner.CornerRadius = UDim.new(0, 6)
                modeCorner.Parent = modeButton
                
                modeButton.MouseEnter:Connect(function()
                    TweenService:Create(modeButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(65, 65, 125)
                    }):Play()
                end)
                
                modeButton.MouseLeave:Connect(function()
                    TweenService:Create(modeButton, TweenInfo.new(0.15), {
                        BackgroundColor3 = Color3.fromRGB(45, 45, 85)
                    }):Play()
                end)
                
                modeButton.MouseButton1Click:Connect(function()
                    local modeConfigPath = string.gsub(configPath, "enabled", "mode")
                    setValue(modeConfigPath, mode)
                    dropdown.Text = mode .. " ▼"
                    dropdownMenu.Visible = false
                    playSupremeSound("activate", 0.3)
                end)
            end
            
            dropdown.MouseButton1Click:Connect(function()
                dropdownMenu.Visible = not dropdownMenu.Visible
                playSupremeSound("activate", 0.2)
            end)
            
        elseif controlType == "slider" then
            -- Slider ULTRA SUPREMO
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(0, 200, 0, 25)
            sliderLabel.Position = UDim2.new(0, 15, 0, 10)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = "🎯 " .. name
            sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.TextScaled = true
            sliderLabel.Font = Enum.Font.GothamBold
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = controlFrame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(0, 400, 0, 25)
            sliderBg.Position = UDim2.new(0, 15, 0, 45)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = controlFrame
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local fillGradient = Instance.new("UIGradient")
            fillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 255, 100)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 100))
            }
            fillGradient.Parent = sliderFill
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Size = UDim2.new(0, 35, 0, 35)
            sliderKnob.Position = UDim2.new(0.5, -17.5, 0, -5)
            sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderKnob.BorderSizePixel = 0
            sliderKnob.Parent = sliderBg
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = sliderKnob
            
            local knobGlow = Instance.new("UIStroke")
            knobGlow.Color = Color3.fromRGB(100, 255, 255)
            knobGlow.Thickness = 4
            knobGlow.Transparency = 0.3
            knobGlow.Parent = sliderKnob
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 60, 0, 25)
            valueLabel.Position = UDim2.new(1, -75, 0, 45)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = "200"
            valueLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            valueLabel.TextScaled = true
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Parent = controlFrame
            
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(0, 350, 0, 20)
            descLabel.Position = UDim2.new(0, 15, 0, 80)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = "✨ " .. description
            descLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
            descLabel.TextSize = 12
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.Parent = controlFrame
            
            -- Sistema de slider funcional
            local dragging = false
            local minValue = configPath == "aimBot.fov" and 50 or (configPath == "aimBot.smoothness" and 0.1 or 0)
            local maxValue = configPath == "aimBot.fov" and 500 or (configPath == "aimBot.smoothness" and 1 or 100)
            local currentValue = configPath == "aimBot.fov" and 200 or (configPath == "aimBot.smoothness" and 0.15 or 50)
            
            local function updateSlider(value)
                local percentage = (value - minValue) / (maxValue - minValue)
                percentage = math.clamp(percentage, 0, 1)
                
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percentage, -17.5, 0, -5)
                
                if configPath == "aimBot.smoothness" then
                    valueLabel.Text = string.format("%.2f", value)
                else
                    valueLabel.Text = tostring(math.floor(value))
                end
                
                -- Atualizar config
                setValue(configPath, value)
                
                -- Efeito visual
                local hue = percentage
                knobGlow.Color = Color3.fromHSV(hue, 1, 1)
                fillGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.2) % 1, 1, 1))
                }
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    playSupremeSound("activate", 0.2)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = Players.LocalPlayer:GetMouse()
                    local relativeX = mouse.X - sliderBg.AbsolutePosition.X
                    local percentage = math.clamp(relativeX / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = minValue + (percentage * (maxValue - minValue))
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            updateSlider(currentValue)
        end
        
        return controlFrame
    end
    
    -- Criar controles SUPREMOS para AIM DESTROYER
    createSupremeControl("AIM BOT", "Lock automático com predição de movimento", "aimBot.enabled", aimSection, 80, "toggle")
    createSupremeControl("AUTO FIRE", "Disparo automático ultra preciso", "autoFire.enabled", aimSection, 170, "toggle")
    createSupremeControl("AUTO WALL", "Penetração inteligente de paredes", "autoWall.enabled", aimSection, 260, "toggle")
    createSupremeControl("CHECK WALL", "Verificação avançada de obstáculos", "checkWall", aimSection, 350, "toggle")
    
    -- Sliders para configuração
    createSupremeControl("FOV SIZE", "Raio do campo de visão do aimbot", "aimBot.fov", visualSection, 80, "slider")
    createSupremeControl("SMOOTHNESS", "Suavidade do movimento do aimbot", "aimBot.smoothness", visualSection, 210, "slider")
    
    -- Controles visuais
    createSupremeControl("SHOW FOV", "Exibir círculo do campo de visão", "visuals.showFOV", visualSection, 340, "toggle")
    
    -- Sistema de minimização ULTRA SUPREMO
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    local function toggleMinimize()
        isMinimized = not isMinimized
        
        local targetSize = isMinimized and UDim2.new(0, 650, 0, 100) or originalSize
        local targetText = isMinimized and "⬆" : "⬇"
        local targetColor = isMinimized and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(50, 150, 255)
        
        -- Animação ÉPICA
        local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local sizeTween = TweenService:Create(mainFrame, tweenInfo, {Size = targetSize})
        local colorTween = TweenService:Create(minimizeButton, tweenInfo, {BackgroundColor3 = targetColor})
        
        sizeTween:Play()
        colorTween:Play()
        
        minimizeButton.Text = targetText
        mainContainer.Visible = not isMinimized
        
        if isMinimized then
            playSupremeSound("deactivate", 0.5)
            
            -- Efeito de implosão SUPREMO
            for i = 1, 20 do
                local particle = Instance.new("Frame")
                particle.Size = UDim2.new(0, math.random(8, 15), 0, math.random(8, 15))
                particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
                particle.BackgroundColor3 = Color3.fromHSV(i/20, 1, 1)
                particle.BorderSizePixel = 0
                particle.Parent = mainFrame
                
                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(1, 0)
                pCorner.Parent = particle
                
                local angle = math.rad(i * 18)
                TweenService:Create(particle, TweenInfo.new(0.8), {
                    Position = UDim2.new(0.5 + math.cos(angle) * 3, 0, 0.5 + math.sin(angle) * 3, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Rotation = 720
                }):Play()
                
                game:GetService("Debris"):AddItem(particle, 0.8)
            end
            
            -- Efeito pulse no header
            local pulseTween = TweenService:Create(headerStroke,
                TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Transparency = 0, Thickness = 4}
            )
            pulseTween:Play()
            header:SetAttribute("PulseTween", pulseTween)
        else
            playSupremeSound("activate", 0.5)
            
            -- Parar pulse
            local pulseTween = header:GetAttribute("PulseTween")
            if pulseTween then
                pulseTween:Cancel()
                headerStroke.Transparency = 0.3
                headerStroke.Thickness = 2
            end
            
            -- Efeito de explosão na restauração
            for i = 1, 15 do
                local spark = Instance.new("Frame")
                spark.Size = UDim2.new(0, 4, 0, 4)
                spark.Position = UDim2.new(0.5, 0, 0, 50)
                spark.BackgroundColor3 = Color3.fromHSV(i/15, 1, 1)
                spark.BorderSizePixel = 0
                spark.Parent = mainFrame
                
                local sCorner = Instance.new("UICorner")
                sCorner.CornerRadius = UDim.new(1, 0)
                sCorner.Parent = spark
                
                local angle = math.rad(i * 24)
                TweenService:Create(spark, TweenInfo.new(0.6), {
                    Position = UDim2.new(0.5 + math.cos(angle) * 1.5, 0, 0.1 + math.sin(angle) * 0.5, 0),
                    Size = UDim2.new(0, 8, 0, 8),
                    BackgroundTransparency = 0.3
                }):Play()
                
                wait(0.6)
                TweenService:Create(spark, TweenInfo.new(0.4), {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
                
                game:GetService("Debris"):AddItem(spark, 1)
            end
        end
    end
    
    minimizeButton.MouseButton1Click:Connect(toggleMinimize)
    
    -- Sistema de estatísticas em tempo real SUPREMO
    local kills = 0
    local shots = 0
    local hits = 0
    local streak = 0
    local headshots = 0
    
    local function createStatDisplay(name, value, icon, parent, xPos)
        local statFrame = Instance.new("Frame")
        statFrame.Size = UDim2.new(0, 180, 0, 100)
        statFrame.Position = UDim2.new(0, xPos, 0, 80)
        statFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        statFrame.BorderSizePixel = 0
        statFrame.Parent = parent
        
        local statCorner = Instance.-- 🌟💥 ULTRA MEGA BLASTER SUPREME AIM DESTROYER 💥🌟
-- A GUI MAIS INSANA, PERFEITA E DOMINANTE DO UNIVERSO ROBLOX!
-- TUDO CORRIGIDO, OTIMIZADO E APERFEIÇOADO ALÉM DA IMAGINAÇÃO!

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Mouse = Players.LocalPlayer:GetMouse()

-- Variáveis principais
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()

-- Configurações SUPREMAS
local supremeConfig = {
    aimBot = {
        enabled = false,
        mode = "Toggle", -- Toggle, Hold, Always
        targetParts = {"Head"},
        key = Enum.KeyCode.E,
        smoothness = 0.15, -- Mais baixo = mais suave
        fov = 200,
        prediction = true,
        wallCheck = true,
        visibleCheck = true,
        teamCheck = true,
        maxDistance = 2000
    },
    autoFire = {
        enabled = false,
        mode = "Toggle",
        delay = 0.05, -- Delay entre tiros
        burstMode = false,
        burstCount = 3,
        targetLock = true,
        accuracyCheck = true
    },
    autoWall = {
        enabled = false,
        mode = "Toggle",
        penetrationPower = 5,
        materialCheck = true,
        thicknessCheck = true,
        onlyBreakable = true
    },
    checkWall = false,
    visuals = {
        enabled = true,
        showFOV = true,
        showTarget = true,
        showTracers = true,
        showESP = true,
        rainbowMode = false,
        fovColor = Color3.fromRGB(255, 255, 255),
        targetColor = Color3.fromRGB(255, 0, 0),
        tracerColor = Color3.fromRGB(0, 255, 0)
    },
    performance = {
        maxFPS = 60,
        cpuOptimization = true,
        memoryOptimization = true,
        renderDistance = 1000
    }
}

-- Sistema de sons ÉPICO melhorado
local soundEffects = {
    activate = "rbxasset://sounds/electronicpingshort.wav",
    deactivate = "rbxasset://sounds/button-09.wav",
    target_lock = "rbxasset://sounds/impact_water.mp3",
    fire = "rbxasset://sounds/snap.mp3",
    hit = "rbxasset://sounds/impact-02.wav",
    notification = "rbxasset://sounds/button-10.wav"
}

local function playSupremeSound(soundType, volume)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundEffects[soundType] or soundEffects.notification
        sound.Volume = volume or 0.5
        sound.PlayOnRemove = true
        sound.Parent = Workspace
        sound:Destroy()
    end)
end

-- Sistema de raycast ULTRA melhorado
local function createAdvancedRaycast(origin, direction, distance, ignoreList)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = ignoreList or {character}
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(origin, direction * distance, raycastParams)
    return result
end

-- Sistema de detecção de parede SUPREMO
local function isWallBreakable(part)
    if not part then return false end
    
    local breakableMaterials = {
        Enum.Material.Glass,
        Enum.Material.Ice,
        Enum.Material.Neon,
        Enum.Material.ForceField
    }
    
    local breakableNames = {
        "Glass", "Window", "Breakable", "Destructible", 
        "Fragile", "Weak", "Thin", "Paper"
    }
    
    -- Check material
    for _, material in pairs(breakableMaterials) do
        if part.Material == material then return true end
    end
    
    -- Check transparency
    if part.Transparency > 0.7 then return true end
    
    -- Check collision
    if not part.CanCollide then return true end
    
    -- Check size (thin walls)
    local size = part.Size
    if size.X < 1 or size.Y < 1 or size.Z < 1 then return true end
    
    -- Check name
    for _, name in pairs(breakableNames) do
        if string.find(string.lower(part.Name), string.lower(name)) then
            return true
        end
    end
    
    return false
end

-- Sistema de FOV ULTRA precisão
local function isInFOV(targetPosition, fovRadius)
    local camera = Workspace.CurrentCamera
    local screenPoint, onScreen = camera:WorldToScreenPoint(targetPosition)
    
    if not onScreen then return false end
    
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local targetScreenPos = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetScreenPos - screenCenter).Magnitude
    
    return distance <= fovRadius
end

-- Sistema de ESP SUPREMO
local espObjects = {}

local function createESP(player)
    if espObjects[player] then return end
    
    local esp = {}
    
    -- Box ESP
    local boxESP = Drawing.new("Square")
    boxESP.Size = Vector2.new(100, 150)
    boxESP.Color = Color3.fromRGB(255, 0, 0)
    boxESP.Thickness = 2
    boxESP.Transparency = 1
    boxESP.Filled = false
    boxESP.Visible = false
    
    -- Name ESP
    local nameESP = Drawing.new("Text")
    nameESP.Text = player.Name
    nameESP.Size = 16
    nameESP.Color = Color3.fromRGB(255, 255, 255)
    nameESP.Center = true
    nameESP.Outline = true
    nameESP.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameESP.Visible = false
    
    -- Health ESP
    local healthESP = Drawing.new("Text")
    healthESP.Text = "100 HP"
    healthESP.Size = 14
    healthESP.Color = Color3.fromRGB(0, 255, 0)
    healthESP.Center = true
    healthESP.Outline = true
    healthESP.OutlineColor = Color3.fromRGB(0, 0, 0)
    healthESP.Visible = false
    
    -- Distance ESP
    local distanceESP = Drawing.new("Text")
    distanceESP.Text = "0m"
    distanceESP.Size = 12
    distanceESP.Color = Color3.fromRGB(255, 255, 0)
    distanceESP.Center = true
    distanceESP.Outline = true
    distanceESP.OutlineColor = Color3.fromRGB(0, 0, 0)
    distanceESP.Visible = false
    
    esp.box = boxESP
    esp.name = nameESP
    esp.health = healthESP
    esp.distance = distanceESP
    
    espObjects[player] = esp
end

local function updateESP()
    for targetPlayer, esp in pairs(espObjects) do
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local character = targetPlayer.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local rootPart = character.HumanoidRootPart
            
            local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
            
            if onScreen and supremeConfig.visuals.showESP then
                local distance = (rootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                -- Update box
                esp.box.Position = Vector2.new(screenPos.X - 50, screenPos.Y - 75)
                esp.box.Visible = true
                
                -- Update name
                esp.name.Position = Vector2.new(screenPos.X, screenPos.Y - 90)
                esp.name.Visible = true
                
                -- Update health
                if humanoid then
                    local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                    esp.health.Text = healthPercent .. " HP"
                    esp.health.Color = Color3.fromRGB(255 - (healthPercent * 2.55), healthPercent * 2.55, 0)
                    esp.health.Position = Vector2.new(screenPos.X, screenPos.Y + 80)
                    esp.health.Visible = true
                end
                
                -- Update distance
                esp.distance.Text = math.floor(distance / 3.571) .. "m"
                esp.distance.Position = Vector2.new(screenPos.X, screenPos.Y + 95)
                esp.distance.Visible = true
                
                -- Rainbow mode
                if supremeConfig.visuals.rainbowMode then
                    local time = tick()
                    esp.box.Color = Color3.fromHSV((time * 0.5) % 1, 1, 1)
                end
            else
                esp.box.Visible = false
                esp.name.Visible = false
                esp.health.Visible = false
                esp.distance.Visible = false
            end
        else
            -- Clean up disconnected players
            if esp then
                esp.box:Remove()
                esp.name:Remove()
                esp.health:Remove()
                esp.distance:Remove()
                espObjects[targetPlayer] = nil
            end
        end
    end
end

-- FOV Circle SUPREMO
local fovCircle = Drawing.new("Circle")
fovCircle.Color = supremeConfig.visuals.fovColor
fovCircle.Thickness = 2
fovCircle.NumSides = 50
fovCircle.Radius = supremeConfig.aimBot.fov
fovCircle.Filled = false
fovCircle.Transparency = 0.7
fovCircle.Visible = supremeConfig.visuals.showFOV

-- Target indicator SUPREMO
local targetIndicator = Drawing.new("Circle")
targetIndicator.Color = supremeConfig.visuals.targetColor
targetIndicator.Thickness = 3
targetIndicator.NumSides = 20
targetIndicator.Radius = 20
targetIndicator.Filled = false
targetIndicator.Transparency = 1
targetIndicator.Visible = false

-- Função para criar a GUI ULTRA MEGA SUPREMA
local function createSupremeGUI()
    -- Destruir GUI existente
    if playerGui:FindFirstChild("SupremeAimGUI") then
        playerGui.SupremeAimGUI:Destroy()
    end
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SupremeAimGUI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 100
    
    -- Background animado SUPREMO
    local backgroundFrame = Instance.new("Frame")
    backgroundFrame.Name = "BackgroundFrame"
    backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
    backgroundFrame.Position = UDim2.new(0, 0, 0, 0)
    backgroundFrame.BackgroundTransparency = 0.97
    backgroundFrame.BorderSizePixel = 0
    backgroundFrame.Parent = screenGui
    
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 15)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(15, 5, 30)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(30, 5, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 15, 5))
    }
    bgGradient.Rotation = 0
    bgGradient.Parent = backgroundFrame
    
    -- Animação suprema do background
    local bgRotationTween = TweenService:Create(bgGradient, 
        TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    bgRotationTween:Play()
    
    -- Frame principal MEGA SUPREMO
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 650, 0, 800)
    mainFrame.Position = UDim2.new(0.5, -325, 0.5, -400)
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 15)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Gradiente principal ÉPICO
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 25)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(25, 10, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 10, 100)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(25, 50, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 25, 10))
    }
    mainGradient.Rotation = 45
    mainGradient.Parent = mainFrame
    
    -- Cantos arredondados PREMIUM
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 25)
    mainCorner.Parent = mainFrame
    
    -- Múltiplas bordas NEON para efeito 3D
    for i = 1, 3 do
        local neonBorder = Instance.new("UIStroke")
        neonBorder.Color = Color3.fromHSV((i * 0.33) % 1, 1, 1)
        neonBorder.Thickness = 4 - i
        neonBorder.Transparency = 0.2 + (i * 0.2)
        neonBorder.Parent = mainFrame
        
        -- Animação individual para cada borda
        local borderTween = TweenService:Create(neonBorder,
            TweenInfo.new(3 + i, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Color = Color3.fromHSV((i * 0.33 + 0.5) % 1, 1, 1)}
        )
        borderTween:Play()
    end
    
    -- Sombra SUPREMA multi-layer
    for i = 1, 5 do
        local shadow = Instance.new("Frame")
        shadow.Name = "Shadow" .. i
        shadow.Size = UDim2.new(1, i * 8, 1, i * 8)
        shadow.Position = UDim2.new(0, -i * 4, 0, -i * 4)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.5 + (i * 0.1)
        shadow.ZIndex = -i
        shadow.Parent = mainFrame
        
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(0, 25 + i * 2)
        shadowCorner.Parent = shadow
    end
    
    -- Header ULTRA FUTURÍSTICO
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 100)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 60)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(60, 30, 120)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(120, 60, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 60))
    }
    headerGradient.Rotation = 90
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 25)
    headerCorner.Parent = header
    
    -- Borda do header
    local headerStroke = Instance.new("UIStroke")
    headerStroke.Color = Color3.fromRGB(255, 255, 255)
    headerStroke.Thickness = 2
    headerStroke.Transparency = 0.3
    headerStroke.Parent = header
    
    -- Título MEGA ÉPICO
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -250, 0, 50)
    title.Position = UDim2.new(0, 30, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "⚡💥 ULTRA MEGA BLASTER SUPREME 💥⚡"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Gradiente animado do título
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 255)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(50, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 50)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 50))
    }
    titleGradient.Parent = title
    
    -- Animação INSANA do título
    local titleTween = TweenService:Create(titleGradient,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    titleTween:Play()
    
    -- Subtítulo ÉPICO
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -250, 0, 30)
    subtitle.Position = UDim2.new(0, 30, 0, 60)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🔥💎 VERSÃO ULTRA EXCLUSIVA - DOMINAÇÃO TOTAL 💎🔥"
    subtitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Efeito blink MELHORADO
    local blinkTween = TweenService:Create(subtitle,
        TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.3}
    )
    blinkTween:Play()
    
    -- Sistema de botões ULTRA FUTURÍSTICO
    local function createSupremeButton(name, text, color, position, size, parent)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = size or UDim2.new(0, 60, 0, 60)
        button.Position = position
        button.BackgroundColor3 = color
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextScaled = true
        button.Font = Enum.Font.GothamBold
        button.BorderSizePixel = 0
        button.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 15)
        buttonCorner.Parent = button
        
        local buttonStroke = Instance.new("UIStroke")
        buttonStroke.Color = Color3.fromRGB(255, 255, 255)
        buttonStroke.Thickness = 3
        buttonStroke.Transparency = 0.4
        buttonStroke.Parent = button
        
        local buttonGradient = Instance.new("UIGradient")
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(0.5, Color3.new(math.min(color.R * 1.8, 1), math.min(color.G * 1.8, 1), math.min(color.B * 1.8, 1))),
            ColorSequenceKeypoint.new(1, color)
        }
        buttonGradient.Rotation = 45
        buttonGradient.Parent = button
        
        -- Efeitos hover SUPREMOS
        button.MouseEnter:Connect(function()
            playSupremeSound("activate", 0.3)
            
            TweenService:Create(button, TweenInfo.new(0.15), {
                Size = UDim2.new(size.X.Scale, size.X.Offset * 1.15, size.Y.Scale, size.Y.Offset * 1.15)
            }):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.15), {Transparency = 0}):Play()
            
            -- Efeito de partículas
            for i = 1, 8 do
                local particle = Instance.new("Frame")
                particle.Size = UDim2.new(0, 3, 0, 3)
                particle.Position = UDim2.new(0.5, 0, 0.5, 0)
                particle.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)
                particle.BorderSizePixel = 0
                particle.Parent = button
                
                local pCorner = Instance.new("UICorner")
                pCorner.CornerRadius = UDim.new(1, 0)
                pCorner.Parent = particle
                
                local angle = math.rad(i * 45)
                TweenService:Create(particle, TweenInfo.new(0.5), {
                    Position = UDim2.new(0.5 + math.cos(angle) * 2, 0, 0.5 + math.sin(angle) * 2, 0),
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }):Play()
                
                game:GetService("Debris"):AddItem(particle, 0.5)
            end
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.15), {Size = size}):Play()
            TweenService:Create(buttonStroke, TweenInfo.new(0.15), {Transparency = 0.4}):Play()
        end)
        
        return button
    end
    
    -- Botões do header
    local minimizeButton = createSupremeButton("MinimizeButton", "⬇", 
        Color3.fromRGB(50, 150, 255), UDim2.new(1, -180, 0, 20), UDim2.new(0, 50, 0, 50), header)
    local settingsButton = createSupremeButton("SettingsButton", "⚙", 
        Color3.fromRGB(255, 150, 50), UDim2.new(1, -120, 0, 20), UDim2.new(0, 50, 0, 50), header)
    local closeButton = createSupremeButton("CloseButton", "✕", 
        Color3.fromRGB(255, 50, 50), UDim2.new(1, -60, 0, 20), UDim2.new(0, 50, 0, 50), header)
    
    -- Container principal com scroll SUPREMO
    local mainContainer = Instance.new("ScrollingFrame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, -20, 1, -120)
    mainContainer.Position = UDim2.new(0, 10, 0, 110)
    mainContainer.BackgroundTransparency = 1
    mainContainer.BorderSizePixel = 0
    mainContainer.ScrollBarThickness = 12
    mainContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 255, 255)
    mainContainer.CanvasSize = UDim2.new(0, 0, 0, 2000)
    mainContainer.Parent = mainFrame
    
    -- Gradiente para a scrollbar
    local scrollGradient = Instance.new("UIGradient")
    scrollGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 255, 255))
    }
    scrollGradient.Rotation = 90
    scrollGradient.Parent = mainContainer
    
    -- Função para criar seção SUPREMA
    local function createSupremeSection(name, icon, yPos, height)
        local section = Instance.new("Frame")
        section.Name = name .. "Section"
        section.Size = UDim2.new(1, -10, 0, height or 350)
        section.Position = UDim2.new(0, 5, 0, yPos)
        section.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
        section.BorderSizePixel = 0
        section.Parent = mainContainer
        
        local sectionGradient = Instance.new("UIGradient")
        sectionGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 40, 20))
        }
        sectionGradient.Rotation = 135
        sectionGradient.Parent = section
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 20)
        sectionCorner.Parent = section
        
        local sectionStroke = Instance.new("UIStroke")
        sectionStroke.Color = Color3.fromRGB(100, 200, 255)
        sectionStroke.Thickness = 2
        sectionStroke.Transparency = 0.5
        sectionStroke.Parent = section
        
        -- Animação da borda da seção
        local strokeTween = TweenService:Create(sectionStroke,
            TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Color = Color3.fromRGB(255, 100, 200)}
        )
        strokeTween:Play()
        
        -- Título da seção ÉPICO
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Name = "SectionTitle"
        sectionTitle.Size = UDim2.new(1, -20, 0, 60)
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
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 150))
        }
        titleGradient.Parent = sectionTitle
        
        return section
    end
    
    -- Seções SUPREMAS
    local aimSection = createSupremeSection("AIM DESTROYER", "🎯", 10, 400)
    local visualSection = createSupremeSection("VISUAL HACKS", "👁️", 430, 350)
    local configSection = createSupremeSection("CONFIGURAÇÕES", "⚙
