print("Script carregado com sucesso!")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Drawing = Drawing or require("Drawing") -- Certifique-se de ter a biblioteca Drawing

local aimbotEnabled = false
local aimbotFov = 50
local fovCircle = Drawing.new("Circle")
local aimAtHead = true

-- Configurações do círculo de FOV
fovCircle.Visible = true
fovCircle.Radius = aimbotFov
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local gameId = 1234567890 -- Substitua pelo ID real do jogo "Foguete PvP"
if game.PlaceId ~= gameId then
    print("Jogo não corresponde ao ID especificado.")
    return
end

local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local ToggleAimbotButton = Instance.new("TextButton")
    local SetFovButton = Instance.new("TextButton")
    local IncreaseFovButton = Instance.new("TextButton")
    local DecreaseFovButton = Instance.new("TextButton")
    local FovTextBox = Instance.new("TextBox")
    local Title = Instance.new("TextLabel")

    ScreenGui.Parent = game.CoreGui

    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Frame.Position = UDim2.new(0, 50, 0, 50)
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Active = true
    Frame.Draggable = true

    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Painel de Controle Do Aimbot Do Alexandre"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24

    ToggleAimbotButton.Parent = Frame
    ToggleAimbotButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ToggleAimbotButton.Position = UDim2.new(0, 50, 0, 60)
    ToggleAimbotButton.Size = UDim2.new(0, 200, 0, 50)
    ToggleAimbotButton.Font = Enum.Font.SourceSansBold
    ToggleAimbotButton.Text = "Aimbozin"
    ToggleAimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleAimbotButton.TextSize = 18

    SetFovButton.Parent = Frame
    SetFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SetFovButton.Position = UDim2.new(0, 50, 0, 120)
    SetFovButton.Size = UDim2.new(0, 200, 0, 50)
    SetFovButton.Font = Enum.Font.SourceSansBold
    SetFovButton.Text = "O Fov Seu Burro"
    SetFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetFovButton.TextSize = 18

    IncreaseFovButton.Parent = Frame
    IncreaseFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    IncreaseFovButton.Position = UDim2.new(0, 10, 0, 180)
    IncreaseFovButton.Size = UDim2.new(0, 130, 0, 30)
    IncreaseFovButton.Font = Enum.Font.SourceSansBold
    IncreaseFovButton.Text = "+"
    IncreaseFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncreaseFovButton.TextSize = 18

    DecreaseFovButton.Parent = Frame
    DecreaseFovButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DecreaseFovButton.Position = UDim2.new(0, 160, 0, 180)
    DecreaseFovButton.Size = UDim2.new(0, 130, 0, 30)
    DecreaseFovButton.Font = Enum.Font.SourceSansBold
    DecreaseFovButton.Text = "-"
    DecreaseFovButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseFovButton.TextSize = 18

    FovTextBox.Parent = Frame
    FovTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    FovTextBox.Position = UDim2.new(0, 50, 0, 220)
    FovTextBox.Size = UDim2.new(0, 200, 0, 30)
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
            fovCircle.Radius = aimbotFov
        end
    end)

    IncreaseFovButton.MouseButton1Click:Connect(function()
        aimbotFov = aimbotFov + 10
        fovCircle.Radius = aimbotFov
    end)

    DecreaseFovButton.MouseButton1Click:Connect(function()
        aimbotFov = aimbotFov - 10
        fovCircle.Radius = aimbotFov
    end)
end

local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = aimbotFov

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPosition = player.Character.Head.Position
            local headScreenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(headPosition)
            local mouseLocation = UserInputService:GetMouseLocation()
            local distance = (Vector2.new(headScreenPos.X, headScreenPos.Y) - mouseLocation).Magnitude

            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

    if aimbotEnabled then
        local target = getClosestPlayerToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPosition = target.Character.Head.Position
            local aimAtPos = aimAtHead and headPosition or target.Character.HumanoidRootPart.Position
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, aimAtPos)
        end
    end
end)

createGui()
print("Painel de controle criado.")
