print("Script carregado com sucesso!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Certifique-se de ter a biblioteca Drawing
local Drawing = Drawing or require("Drawing")

local aimbotEnabled = false
local espEnabled = true

local function createESP(player)
    if player == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character
    return highlight
end

local function toggleESP()
    espEnabled = not espEnabled
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Highlight") then
            player.Character.Highlight.Enabled = espEnabled
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            createESP(player)
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        createESP(player)
    end
end

local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local LogoButton = Instance.new("TextButton")
    local ToggleAimbotButton = Instance.new("TextButton")
    local ToggleESPButton = Instance.new("TextButton")
    local Title = Instance.new("TextLabel")
    local ProjectAimLabel = Instance.new("TextLabel")

    ScreenGui.Parent = game.CoreGui

    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0, 50, 0, 100)
    MainFrame.Size = UDim2.new(0, 350, 0, 450)
    MainFrame.BorderSizePixel = 0
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UICornerMainFrame = Instance.new("UICorner")
    UICornerMainFrame.CornerRadius = UDim.new(0, 10)
    UICornerMainFrame.Parent = MainFrame

    LogoButton.Parent = ScreenGui
    LogoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoButton.Position = UDim2.new(0, 10, 0, 10)
    LogoButton.Size = UDim2.new(0, 50, 0, 50) -- Tamanho reduzido
    LogoButton.Text = ""
    LogoButton.Draggable = true
    local UICornerLogo = Instance.new("UICorner")
    UICornerLogo.CornerRadius = UDim.new(0, 25)
    UICornerLogo.Parent = LogoButton

    ProjectAimLabel.Parent = MainFrame
    ProjectAimLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProjectAimLabel.BackgroundTransparency = 1
    ProjectAimLabel.Size = UDim2.new(1, 0, 0, 30)
    ProjectAimLabel.Font = Enum.Font.GothamBold
    ProjectAimLabel.Text = "Project Aim"
    ProjectAimLabel.TextColor3 = Color3.fromRGB(170, 0, 255)
    ProjectAimLabel.TextSize = 28
    ProjectAimLabel.Position = UDim2.new(0, 10, 0, 10)

    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Painel de Controle"
    Title.TextColor3 = Color3.fromRGB(170, 0, 255)
    Title.TextSize = 24

    ToggleAimbotButton.Parent = MainFrame
    ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleAimbotButton.Position = UDim2.new(0, 50, 0, 60)
    ToggleAimbotButton.Size = UDim2.new(0, 250, 0, 50)
    ToggleAimbotButton.Font = Enum.Font.SourceSansBold
    ToggleAimbotButton.Text = "Toggle Aimbot"
    ToggleAimbotButton.TextColor3 = Color3.fromRGB(170, 0, 255)
    ToggleAimbotButton.TextSize = 18
    local UICornerAimbotButton = Instance.new("UICorner")
    UICornerAimbotButton.CornerRadius = UDim.new(0, 10)
    UICornerAimbotButton.Parent = ToggleAimbotButton

    local AimbotDescription = Instance.new("TextLabel")
    AimbotDescription.Parent = MainFrame
    AimbotDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AimbotDescription.BackgroundTransparency = 1
    AimbotDescription.Position = UDim2.new(0, 50, 0, 115)
    AimbotDescription.Size = UDim2.new(0, 250, 0, 30)
    AimbotDescription.Font = Enum.Font.SourceSans
    AimbotDescription.Text = "Liga/Desliga a função de mira automática"
    AimbotDescription.TextColor3 = Color3.fromRGB(170, 0, 255)
    AimbotDescription.TextSize = 14
        ToggleESPButton.Parent = MainFrame
    ToggleESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleESPButton.Position = UDim2.new(0, 50, 0, 160)
    ToggleESPButton.Size = UDim2.new(0, 250, 0, 50)
    ToggleESPButton.Font = Enum.Font.SourceSansBold
    ToggleESPButton.Text = "Toggle ESP"
    ToggleESPButton.TextColor3 = Color3.fromRGB(170, 0, 255)
    ToggleESPButton.TextSize = 18
    local UICornerESPButton = Instance.new("UICorner")
    UICornerESPButton.CornerRadius = UDim.new(0, 10)
    UICornerESPButton.Parent = ToggleESPButton

    local ESPDescription = Instance.new("TextLabel")
    ESPDescription.Parent = MainFrame
    ESPDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ESPDescription.BackgroundTransparency = 1
    ESPDescription.Position = UDim2.new(0, 50, 0, 215)
    ESPDescription.Size = UDim2.new(0, 250, 0, 30)
    ESPDescription.Font = Enum.Font.SourceSans
    ESPDescription.Text = "Liga/Desliga a visualização dos jogadores"
    ESPDescription.TextColor3 = Color3.fromRGB(170, 0, 255)
    ESPDescription.TextSize = 14

    -- Funções para os botões
    local function toggleAimbot()
        aimbotEnabled = not aimbotEnabled
        ToggleAimbotButton.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    end

    ToggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)
    ToggleESPButton.MouseButton1Click:Connect(toggleESP)

    -- Suporte a dispositivos móveis
    ToggleAimbotButton.TouchTap:Connect(toggleAimbot)
    ToggleESPButton.TouchTap:Connect(toggleESP)

    -- Função para abrir e fechar o painel
    local function toggleMainFrame()
        MainFrame.Visible = not MainFrame.Visible
    end

    LogoButton.MouseButton1Click:Connect(toggleMainFrame)
    LogoButton.TouchTap:Connect(toggleMainFrame)
end

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("UpperTorso") then
            local torsoPosition = player.Character.UpperTorso.Position
            local torsoScreenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(torsoPosition)
            local mouseLocation = UserInputService:GetMouseLocation()
            local distance = (Vector2.new(torsoScreenPos.X, torsoScreenPos.Y) - mouseLocation).Magnitude

            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("UpperTorso") then
            local torsoPosition = target.Character.UpperTorso.Position
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, torsoPosition)
        end
    end
end)

createGui()
print("Painel de controle criado.")
