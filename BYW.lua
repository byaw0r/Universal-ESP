--BYW SCRIPT
local espEnabled = false
local chamsEnabled = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPMenu"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local espBtn = Instance.new("TextButton")
espBtn.Name = "ESPBtn"
espBtn.Size = UDim2.new(0, 40, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 10)
espBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
espBtn.Text = "B"
espBtn.TextSize = 28
espBtn.Font = Enum.Font.GothamBold
espBtn.BorderSizePixel = 0
espBtn.Active = true
espBtn.Draggable = true
espBtn.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = espBtn

local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 150, 0, 100)
menuFrame.Position = UDim2.new(0, 70, 0, 10)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuFrame.Visible = false
menuFrame.Parent = screenGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 8)
menuCorner.Parent = menuFrame

local espToggle = Instance.new("TextButton")
espToggle.Name = "ESPToggle"
espToggle.Size = UDim2.new(0, 130, 0, 30)
espToggle.Position = UDim2.new(0, 10, 0, 10)
espToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
espToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
espToggle.Text = "Esp Name: OFF"
espToggle.TextSize = 14
espToggle.Font = Enum.Font.GothamBold
espToggle.Parent = menuFrame

local chamsToggle = Instance.new("TextButton")
chamsToggle.Name = "ChamsToggle"
chamsToggle.Size = UDim2.new(0, 130, 0, 30)
chamsToggle.Position = UDim2.new(0, 10, 0, 50)
chamsToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
chamsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
chamsToggle.Text = "CHAMS: OFF"
chamsToggle.TextSize = 14
chamsToggle.Font = Enum.Font.GothamBold
chamsToggle.Parent = menuFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = espToggle
toggleCorner:Clone().Parent = chamsToggle

local espObjects = {}
local chamsObjects = {}

espBtn:GetPropertyChangedSignal("Position"):Connect(function()
    if menuFrame.Visible then
        menuFrame.Position = UDim2.new(0, espBtn.Position.X.Offset + 60, 0, espBtn.Position.Y.Offset)
    end
end)

local function createESP(player)
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 1
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.Parent = billboard
    
    espObjects[player] = billboard
end

local function createChams(player)
    local character = player.Character
    if not character then return end
    
    local mainParts = {
        "Head",
        "Torso",
        "Left Arm", 
        "Right Arm",
        "Left Leg",
        "Right Leg"
    }
    
    for _, partName in pairs(mainParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local highlight = Instance.new("Highlight")
            highlight.Name = "Chams_" .. player.Name
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = part
            highlight.Parent = part
            
            chamsObjects[part] = highlight
        end
    end
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

local function removeChams(player)
    local character = player.Character
    if character then
        for part, highlight in pairs(chamsObjects) do
            if part:IsDescendantOf(character) then
                highlight:Destroy()
                chamsObjects[part] = nil
            end
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        espToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        espToggle.Text = "Esp Name: ON"
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESP(player)
            end
        end
    else
        espToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        espToggle.Text = "Esp Name: OFF"
        
        for player, esp in pairs(espObjects) do
            esp:Destroy()
        end
        espObjects = {}
    end
end

local function toggleChams()
    chamsEnabled = not chamsEnabled
    
    if chamsEnabled then
        chamsToggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        chamsToggle.Text = "CHAMS: ON"
        
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createChams(player)
            end
        end
    else
        chamsToggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        chamsToggle.Text = "CHAMS: OFF"
        
        for _, highlight in pairs(chamsObjects) do
            highlight:Destroy()
        end
        chamsObjects = {}
    end
end

local function toggleMenu()
    menuFrame.Visible = not menuFrame.Visible
    if menuFrame.Visible then
        menuFrame.Position = UDim2.new(0, espBtn.Position.X.Offset + 60, 0, espBtn.Position.Y.Offset)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            wait(1)
            createESP(player)
        end
        if chamsEnabled then
            wait(1)
            createChams(player)
        end
    end)
    
    if player.Character and espEnabled then
        createESP(player)
    end
    if player.Character and chamsEnabled then
        createChams(player)
    end
end

espBtn.MouseButton1Click:Connect(toggleMenu)

espToggle.MouseButton1Click:Connect(toggleESP)
chamsToggle.MouseButton1Click:Connect(toggleChams)

for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        onPlayerAdded(player)
    end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeChams(player)
end)

print("BYW SCRIPT loaded!")
