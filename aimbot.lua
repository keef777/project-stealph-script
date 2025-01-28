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

    ScreenGui.Parent = game.CoreGui

    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.Position = UDim2.new(0, 50, 0, 100)
    MainFrame.Size = UDim2.new(0, 300, 0, 350)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false

    LogoButton.Parent = ScreenGui
    LogoButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoButton.Position = UDim2.new(0, 10, 0, 10)
    LogoButton.Size = UDim2.new(0, 50, 0, 50) -- Tamanho reduzido
    LogoButton.Text = ""
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 25) -- Pontas arredondadas
    UICorner.Parent = LogoButton

    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Painel de Controle"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24

    ToggleAimbotButton.Parent = MainFrame
    ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleAimbotButton.Position = UDim2.new(0, 50, 0, 60)
    ToggleAimbotButton.Size = UDim2.new(0, 200, 0, 50)
    ToggleAimbotButton.Font = Enum.Font.SourceSansBold
    ToggleAimbotButton.Text = "Toggle Aimbot"
    ToggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleAimbotButton.TextSize = 18

    ToggleESPButton.Parent = MainFrame
    ToggleESPButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleESPButton.Position = UDim2.new(0, 50, 0, 120)
    ToggleESPButton.Size = UDim2.new(0, 200, 0, 50)
    ToggleESPButton.Font = Enum.Font.SourceSansBold
    ToggleESPButton.Text = "Toggle ESP"
    ToggleESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleESPButton.TextSize = 18

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
