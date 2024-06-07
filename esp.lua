local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ESPEnabled = false
local highlights = {}
local counter = 0

local function CreateESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = player.Character
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(0, 1, 0)
        highlight.OutlineTransparency = 0
        highlight.Parent = player.Character
        highlights[player] = highlight
    end
end

local function RemoveESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function EnableESP()
    ESPEnabled = true
    for _, player in pairs(Players:GetPlayers()) do
        if not highlights[player] then
            CreateESP(player)
        end
    end
end

local function DisableESP()
    ESPEnabled = false
    for player, highlight in pairs(highlights) do
        if highlight then
            highlight:Destroy()
        end
    end
    highlights = {}
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if ESPEnabled then
            if player.Character and not highlights[player] then
                CreateESP(player)
            end
        else
            RemoveESP(player)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        counter = (counter + 0.001) % 5 -- Daha yavaş ve yumuşak geçiş için
        local hue = counter
        for _, highlight in pairs(highlights) do
            highlight.FillColor = Color3.fromHSV(hue, 1, 1)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            EnableESP()
        else
            DisableESP()
        end
    end
end)

local function CheckAndToggleESP()
    while true do
        wait(1)
        if ESPEnabled then
            DisableESP()
            EnableESP()
        end
    end
end

spawn(CheckAndToggleESP)
