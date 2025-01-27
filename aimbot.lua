-- Verificação para garantir que o script funcione apenas no jogo "Foguete PvP"
local gameId = 1234567890 -- Substitua pelo ID real do jogo "Foguete PvP"
if game.PlaceId ~= gameId then
    return
end

-- Criando um painel de controle similar ao Maru Hub com funcionalidades de Aimbot e ajuste de FOV

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Configurações do Aimbot
local aimbotEnabled = false
local aimbotFov = 50
local aimAtRocket = true

-- Função para criar a interface do usuário
local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local ToggleAimbotButton = Instance.new("TextButton")
    local SetFovButton = Instance.new("TextButton")
    local FovTextBox = Instance.new("TextBox")
    local Title = Instance.new("TextLabel")

    ScreenGui.Parent = game.CoreGui

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.Position = UDim2.new(0, 50, 0, 50)
    Frame.Size = UDim2.new(0, 300, 0, 200)
    Frame.Active = true
    Frame.Draggable = true

    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Painel de Controle"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24

    ToggleAimbotButton.Parent = Frame
    ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleAimbotButton.Position = UDim2.new(0, 50, 0, 60)
    ToggleAimbotButton.Size = UDim2.new(0, 200, 0, 50)
    ToggleAimbotButton.Font = Enum.Font.SourceSansBold
    ToggleAimbotButton.Text = "Toggle Aimbot"
    ToggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleAimbotButton.TextSize = 18

    SetFovButton.Parent = Frame
    SetFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SetFovButton.Position = UDim2.new(0, 50, 0, 120)
    SetFovButton.Size = UDim2.new(0, 200, 0, 50)
    SetFovButton.Font = Enum.Font.SourceSansBold
    SetFovButton.Text = "Set FOV"
    SetFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetFovButton.TextSize = 18

    FovTextBox.Parent = Frame
    FovTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    FovTextBox.Position = UDim2.new(0, 50, 0, 180)
    FovTextBox.Size = UDim2.new(0, 200, 0, 50)
    FovTextBox.Font = Enum.Font.SourceSansBold
    FovTextBox.PlaceholderText = "Enter FOV"
    FovTextBox.Text = ""
    FovTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    FovTextBox.TextSize = 18

    -- Funções para os botões
    ToggleAimbotButton.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        ToggleAimbotButton.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    end)

    SetFovButton.MouseButton1Click:Connect(function()
        local newFov = tonumber(FovTextBox.Text)
        if newFov then
            aimbotFov = newFov
        end
    end)
end

-- Função do Aimbot
local function getClosestRocket()
    local closestRocket = nil
    local shortestDistance = aimbotFov

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Rocket") then
            local distance = (player.Character.Rocket.Position - Players.LocalPlayer.Character.Head.Position).magnitude
            if distance < shortestDistance then
                closestRocket = player.Character.Rocket
                shortestDistance = distance
            end
        end
    end

    return closestRocket
end

-- Loop do Aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetRocket = getClosestRocket()
        if targetRocket then
            local rocketPosition = targetRocket.Position
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, rocketPosition)
        end
    end
end)

-- Criar a interface do usuário
createGui()
