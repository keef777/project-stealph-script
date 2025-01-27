print("Script carregado com sucesso!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Certifique-se de ter a biblioteca Drawing
local Drawing = Drawing or require("Drawing")

local aimbotEnabled = false
local aimbotFov = 50
local fovCircle = Drawing.new("Circle")
local fovVisible = true

-- Configurações do círculo de FOV
fovCircle.Visible = fovVisible
fovCircle.Radius = aimbotFov
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Filled = false -- Deixa a parte interna do círculo invisível
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local gameId = 84065576744468 -- Substitua pelo ID real do jogo "Foguete PvP"
if game.PlaceId ~= gameId then
    print("Jogo não corresponde ao ID especificado.")
    return
end

local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local LogoButton = Instance.new("TextButton")
    local ToggleAimbotButton = Instance.new("TextButton")
    local SetFovButton = Instance.new("TextButton")
    local IncreaseFovButton = Instance.new("TextButton")
    local DecreaseFovButton = Instance.new("TextButton")
    local ToggleFovVisibilityButton = Instance.new("TextButton")
    local FovTextBox = Instance.new("TextBox")
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
    LogoButton.BorderSizePixel = 0
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

    SetFovButton.Parent = MainFrame
    SetFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SetFovButton.Position = UDim2.new(0, 50, 0, 120)
    SetFovButton.Size = UDim2.new(0, 200, 0, 50)
    SetFovButton.Font = Enum.Font.SourceSansBold
    SetFovButton.Text = "Set FOV"
    SetFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetFovButton.TextSize = 18

    IncreaseFovButton.Parent = MainFrame
    IncreaseFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    IncreaseFovButton.Position = UDim2.new(0, 10, 0, 180)
    IncreaseFovButton.Size = UDim2.new(0, 130, 0, 30)
    IncreaseFovButton.Font = Enum.Font.SourceSansBold
    IncreaseFovButton.Text = "+"
    IncreaseFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncreaseFovButton.TextSize = 18

    DecreaseFovButton.Parent = MainFrame
    DecreaseFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DecreaseFovButton.Position = UDim2.new(0, 160, 0, 180)
    DecreaseFovButton.Size = UDim2.new(0, 130, 0, 30)
    DecreaseFovButton.Font = Enum.Font.SourceSansBold
    DecreaseFovButton.Text = "-"
    DecreaseFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseFovButton.TextSize = 18

    ToggleFovVisibilityButton.Parent = MainFrame
    ToggleFovVisibilityButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleFovVisibilityButton.Position = UDim2.new(0, 50, 0, 220)
    ToggleFovVisibilityButton.Size = UDim2.new(0, 200, 0, 50)
    ToggleFovVisibilityButton.Font = Enum.Font.SourceSansBold
    ToggleFovVisibilityButton.Text = "Toggle FOV Visibility"
    ToggleFovVisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleFovVisibilityButton.TextSize = 18

    FovTextBox.Parent = MainFrame
    FovTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    FovTextBox.Position = UDim2.new(0, 50, 0, 280)
    FovTextBox.Size = UDim2.new(0, 200, 0, 30)
    FovTextBox.Font = Enum.Font.SourceSansBold
    FovTextBox.PlaceholderText = "Enter FOV"
    FovTextBox.Text = ""
    FovTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    FovTextBox.TextSize = 18

    -- Funções para os botões
    local function toggleAimbot()
        aimbotEnabled = not aimbotEnabled
        ToggleAimbotButton.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    end

    local function setFov()
        local newFov = tonumber(FovTextBox.Text)
        if newFov then
            aimbotFov = newFov
            fovCircle.Radius = aimbotFov
        end
    end

    local function increaseFov()
        aimbotFov = aimbotFov + 10
        fovCircle.Radius = aimbotFov
    end

    local function decreaseFov()
        aimbotFov = aimbotFov - 10
        fovCircle.Radius = aimbotFov
    end

    local function toggleFovVisibility()
        fovVisible = not fovVisible
        fovCircle.Visible = fovVisible
    end

    ToggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)
    SetFovButton.MouseButton1Click:Connect(setFov)
    IncreaseFovButton.MouseButton1Click:Connect(increaseFov)
    DecreaseFovButton.MouseButton1Click:Connect(decreaseFov)
    ToggleFovVisibilityButton.MouseButton1Click:Connect(toggleFovVisibility)

    -- Suporte a dispositivos móveis
    ToggleAimbotButton.TouchTap:Connect(toggleAimbot)
    SetFovButton.TouchTap:Connect(setFov)
    IncreaseFovButton.TouchTap:Connect(increaseFov)
    DecreaseFovButton.TouchTap:Connect(decreaseFov)
    ToggleFovVisibilityButton.TouchTap:Connect(toggleFovVisibility)

    -- Função para abrir e fechar o painel
local function toggleMainFrame()
    MainFrame.Visible = not MainFrame.Visible
end

LogoButton.MouseButton1Click:Connect(toggleMainFrame)
LogoButton.TouchTap:Connect(toggleMainFrame)

RunService.RenderStepped:Connect(function()
    fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

    if aimbotEnabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("UpperTorso") then
            local torsoPosition = target.Character.UpperTorso.Position
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, torsoPosition)
        end
    end
end)

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = aimbotFov

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

createGui()
print("Painel de controle criado.")
