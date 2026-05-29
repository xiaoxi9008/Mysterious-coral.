local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local cloneref = cloneref or function(instance) return instance end

local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        if RunService:IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild("WindUI"):WaitForChild("Init")))
        else
            WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/hxjxnx/refs/heads/main/OhioUI.lua"))()
        end
    end
end

local ESPEnabled = false
local ESP_ScreenGui = nil
local ESPFolder = nil
local ESPNameColor = Color3.fromRGB(0, 255, 127)
local ESPBodyColor = Color3.fromRGB(0, 255, 127)
local ESPNameSize = 14
local ESPRainbowEnabled = false
local ESPRainbowSpeed = 5
local CurrentESPHue = 0
local ESPTeamCheck = false

local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false

local InfiniteJumpEnabled = false
local JumpConnection = nil
local SpeedEnabled = false
local SpeedValue = 1
local SpeedConnection = nil
local GravityLoop = nil
local originalGravity = workspace.Gravity

local NightVisionEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

local RainbowUIEnabled = false
local RainbowUIScreenGui = nil
local StatusIndicator = nil
local animationConnection = nil

local AimSettings = {
    Enabled = false,
    FOV = 100,
    Smoothness = 10,
    CrosshairDistance = 5,
    FOVColor = Color3.fromRGB(0, 255, 0),
    FriendCheck = true,
    WallCheck = true,
    TargetPlayer = nil,
    TargetAll = true,
    FOVRainbowEnabled = true,
    FOVRainbowSpeed = 8,
    FOVEnabled = true
}

local DrawingObjects = {}
local AimConnection = nil
local FOVCircle = nil
local TargetPlayers = {}
local CurrentFOVHue = 0
local CurrentTarget = nil

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local AimBlacklist = {}
local AimTeamCheck = false
local AimTargetPart = "头"
local ESPMaxDistance = 1000

local blacklistInput

-- ========== 美化功能变量 ==========
local inv = require(ReplicatedStorage.devv).load("v3item").inventory
local sig = require(ReplicatedStorage.devv).load("Signal")
local skinvoid = false
local autoskin = false
local skinsec = ""
local balloonBuyThread = nil
local balloonBuyTeleporting = false
local balloonItems = {
    "Balloon", "Dollar Balloon", "Black Rose", "Golden Rose", 
    "Bat Balloon", "Bunny Balloon", "Clover Balloon", "Ghost Balloon",
    "Gold Clover Balloon", "Heart Balloon", "Skull Balloon", "Snowflake Balloon"
}

local items = {
    "Golden Rose", "Black Rose", "Dollar Balloon", "Bat Balloon", "Bunny Balloon", "Clover Balloon",
    "Ghost Balloon", "Gold Clover Balloon", "Heart Balloon", "Skull Balloon", "Snowflake Balloon",
    "Admin AK-47", "Admin Nuke Launcher", "Admin RPG", "Void Gem", "Pulse Rifle", "Unusual Money Printer",
    "Money Printer", "Trident", "NextBot Grenade", "El Fuego", "Kunai", "Spirit Kunai"
}

local itemDisplayNames = {
    ["Golden Rose"] = "金玫瑰", ["Black Rose"] = "黑玫瑰", ["Dollar Balloon"] = "美元气球",
    ["Bat Balloon"] = "蝙蝠气球", ["Bunny Balloon"] = "兔子气球", ["Clover Balloon"] = "三叶草气球",
    ["Ghost Balloon"] = "幽灵气球", ["Gold Clover Balloon"] = "金三叶草气球", ["Heart Balloon"] = "爱心气球",
    ["Skull Balloon"] = "骷髅气球", ["Snowflake Balloon"] = "雪花气球", ["Admin AK-47"] = "管理员黄金AK-47",
    ["Admin Nuke Launcher"] = "管理员核弹发射器", ["Admin RPG"] = "管理员RPG", ["Void Gem"] = "虚空宝石",
    ["Pulse Rifle"] = "脉冲步枪", ["Unusual Money Printer"] = "异常印钞机", ["Money Printer"] = "印钞机",
    ["Trident"] = "三叉戟", ["NextBot Grenade"] = "NextBot手榴弹", ["El Fuego"] = "烈焰喷射器",
    ["Kunai"] = "苦无", ["Spirit Kunai"] = "灵魂苦无"
}

local itemData = {}

itemData["Bat Balloon"] = {name = "Bat Balloon", cost = 0, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5.5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, math.pi, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Bunny Balloon"] = {name = "Bunny Balloon", cost = 0, unpurchasable = true, multiplier = 0.61, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 4.75, offset = CFrame.new(0, -0.25, 0), rotoffset = CFrame.Angles(0, 4.71238898038469, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Clover Balloon"] = {name = "Clover Balloon", cost = 200, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Ghost Balloon"] = {name = "Ghost Balloon", cost = 0, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 3.5, offset = CFrame.new(0, 0.5, 0), rotoffset = CFrame.Angles(0, math.pi, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Gold Clover Balloon"] = {name = "Gold Clover Balloon", cost = 250000, unpurchasable = true, multiplier = 0.6, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Heart Balloon"] = {name = "Heart Balloon", cost = 200, multiplier = 0.6, holdableType = "Balloon", unpurchasable = true, canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Skull Balloon"] = {name = "Skull Balloon", cost = 0, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5.5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, -270, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Snowflake Balloon"] = {name = "Snowflake Balloon", cost = 0, unpurchasable = true, multiplier = 0.625, holdableType = "Balloon", canDrop = true, dropCooldown = 120, permanent = true, TPSOffsets = {hold = CFrame.new(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Golden Rose"] = {name = "Golden Rose", guid = "golden_rose_"..tostring(tick()), permanent = true, canDrop = true, dropCooldown = 120, multiplier = 0.625, holdableType = "Balloon", movespeedAdd = 5, TPSOffsets = {hold = CFrame.new(0, 0.5, 0)}, viewportOffsets = {hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)}, ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744467859455345, 0)}, slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}}}
itemData["Black Rose"] = {name = "Black Rose", guid = "black_rose_"..tostring(tick()), permanent = true, canDrop = true, dropCooldown = 120, multiplier = 0.75, holdableType = "Balloon", movespeedAdd = 12, TPSOffsets = {hold = CFrame.new(0, 0.5, 0)}, viewportOffsets = {hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)}, ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744467859455345, 0)}, slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}}}
itemData["Dollar Balloon"] = {name = "Dollar Balloon", cost = 100000000000, unpurchasable = true, multiplier = 0.8, holdableType = "Balloon", movespeedAdd = 8, cannotDiscard = true, TPSOffsets = {hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0)}, viewportOffsets = {hotbar = {dist = 4, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}, ammoHUD = {dist = 5, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 0, 0)}}}
itemData["Admin AK-47"] = {name = "Admin AK-47", modelName = "Gold AK-47", subtype = "AK-47", adminOnly = true, canDrop = false, unpurchasable = true, damage = 10, ammo = 999999999, startAmmo = -1, maxAmmo = -1, firemode = "auto", numProjectiles = 8, fireDebounce = 0.01}
itemData["Admin Nuke Launcher"] = {name = "Admin Nuke Launcher", modelName = "Nuke Launcher", subtype = "Nuke Launcher", adminOnly = true, canDrop = false, unpurchasable = true, ammo = 99999999, startAmmo = -1, maxAmmo = -1, overrideProjectileProperties = {disableNukeFlash = true}, reloadTime = 0, reloadType = "mag", firemode = "auto", numProjectiles = 1, fireDebounce = 0.2}
itemData["Admin RPG"] = {canDrop = false, unpurchasable = true, name = "Admin RPG", modelName = "RPG", subtype = "RPG", adminOnly = true, ammo = 99999999, startAmmo = -1, maxAmmo = -1, reloadTime = 0, reloadType = "mag", firemode = "auto", numProjectiles = 1, fireDebounce = 0.02, recoilAdd = 0, maxRecoil = 0, recoilDiminishFactor = 0, recoilFastDiminishFactor = 0}
itemData["Void Gem"] = {name = "Void Gem", subtype = "gem", maxAmmo = 3, adminLimit = 1, sellPrice = 25000, canDrop = true, dropCooldown = 300}
itemData["Pulse Rifle"] = {name = "Pulse Rifle", subtype = "Raygun", unpurchasable = true, damage = 22, headshotMultiplier = 1.5, ammo = 50, startAmmo = -1, maxAmmo = -1, reloadTime = 3.5, reloadType = "mag", firemode = "auto", numProjectiles = 1, fireDebounce = 0.04, projectileLength = 20, projectileLifetime = 200, speedDropoff = 0.04, speedMax = 5, baseSpread = 3, baseAimSpread = 0.8, spread = 11, aimSpread = 2.4, recoilAdd = 0.05, maxRecoil = 0.4, recoilDiminishFactor = 0.95, recoilFastDiminishFactor = 0.85}
itemData["Unusual Money Printer"] = {name = "Unusual Money Printer", cost = 500, ammo = 1, startAmmo = -1, maxAmmo = 1, hint = {computer = "Click to Place", console = "Click to Place"}, canDrop = true, dropCooldown = 600, isConsumable = true, TPSOffsets = {hold = CFrame.new(-0.1, 0, -0.75) * CFrame.Angles(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0.15, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}, ammoHUD = {dist = 3.25, offset = CFrame.new(0, 1, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)}}}
itemData["Money Printer"] = {name = "Money Printer", ammo = 1, startAmmo = -1, maxAmmo = 1, adminLimit = 10, hint = {computer = "Click to Place", console = "Click to Place"}, canDrop = true, dropCooldown = 600, isConsumable = true, permanent = true, TPSOffsets = {hold = CFrame.new(-0.1, 0, -0.75) * CFrame.Angles(0, 0, 0)}, viewportOffsets = {hotbar = {dist = 5, offset = CFrame.new(0, 0.15, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}, ammoHUD = {dist = 3.25, offset = CFrame.new(0, 1, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}}}
itemData["Trident"] = {name = "Trident", subtype = "RPG", unpurchasable = true, ammo = 1, startAmmo = 12, maxAmmo = 12, firemode = "semi", numProjectiles = 3, fireDebounce = 0.5, projectileLength = 4, projectileLifetime = 1000, speedDropoff = 0.04, speedMax = 5, baseSpread = 5, baseAimSpread = 1, spread = 10, aimSpread = 6, recoilAdd = 1, maxRecoil = 1.25, recoilDiminishFactor = 0.9, recoilFastDiminishFactor = 0.66}
itemData["NextBot Grenade"] = {name = "NextBot Grenade", isNade = true, bounceSFX = "nadeBounce", canDrop = true, dropCooldown = 600, thrownOffset = CFrame.Angles(0, (math.pi/2), 0), ammo = 1, startAmmo = -1, maxAmmo = 1, permanent = true, throwDist = 50, TPSOffsets = {hold = CFrame.new(-0.1, 0.25, -0.125)}, viewportOffsets = {hotbar = {dist = 2.75, offset = CFrame.new(0, -0.125, 0), rotoffset = CFrame.Angles(0, 1.8849555921538759, 0)}, ammoHUD = {dist = 2, offset = CFrame.new(0, 0.1, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)}}}
itemData["El Fuego"] = {name = "El Fuego", modelName = "El Fuego", subtype = "Flamethrower", unpurchasable = true, ammo = 600, startAmmo = 0, maxAmmo = 600, reloadTime = 6, reloadType = "mag", firemode = "auto", damage = 6, numProjectiles = 3, fireDebounce = 0.05, projectileLength = 4, projectileLifetime = 60, speedDropoff = 0.04, speedMax = 5, baseSpread = 4, baseAimSpread = 2, spread = 12, aimSpread = 6, recoilAdd = 0.1, maxRecoil = 1, recoilDiminishFactor = 0.95, recoilFastDiminishFactor = 0.8}
itemData["Kunai"] = {name = "Kunai", permanent = true, canDrop = true, dropCooldown = 120, holdableType = "Kunai", movespeedAdd = 12, TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}, viewportOffsets = {hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}, ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}, slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}}}
itemData["Spirit Kunai"] = {name = "Spirit Kunai", permanent = true, canDrop = true, dropCooldown = 120, holdableType = "Kunai", movespeedAdd = 12, TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}, viewportOffsets = {hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}, ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}, slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}}}

local selectedItem = ""

local function getItemNameByDisplayName(displayName)
    for itemName, dispName in pairs(itemDisplayNames) do
        if dispName == displayName then return itemName end
    end
    return displayName
end

local function addItem(itemName)
    pcall(function()
        local itemSystem = require(ReplicatedStorage.devv).load("v3item")
        local inventory = itemSystem.inventory
        if not itemData[itemName] then return end
        local itemConfig = itemData[itemName]
        local itemToAdd = {
            name = itemConfig.name,
            guid = itemName:lower():gsub(" ", "_").."_"..tostring(tick()),
            permanent = itemConfig.permanent or true,
            canDrop = itemConfig.canDrop or true,
            dropCooldown = itemConfig.dropCooldown or 120,
            multiplier = itemConfig.multiplier or 0.625,
            holdableType = itemConfig.holdableType or "Balloon",
            movespeedAdd = itemConfig.movespeedAdd or 0,
            cannotDiscard = itemConfig.cannotDiscard or false,
            TPSOffsets = itemConfig.TPSOffsets or {hold = CFrame.new(0, 0.5, 0)},
            viewportOffsets = itemConfig.viewportOffsets or {
                hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, (math.pi/2), 0)},
                ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744467859455345, 0)},
                slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, (-math.pi/2), 0)}
            }
        }
        if itemConfig.subtype then itemToAdd.subtype = itemConfig.subtype end
        if itemConfig.modelName then itemToAdd.modelName = itemConfig.modelName end
        if itemConfig.adminOnly then itemToAdd.adminOnly = itemConfig.adminOnly end
        if itemConfig.damage then itemToAdd.damage = itemConfig.damage end
        if itemConfig.ammo then itemToAdd.ammo = itemConfig.ammo end
        if itemConfig.startAmmo then itemToAdd.startAmmo = itemConfig.startAmmo end
        if itemConfig.maxAmmo then itemToAdd.maxAmmo = itemConfig.maxAmmo end
        if itemConfig.reloadTime then itemToAdd.reloadTime = itemConfig.reloadTime end
        if itemConfig.reloadType then itemToAdd.reloadType = itemConfig.reloadType end
        if itemConfig.firemode then itemToAdd.firemode = itemConfig.firemode end
        if itemConfig.numProjectiles then itemToAdd.numProjectiles = itemConfig.numProjectiles end
        if itemConfig.fireDebounce then itemToAdd.fireDebounce = itemConfig.fireDebounce end
        if itemConfig.projectileLength then itemToAdd.projectileLength = itemConfig.projectileLength end
        if itemConfig.projectileLifetime then itemToAdd.projectileLifetime = itemConfig.projectileLifetime end
        if itemConfig.headshotMultiplier then itemToAdd.headshotMultiplier = itemConfig.headshotMultiplier end
        if itemConfig.hint then itemToAdd.hint = itemConfig.hint end
        if itemConfig.isConsumable then itemToAdd.isConsumable = itemConfig.isConsumable end
        if itemConfig.isNade then itemToAdd.isNade = itemConfig.isNade end
        if itemConfig.throwDist then itemToAdd.throwDist = itemConfig.throwDist end
        if itemConfig.sellPrice then itemToAdd.sellPrice = itemConfig.sellPrice end
        if itemConfig.adminLimit then itemToAdd.adminLimit = itemConfig.adminLimit end
        if itemConfig.overrideProjectileProperties then itemToAdd.overrideProjectileProperties = itemConfig.overrideProjectileProperties end
        if itemConfig.recoilAdd then itemToAdd.recoilAdd = itemConfig.recoilAdd end
        if itemConfig.maxRecoil then itemToAdd.maxRecoil = itemConfig.maxRecoil end
        if itemConfig.recoilDiminishFactor then itemToAdd.recoilDiminishFactor = itemConfig.recoilDiminishFactor end
        if itemConfig.recoilFastDiminishFactor then itemToAdd.recoilFastDiminishFactor = itemConfig.recoilFastDiminishFactor end
        if inventory.add then
            inventory.add(itemToAdd, false)
            if inventory.currentItemsData then
                table.insert(inventory.currentItemsData, itemToAdd)
            end
        end
        if inventory.rerender then
            inventory:rerender()
        end
    end)
end

-- ========== 原有的ESP和自瞄函数 ==========
local function GetRainbowColor(hue)
    hue = hue % 1
    local r, g, b
    local i = math.floor(hue * 6)
    local f = hue * 6 - i
    local p = 1
    local q = 1 - f
    local t = f
    if i % 6 == 0 then r, g, b = 1, t, p
    elseif i % 6 == 1 then r, g, b = q, 1, p
    elseif i % 6 == 2 then r, g, b = p, 1, t
    elseif i % 6 == 3 then r, g, b = p, q, 1
    elseif i % 6 == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end
    return Color3.new(r, g, b)
end

local function InitESP()
    ESP_ScreenGui = Instance.new("ScreenGui")
    ESP_ScreenGui.Name = "PlayerESP_System"
    ESP_ScreenGui.ResetOnSpawn = false
    ESP_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ESP_ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "PlayerESPFolder"
    ESPFolder.Parent = ESP_ScreenGui
end

local function UpdateESPColors()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
                    nameLabel.TextSize = ESPNameSize
                end
            elseif child:IsA("Highlight") then
                child.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
                child.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
            end
        end
    end)
end

local function UpdateESPNameSize()
    if not ESPEnabled or not ESPFolder then return end
    pcall(function()
        for _, child in ipairs(ESPFolder:GetChildren()) do
            if child:IsA("BillboardGui") then
                local nameLabel = child:FindFirstChild("NameLabel")
                if nameLabel then
                    nameLabel.TextSize = ESPNameSize
                end
            end
        end
    end)
end

local function CreatePlayerESP(player)
    if player == LocalPlayer or not ESPEnabled then return end
    pcall(function()
        local character = player.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        local existingESP = ESPFolder:FindFirstChild(player.Name)
        if existingESP then existingESP:Destroy() end
        local ESPGui = Instance.new("BillboardGui")
        ESPGui.Name = player.Name
        ESPGui.Adornee = humanoidRootPart
        ESPGui.Size = UDim2.new(0, 100, 0, 40)
        ESPGui.StudsOffset = Vector3.new(0, 3, 0)
        ESPGui.AlwaysOnTop = true
        ESPGui.MaxDistance = 10000
        ESPGui.Enabled = true
        ESPGui.Parent = ESPFolder
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextSize = ESPNameSize
        NameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
        NameLabel.TextStrokeTransparency = 0.5
        NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        NameLabel.Text = player.Name
        NameLabel.Parent = ESPGui
        local DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.TextSize = 12
        DistanceLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
        DistanceLabel.TextStrokeTransparency = 0.5
        DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        DistanceLabel.Name = "DistanceLabel"
        DistanceLabel.Parent = ESPGui
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name .. "_Highlight"
        Highlight.Adornee = character
        Highlight.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.FillTransparency = 0.7
        Highlight.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
        Highlight.OutlineTransparency = 0
        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.Enabled = true
        Highlight.Parent = ESPFolder
    end)
end

local function CheckBackstabThreat()
    if not BackstabCheckEnabled then return end
    if BackstabCooldown > 0 then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local myPosition = myHRP.Position
        local myCFrame = myHRP.CFrame
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if hrp and humanoid and humanoid.Health > 0 then
                    local enemyPosition = hrp.Position
                    local distance = (myPosition - enemyPosition).Magnitude
                    if distance < 30 then
                        local toEnemy = (enemyPosition - myPosition).Unit
                        local myForward = myCFrame.LookVector
                        local dotProduct = toEnemy:Dot(myForward)
                        if dotProduct < 0.5 then
                            WindUI:Notify({
                                Title = "有傻逼瞄你",
                                Content = "赶紧的回头反打" .. player.Name,
                                Icon = "alert-triangle",
                                Color = Color3.fromRGB(255, 100, 100),
                                Duration = 5
                            })
                            BackstabCooldown = BACKSTAB_COOLDOWN_TIME
                            break
                        end
                    end
                end
            end
        end
    end)
end

local function SetupDeathDetection()
    LocalPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        pcall(function()
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                if DeathCheckEnabled then
                    WindUI:Notify({
                        Title = "😡",
                        Content = "Fuck you",
                        Icon = "skull",
                        Color = Color3.fromRGB(255, 0, 0),
                        Duration = 8
                    })
                end
            end)
        end)
    end)
    if LocalPlayer.Character then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if DeathCheckEnabled then
                        WindUI:Notify({
                            Title = "😡",
                            Content = "Fuck you.",
                            Icon = "skull",
                            Color = Color3.fromRGB(255, 0, 0),
                            Duration = 8
                        })
                    end
                end)
            end
        end)
    end
end

local function UpdateESP()
    if not ESPEnabled then return end
    pcall(function()
        local myCharacter = LocalPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if not espGui then
                            CreatePlayerESP(player)
                            espGui = ESPFolder:FindFirstChild(player.Name)
                        end
                        if espGui then
                            local distance = (myHRP.Position - hrp.Position).Magnitude
                            local distanceLabel = espGui:FindFirstChild("DistanceLabel")
                            if distanceLabel then
                                distanceLabel.Text = string.format("%.0f studs", distance)
                            end
                            if distance > ESPMaxDistance then
                                espGui.Enabled = false
                                local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                if highlight then highlight.Enabled = false end
                            else
                                local teamHide = false
                                if ESPTeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                                    teamHide = true
                                end
                                if teamHide then
                                    espGui.Enabled = false
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = false end
                                else
                                    espGui.Enabled = true
                                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                                    if highlight then highlight.Enabled = true end
                                end
                            end
                        end
                    else
                        local espGui = ESPFolder:FindFirstChild(player.Name)
                        if espGui then espGui:Destroy() end
                        local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                        if highlight then highlight:Destroy() end
                    end
                else
                    local esp = ESPFolder:FindFirstChild(player.Name)
                    if esp then esp:Destroy() end
                    local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)
end

local function ToggleESP(state)
    ESPEnabled = state
    if state then
        pcall(function()
            if not ESP_ScreenGui then InitESP() end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已开启",
                Icon = "eye",
            })
        end)
    else
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            WindUI:Notify({
                Title = "透视",
                Content = "玩家透视已关闭",
                Icon = "eye",
            })
        end)
    end
end

InitESP()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if ESPEnabled then
        pcall(function()
            if ESPFolder then
                for _, esp in ipairs(ESPFolder:GetChildren()) do
                    esp:Destroy()
                end
            end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    CreatePlayerESP(player)
                end
            end
        end)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            pcall(function()
                CreatePlayerESP(player)
            end)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    pcall(function()
        if ESPFolder then
            local espGui = ESPFolder:FindFirstChild(player.Name)
            if espGui then espGui:Destroy() end
            local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
            if highlight then highlight:Destroy() end
        end
        if CurrentTarget == player then
            CurrentTarget = nil
        end
        for i, name in ipairs(AimBlacklist) do
            if name == player.Name then
                table.remove(AimBlacklist, i)
                break
            end
        end
        if blacklistInput and blacklistInput.SetValue then
            blacklistInput:SetValue(table.concat(AimBlacklist, ", "))
        end
    end)
end)

local function heartBeatLoop(deltaTime)
    pcall(function()
        UpdateESP()
        if ESPRainbowEnabled then
            CurrentESPHue = CurrentESPHue + deltaTime * ESPRainbowSpeed / 10
            UpdateESPColors()
        end
        if BackstabCooldown > 0 then
            BackstabCooldown = BackstabCooldown - deltaTime
        end
        CheckBackstabThreat()
    end)
end

RunService.Heartbeat:Connect(heartBeatLoop)

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFD700'>O</font><font color='#FFC125'>h</font><font color='#FFD700'>i</font><font color='#FFC125'>o</font> <font color='#FFD700'>辅</font><font color='#FFC125'>助</font> <font color='#FFD700'>脚</font><font color='#FFC125'>本</font>",
    Author = "<font color='#E6F3FF'>B</font><font color='#CCE5FF'>Y</font> <font color='#B3D9FF'>小</font><font color='#99CCFF'>西</font>",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(200, 395),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 135,
    ScrollBarEnabled = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/c5PCPLQ8Y10qkl83HQp0cCiSqHDcdED2FZ8eDEAG0Ce6gv9paDuTKxxIr7KJCZak_2730x1535x3967957.png",
    BackgroundImageTransparency = 0.5,
})

Window:EditOpenButton({
    Title = "<font color='#FFF8DC'>付</font><font color='#FFE4B5'>费</font><font color='#FFD700'>版</font><font color='#FFC125'>用</font><font color='#DAA520'>户</font>",
    CornerRadius = UDim.new(0,10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(
        Color3.fromHex("#FFFFFF"),
        Color3.fromHex("#000000")
    ),
    Draggable = true,
})

-- ========== 创建美化Tab ==========
local BeautyTab = Window:Tab({  
    Title = "快捷美化类",  
    Icon = "crown",  
    Locked = false,
})

local function getItemList()
    local itemList = {}
    for _, itemName in ipairs(items) do
        local displayName = itemDisplayNames[itemName] or itemName
        table.insert(itemList, displayName)
    end
    return itemList
end

BeautyTab:Toggle({
    Title = "自动购买气球",
    Default = false,
    Callback = function(state)
        if balloonBuyThread then
            balloonBuyThread:Disconnect()
            balloonBuyThread = nil
        end
        if state then
            local heartbeat = game:GetService("RunService").Heartbeat
            balloonBuyThread = heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char or balloonBuyTeleporting then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local holdingBalloon = false
                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("Tool") then
                        for _, balloonName in pairs(balloonItems) do
                            if child.Name == balloonName or child.Name:find("Balloon") or child.Name:find("Rose") then
                                holdingBalloon = true
                                break
                            end
                        end
                    end
                    if holdingBalloon then break end
                end
                
                if holdingBalloon then
                    return
                end
                
                local hasAnyBalloon = false
                for _, v in next, inv.items do
                    for _, balloonName in pairs(balloonItems) do
                        if v.name == balloonName or v.name:find("Balloon") or v.name:find("Rose") then
                            hasAnyBalloon = true
                            break
                        end
                    end
                    if hasAnyBalloon then break end
                end
                
                if not hasAnyBalloon then
                    balloonBuyTeleporting = true
                    
                    local originalCFrame = hrp.CFrame
                    
                    hrp.CFrame = CFrame.new(822.87, 26.64, -889.86)
                    task.wait(0.1)
                    
                    sig.InvokeServer("attemptPurchase", "Balloon")
                    task.wait(0.3)
                    
                    hrp.CFrame = originalCFrame
                    
                    balloonBuyTeleporting = false
                else
                    for _, v in next, inv.items do
                        for _, balloonName in pairs(balloonItems) do
                            if v.name == balloonName or v.name:find("Balloon") or v.name:find("Rose") then
                                sig.FireServer("equip", v.guid)
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
})

BeautyTab:Button({
    Title = "美化美金(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Dollar Balloon", 200, true, 0.8, 8, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.pi, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 4 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Dollar Balloon" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

BeautyTab:Button({
    Title = "美化黑玫瑰(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name, v.cost, v.unpurchasable, v.multiplier, v.movespeedAdd, v.cannotDiscard = "Black Rose", 200, true, 0.75, 12, true
                if v.TPSOffsets then v.TPSOffsets.hold = CFrame.new(0, 0.5, 0) end
                if v.viewportOffsets and v.viewportOffsets.hotbar then v.viewportOffsets.hotbar.dist = 3 end
                v.canDrop, v.dropCooldown, v.craft = nil
                break
            end
        end

        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Black Rose" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

BeautyTab:Button({
    Title = "美化Kunai(需普通气球)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Balloon" and rawget(v, "holdableType") == "Balloon" then
                v.name = "Kunai"
                v.permanent = true
                v.canDrop = true
                v.dropCooldown = 120
                v.holdableType = "Balloon"
                v.movespeedAdd = 12
                if v.TPSOffsets then
                    v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
                else
                    v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
                end
                if v.viewportOffsets then
                    if v.viewportOffsets.hotbar then
                        v.viewportOffsets.hotbar.dist = 3
                        v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
                        v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
                    else
                        v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
                    end
                    if v.viewportOffsets.ammoHUD then
                        v.viewportOffsets.ammoHUD.dist = 2
                        v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
                    else
                        v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
                    end
                    if v.viewportOffsets.slotButton then
                        v.viewportOffsets.slotButton.dist = 1
                        v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
                    else
                        v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    end
                else
                    v.viewportOffsets = {
                        hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
                        ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
                        slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    }
                end
                break
            end
        end
        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Kunai" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

BeautyTab:Button({
    Title = "美化Spirit Kunai(需普通Kunai)",
    Callback = function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "name") == "Kunai" and rawget(v, "holdableType") == "Kunai" then
                v.name = "Spirit Kunai"
                v.permanent = true
                v.canDrop = true
                v.dropCooldown = 120
                v.holdableType = "Kunai"
                v.movespeedAdd = 12
                if v.TPSOffsets then
                    v.TPSOffsets.hold = CFrame.new(0, -0.3, 0)
                else
                    v.TPSOffsets = {hold = CFrame.new(0, -0.3, 0)}
                end
                if v.viewportOffsets then
                    if v.viewportOffsets.hotbar then
                        v.viewportOffsets.hotbar.dist = 3
                        v.viewportOffsets.hotbar.offset = CFrame.new(0, 0, 0)
                        v.viewportOffsets.hotbar.rotoffset = CFrame.Angles(0, 1.5707963, 0)
                    else
                        v.viewportOffsets.hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)}
                    end
                    if v.viewportOffsets.ammoHUD then
                        v.viewportOffsets.ammoHUD.dist = 2
                        v.viewportOffsets.ammoHUD.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.ammoHUD.rotoffset = CFrame.Angles(0, -1.3744468, 0)
                    else
                        v.viewportOffsets.ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)}
                    end
                    if v.viewportOffsets.slotButton then
                        v.viewportOffsets.slotButton.dist = 1
                        v.viewportOffsets.slotButton.offset = CFrame.new(-0.1, -0.2, 0)
                        v.viewportOffsets.slotButton.rotoffset = CFrame.Angles(0, -1.5707963, 0)
                    else
                        v.viewportOffsets.slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    end
                else
                    v.viewportOffsets = {
                        hotbar = {dist = 3, offset = CFrame.new(0, 0, 0), rotoffset = CFrame.Angles(0, 1.5707963, 0)},
                        ammoHUD = {dist = 2, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.3744468, 0)},
                        slotButton = {dist = 1, offset = CFrame.new(-0.1, -0.2, 0), rotoffset = CFrame.Angles(0, -1.5707963, 0)}
                    }
                end
                break
            end
        end
        for _, item in pairs(require(game.ReplicatedStorage.devv.client.Objects.v3item.modules.inventory).items) do
            if item.name == "Spirit Kunai" then
                for _, btn in pairs({item.button, item.backpackButton}) do
                    if btn and btn.resetModelSkin then btn:resetModelSkin() end
                end
            end
        end
    end
})

-- ========== 自定义美化类Tab ==========
local CustomBeautyTab = Window:Tab({  
    Title = "自定义美化类",  
    Icon = "crown",  
    Locked = false,
})

local skinOptions = { 
    "烟火", "虚空", "纯金", "暗物质", "反物质", "神秘", "虚空神秘", "战术", "纯金战术", 
    "白未来", "黑未来", "圣诞未来", "礼物包装", "猩红", "收割者", "虚空收割者", "圣诞玩具",
    "荒地", "隐形", "像素", "钻石像素", "黄金零下", "绿水晶", "生物", "樱花", "精英", 
    "黑樱花", "彩虹激光", "蓝水晶", "紫水晶", "红水晶", "零下", "虚空射线", "冰冻钻石",
    "虚空梦魇", "金雪", "爱国者", "MM2", "声望", "酷化", "蒸汽", "海盗", "玫瑰", "黑玫瑰",
    "激光", "烟花", "诅咒背瓜", "大炮", "财富", "黄金大炮", "四叶草", "自由", "黑曜石", "赛博朋克"
}

CustomBeautyTab:Dropdown({
    Title = "选择美化皮肤",
    Values = skinOptions,
    Callback = function(Value) 
        if Value == "烟火" then
            skinsec = "Sparkler"
        elseif Value == "虚空" then
            skinsec = "Void"
        elseif Value == "纯金" then
            skinsec = "Solid Gold"
        elseif Value == "暗物质" then
            skinsec = "Dark Matter"
        elseif Value == "反物质" then
            skinsec = "Anti Matter"
        elseif Value == "神秘" then
            skinsec = "Hystic"
        elseif Value == "虚空神秘" then
            skinsec = "Void Mystic"
        elseif Value == "战术" then
            skinsec = "Tactical"
        elseif Value == "纯金战术" then
            skinsec = "Solid Gold Tactical"
        elseif Value == "白未来" then
            skinsec = "Future White"
        elseif Value == "黑未来" then
            skinsec = "Future Black"
        elseif Value == "圣诞未来" then
            skinsec = "Christmas Future"
        elseif Value == "礼物包装" then
            skinsec = "Gift Wrapped"
        elseif Value == "猩红" then
            skinsec = "Crimson Blood"
        elseif Value == "收割者" then
            skinsec = "Reaper"
        elseif Value == "虚空收割者" then
            skinsec = "Void Reaper"
        elseif Value == "圣诞玩具" then
            skinsec = "Christmas Toy"
        elseif Value == "荒地" then
            skinsec = "Wasteland"
        elseif Value == "隐形" then
            skinsec = "Invisible"
        elseif Value == "像素" then
            skinsec = "Pixel"
        elseif Value == "钻石像素" then
            skinsec = "Diamond Pixel"
        elseif Value == "黄金零下" then
            skinsec = "Frozen-Gold"
        elseif Value == "绿水晶" then
            skinsec = "Atomic Nature"
        elseif Value == "生物" then
            skinsec = "Biohazard"
        elseif Value == "樱花" then
            skinsec = "Sakura"
        elseif Value == "精英" then
            skinsec = "Elite"
        elseif Value == "黑樱花" then
            skinsec = "Death Blossom-Gold"
        elseif Value == "彩虹激光" then
            skinsec = "Rainbowlaser"
        elseif Value == "蓝水晶" then
            skinsec = "Atomic Water"
        elseif Value == "紫水晶" then
            skinsec = "Atomic Amethyst"
        elseif Value == "红水晶" then
            skinsec = "Atomic Flame"
        elseif Value == "零下" then
            skinsec = "Sub-Zero"
        elseif Value == "虚空射线" then
            skinsec = "Void-Ray"
        elseif Value == "冰冻钻石" then
            skinsec = "Frozen Diamond"
        elseif Value == "虚空梦魇" then
            skinsec = "Void Nightmare"
        elseif Value == "金雪" then
            skinsec = "Golden Snow"
        elseif Value == "爱国者" then
            skinsec = "Patriot"
        elseif Value == "MM2" then
            skinsec = "MM2 Barrett"
        elseif Value == "声望" then
            skinsec = "Prestige Barnett"
        elseif Value == "酷化" then
            skinsec = "Skin Walter"
        elseif Value == "蒸汽" then
            skinsec = "Steampunk"
        elseif Value == "海盗" then
            skinsec = "Pirate"
        elseif Value == "玫瑰" then
            skinsec = "Rose"
        elseif Value == "黑玫瑰" then
            skinsec = "Black Rose"
        elseif Value == "激光" then
            skinsec = "Hyperlaser"
        elseif Value == "烟花" then
            skinsec = "Firework"
        elseif Value == "诅咒背瓜" then
            skinsec = "Cursed Pumpkin"
        elseif Value == "大炮" then
            skinsec = "Cannon"
        elseif Value == "财富" then
            skinsec = "Firework"
        elseif Value == "黄金大炮" then
            skinsec = "Gold Cannon"
        elseif Value == "四叶草" then
            skinsec = "Lucky Clover"
        elseif Value == "自由" then
            skinsec = "Freedom"
        elseif Value == "黑曜石" then
            skinsec = "Obsidian"
        elseif Value == "赛博朋克" then
            skinsec = "Cyberpunk"
        end
    end
})

CustomBeautyTab:Toggle({
    Title = "全部枪械美化",
    Value = false,
    Callback = function(start) 
        autoskin = start
        if autoskin then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    it.skinUpdate(item.name, skinsec)
                end
            end
        end
    end
})

CustomBeautyTab:Toggle({
    Title = "背包枪械美化虚空",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Void")
                end
            end
        end
    end
})

CustomBeautyTab:Toggle({
    Title = "背包枪械美化战术",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Tactical")
                end
            end
        end
    end
})

CustomBeautyTab:Toggle({
    Title = "背包枪械美化赛博",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Cyberpunk")
                end
            end
        end
    end
})

CustomBeautyTab:Toggle({
    Title = "背包枪械美化黑曜石",
    Value = false,
    Callback = function(start) 
        skinvoid = start
        if skinvoid then
            local it = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory
            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
            for i, item in next, b1 do 
                if item.type == "Gun" then
                    table.insert(require(game:GetService("ReplicatedStorage").devv.shared.Indicies.skins.bin.Special.Void).compatabilities, item.name)
                    it.skinUpdate(item.name, "Obsidian")
                end
            end
        end
    end
})

-- ========== 物品获取Tab ==========
local ItemTab = Window:Tab({  
    Title = "物品获取",  
    Icon = "crown",  
    Locked = false,
})

ItemTab:Dropdown({
    Title = "选择物品",
    Desc = "从列表中选择要获得的物品",
    Values = getItemList(),
    Value = "",
    Callback = function(value)
        if value and value ~= "" then
            selectedItem = value
        else
            selectedItem = ""
        end
    end
})

ItemTab:Button({
    Title = "免费获得选择的物品",
    Callback = function()
        if selectedItem and selectedItem ~= "" then
            local itemName = getItemNameByDisplayName(selectedItem)
            if itemName then
                addItem(itemName)
                WindUI:Notify({
                    Title = "物品获取",
                    Content = "已获得: " .. selectedItem,
                    Icon = "gift",
                    Duration = 2
                })
            end
        end
    end
})

-- ========== 原有的自瞄和绘制功能Tab ==========
local AimTab = Window:Tab({  
    Title = "自瞄设置",  
    Icon = "crown",  
    Locked = false,
})

local function InitializeAimDrawings()
    pcall(function()
        if not FOVCircle then
            FOVCircle = Drawing.new("Circle")
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Thickness = 2
            FOVCircle.Filled = false
            FOVCircle.Radius = AimSettings.FOV
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
            table.insert(DrawingObjects, FOVCircle)
        end
    end)
end

local function UpdateFOVCircle()
    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
            FOVCircle.Radius = AimSettings.FOV
            if AimSettings.FOVRainbowEnabled then
                FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
            else
                FOVCircle.Color = AimSettings.FOVColor
            end
            FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        end
    end)
end

local function CleanupDrawings()
    pcall(function()
        for _, drawing in ipairs(DrawingObjects) do
            if drawing then
                drawing:Remove()
            end
        end
        DrawingObjects = {}
        FOVCircle = nil
    end)
end

local function IsFriend(player)
    if not AimSettings.FriendCheck then
        return false
    end
    local success, result = pcall(function()
        if LocalPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function WallCheck(targetPosition, targetCharacter)
    if not AimSettings.WallCheck then
        return true
    end
    local success, result = pcall(function()
        local camera = workspace.CurrentCamera
        local origin = camera.CFrame.Position
        local direction = (targetPosition - origin).Unit
        local distance = (targetPosition - origin).Magnitude
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.IgnoreWater = true
        raycastParams.CollisionGroup = "Default"
        local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
        return raycastResult == nil
    end)
    return success and result
end

local function GetTargetPosition(character, partName)
    if not character then return nil end
    local part
    if partName == "头" then
        part = character:FindFirstChild("Head")
    elseif partName == "上身" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("HumanoidRootPart")
    elseif partName == "左腿" then
        part = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("LeftUpperLeg")
    elseif partName == "右腿" then
        part = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("RightUpperLeg")
    elseif partName == "鸡巴" then
        part = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso")
    elseif partName == "奶子" then
        part = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    else
        part = character:FindFirstChild("Head")
    end
    return part and part.Position
end

local function GetClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = AimSettings.FOV

    if AimSettings.TargetPlayer and not AimSettings.TargetAll then
        local target = Players:FindFirstChild(AimSettings.TargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if target.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and target.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local humanoid = target.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
                            if not AimSettings.FriendCheck or not IsFriend(target) then
                                CurrentTarget = target
                                return target
                            end
                        end
                    end
                end
            end
        end
        CurrentTarget = nil
        return nil
    end

    if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            local inBlacklist = false
            for _, blackName in ipairs(AimBlacklist) do
                if CurrentTarget.Name == blackName then
                    inBlacklist = true
                    break
                end
            end
            if not inBlacklist then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and CurrentTarget.Team == myTeam then
                        CurrentTarget = nil
                        return nil
                    end
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
                        if not AimSettings.FriendCheck or not IsFriend(CurrentTarget) then
                            return CurrentTarget
                        end
                    end
                end
            end
        end
    end

    CurrentTarget = nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local skip = false
            if AimSettings.FriendCheck and IsFriend(player) then
                skip = true
            end
            if not skip then
                for _, blackName in ipairs(AimBlacklist) do
                    if player.Name == blackName then
                        skip = true
                        break
                    end
                end
            end
            if not skip then
                if AimTeamCheck then
                    local myTeam = LocalPlayer.Team
                    if myTeam and player.Team == myTeam then
                        skip = true
                    end
                end
            end
            if not skip then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoidRootPart and humanoid and humanoid.Health > 0 then
                    if WallCheck(humanoidRootPart.Position, player.Character) then
                        local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                        if onScreen then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance then
                                shortestDistance = distance
                                nearestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end
    if nearestPlayer then
        CurrentTarget = nearestPlayer
    end
    return nearestPlayer
end

local function AimBot()
    if not AimSettings.Enabled then
        return
    end
    pcall(function()
        local camera = workspace.CurrentCamera
        local target = GetClosestPlayer()
        if target and target.Character then
            local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
            local head = target.Character:FindFirstChild("Head")
            local targetPosition = GetTargetPosition(target.Character, AimTargetPart) or (head and head.Position) or (humanoidRootPart and humanoidRootPart.Position)
            if not targetPosition then return end
            if humanoidRootPart then
                local targetVelocity = humanoidRootPart.Velocity
                if AimSettings.CrosshairDistance > 0 then
                    local distance = (targetPosition - camera.CFrame.Position).Magnitude
                    local timeToTarget = distance / 1000
                    targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
                end
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
            camera.CFrame = smoothedCFrame
        end
    end)
end

local function CreateRainbowUI()
    if RainbowUIScreenGui then
        RainbowUIScreenGui:Destroy()
        RainbowUIScreenGui = nil
    end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    RainbowUIScreenGui = Instance.new("ScreenGui")
    RainbowUIScreenGui.Name = "RainbowCircleUI"
    RainbowUIScreenGui.ResetOnSpawn = false
    RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    RainbowUIScreenGui.DisplayOrder = 99999
    RainbowUIScreenGui.IgnoreGuiInset = true
    RainbowUIScreenGui.Enabled = true
    RainbowUIScreenGui.Parent = playerGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "RainbowCircle"
    mainFrame.Size = UDim2.new(0, 80, 0, 80)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundTransparency = 1
    mainFrame.ZIndex = 100000
    mainFrame.Parent = RainbowUIScreenGui
    mainFrame.Active = true
    mainFrame.Selectable = true
    mainFrame.Draggable = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = mainFrame
    local rainbowBackground = Instance.new("Frame")
    rainbowBackground.Name = "RainbowBackground"
    rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
    rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
    rainbowBackground.BackgroundTransparency = 0
    rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    rainbowBackground.ZIndex = 100001
    rainbowBackground.Parent = mainFrame
    rainbowBackground.Active = true
    rainbowBackground.Selectable = true
    local rainbowCorner = Instance.new("UICorner")
    rainbowCorner.CornerRadius = UDim.new(1, 0)
    rainbowCorner.Parent = rainbowBackground
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
    rainbowStroke.Thickness = 3
    rainbowStroke.Transparency = 0
    rainbowStroke.Parent = mainFrame
    local innerStroke = Instance.new("UIStroke")
    innerStroke.Name = "InnerStroke"
    innerStroke.Color = Color3.fromRGB(0, 0, 0)
    innerStroke.Thickness = 1
    innerStroke.Transparency = 0.3
    innerStroke.Parent = rainbowBackground
    StatusIndicator = Instance.new("Frame")
    StatusIndicator.Name = "StatusIndicator"
    StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
    StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
    StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    StatusIndicator.BackgroundTransparency = 0
    StatusIndicator.ZIndex = 100002
    StatusIndicator.Parent = mainFrame
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = StatusIndicator
    local indicatorStroke = Instance.new("UIStroke")
    indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
    indicatorStroke.Thickness = 2
    indicatorStroke.Parent = StatusIndicator
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, 0, 0, 25)
    statusText.Position = UDim2.new(0, 0, 1, 5)
    statusText.BackgroundTransparency = 1
    statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
    statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusText.TextSize = 14
    statusText.Font = Enum.Font.GothamBold
    statusText.TextStrokeTransparency = 0.3
    statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    statusText.ZIndex = 100002
    statusText.Parent = mainFrame
    local clickArea = Instance.new("TextButton")
    clickArea.Name = "ClickArea"
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.Position = UDim2.new(0, 0, 0, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 100003
    clickArea.Parent = mainFrame
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 95, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 215, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(144, 238, 144),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 200, 200),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(138, 43, 226),
        Color3.fromRGB(148, 0, 211),
        Color3.fromRGB(199, 21, 133),
        Color3.fromRGB(255, 20, 147)
    }
    local rainbowColors2 = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(148, 0, 211)
    }
    local timeOffset = 0
    local hoverAmplitude = 4
    local hoverSpeed = 4
    local pulseSpeed = 2
    local pulseAmount = 0.1
    local colorIndex = 1
    local colorIndex2 = 3
    local transitionTime = 0.8
    local transitionTime2 = 0.5
    local elapsedTime = 0
    local elapsedTime2 = 0
    local pulseScale = 1
    local isPulsingOut = true
    if animationConnection then
        animationConnection:Disconnect()
    end
    animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        pcall(function()
            if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
                animationConnection:Disconnect()
                animationConnection = nil
                return
            end
            elapsedTime = elapsedTime + deltaTime
            if elapsedTime >= transitionTime then
                elapsedTime = 0
                colorIndex = colorIndex + 1
                if colorIndex > #rainbowColors then
                    colorIndex = 1
                end
            end
            local nextColorIndex = colorIndex + 1
            if nextColorIndex > #rainbowColors then
                nextColorIndex = 1
            end
            local alpha = elapsedTime / transitionTime
            local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
            rainbowBackground.BackgroundColor3 = currentBgColor
            elapsedTime2 = elapsedTime2 + deltaTime
            if elapsedTime2 >= transitionTime2 then
                elapsedTime2 = 0
                colorIndex2 = colorIndex2 + 1
                if colorIndex2 > #rainbowColors2 then
                    colorIndex2 = 1
                end
            end
            local nextColorIndex2 = colorIndex2 + 1
            if nextColorIndex2 > #rainbowColors2 then
                nextColorIndex2 = 1
            end
            local alpha2 = elapsedTime2 / transitionTime2
            local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
            rainbowStroke.Color = currentStrokeColor
            if isPulsingOut then
                pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
                if pulseScale >= 1 + pulseAmount then
                    isPulsingOut = false
                end
            else
                pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
                if pulseScale <= 1 - pulseAmount then
                    isPulsingOut = true
                end
            end
            rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
            rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
            timeOffset = timeOffset + deltaTime * hoverSpeed
            local hoverOffset = math.sin(timeOffset) * hoverAmplitude
            mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
            innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
            if statusText then
                statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
                statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
            end
        end)
    end)
    local function handleClick()
        AimSettings.Enabled = not AimSettings.Enabled
        if AimSettings.Enabled then
            InitializeAimDrawings()
            UpdateFOVCircle()
            if AimConnection then
                AimConnection:Disconnect()
            end
            AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                pcall(function()
                    if AimSettings.FOVRainbowEnabled then
                        CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                    end
                    UpdateFOVCircle()
                    AimBot()
                end)
            end)
        else
            if AimConnection then
                AimConnection:Disconnect()
                AimConnection = nil
            end
            CleanupDrawings()
            CurrentTarget = nil
        end
        if StatusIndicator then
            StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        if statusText then
            statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
            statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
        end
        local originalSize = rainbowBackground.Size
        local originalPosition = rainbowBackground.Position
        local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
            Size = originalSize * 0.7,
            Position = UDim2.new(0.15, 0, 0.15, 0)
        })
        local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
            Size = originalSize,
            Position = originalPosition
        })
        local originalStrokeColor = rainbowStroke.Color
        local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
            Color = Color3.fromRGB(255, 255, 255)
        })
        local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
            Color = originalStrokeColor
        })
        clickScaleUp:Play()
        flashTween:Play()
        clickScaleUp.Completed:Connect(function()
            clickScaleDown:Play()
            revertStroke:Play()
        end)
    end
    clickArea.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseButton1Click:Connect(handleClick)
    mainFrame.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 6
        })
        pulseAmount = 0.15
        tween1:Play()
    end)
    mainFrame.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
            Thickness = 3
        })
        pulseAmount = 0.1
        tween1:Play()
    end)
    rainbowBackground.BackgroundTransparency = 1
    rainbowStroke.Transparency = 1
    local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
        BackgroundTransparency = 0
    })
    local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
        Transparency = 0
    })
    task.wait(0.2)
    fadeIn:Play()
    strokeFadeIn:Play()
    return true
end

local function ToggleRainbowUI(state)
    RainbowUIEnabled = state
    if state then
        local success = CreateRainbowUI()
        if success then
            WindUI:Notify({
                Title = "自瞄快捷UI",
                Content = "快捷UI 让你秒人更加高效",
                Icon = "sparkles",
            })
        end
    else
        if RainbowUIScreenGui then
            RainbowUIScreenGui:Destroy()
            RainbowUIScreenGui = nil
        end
        WindUI:Notify({
            Title = "自瞄快捷UI",
            Content = "快捷UI已隐藏",
            Icon = "sparkles",
        })
    end
end

do
    AimTab:Section({
        Title = "自瞄设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Toggle({
        Title = "启用自瞄",
        Desc = "开启/关闭自瞄功能",
        Callback = function(enabled)
            AimSettings.Enabled = enabled
            if enabled then
                InitializeAimDrawings()
                UpdateFOVCircle()
                if AimConnection then
                    AimConnection:Disconnect()
                end
                AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
                    pcall(function()
                        if AimSettings.FOVRainbowEnabled then
                            CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
                        end
                        UpdateFOVCircle()
                        AimBot()
                    end)
                end)
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已开启",
                    Icon = "crosshair",
                })
            else
                if AimConnection then
                    AimConnection:Disconnect()
                    AimConnection = nil
                end
                CleanupDrawings()
                CurrentTarget = nil
                WindUI:Notify({
                    Title = "自瞄",
                    Content = "自瞄功能已关闭",
                    Icon = "crosshair",
                })
            end
            if StatusIndicator then
                StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            end
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "自瞄快捷UI",
        Desc = "快捷UI 让你秒人更加高效",
        Callback = function(enabled)
            ToggleRainbowUI(enabled)
        end
    })
    AimTab:Toggle({
        Title = "FOV开关",
        Desc = "显示自瞄范围圆圈",
        Value = AimSettings.FOVEnabled,
        Callback = function(enabled)
            AimSettings.FOVEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Toggle({
        Title = "FOV彩虹效果",
        Desc = "开启FOV圆圈彩虹效果",
        Value = AimSettings.FOVRainbowEnabled,
        Callback = function(enabled)
            AimSettings.FOVRainbowEnabled = enabled
            UpdateFOVCircle()
        end
    })
    AimTab:Slider({
        Title = "FOV彩虹速度",
        Desc = "调整彩虹流动的速度",
        Value = {
            Min = 1,
            Max = 20,
            Default = AimSettings.FOVRainbowSpeed,
        },
        Callback = function(value)
            AimSettings.FOVRainbowSpeed = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄范围 (FOV)",
        Desc = "设置自瞄FOV大小",
        Value = {
            Min = 50,
            Max = 500,
            Default = AimSettings.FOV,
        },
        Callback = function(value)
            AimSettings.FOV = value
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "自瞄平滑度",
        Desc = "数值越小越强锁",
        Value = {
            Min = 1,
            Max = 50,
            Default = AimSettings.Smoothness,
        },
        Callback = function(value)
            AimSettings.Smoothness = value
        end
    })
    AimTab:Space()
    AimTab:Slider({
        Title = "预判距离",
        Desc = "设置预判距离(需要强锁直接调到0-3)",
        Value = {
            Min = 0,
            Max = 20,
            Default = AimSettings.CrosshairDistance,
        },
        Callback = function(value)
            AimSettings.CrosshairDistance = value
        end
    })
    AimTab:Space()
    AimTab:Colorpicker({
        Title = "FOV圆圈颜色",
        Desc = "彩虹模式关闭时生效",
        Default = AimSettings.FOVColor,
        Callback = function(color)
            AimSettings.FOVColor = color
            UpdateFOVCircle()
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "好友检测",
        Desc = "不秒好友",
        Value = AimSettings.FriendCheck,
        Callback = function(enabled)
            AimSettings.FriendCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "墙壁检测",
        Desc = "开启墙壁检测 避免自瞄乱飞",
        Value = AimSettings.WallCheck,
        Callback = function(enabled)
            AimSettings.WallCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "队伍检测",
        Desc = "不攻击同队队友",
        Value = AimTeamCheck,
        Callback = function(enabled)
            AimTeamCheck = enabled
        end
    })
    AimTab:Space()
    AimTab:Toggle({
        Title = "目标自瞄模式",
        Desc = "开启后可以选择目标进行制裁",
        Value = false,
        Callback = function(enabled)
            AimSettings.TargetAll = not enabled
            CurrentTarget = nil
        end
    })
    local playerList = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerList, player.Name)
        end
    end
    local targetDropdown = AimTab:Dropdown({
        Title = "选择目标玩家",
        Desc = "选择要自瞄的玩家",
        Values = playerList,
        Value = nil,
        AllowNone = true,
        Callback = function(selected)
            AimSettings.TargetPlayer = selected
            CurrentTarget = nil
        end
    })
    Players.PlayerAdded:Connect(function(player)
        table.insert(playerList, player.Name)
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        for i, name in ipairs(playerList) do
            if name == player.Name then
                table.remove(playerList, i)
                break
            end
        end
        if targetDropdown and targetDropdown.Refresh then
            targetDropdown:Refresh(playerList)
        end
    end)
    AimTab:Space()
    AimTab:Section({
        Title = "自瞄部位设置",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    AimTab:Dropdown({
        Title = "自瞄部位",
        Desc = "选择要瞄准的身体部位",
        Values = {"头", "上身", "左腿", "右腿", "鸡巴", "奶子"},
        Value = AimTargetPart,
        Callback = function(selected)
            AimTargetPart = selected
        end
    })
    AimTab:Space()
    AimTab:Section({
        Title = "黑名单管理",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    blacklistInput = AimTab:Input({
        Title = "自瞄黑名单",
        Desc = "输入不攻击的玩家名字，多个用逗号分隔",
        Placeholder = "例如: Player1,Player2,Player3",
        Callback = function(value)
            local names = {}
            for name in string.gmatch(value, "[^,]+") do
                name = name:match("^%s*(.-)%s*$")
                if name ~= "" then
                    table.insert(names, name)
                end
            end
            AimBlacklist = names
        end
    })
    AimTab:Button({
        Title = "添加当前目标到黑名单",
        Justify = "Center",
        Callback = function()
            if CurrentTarget and CurrentTarget.Name then
                local targetName = CurrentTarget.Name
                for _, name in ipairs(AimBlacklist) do
                    if name == targetName then
                        WindUI:Notify({
                            Title = "黑名单",
                            Content = targetName .. " 已在黑名单中",
                            Icon = "info",
                        })
                        return
                    end
                end
                table.insert(AimBlacklist, targetName)
                local newValue = table.concat(AimBlacklist, ", ")
                if blacklistInput and blacklistInput.SetValue then
                    blacklistInput:SetValue(newValue)
                else
                    WindUI:Notify({
                        Title = "黑名单",
                        Content = "已添加 " .. targetName .. "，请手动更新输入框",
                        Icon = "info",
                    })
                end
            else
                WindUI:Notify({
                    Title = "黑名单",
                    Content = "没有当前目标",
                    Icon = "alert-circle",
                })
            end
        end
    })
    AimTab:Space()
    AimTab:Button({
        Title = "清空白名单",
        Justify = "Center",
        Callback = function()
            AimBlacklist = {}
            if blacklistInput and blacklistInput.SetValue then
                blacklistInput:SetValue("")
            end
            WindUI:Notify({
                Title = "黑名单",
                Content = "黑名单已清空",
                Icon = "check",
            })
        end
    })
    AimTab:Space()
    local statusText = "自瞄状态: 未启用"
    if AimSettings.Enabled then
        statusText = "自瞄状态: 已启用 模式: " .. (AimSettings.TargetAll and "全部玩家" or "目标玩家")
    end
    AimTab:Section({
        Title = statusText,
        TextSize = 14,
        FontWeight = Enum.FontWeight.Medium,
        TextColor = AimSettings.Enabled and Green or Grey,
    })
    local QuickSettings = AimTab:Group({})
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹有延迟类]",
        Desc = "FOV99 平滑1 预判0.96",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 99
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0.96
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用近距离设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 强锁[子弹无延迟]",
        Desc = "FOV120, 平滑1 预判0",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 120
            AimSettings.Smoothness = 1
            AimSettings.CrosshairDistance = 0
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用强锁设置",
                Icon = "settings",
            })
        end
    })
    QuickSettings:Space()
    QuickSettings:Button({
        Title = "快速设置: 平滑类[]",
        Desc = "FOV130 平滑6 预判1",
        Justify = "Center",
        Callback = function()
            AimSettings.FOV = 130
            AimSettings.Smoothness = 6
            AimSettings.CrosshairDistance = 1
            UpdateFOVCircle()
            WindUI:Notify({
                Title = "快速设置",
                Content = "已使用远距离设置",
                Icon = "settings",
            })
        end
    })
end

-- ========== 绘制功能Tab ==========
local OtherTab = Window:Tab({  
    Title = "绘制功能",  
    Icon = "crown",  
    Locked = false,
})

do
    OtherTab:Section({
        Title = "ESP",
        TextSize = 16,
        FontWeight = Enum.FontWeight.SemiBold,
    })
    OtherTab:Toggle({
        Title = "玩家透视 (ESP)",
        Desc = "显示玩家描边和距离",
        Callback = function(enabled)
            ToggleESP(enabled)
        end
    })
    OtherTab:Space()
    OtherTab:Colorpicker({
        Title = "ESP玩家名字颜色",
        Desc = "设置玩家名字显示颜色",
        Default = ESPNameColor,
        Callback = function(color)
            ESPNameColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Colorpicker({
        Title = "ESP身体绘制颜色",
        Desc = "设置玩家身体颜色",
        Default = ESPBodyColor,
        Callback = function(color)
            ESPBodyColor = color
            if ESPEnabled and not ESPRainbowEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP玩家名字大小",
        Desc = "设置玩家名字的文本大小",
        Value = {
            Min = 8,
            Max = 24,
            Default = ESPNameSize,
        },
        Callback = function(value)
            ESPNameSize = value
            if ESPEnabled then
                UpdateESPNameSize()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "ESP彩虹渐变",
        Desc = "开启透视彩虹效果",
        Callback = function(enabled)
            ESPRainbowEnabled = enabled
            if ESPEnabled then
                UpdateESPColors()
            end
        end
    })
    OtherTab:Slider({
        Title = "ESP彩虹速度",
        Desc = "调整彩虹的速度",
        Value = {
            Min = 1,
            Max = 10,
            Default = ESPRainbowSpeed,
        },
        Callback = function(value)
            ESPRainbowSpeed = value
        end
    })
    OtherTab:Space()
    OtherTab:Slider({
        Title = "ESP最大显示距离",
        Desc = "设置ESP显示的最大距离（单位：studs）",
        Value = {
            Min = 50,
            Max = 10000,
            Default = ESPMaxDistance,
        },
        Callback = function(value)
            ESPMaxDistance = value
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "队伍检测",
        Desc = "开启后只显示敌方队伍",
        Value = ESPTeamCheck,
        Callback = function(enabled)
            ESPTeamCheck = enabled
            if ESPEnabled then
                UpdateESP()
            end
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "偷袭检测提醒",
        Desc = "检测背后或侧面的敌人并提醒",
        Callback = function(enabled)
            BackstabCheckEnabled = enabled
            WindUI:Notify({
                Title = "偷袭检测",
                Content = enabled and "偷袭检测已开启" or "偷袭检测已关闭",
                Icon = "shield-alert",
            })
        end
    })
    OtherTab:Toggle({
        Title = "死亡提醒",
        Desc = "玩家死亡时显示提醒消息",
        Callback = function(enabled)
            DeathCheckEnabled = enabled
            if enabled then
                SetupDeathDetection()
            end
            WindUI:Notify({
                Title = "死亡提醒",
                Content = enabled and "死亡提醒已开启" or "死亡提醒已关闭",
                Icon = "heart",
            })
        end
    })
    OtherTab:Space()
    OtherTab:Toggle({
        Title = "夜视模式",
        Desc = "开启夜间模式",
        Callback = function(enabled)
            NightVisionEnabled = enabled
            if enabled then
                originalBrightness = Lighting.Brightness
                originalAmbient = Lighting.Ambient
                Lighting.Brightness = 2
                Lighting.Ambient = Color3.fromRGB(200, 200, 200)
                Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已开启",
                    Icon = "moon",
                })
            else
                Lighting.Brightness = originalBrightness
                Lighting.Ambient = originalAmbient
                Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
                WindUI:Notify({
                    Title = "夜视模式",
                    Content = "夜视模式已关闭",
                    Icon = "moon",
                })
            end
        end
    })
end

-- ========== 辅助自瞄Tab ==========
local KillTab = Window:Tab({  
    Title = "搭配自瞄",  
    Icon = "crown",  
    Locked = false,
})        

local originalFire = nil

KillTab:Toggle({
    Title = "子弹小范围",
    Value = false,
    Callback = function(state)
        local bullet_handler = require(game:GetService("ReplicatedStorage").ModuleScripts.GunModules.BulletHandler)
        
        if state then
            if not originalFire then
                originalFire = bullet_handler.Fire
            end

            local function get_closest_target(range)
                local players = game:GetService("Players")
                local local_player = players.LocalPlayer
                local camera = workspace.CurrentCamera
                local closest_part, closest_distance = nil, range

                for _, player in ipairs(players:GetPlayers()) do
                    if player ~= local_player then
                        local character = player.Character
                        if character then
                            local humanoid = character:FindFirstChild("Humanoid")
                            local head = character:FindFirstChild("Head")
                            if head and humanoid and humanoid.Health > 0 then
                                local screen_position, on_screen = camera:WorldToViewportPoint(head.Position)
                                if on_screen then
                                    local distance = (Vector2.new(screen_position.X, screen_position.Y) - camera.ViewportSize / 2).Magnitude
                                    if distance < closest_distance then
                                        closest_part = head
                                        closest_distance = distance
                                    end
                                end
                            end
                        end
                    end
                end
                return closest_part
            end

            bullet_handler.Fire = function(data)
                local closest = get_closest_target(999)
                if closest then
                    data.Force = data.Force * 1000
                    data.Direction = (closest.Position - data.Origin).Unit
                end
                return originalFire(data)
            end
        else
            if originalFire then
                bullet_handler.Fire = originalFire
            end
        end
    end
})

local autoLobbyEnabled = false
local autoLobbyThread = nil

print("辅助脚本已开启")