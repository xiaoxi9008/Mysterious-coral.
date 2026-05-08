--其他功能by小西制作开出来敢二改给你马全杀了除了YG
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

local Env = getfenv()

local LogService = game:GetService("LogService")
local getconnections = Env.getconnections
local MessageOut = "MessageOut"
local cons = getconnections(LogService[MessageOut])
if cons then
    for _, v in pairs(cons) do
        pcall(function() v:Disable() end)
    end
end

local function cleanupConnections()
    pcall(function()
        
        for _, conn in ipairs(getconnections(LogService.MessageOut) or {}) do
            pcall(function() conn:Disable() end)
        end
    end)
end
cleanupConnections()

print("✅ 环境净化完成，LogService 干扰已禁用")

-- 放最上面
local function searchPlayers(username)
    local url = "https://users.roblox.com/v1/users/search?keyword=" .. username .. "&limit=10"
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success and result then
        local data = game:GetService("HttpService"):JSONDecode(result)
        if data.data and #data.data > 0 then
            return data.data
        end
    end
    return {}
end

local function getUserInfo(userId)
    local url = "https://users.roblox.com/v1/users/" .. tostring(userId)
    local success, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if success and result then
        return game:GetService("HttpService"):JSONDecode(result)
    end
    return nil
end

local function spoofPlayer(userId, username, displayName)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    task.spawn(function()
        LocalPlayer.Name = username
        LocalPlayer.DisplayName = displayName or username
        LocalPlayer.UserId = userId
        LocalPlayer.CharacterAppearanceId = userId

        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait()
        end
        task.wait(0.5)
        
        local char = LocalPlayer.Character
        local ok, appearance = pcall(function()
            return Players:GetCharacterAppearanceAsync(userId)
        end)
        
        if ok and appearance then
            for _, v in pairs(char:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
                    v:Destroy()
                end
            end
            for _, v in pairs(appearance:GetChildren()) do
                if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("BodyColors") then
                    v.Parent = char
                elseif v:IsA("Accessory") then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum:AddAccessory(v) end
                end
            end
            local head = char:FindFirstChild("Head")
            if head then
                local face = head:FindFirstChild("face")
                if face then face:Destroy() end
                if appearance:FindFirstChild("face") then
                    appearance.face.Parent = head
                end
            end
            local parent = char.Parent
            char.Parent = nil
            char.Parent = parent
        end
    end)
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/hxjxnx/refs/heads/main/OhioUI.lua"))()
local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    Icon = "monitor",
    Author = "by 小西",
    Folder = "HackerHub",
    Size = UDim2.fromOffset(150, 400),
    Transparent = true,
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Transparent = true,
    Background = "https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/1777784268833.jpeg",
    User = {
        Enabled = true,
        Callback = function()
            WindUI:Notify({
                Title = "点击了自己",
                Content = "没什么",
                Duration = 1,
                Icon = "4483362748"
            })
        end,
        Anonymous = false
    },
})

AddSnowEffect(Window.UIElements.Main.Background, 30, 14, 0.5)

Window:Tag({Title = "付费版", Radius = 4, Color = Color3.fromHex("#ffffff")})
Window:Tag({Title = "Ohio", Radius = 4, Color = Color3.fromHex("#ffffff")})

WindUI.Themes.Dark.Button = Color3.fromRGB(255, 255, 255)
WindUI.Themes.Dark.ButtonBorder = Color3.fromRGB(255, 255, 255)

local function addButtonBorderStyle()
    local mainFrame = Window.UIElements.Main
    if not mainFrame then return end

    local styleSheet = Instance.new("StyleSheet")
    styleSheet.Parent = mainFrame

    local rule = Instance.new("StyleRule")
    rule.Selector = "Button, ImageButton, TextButton"
    rule.Parent = styleSheet

    local borderProp = Instance.new("StyleProperty")
    borderProp.Name = "BorderSizePixel"
    borderProp.Value = 1
    borderProp.Parent = rule

    local colorProp = Instance.new("StyleProperty")
    colorProp.Name = "BorderColor3"
    colorProp.Value = Color3.fromRGB(255, 255, 255)
    colorProp.Parent = rule
end

Window:CreateTopbarButton("theme-switcher", "moon", function()
    local themes_list = {"Dark", "Light", "Mocha", "Aqua"}
    currentThemeIndex = (currentThemeIndex % #themes_list) + 1
    local newTheme = themes_list[currentThemeIndex]
    WindUI:SetTheme(newTheme)
    WindUI:Notify({
        Title = "主题已切换",
        Content = "当前主题: " .. newTheme,
        Duration = 2
    })
end, 990)

WindUI.Themes.Dark.Toggle = Color3.fromHex("FF69B4")
WindUI.Themes.Dark.Checkbox = Color3.fromHex("FFB6C1")
WindUI.Themes.Dark.Button = Color3.fromHex("FF1493")
WindUI.Themes.Dark.Slider = Color3.fromHex("FF69B4")

-- ===== 黑白流动渐变色方案 =====
local COLOR_SCHEMES = {
    ["黑白流动"] = {
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),   -- 纯黑
            ColorSequenceKeypoint.new(0.2, Color3.fromHex("1A1A1A")), -- 深黑
            ColorSequenceKeypoint.new(0.4, Color3.fromHex("808080")), -- 灰色
            ColorSequenceKeypoint.new(0.6, Color3.fromHex("F0F0F0")), -- 亮灰
            ColorSequenceKeypoint.new(0.8, Color3.fromHex("FFFFFF")), -- 纯白
            ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))    -- 回到纯黑
        }),
        "waves"
    },
}

local function createRainbowBorder(window, colorScheme, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        existingStroke:Destroy()
    end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2.5  -- 稍微加粗让黑白更明显
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"

    local schemeData = COLOR_SCHEMES[colorScheme or "黑白流动"]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["黑白流动"][1]
    end

    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.UIElements.Main
    if not mainFrame then return nil end

    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end

    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end

    local animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then
            animation:Disconnect()
            return
        end

        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)

    return animation
end

local borderAnimation
local borderEnabled = true
local currentColor = "黑白流动"
local animationSpeed = 3  -- 流动速度，越小越慢

local rainbowStroke = createRainbowBorder(Window, currentColor, animationSpeed)
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

function Tab(a)
    return Window:Tab({ Title = a, Icon = "eye" })
end

function Button(a, b, c)
    return a:Button({ Title = b, Callback = c })
end

function Toggle(a, b, c, d)
    return a:Toggle({ Title = b, Value = c, Callback = d })
end

function Slider(a, b, c, d, e, f)
    return a:Slider({ Title = b, Step = 1, Value = { Min = c, Max = d, Default = e }, Callback = f })
end

function Dropdown(a, b, c, d, e)
    return a:Dropdown({ Title = b, Values = c, Value = d, Callback = e })
end

function Input(a, b, c, d, e, f)
    return a:Input({
        Title = b,
        Desc = c or "",
        Value = d or "",
        Placeholder = e or "",
        Callback = f
    })
end

Window:EditOpenButton({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>H</font><font color='#444444'>U</font><font color='#222222'>B</font><font color='#FFAEC4'></font>",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2.35,
    Color = ColorSequence.new(
        Color3.fromHex("000000"),  -- 黑
        Color3.fromHex("FFFFFF")   -- 白
    ),
    Draggable = true,
})

local Tabs = {}

do
    Tabs.BladeSection = Window:Section({
        Title = "杀戮类",
        Opened = true,
    })

    Tabs.qiangSection = Window:Section({
        Title = "枪械类",
        Opened = true,
    })
    
    Tabs.MoneySection = Window:Section({
        Title = "主要类",
        Opened = true,
    })
    
    Tabs.ProSection = Window:Section({
        Title = "防护类",
        Opened = true,
    })
    
    Tabs.ConfigSection = Window:Section({
        Title = "次要类",
        Opened = true,
    })
    
    Tabs.ACSection = Window:Section({
        Title = "活动类",
        Opened = true,
    })
    Tabs.MusicSection = Window:Section({
         Title = "音乐类",
         Opened = true,
    })
    Tabs.genSection = Window:Section({
         Title = "服务器",
         Opened = true,
    })

    Tabs.BladeTab = Tabs.BladeSection:Tab({ Title = "杀戮光环", Icon = "crown" })
    Tabs.ESPTab = Tabs.BladeSection:Tab({ Title = "杀戮光环", Icon = "crown" })
    Tabs.MoneyTab = Tabs.MoneySection:Tab({ Title = "刷钱类", Icon = "crown" })
    Tabs.BypassTab = Tabs.MoneySection:Tab({ Title = "绕过类", Icon = "crown" })
    Tabs.ProTab = Tabs.ProSection:Tab({ Title = "防护类", Icon = "crown" })
    Tabs.ziaoxiTab = Tabs.qiangSection:Tab({ Title = "枪械设置", Icon = "crown" })
    Tabs.PlayerTab = Tabs.ConfigSection:Tab({ Title = "通用类", Icon = "crown" })
    Tabs.MMMTab = Tabs.ConfigSection:Tab({ Title = "快捷美化类", Icon = "crown" })
    Tabs.MHTab = Tabs.ConfigSection:Tab({ Title = "自定义美化类", Icon = "crown" })
    Tabs.ACTab = Tabs.ACSection:Tab({ Title = "复活节活动", Icon = "crown" })
    Tabs.MusicTab = Tabs.MusicSection:Tab({ Title = "音乐", Icon = "music" })
    Tabs.zhuyaoTab = Tabs.genSection:Tab({ Title = "服务器", Icon = "music" })
    Tabs.weiTab = Tabs.genSection:Tab({ Title = "伪装欺骗", Icon = "music" })
    Tabs.ggiTab = Tabs.genSection:Tab({ Title = "获得飞镖教程", Icon = "music" })
end

Window:SelectTab(1)

_G.HealthThreshold = 0
_G.BladeAuraEnabled = false

local AutoArmor = false
local autokz = false
local healThread = nil
local AutoKnockReset = false
local antiKBEnabled = false
local sudu = nil
local Speed = 1
local jumpConn = nil
local skinvoid = false
local autoskin = false
local skinsec = ""

local PlayerList = {}
local function UpdatePlayerList()
    PlayerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList, player.Name)
        end
    end
end
UpdatePlayerList()
Players.PlayerAdded:Connect(function() UpdatePlayerList() end)
Players.PlayerRemoving:Connect(function() UpdatePlayerList() end)

local TargetPlayer = ""
local TeleportToPlayer = false
local LoopTeleportAll = false
local TeleportBehind = false
local teleportSpeed = 0.3  

local function TeleportToTargetPlayer()
    local character = LocalPlayer.Character
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    if TargetPlayer ~= "" then
        local target = Players:FindFirstChild(TargetPlayer)
        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
               
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                end
                
                if TeleportBehind then
                    
                    local behindPos = targetHRP.Position - targetHRP.CFrame.LookVector * 2.5
                    rootPart.CFrame = CFrame.new(behindPos, targetHRP.Position)
                else
                    
                    rootPart.CFrame = targetHRP.CFrame
                end
                return true
            end
        end
    end
    return false
end

local teleportAllConnection = nil
local function StartLoopTeleportAll()
    if teleportAllConnection then
        teleportAllConnection:Disconnect()
        teleportAllConnection = nil
    end
    
    teleportAllConnection = RunService.Heartbeat:Connect(function()
        if not LoopTeleportAll then
            if teleportAllConnection then
                teleportAllConnection:Disconnect()
                teleportAllConnection = nil
            end
            return
        end
        
        local character = LocalPlayer.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local closestPlayer = nil
        local closestDist = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    local dist = (rootPart.Position - targetHRP.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
        
        
        if closestPlayer and closestPlayer.Character then
            local targetHRP = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                end
                
                if TeleportBehind then
                    local behindPos = targetHRP.Position - targetHRP.CFrame.LookVector * 2.5
                    rootPart.CFrame = CFrame.new(behindPos, targetHRP.Position)
                else
                    rootPart.CFrame = targetHRP.CFrame
                end
                
                 WindUI:Notify({
                     Title = "传送",
                     Content = "已传送到 " .. closestPlayer.Name,
                     Duration = 0.5,
                     Icon = "zap"
                 })
            end
        end
    end)
end

local teleportSingleConnection = nil
local function StartLoopTeleportSingle()
    if teleportSingleConnection then
        teleportSingleConnection:Disconnect()
        teleportSingleConnection = nil
    end
    
    teleportSingleConnection = RunService.Heartbeat:Connect(function()
        if not TeleportToPlayer then
            if teleportSingleConnection then
                teleportSingleConnection:Disconnect()
                teleportSingleConnection = nil
            end
            return
        end
        
        if TargetPlayer == "" then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local target = Players:FindFirstChild(TargetPlayer)
        if target and target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                end
                
                if TeleportBehind then
                    local behindPos = targetHRP.Position - targetHRP.CFrame.LookVector * 2.5
                    rootPart.CFrame = CFrame.new(behindPos, targetHRP.Position)
                else
                    rootPart.CFrame = targetHRP.CFrame
                end
            end
        end
    end)
end

Tabs.BladeTab:Paragraph({
    Title = "使用须知",
    Desc = "飞镖和战斧获得请看最后一个选项卡",
    Image = "sword",
    ImageSize = 42,
})

Tabs.BladeTab:Paragraph({
    Title = "关于作者",
    Desc = "作者：by小西  QQ群：705378396",
    Image = "sword",
    ImageSize = 42,
})

local plrs = game:GetService("Players")
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local lp = plrs.LocalPlayer

local dvv = require(rs.devv)
local sig = dvv.load("Signal")
local guid = dvv.load("GUID")
local inv = dvv.load("v3item").inventory

local dartOn = false
local dartTeleportTargets = false
local dartCachedHitId = nil
local dartCurrentTarget = nil
local dartHeartConnections = {}
local dartNinjaStarBuyThread = nil

getgenv().TrailColors = {
    StartColor = Color3.fromRGB(200, 180, 255),
    EndColor = Color3.fromRGB(140, 100, 220),
    MiddleColor1 = Color3.fromRGB(180, 150, 240),
    MiddleColor2 = Color3.fromRGB(160, 130, 230)
}

local function createBeautifulTrail(origin, targetPos)
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "MagicTrail"
    trailContainer.Parent = Workspace
    
    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)
    
    local function createBezierCurve(p0, p1, p2, t)
        return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
    end
    
    local curvePoints = {}
    local numSegments = 20
    
    for i = 0, numSegments do
        local t = i / numSegments
        local point = createBezierCurve(origin, controlPoint, targetPos, t)
        table.insert(curvePoints, point)
    end
    
    for i = 1, #curvePoints - 1 do
        local startPoint = curvePoints[i]
        local endPoint = curvePoints[i + 1]
        local distance = (endPoint - startPoint).Magnitude
        
        local beamPart = Instance.new("Part")
        beamPart.Size = Vector3.new(0.15, 0.15, distance)
        beamPart.Anchored = true
        beamPart.CanCollide = false
        beamPart.Material = Enum.Material.Neon
        beamPart.Transparency = 0.3
        beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
        beamPart.Parent = trailContainer
        
        local t = i / (#curvePoints - 1)
        local color
        if t < 0.3 then
            color = getgenv().TrailColors.StartColor or Color3.fromRGB(200, 180, 255)
        elseif t < 0.6 then
            color = getgenv().TrailColors.MiddleColor1 or Color3.fromRGB(180, 150, 240)
        elseif t < 0.9 then
            color = getgenv().TrailColors.MiddleColor2 or Color3.fromRGB(160, 130, 230)
        else
            color = getgenv().TrailColors.EndColor or Color3.fromRGB(140, 100, 220)
        end
        
        beamPart.Color = color
        
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 5
        pointLight.Range = 3
        pointLight.Color = color
        pointLight.Parent = beamPart
        
        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Transparency = NumberSequence.new(0.3, 0.8)
        particles.Lifetime = NumberRange.new(0.5, 1)
        particles.Rate = 50
        particles.Speed = NumberRange.new(1, 2)
        particles.VelocitySpread = 180
        particles.Color = ColorSequence.new(color)
        particles.Parent = beamPart
    end
    
    task.delay(1.5, function()
        if trailContainer and trailContainer.Parent then
            trailContainer:Destroy()
        end
    end)
    
    return trailContainer
end

local function dartCleanupConnections()
    for _, conn in ipairs(dartHeartConnections) do
        if conn then conn:Disconnect() end
    end
    dartHeartConnections = {}
end

local function dartEquipNinjaStar()
    local itm = inv.getItems and inv.getItems() or inv.items or {}
    for _, v in next, itm do
        if v.name == "Ninja Star" then
            sig.FireServer("equip", v.guid)
            return v.guid
        end
    end
    return nil
end

local function dartInitThrow()
    local sg = dartEquipNinjaStar()
    if not sg then return end
    
    local c = lp.Character
    if not c then return end
    
    local rh = c:FindFirstChild("RightHand")
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not rh or not hrp then return end
    
    local mp = rh.Position + Vector3.new(0, 0.5, 0)
    local tp = mp + Vector3.new(50, 0, 0)
    local vel = (tp - mp).Unit * 150
    
    createBeautifulTrail(mp, tp)
    
    local ok, r1, hid = pcall(function()
        return sig.InvokeServer("throwSticky", guid(), "Ninja Star", sg, vel, tp)
    end)
    
    if ok and r1 and hid then
        dartCachedHitId = hid
    end
end

local function dartHasShield(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local char = targetPlayer.Character
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    for _, desc in pairs(char:GetDescendants()) do
        if desc:IsA("ForceField") then
            return true
        end
    end
    
    return false
end

local function dartFindValidTarget()
    local closest = nil
    local minDist = math.huge
    local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
    
    if not myPos then return nil end
    
    for _, player in ipairs(plrs:GetPlayers()) do
        if player ~= lp and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if humanoid and head and hrp and humanoid.Health > 0 and not dartHasShield(player) then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < minDist and dist <= 50 then
                    minDist = dist
                    closest = {player = player, head = head}
                end
            end
        end
    end
    return closest
end

local function dartRapidThrowAttack()
    if not dartOn or not dartCachedHitId then return end
    
    local targetData = dartFindValidTarget()
    if not targetData then return end
    
    local head = targetData.head 
    local tp = head.Position
    local wcf = CFrame.new(tp, tp + Vector3.new(0, 1, 0))
    local rcf = CFrame.new(0, 0, 0)
    
    local c = lp.Character
    if c and c:FindFirstChild("RightHand") then
        local rh = c:FindFirstChild("RightHand")
        createBeautifulTrail(rh.Position, tp)
    end
    
    for i = 1, 15 do 
        sig.InvokeServer("hitSticky", dartCachedHitId, head, rcf, wcf)
    end
end

local function dartFindNextTeleportTarget()
    local players = plrs:GetPlayers()
    
    for _, player in ipairs(players) do
        if player ~= lp and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 and not dartHasShield(player) then
                return player
            end
        end
    end
    return nil
end

local function dartFastTeleport()
    if not dartTeleportTargets or not dartOn then return end
    
    if not dartCurrentTarget then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    if not dartCurrentTarget.Character then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    local humanoid = dartCurrentTarget.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 or dartHasShield(dartCurrentTarget) then
        dartCurrentTarget = dartFindNextTeleportTarget()
        if not dartCurrentTarget then return end
    end
    
    local char = lp.Character
    if not char or not char.PrimaryPart then return end
    
    local targetChar = dartCurrentTarget.Character
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end
    
    char.PrimaryPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
end

Tabs.BladeTab:Paragraph({
    Title = "一 传送功能 一",
    Desc = "选择玩家并开启传送（循环传送会自动传送到最近的玩家）",
    Image = "zap",
    ImageSize = 32,
})

Tabs.BladeTab:Dropdown({
    Title = "选择玩家用户名",
    Values = PlayerList,
    Value = "",
    Callback = function(name)
        TargetPlayer = name
        WindUI:Notify({
            Title = "已选择",
            Content = "目标玩家: " .. name,
            Duration = 1,
            Icon = "user"
        })
    end
})

Tabs.BladeTab:Button({
    Title = "刷新玩家列表",
    Callback = function()
        UpdatePlayerList()
        WindUI:Notify({
            Title = "刷新完成",
            Content = "当前在线玩家: " .. #PlayerList .. "人",
            Duration = 1,
            Icon = "refresh"
        })
    end
})

local teleportMode = "身边"
Tabs.BladeTab:Dropdown({
    Title = "传送模式",
    Values = {"身边", "后面"},
    Value = "身边",
    Callback = function(mode)
        teleportMode = mode
        TeleportBehind = (mode == "后面")
    end
})

Tabs.BladeTab:Toggle({
    Title = "循环锁定传送至该玩家",
    Value = false,
    Callback = function(state)
        TeleportToPlayer = state
        if state then
            if TargetPlayer == "" then
                WindUI:Notify({
                    Title = "提示",
                    Content = "请先选择一个玩家",
                    Duration = 2,
                    Icon = "alert"
                })
                TeleportToPlayer = false
                return
            end
            StartLoopTeleportSingle()
            WindUI:Notify({
                Title = "已开启",
                Content = "正在循环传送到 " .. TargetPlayer,
                Duration = 1,
                Icon = "zap"
            })
        else
            if teleportSingleConnection then
                teleportSingleConnection:Disconnect()
                teleportSingleConnection = nil
            end
            WindUI:Notify({
                Title = "已关闭",
                Content = "停止循环传送",
                Duration = 1,
                Icon = "x"
            })
        end
    end
})

Tabs.BladeTab:Toggle({
    Title = "循环传送到所有人身边",
    Value = false,
    Callback = function(state)
        LoopTeleportAll = state
        if state then
            StartLoopTeleportAll()
            WindUI:Notify({
                Title = "已开启",
                Content = "正在循环传送到最近的玩家" .. (TeleportBehind and "后面" or "身边"),
                Duration = 1,
                Icon = "zap"
            })
        else
            if teleportAllConnection then
                teleportAllConnection:Disconnect()
                teleportAllConnection = nil
            end
            WindUI:Notify({
                Title = "已关闭",
                Content = "停止循环传送",
                Duration = 1,
                Icon = "x"
            })
        end
    end
})

Tabs.BladeTab:Button({
    Title = "单次传送(到选中玩家)",
    Callback = function()
        if TargetPlayer == "" then
            WindUI:Notify({
                Title = "提示",
                Content = "请先选择一个玩家",
                Duration = 2,
                Icon = "alert"
            })
            return
        end
        local success = TeleportToTargetPlayer()
        if success then
            WindUI:Notify({
                Title = "传送完成",
                Content = "已传送到 " .. TargetPlayer .. (TeleportBehind and " 后面" or " 身边"),
                Duration = 1,
                Icon = "zap"
            })
        else
            WindUI:Notify({
                Title = "传送失败",
                Content = "目标玩家不存在或无法传送",
                Duration = 1,
                Icon = "alert"
            })
        end
    end
})

Tabs.BladeTab:Paragraph({
    Title = "一 暴力功能 一",
    Desc = "需要有飞镖香蕉战斧只要有以下物品就能用以下功能",
    Image = "zap",
    ImageSize = 32,
})

Tabs.BladeTab:Toggle({
    Title = "透视",
Value = false,
Callback = function(enableESP)
if enableESP then
local function ApplyESP(v)
if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
v.Character.Humanoid.NameDisplayDistance = 9e9
v.Character.Humanoid.NameOcclusion = "NoOcclusion"
v.Character.Humanoid.HealthDisplayDistance = 9e9
v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
v.Character.Humanoid.Health = v.Character.Humanoid.Health
end
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
for i, v in pairs(Players:GetPlayers()) do
ApplyESP(v)
v.CharacterAdded:Connect(function()
task.wait(0.33)
ApplyESP(v)
end)
end
Players.PlayerAdded:Connect(function(v)
ApplyESP(v)
v.CharacterAdded:Connect(function()
task.wait(0.33)
ApplyESP(v)
end)
end)
local espConnection = RunService.Heartbeat:Connect(function()
for i, v in pairs(Players:GetPlayers()) do
if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
v.Character.Humanoid.NameDisplayDistance = 9e9
v.Character.Humanoid.NameOcclusion = "NoOcclusion"
v.Character.Humanoid.HealthDisplayDistance = 9e9
v.Character.Humanoid.HealthDisplayType = "AlwaysOn"
end
end
end)
_G.ESPConnection = espConnection
else
if _G.ESPConnection then
_G.ESPConnection:Disconnect()
_G.ESPConnection = nil
end
local Players = game:GetService("Players")
for i, v in pairs(Players:GetPlayers()) do
if v.Character and v.Character:FindFirstChildOfClass'Humanoid' then
v.Character.Humanoid.NameDisplayDistance = 100
v.Character.Humanoid.NameOcclusion = "OccludeAll"
v.Character.Humanoid.HealthDisplayDistance = 100
v.Character.Humanoid.HealthDisplayType = "DisplayWhenDamaged"
end
end
end
end
})

Tabs.BladeTab:Toggle({
    Title = "踩踏光环",
Value = false,
Callback = function(state)
autostomp = state
end
})
   
Tabs.BladeTab:Toggle({
    Title = "忍者飞镖光环",
    Default = false,
    Callback = function(state)
        dartOn = state
        dartCleanupConnections()
        
        if state then
            dartEquipNinjaStar()
            task.wait(0.1)
            dartInitThrow()
            
            local fastAttackConn = runService.RenderStepped:Connect(function()
                if not dartOn then return end
                dartRapidThrowAttack()
            end)
            table.insert(dartHeartConnections, fastAttackConn)
        end
    end
})

Tabs.BladeTab:Toggle({
    Title = "传送攻击(需打开忍者飞镖光环)",
    Default = false,
    Callback = function(state)
        dartTeleportTargets = state
        
        if state and dartOn then
            local fastTeleportConn = runService.RenderStepped:Connect(function()
                dartFastTeleport()
            end)
            table.insert(dartHeartConnections, fastTeleportConn)
            
            WindUI:Notify({
                Title = "TPattack",
                Content = "open",
                Duration = 2,
                Icon = "zap"
            })
        elseif state then
            local checkConnection
            checkConnection = runService.Heartbeat:Connect(function()
                if dartOn then
                    checkConnection:Disconnect()
                    local fastTeleportConn = runService.RenderStepped:Connect(function()
                        dartFastTeleport()
                    end)
                    table.insert(dartHeartConnections, fastTeleportConn)
                elseif not dartTeleportTargets then
                    checkConnection:Disconnect()
                end
            end)
        end
    end
})

Tabs.BladeTab:Toggle({
    Title = "自动购买忍者飞镖",
    Default = false,
    Callback = function(state)
        if dartNinjaStarBuyThread then
            dartNinjaStarBuyThread:Disconnect()
            dartNinjaStarBuyThread = nil
        end
        if state then
            local heartbeat = game:GetService("RunService").Heartbeat
            dartNinjaStarBuyThread = heartbeat:Connect(function()
                sig.InvokeServer("attemptPurchase", "Ninja Star")
                for _, v in next, inv.items do
                    if v.name == "Ninja Star" then
                        break
                    end
                end
            end)
        end
    end
})

local originalOnDestroy = Window.OnDestroy or function() end
Window.OnDestroy = function(...)
    originalOnDestroy(...)
    dartCleanupConnections()
    if dartNinjaStarBuyThread then
        dartNinjaStarBuyThread:Disconnect()
        dartNinjaStarBuyThread = nil
    end
end

Tabs.BladeTab:Toggle({
    Title = "香蕉光环",
    Default = false,
    Callback = function(state)
        _G.AuraEnabled = state
        if not state then _G.TargetId = nil end
    end
})

Tabs.BladeTab:Toggle({
    Title = "战斧光环",
    Default = false,
    Callback = function(state)
        _G.BladeAuraEnabled = state
    end
})

Tabs.BladeTab:Slider({
    Title = "不攻击生命值",
    Value = {
        Min = 0,
        Max = 25,
        Default = 0,
    },
    Callback = function(value)
        _G.HealthThreshold = value
    end
})

local devv = ReplicatedStorage:WaitForChild("devv")
local load = require(devv).load
local FireServer = load("Signal").FireServer
local InvokeServer = load("Signal").InvokeServer
local GUID = load("GUID")
local Raycast = load("Raycast")
local v3item = load("v3item")
local inventory = v3item.inventory

_G.TargetId = nil
local lastAttack = 0
local lastAmmo = 0

local function getTarget()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local target, dist = nil, 150
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local tHum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health >= _G.HealthThreshold then
                local d = (root.Position - tRoot.Position).Magnitude
                if d < dist then
                    dist = d
                    target = plr
                end
            end
        end
    end
    return target
end

local function hackthrow(plr, itemname, itemguid, velocity, epos)
    if plr ~= LocalPlayer then
        return
    end
    task.spawn(function()
        local throwGuid = GUID()
        local char = plr.Character
        if char and char:FindFirstChild("RightHand") then
            local hand = char:FindFirstChild("RightHand")
            createBeautifulTrail(hand.Position, epos)
        end
        
        local success, stickyId = InvokeServer("throwSticky", throwGuid, itemname, itemguid, velocity, epos)
        if not success then
            return
        end
        local dummyPart = Instance.new("Part")
        dummyPart.Size = Vector3.new(2, 2, 2)
        dummyPart.Position = epos
        dummyPart.Anchored = true
        dummyPart.Transparency = 1
        dummyPart.CanCollide = true
        dummyPart.Parent = workspace
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = { plr.Character, workspace.Game.Local, workspace.Game.Drones }
        local dist = (epos - plr.Character.Head.Position).Magnitude
        local rayResult = workspace:Raycast(
            plr.Character.Head.Position,
            (epos - plr.Character.Head.Position).Unit * (dist + 5),
            rayParams
        )
        if rayResult and rayResult.Instance then
            local hitPart = rayResult.Instance
            local relativeHitCFrame = hitPart.CFrame:ToObjectSpace(CFrame.new(rayResult.Position, rayResult.Position + rayResult.Normal))
            local stickyCFrame = CFrame.new(rayResult.Position)
            if dummyPart.Parent then
                dummyPart:Destroy()
            end
            _G.throwargs = {
                "hitSticky",
                stickyId or throwGuid,
                hitPart,
                relativeHitCFrame,
                stickyCFrame,
            }
            InvokeServer("hitSticky", stickyId or throwGuid, hitPart, relativeHitCFrame, stickyCFrame)
        else
            if dummyPart.Parent then
                dummyPart:Destroy()
            end
        end
    end)
end

local function getinventory()
    return inventory.items
end

local function finditem(string)
    for guid, data in next, getinventory() do
        if data.name == string or data.type == string or data.subtype == string then
            return data
        end
    end
end

local function executebladekill(plr, head)
    local item = finditem("Tomahawk")
    if item then
        FireServer("equip", item.guid)

        if not _G.throwargs then
            local char = LocalPlayer.Character
            if not char then return end
            local hand = char:FindFirstChild("RightHand")
            if not hand then return end
            
            local spos = hand.Position
            local epos = head.Position
            local velocity = (epos - spos).Unit * ((spos - epos).Magnitude * 15)
            createBeautifulTrail(spos, epos)
            task.spawn(InvokeServer, "attemptPurchaseAmmo", "Tomahawk")
            hackthrow(LocalPlayer, "Tomahawk", item.guid, velocity, epos)
        end

        if _G.throwargs then
            _G.throwargs[3] = head
            task.spawn(InvokeServer, unpack(_G.throwargs))
        end
    else
        task.spawn(InvokeServer, "attemptPurchase", "Tomahawk")
    end
end

local function attack(plr)
    local now = tick()
    if now - lastAttack < 0.03 then return end
    lastAttack = now

    local tChar = plr.Character
    local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
    if not tRoot or not tHum or tHum.Health < 15 then return end

    task.spawn(function()
        local items = inventory.items or {}
        local banana = nil
        for _, v in next, items do
            if v.name == "Banana Peel" then
                banana = v
                break
            end
        end

        if not banana then
            pcall(function() InvokeServer("attemptPurchase", "Banana Peel") end)
            return
        end

        FireServer("equip", banana.guid)

        local pred = tRoot.AssemblyLinearVelocity * 0.2
        local cf = tRoot.CFrame * CFrame.new(0, -1, 0) + pred
        local rcf = tRoot.CFrame:ToObjectSpace(cf)

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("RightHand") then
            local hand = char:FindFirstChild("RightHand")
            createBeautifulTrail(hand.Position, cf.Position)
        end

        if not _G.TargetId then
            local ok, _, id = pcall(function()
                return InvokeServer("throwSticky", GUID(), "Banana Peel", banana.guid, Vector3.new(0, 100, 0), cf.Position)
            end)
            if ok and id then _G.TargetId = id end
        end

        if _G.TargetId then
            pcall(function()
                InvokeServer("hitSticky", _G.TargetId, tRoot, rcf, cf)
            end)
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if _G.AuraEnabled then
        local target = getTarget()
        if target then
            attack(target)
        end
        
        if tick() - lastAmmo > 0.5 then
            lastAmmo = tick()
            task.spawn(function()
                pcall(function() InvokeServer("attemptPurchaseAmmo", "Banana Peel") end)
            end)
        end
    end
    
    if _G.BladeAuraEnabled and HumanoidRootPart then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local head = char and char:FindFirstChild("Head")
                if head then
                    local dist = (HumanoidRootPart.Position - head.Position).Magnitude
                    if hum and hum.Health > 0 and dist < 190 then
                        executebladekill(plr, head)
                        break
                    end
                end
            end
        end
    end
end)

local autobank = false
local bankTeleportCFrame = CFrame.new(1112.12671, 10.1856346, -324.815613)  
local originalPosition = nil  

local function robBankAndReturn()
    if not autobank then return end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    originalPosition = rootPart.CFrame
    
    rootPart.CFrame = bankTeleportCFrame
    task.wait(0.1)
    
    local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
    
    local waitTime = 0.1
    local maxWait = 10.0
    
    local startTime = tick()
    while autobank and (tick() - startTime) < maxWait do
        Signal.FireServer("stealBankCash")
        task.wait(waitTime)
    end
    
    if autobank and originalPosition then
        rootPart.CFrame = originalPosition
        task.wait(0.1)
    end
    
    originalPosition = nil
end

local bankThread = nil

local function startBankRobberyLoop()
    if bankThread then return end
    
    bankThread = task.spawn(function()
        while autobank do
            robBankAndReturn()
            task.wait(0.5)
        end
        bankThread = nil
    end)
end

local function stopBankRobberyLoop()
    if bankThread then
        task.cancel(bankThread)
        bankThread = nil
    end
end

Tabs.MoneyTab:Paragraph({ Title = "━━━━━━ 银行抢劫 ━━━━━━", Desc = "自动抢劫银行", Image = "dollar-sign", ImageSize = 42 })

Tabs.MoneyTab:Dropdown({
    Title = "银行模式",
    Values = {"Regular", "AFK"},
    Value = "Regular",
    Callback = function(value) bankMode = value end
})

local function GetBankCash()
    if Workspace.BankRobbery and Workspace.BankRobbery:FindFirstChild("BankCash") then
        return Workspace.BankRobbery.BankCash
    end
    return nil
end

local bankFarmConn = nil
local function startBankFarm()
    if bankFarmConn then bankFarmConn:Disconnect() end
    bankFarmConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AutoRobBank then return end
        local bankCash = GetBankCash()
        if not bankCash or not bankCash:FindFirstChild("Cash") then return end
        if #bankCash.Cash:GetChildren() <= 0 then return end
        
        local hrp = HumanoidRootPart
        if not hrp then return end
        
        local mainPart = Workspace.BankRobbery.BankCash:FindFirstChild("Main")
        if mainPart then
            hrp.CFrame = mainPart.CFrame * CFrame.new(0, -2.7, -1) * CFrame.Angles(math.rad(90), 0, 0)
        end
        
        for _, v in pairs(Workspace.BankRobbery:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
            end
        end
        
        if bankMode == "AFK" and #bankCash.Cash:GetChildren() <= 0 then
            hrp.CFrame = CFrame.new(1653.3216552734375, -16.953155517578125, -529.6856079101562)
        end
    end)
end

Tabs.MoneyTab:Toggle({
    Title = "自动抢银行",
    Default = false,
    Callback = function(state)
        getgenv().AutoRobBank = state
        if state then startBankFarm() end
    end
})

Tabs.MoneyTab:Button({
    Title = "传送去银行",
    Callback = function()
        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(1089.2777099609375, 8.169798851013184, -344.85955810546875)
        end
    end
})

Tabs.MoneyTab:Paragraph({ Title = "━━━━━━ ATM抢劫 ━━━━━━", Desc = "自动抢劫ATM机", Image = "dollar-sign", ImageSize = 42 })

Tabs.MoneyTab:Dropdown({
    Title = "ATM模式",
    Values = {"Regular", "AFK"},
    Value = "Regular",
    Callback = function(value) atmMode = value end
})

local atmFarmConn = nil
local function startATMFarm()
    if atmFarmConn then atmFarmConn:Disconnect() end
    atmFarmConn = RunService.Heartbeat:Connect(function()
        if not getgenv().AutoRobATM then return end
        local atms = GetATMS()
        if #atms == 0 then return end
        
        local hrp = HumanoidRootPart
        if not hrp then return end
        
        for _, atm in pairs(atms) do
            if atm:GetAttribute("state") ~= "destroyed" and atm.PrimaryPart then
                local dis = (hrp.Position - atm.PrimaryPart.Position).magnitude
                if dis <= 20 then
                    equip("Fists")
                    local args = {
                        "prop",
                        { ["meleeType"] = "meleepunch", ["guid"] = atm:GetAttribute("guid") }
                    }
                    local l = require(ReplicatedStorage.devv).load
                    local sig = l("Signal")
                    sig.FireServer("meleeItemHit", unpack(args))
                end
            end
        end
    end)
end

Tabs.MoneyTab:Toggle({
    Title = "自动抢ATM",
    Default = false,
    Callback = function(state)
        getgenv().AutoRobATM = state
        if state then startATMFarm() end
    end
})

Tabs.MoneyTab:Paragraph({ Title = "━━━━━━ 物品拾取 ━━━━━━", Desc = "自动拾取物品", Image = "package", ImageSize = 42 })

local cashAuraConn = nil

local cashAuraEnabled = false
Tabs.MoneyTab:Toggle({
Title = "现金光环",
Value = false,
Callback = function(state)
cashAuraEnabled = state
if state then
task.spawn(function()
while cashAuraEnabled do
for _, cash in pairs(Workspace.Game.Entities.CashBundle:GetChildren()) do
if not cashAuraEnabled then break end
if cash:FindFirstChildOfClass("Part") then
local part = cash:FindFirstChildOfClass("Part")
local distance = (HumanoidRootPart.Position - part.Position).magnitude
if distance <= 30 and cash:FindFirstChildOfClass("ClickDetector") then
fireclickdetector(cash:FindFirstChildOfClass("ClickDetector"))
end
end
end
task.wait(0.1)
end
end)
end
end
})

local itemAuraConn = nil
local valuableItems = {
    "Dark Matter Gem", "Void Gem", "Diamond Ring", "Diamond", "Rollie",
    "Gold Crown", "Gold Cup", "Emerald", "Ruby", "Sapphire", "Gold Bar",
    "Money Printer", "Treasure Map", "Military Armory Keycard"
}
Tabs.MoneyTab:Toggle({
    Title = "物品光环",
    Default = false,
    Callback = function(state)
        if itemAuraConn then itemAuraConn:Disconnect() end
        if state then
            itemAuraConn = RunService.Heartbeat:Connect(function()
                for _, v in pairs(GetItems()) do
                    local itemName = v:GetAttribute("itemName") or v.Name
                    local valuable = false
                    for _, val in pairs(valuableItems) do
                        if itemName == val then valuable = true break end
                    end
                    if valuable and v:FindFirstChildOfClass("ClickDetector") then
                        local hrp = HumanoidRootPart
                        if hrp and (hrp.Position - (v:FindFirstChildOfClass("Part") and v:FindFirstChildOfClass("Part").Position or Vector3.new())).magnitude <= 27 then
                            fireClickDetector(v)
                        end
                    end
                end
            end)
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "自动开保险箱/柜子",
    Default = false,
    Callback = function(state)
        task.spawn(function()
            while state do
                task.wait(0.5)
                buyItem("Lockpick")
                for _, v in pairs(Workspace.Game.Entities:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
                for _, v in pairs(Workspace.GemRobbery:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        fireproximityprompt(v)
                    end
                end
            end
        end)
    end
})

Tabs.MoneyTab:Toggle({
    Title = "珠宝箱农场(稀有宝石)",
    Value = false,
    Callback = function(state)
        getgenv().AutoFarmRareJewelry = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        while task.wait(0.5) do
            if not getgenv().AutoFarmRareJewelry then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local gameFolder = game.Workspace:FindFirstChild("Game")
            if not gameFolder then return end
            local entities = gameFolder:FindFirstChild("Entities")
            if not entities then return end

            local jewelSafes = entities:FindFirstChild("JewelSafe")
            if jewelSafes then
                for _, safe in pairs(jewelSafes:GetChildren()) do
                    if safe.PrimaryPart then
                        rootPart.CFrame = safe.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
                        local prompt = safe:FindFirstChild("ProximityPrompt", true)
                        if prompt then
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end

            local goldJewelSafes = entities:FindFirstChild("GoldJewelSafe")
            if goldJewelSafes then
                for _, safe in pairs(goldJewelSafes:GetChildren()) do
                    if safe.PrimaryPart then
                        rootPart.CFrame = safe.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
                        local prompt = safe:FindFirstChild("ProximityPrompt", true)
                        if prompt then
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "珠宝箱农场(所有宝石)",
    Value = false,
    Callback = function(state)
        getgenv().AutoFarmAllJewelry = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        while task.wait(0.5) do
            if not getgenv().AutoFarmAllJewelry then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local gameFolder = game.Workspace:FindFirstChild("Game")
            if not gameFolder then return end
            local entities = gameFolder:FindFirstChild("Entities")
            if not entities then return end

            local jewelCases = entities:FindFirstChild("JewelryCase")
            if jewelCases then
                for _, box in pairs(jewelCases:GetChildren()) do
                    if box:FindFirstChild("ProximityPrompt") then
                        rootPart.CFrame = box.CFrame + Vector3.new(0, 2, 0)
                        local prompt = box.ProximityPrompt
                        prompt.RequiresLineOfSight = false
                        prompt.HoldDuration = 0
                        task.wait(0.05)
                        if fireproximityprompt then
                            fireproximityprompt(prompt)
                        else
                            firesignal(prompt.Triggered)
                        end
                    end
                end
            end

            local jewelSafes = entities:FindFirstChild("JewelSafe")
            if jewelSafes then
                for _, safe in pairs(jewelSafes:GetChildren()) do
                    if safe.PrimaryPart then
                        rootPart.CFrame = safe.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
                        local prompt = safe:FindFirstChild("ProximityPrompt", true)
                        if prompt then
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end

            local goldJewelSafes = entities:FindFirstChild("GoldJewelSafe")
            if goldJewelSafes then
                for _, safe in pairs(goldJewelSafes:GetChildren()) do
                    if safe.PrimaryPart then
                        rootPart.CFrame = safe.PrimaryPart.CFrame + Vector3.new(0, 2, 0)
                        local prompt = safe:FindFirstChild("ProximityPrompt", true)
                        if prompt then
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})
Tabs.MoneyTab:Toggle({
    Title = "宝藏物品",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickTreasure = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Treasure Map",
            "Pearl Necklace",
            "Seashell",
            "Purple Seashell",
            "Blue Seashell"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickTreasure then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})
Tabs.MoneyTab:Toggle({
    Title = "组件箱",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickComponent = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Component Box"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickComponent then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "黄金枪械",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickGoldGun = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Gold AK-47",
            "Gold Deagle"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickGoldGun then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "礼物/幸运方块",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickPresent = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Small Present",
            "Medium Present",
            "Large Present",
            "Gold Lucky Block",
            "Orange Lucky Block",
            "Purple Lucky Block",
            "Green Lucky Block",
            "Red Lucky Block",
            "Blue Lucky Block"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickPresent then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "稀有宝石",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickRareGem = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Diamond",
            "Diamond Ring",
            "Diamond Ore",
            "Rollie",
            "Dark Matter Gem",
            "Void Gem",
            "Gold Cup",
            "Gold Crown"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickRareGem then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "超稀有物品",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickVeryRare = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Dollar Balloon",
            "Heart Crossbow",
            "Void Gem",
            "Diamond",
            "Nuclear Missile Launcher", 
            "NextBot Grenade",
            "Rollie",
            "Gold Crown",
            "Dark Matter Gem",
            "Diamond Glock",
            "Diamond Banana Peel",
            "Spirit Kunai",
            "Kunai",
            "Purple Lucky Block",
            "Snowflake Balloon",
            "Suitcase Nuke",
            "Nuke Launcher",
            "Easter Basket",
            "Gold Cup",
            "Pearl Necklace",
            "Treasure Map",
            "Spectral Scythe",
            "Bunny Balloon",
            "Ghost Balloon",
            "Clover Balloon",
            "Bat Balloon",
            "Gold Clover Balloon",
            "Golden Rose",
            "Black Rose",
            "Heart Balloon",
            "Skull Balloon",
            "Candy Cane",
            "Easter Basket",
            "Diamond Glock",
            "Clover Balloon",
            "Heart Balloon",
            "Ghost Balloon",
            "Nuke Case",
            "NextBot Grenade",
            "Pulse Rifle",
            "Trident",
            "El Fuego"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickVeryRare then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "蓝卡",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickBlueCard = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Police Armory Keycard"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickBlueCard then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "红卡",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickRedCard = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Military Armory Keycard"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickRedCard then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "印钞机",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickPrinter = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Money Printer"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickPrinter then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "金条",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickGoldBar = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Gold Bar"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickGoldBar then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "音箱",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickBoombox = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Boombox"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickBoombox then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

Tabs.MoneyTab:Toggle({
    Title = "车辆钥匙",
    Value = false,
    Callback = function(state)
        getgenv().AutoPickCarKey = state

        if not state then
            return
        end

        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local targetItems = {
            "Mustang Key",
            "Cruiser Key",
            "Helicopter Key",
            "Airdrop Marker"
        }

        while task.wait(0.1) do
            if not getgenv().AutoPickCarKey then
                break
            end

            if not rootPart or not rootPart:IsDescendantOf(game) then
                character = localPlayer.Character
                rootPart = character:WaitForChild("HumanoidRootPart")
            end

            local itemFolder = game.Workspace:FindFirstChild("Game")
            if not itemFolder then return end
            local entities = itemFolder:FindFirstChild("Entities")
            if not entities then return end
            local itemPickup = entities:FindFirstChild("ItemPickup")
            if not itemPickup then return end

            for _, l in pairs(itemPickup:GetChildren()) do
                for _, v in pairs(l:GetChildren()) do
                    if v:IsA("MeshPart") or v:IsA("Part") then
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                        if prompt and table.find(targetItems, prompt.ObjectText) then
                            rootPart.CFrame = v.CFrame + Vector3.new(0, 2, 0)
                            prompt.RequiresLineOfSight = false
                            prompt.HoldDuration = 0
                            task.wait(0.05)
                            if fireproximityprompt then
                                fireproximityprompt(prompt)
                            else
                                firesignal(prompt.Triggered)
                            end
                        end
                    end
                end
            end
        end
    end
})

local autoATMCashCombo = false

Tabs.MoneyTab:Toggle({
    Title = "ATM农场",
    Default = false,
    Callback = function(Value)
        autoATMCashCombo = Value
        
        if autoATMCashCombo then
            local function collectCash()
                local player = game:GetService("Players").LocalPlayer
                local cashSize = Vector3.new(2, 0.2499999850988388, 1)
                
                for _, part in ipairs(workspace.Game.Entities.CashBundle:GetDescendants()) do
                    if part:IsA("BasePart") and part.Size == cashSize then
                        player.Character.HumanoidRootPart.CFrame = part.CFrame
                        task.wait()
                    end
                end
            end
            
            coroutine.wrap(function()
                while autoATMCashCombo and task.wait() do
                   
                    local ATMsFolder = workspace:FindFirstChild("ATMs")
                    local localPlayer = game:GetService("Players").LocalPlayer
                    local hasActiveATM = false
                    
                    if ATMsFolder and localPlayer.Character then
                        for _, atm in ipairs(ATMsFolder:GetChildren()) do
                            if atm:IsA("Model") then
                                local hp = atm:GetAttribute("health")
                                if hp ~= 0 then
                                    hasActiveATM = true
                                    for _, part in ipairs(atm:GetChildren()) do
                                        if part.Name == "Main" and part:IsA("BasePart") then
                                            localPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
                                            task.wait()
                                            atm:SetAttribute("health", 0)
                                            break
                                        end
                                    end
                                    task.wait()
                                end
                            end
                        end
                    end
                    
                    if hasActiveATM then
                        task.wait(0.01)
                    else
                        collectCash()
                        
                 
                        task.wait()
                    end
                end
            end)()
        end
    end
})

local autoCraftEnabled = false
local autoClaimEnabled = false
local craftConnection

local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")

local function performCrafting()
    if autoCraftEnabled then
        Signal.InvokeServer("beginCraft", 'RollieCraft')
    end
    
    if autoClaimEnabled then
        Signal.InvokeServer("claimCraft", 'RollieCraft')
    end
end

game:GetService("RunService").Heartbeat:Connect(function()
    if autoCraftEnabled or autoClaimEnabled then
        performCrafting()
    end
end)

Tabs.BypassTab:Toggle({
    Title = "自动制作萝莉",
    Value = false,
    Callback = function(state)
        autoCraftEnabled = state
    end
})

Tabs.BypassTab:Toggle({
    Title = "自动领取萝莉",
    Value = false,
    Callback = function(state)
        autoClaimEnabled = state
    end
})

Tabs.BypassTab:Button({
    Title = "绕过移动经销商",
    Callback = function()
local pjyd pjyd=hookmetamethod(game,"__namecall",function(self,...)local args={...}local method=getnamecallmethod()if method=="InvokeServer" and args[2]==true then args[2]=false return pjyd(self,unpack(args))end return pjyd(self,...)end)
game:GetService("Players").LocalPlayer:SetAttribute("mobileDealer",true)
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local mobileDealer=require(ReplicatedStorage.devv.shared.Indicies.mobileDealer)

for category,items in pairs(mobileDealer)do 
    for _,item in ipairs(items)do 
        item.stock=999999 
    end 
end

table.insert(mobileDealer.Gun,{itemName="Acid Gun",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Candy Bucket",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Golden Rose",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Black Rose",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Dollar Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Bat Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Bunny Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Clover Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Ghost Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Gold Clover Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Heart Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Skull Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Snowflake Balloon",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Admin AK-47",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Admin Nuke Launcher",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Admin RPG",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Void Gem",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Pulse Rifle",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Unusual Money Printer",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Money Printer",stock=9999})
table.insert(mobileDealer.Gun,{itemName="Trident",stock=9999})
table.insert(mobileDealer.Gun,{itemName="NextBot Grenade",stock=9999})
table.insert(mobileDealer.Gun,{itemName="El Fuego",stock=9999})

    end
})

Tabs.BypassTab:Button({
    Title = "绕过高级动作",
    Callback = function()
        for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Emotes.Frame.ScrollingFrame:GetDescendants()) do
            if v.Name == "Locked" then
                v.Visible = false
            end
        end
    end
})

Tabs.BypassTab:Button({
    Title = "绕过物品栏封禁",
    Callback = function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("devv"):FindFirstChild("remoteStorage"):FindFirstChild("makeExplosion") then
            game:GetService("ReplicatedStorage"):FindFirstChild("devv"):FindFirstChild("remoteStorage"):FindFirstChild("makeExplosion"):Destroy()
        end
    end
})

Tabs.BypassTab:Button({
    Title = "绕过战斗状态",
    Callback = function()
        for _, func in pairs(getgc(true)) do
            if type(func) == "function" then
                local info = debug.getinfo(func)
                if info.name == "isInCombat" or (info.source and info.source:find("combatIndicator")) then
                    hookfunction(func, function() 
                        return false 
                    end)
                end
            end
        end
    end
})

Tabs.ProTab:Paragraph({ Title = "━━━━━━ 防护 ━━━━━━", Desc = "穿甲和回血可以用", Image = "cloud", ImageSize = 42 })

local AutoArmorWithTeleport = false
local teleportThread = nil
local isTeleporting = false

Tabs.ProTab:Toggle({
    Title = "自动买护甲",
    Default = false,
    Callback = function(Value)
        AutoArmorWithTeleport = Value
        
        if Value then
            
            teleportThread = task.spawn(function()
                while AutoArmorWithTeleport do
                    task.wait(0.5)
                    
                    pcall(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum then return end
                        
                        local armor = LocalPlayer:GetAttribute('armor')
                        local needArmor = (hum.Health > 35) and (armor == nil or armor <= 0)
                        
                        if needArmor and not isTeleporting then
                            isTeleporting = true
                            
                            
                            local originalCFrame = hrp.CFrame
                            
                            
                            hrp.CFrame = CFrame.new(666.22, 6.34, -681.36)
                            
                            
                            local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
                            
                            
                            Signal.InvokeServer("attemptPurchase", "Light Vest")
                            task.wait(0.2)
                            
                            
                            Signal.InvokeServer("attemptPurchase", "Light Vest")
                            task.wait(0.2)
                            
                            
                            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
                            for i, v in next, b1 do
                                if v.name == "Light Vest" then
                                    local light = v.guid
                                    Signal.FireServer("equip", light)
                                    Signal.FireServer("useConsumable", light)
                                    Signal.FireServer("removeItem", light)
                                    break
                                end
                            end
                            
                            task.wait(0.1)
                            
                            
                            hrp.CFrame = originalCFrame
                            
                            isTeleporting = false
                        end
                    end)
                end
            end)
            
        else
            if teleportThread then
                task.cancel(teleportThread)
                teleportThread = nil
            end
            isTeleporting = false
        end
    end
})

Tabs.ProTab:Toggle({
    Title = "自动购买面具（不可用）",
    Value = false,
    Callback = function(state) 
        autokz = state
        if autokz then
            while autokz and task.wait(1) do
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local Mask = character:FindFirstChild("Hockey Mask")
                local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
                local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
                if not Mask then
                    Signal.InvokeServer("attemptPurchase", "Hockey Mask")
                    for i, v in next, b1 do
                        if v.name == "Hockey Mask" then
                            local sugid = v.guid
                            if not Mask then
                                Signal.FireServer("equip", sugid)
                                Signal.FireServer("wearMask", sugid)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
})

local AutoHealWithTeleport = false
local healTeleportThread = nil
local isHealTeleporting = false

Tabs.ProTab:Toggle({
    Title = "自动回血",
    Default = false,
    Callback = function(Value)
        AutoHealWithTeleport = Value
        
        if Value then
            healTeleportThread = task.spawn(function()
                while AutoHealWithTeleport do
                    task.wait(0.5)
                    
                    pcall(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if not hrp or not hum then return end
                        
                 
                        local needHeal = (hum.Health >= 5 and hum.Health < hum.MaxHealth)
                        
                        if needHeal and not isHealTeleporting then
                            isHealTeleporting = true
                            
                           
                            local originalCFrame = hrp.CFrame
                            
                          
                            hrp.CFrame = CFrame.new(1160.81, 26.40, -979.33)
                            
                            
                            local Signal = require(game:GetService("ReplicatedStorage").devv).load("Signal")
                            
                            Signal.InvokeServer("attemptPurchase", "Bandage")
                            task.wait(0.2)
                            
                            Signal.InvokeServer("attemptPurchase", "Bandage")
                            task.wait(0.2)
                            
                            
                            local b1 = require(game:GetService('ReplicatedStorage').devv).load('v3item').inventory.items
                            for i, v in next, b1 do
                                if v.name == "Bandage" then
                                    local bandage = v.guid
                                    Signal.FireServer("equip", bandage)
                                    Signal.FireServer("useConsumable", bandage)
                                    Signal.FireServer("removeItem", bandage)
                                    break
                                end
                            end
                            
                            task.wait(0.1)
                            
                            
                            hrp.CFrame = originalCFrame
                            
                            isHealTeleporting = false
                        end
                    end)
                end
            end)
            
        else
            if healTeleportThread then
                task.cancel(healTeleportThread)
                healTeleportThread = nil
            end
            isHealTeleporting = false
        end
    end
})

local melee = require(game:GetService("ReplicatedStorage").devv).load("ClientReplicator")
local lp = game:GetService("Players").LocalPlayer

Tabs.ProTab:Toggle({
    Title = "反立",
    Default = false,
    Callback = function(Value)
        AutoKnockReset = Value
        if Value then
            task.spawn(function()
                while AutoKnockReset do
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        melee.Set(lp, "knocked", false)
                        melee.Replicate("knocked")
                    end
                    task.wait()
                end
            end)
        end
    end
})

Tabs.ProTab:Toggle({
    Title = "反击退",
    Default = false,
    Callback = function(Value)
        antiKBEnabled = Value
        task.spawn(function()
            while antiKBEnabled and task.wait(0.1) do
                local character = game:GetService("Players").LocalPlayer.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
})

Tabs.ziaoxiTab:Paragraph({ Title = "━━━━━━ 自瞄区 ━━━━━━", Desc = "自动瞄准", Image = "sword", ImageSize = 42 })


--静默自瞄
local silentaim = false

local function findTarget()
    if not silentaim then return nil end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    local closestTarget = nil
    local closestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - Camera.CFrame.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestTarget = head
                end
            end
        end
    end
    return closestTarget
end

local function setupHooks()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local success, loadModule = pcall(function() 
        return require(ReplicatedStorage:WaitForChild("devv")).load 
    end)
    if not success then return end
    local v3item = loadModule("v3item")
    if v3item and v3item.projectiles then
        local oldFn = v3item.projectiles.newProjectileOfType
        v3item.projectiles.newProjectileOfType = function(ptype, pdata)
            local target = findTarget()
            if target and pdata.cframe then
                pdata.cframe = CFrame.lookAt(pdata.cframe.Position, target.Position)
            end
            return oldFn(ptype, pdata)
        end
    end
end
setupHooks()

--武器标签UI
Tabs.ziaoxiTab:Toggle({
    Title = "初始化（点也行不就不点也行不知道有啥用）",
    Default = false,
    Callback = function(state)
        silentaim = state
    end
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local aimConnection = nil

local function hasShieldProtection(player)
    if not player or not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    for _, desc in pairs(player.Character:GetDescendants()) do
        if desc:IsA("ForceField") or desc.Name:lower():find("shield") then
            return true
        end
    end
    return false
end

local function getNearestTarget()
    local nearest = nil
    local minDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end

        local char = plr.Character
        if not char or not char:FindFirstChild(AimbotConfig.AimPart) or not char:FindFirstChild("Humanoid") then continue end
        if char.Humanoid.Health <= 0 then continue end

        if AimbotConfig.CheckShield and hasShieldProtection(plr) then
            continue
        end

        local worldPos = char[AimbotConfig.AimPart].Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)

        local dist
        if AimbotConfig.AimMode == "Camera" then
            if not onScreen then continue end
            dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist > AimbotConfig.Radius then continue end
        else
            dist = (worldPos - Camera.CFrame.Position).Magnitude
        end

        if AimbotConfig.WallCheck then
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local ray = workspace:Raycast(Camera.CFrame.Position, worldPos - Camera.CFrame.Position, rayParams)
            local canSee = ray and ray.Instance and ray.Instance:IsDescendantOf(char)
            if not canSee then continue end
        end

        if AimbotConfig.PredictAim then
            worldPos = worldPos + char[AimbotConfig.AimPart].Velocity * AimbotConfig.PredictValue / 10
        end

        if dist < minDist then
            minDist = dist
            nearest = {Part = char[AimbotConfig.AimPart], WorldPos = worldPos}
        end
    end
    return nearest
end

Tabs.ziaoxiTab:Toggle({
    Title = "辅瞄",
    Default = false,
    Callback = function(Value)
        AimbotConfig.Enabled = Value

        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end

        if Value then
            aimConnection = RunService.RenderStepped:Connect(function()
                if not AimbotConfig.Enabled then return end
                local tar = getNearestTarget()
                if tar and Camera then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, tar.WorldPos)
                end
            end)
        end
    end
})

Tabs.ziaoxiTab:Toggle({
    Title = "墙壁检测",
    Default = true,
    Callback = function(Value)
        AimbotConfig.WallCheck = Value
    end
})

Tabs.ziaoxiTab:Toggle({
    Title = "预判自瞄",
    Default = false,
    Callback = function(Value)
        AimbotConfig.PredictAim = Value
    end
})

Tabs.ziaoxiTab:Slider({
    Title = "瞄准倍数",
    Desc = "瞄准强度",
    Value = {
        Min = 0.1,
        Max = 5,
        Default = 1.5
    },
    Callback = function(Value)
        AimbotConfig.PredictValue = Value
    end
})

Tabs.ziaoxiTab:Dropdown({
    Title = "瞄准部位",
    Values = {
        "头部",
        "身体"
    },
    Default = "头部",
    Callback = function(Value)
        if Value == "头部" then
            AimbotConfig.AimPart = "Head"
        elseif Value == "身体" then
            AimbotConfig.AimPart = "UpperTorso"
        end
    end
})

Tabs.ziaoxiTab:Toggle({
    Title = "检测护盾",
    Default = true,
    Callback = function(Value)
        AimbotConfig.CheckShield = Value
    end
})

Tabs.ziaoxiTab:Dropdown({
    Title = "瞄准模式",
    Values = {
        "PC",
        "手机"
    },
    Default = "相机瞄准",
    Callback = function(Value)
        if Value == "相机瞄准" then
            AimbotConfig.AimMode = "Camera"
        elseif Value == "最近瞄准" then
            AimbotConfig.AimMode = "Nearest"
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local BulletConfig = {
    Enabled = false,
    CheckShield = false,
    CheckFriend = false,
    ShootPart = "Head",
    ShootMode = "Camera",
    Radius = 300
}

-- 缓存系统，解决卡顿
local friendCache = {}
local shieldCache = {}
local lastFriendCheck = 0
local lastShieldCheck = 0

local function updateFriendCache()
    local now = tick()
    if now - lastFriendCheck < 1 then return end
    lastFriendCheck = now
    friendCache = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ok, result = pcall(function()
                return LocalPlayer:IsFriendsWith(plr.UserId)
            end)
            if ok then friendCache[plr.UserId] = result end
        end
    end
end

local function updateShieldCache()
    local now = tick()
    if now - lastShieldCheck < 0.5 then return end
    lastShieldCheck = now
    shieldCache = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local found = false
            if char:FindFirstChildOfClass("ForceField") then
                found = true
            else
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("BasePart") and child.Name:lower():find("shield") then
                        found = true
                        break
                    end
                end
            end
            shieldCache[plr.UserId] = found
        end
    end
end

local function isFriend(plr)
    return friendCache[plr.UserId] or false
end

local function hasShield(char)
    local plr = Players:GetPlayerFromCharacter(char)
    return plr and shieldCache[plr.UserId] or false
end

local function getTarget()
    if BulletConfig.CheckFriend then updateFriendCache() end
    if BulletConfig.CheckShield then updateShieldCache() end
    
    local target = nil
    local minDist = math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end

        local part = char:FindFirstChild(BulletConfig.ShootPart)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end

        if BulletConfig.CheckShield and hasShield(char) then continue end
        if BulletConfig.CheckFriend and isFriend(plr) then continue end

        local wp = part.Position
        local sp, os = Camera:WorldToViewportPoint(wp)
        local dist = (wp - Camera.CFrame.Position).Magnitude

        if BulletConfig.ShootMode == "Camera" then
            if not os then continue end
            local sdist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if sdist > BulletConfig.Radius then continue end
        end

        if dist < minDist then
            minDist = dist
            target = part
        end
    end
    return target
end

local bulletTrackingHook = nil

Tabs.ziaoxiTab:Paragraph({ 
    Title = "━━━━━━ 美国子弹 ━━━━━━", 
    Desc = "穿墙打击堪比静默（封号和无关）",
    Image = "skull", 
    ImageSize = 42 
})

Tabs.ziaoxiTab:Toggle({
    Title = "美国子弹",
    Default = false,
    Callback = function(Value)
        BulletConfig.Enabled = Value

        if bulletTrackingHook then
            hookmetamethod(game, "__namecall", bulletTrackingHook)
            bulletTrackingHook = nil
        end

        if Value then
            bulletTrackingHook = hookmetamethod(game, "__namecall", function(self, ...)
                local m = getnamecallmethod()
                local args = {...}
                if m == "Raycast" and not checkcaller() then
                    local origin = args[1] or Camera.CFrame.Position
                    local tar = getTarget()
                    if tar then
                        return {
                            Instance = tar,
                            Position = tar.Position,
                            Normal = (origin - tar.Position).Unit,
                            Material = Enum.Material.Plastic,
                            Distance = (tar.Position - origin).Magnitude
                        }
                    end
                end
                return bulletTrackingHook(self, ...)
            end)
        end
    end
})

Tabs.ziaoxiTab:Toggle({
    Title = "检测护盾",
    Desc = "已优化",
    Default = false,
    Callback = function(Value)
        BulletConfig.CheckShield = Value
        if not Value then shieldCache = {} end
    end
})

Tabs.ziaoxiTab:Toggle({
    Title = "好友检测",
    Desc = "已优化",
    Default = false,
    Callback = function(Value)
        BulletConfig.CheckFriend = Value
        if not Value then friendCache = {} end
    end
})

Tabs.ziaoxiTab:Dropdown({
    Title = "射击部位",
    Values = {"头部", "身体"},
    Default = "头部",
    Callback = function(Value)
        BulletConfig.ShootPart = Value == "头部" and "Head" or "UpperTorso"
    end
})

Tabs.ziaoxiTab:Dropdown({
    Title = "射击方式",
    Values = {"相机判断", "最近距离"},
    Default = "相机判断",
    Callback = function(Value)
        BulletConfig.ShootMode = Value == "相机判断" and "Camera" or "Nearest"
    end
})

Tabs.ziaoxiTab:Slider({
    Title = "射击范围",
    Desc = "相机判断模式的屏幕半径",
    Value = {
        Min = 50,
        Max = 800,
        Default = 300
    },
    Callback = function(Value)
        BulletConfig.Radius = Value
    end
})

Tabs.ziaoxiTab:Paragraph({ Title = "━━━━━━ 枪械设置 ━━━━━━", Desc = "爆改枪", Image = "alert-triangle", ImageSize = 42 })


Tabs.ziaoxiTab:Button({
    Title = "全枪无后座",
    Locked = false,
    Callback = function()
        for _,particle in pairs(game:GetDescendants()) do
            if particle:IsA("ParticleEmitter") then
                particle:Destroy()
            end
        end
        game.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("ParticleEmitter") then
                descendant:Destroy()
            end
        end)
        local inv = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory.items
        for k,v in pairs(inv) do 
            if v.type == "Gun" then
                v.recoilAdd = 0
                v.maxRecoil = 0
                v.recoilDiminishFactor = 0
                v.recoilFastDiminishFactor = 0
            end 
        end
        local gunTemplates = game:GetService("ReplicatedStorage").devv.shared.Indicies.v3items.bin.Gun
        for _,gunTemplate in pairs(gunTemplates:GetChildren()) do
            if gunTemplate:IsA("ModuleScript") then
                local template = require(gunTemplate)
                template.recoilAdd = 0
                template.maxRecoil = 0
                template.recoilDiminishFactor = 0
                template.recoilFastDiminishFactor = 0
            end
        end
    end
})

Tabs.ziaoxiTab:Button({
    Title = "全枪据点",
    Locked = false,
    Callback = function()
        local inv = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory.items
        for k,v in pairs(inv) do 
            if v.type == "Gun" then
                v.baseSpread = 0
                v.baseAimSpread = 0
                v.spread = 0
                v.aimSpread = 0
            end 
        end
        local gunTemplates = game:GetService("ReplicatedStorage").devv.shared.Indicies.v3items.bin.Gun
        for _,gunTemplate in pairs(gunTemplates:GetChildren()) do
            if gunTemplate:IsA("ModuleScript") then
                local template = require(gunTemplate)
                template.baseSpread = 0
                template.baseAimSpread = 0
            end
        end
    end
})

Tabs.ziaoxiTab:Button({
    Title = "全枪射速",
    Locked = false,
    Callback = function()
        local inv = require(game:GetService("ReplicatedStorage").devv).load("v3item").inventory.items
        for k,v in pairs(inv) do 
            if v.type == "Gun" then
                v.fireDebounce = 0
            end 
        end
        local gunTemplates = game:GetService("ReplicatedStorage").devv.shared.Indicies.v3items.bin.Gun
        for _,gunTemplate in pairs(gunTemplates:GetChildren()) do
            if gunTemplate:IsA("ModuleScript") then
                local template = require(gunTemplate)
                template.fireDebounce = 0
            end
        end
    end
})

Tabs.ziaoxiTab:Button({
    Title = "全枪瞬击",
    Callback = function()
        local inv = require(game.ReplicatedStorage.devv).load("v3item").inventory.items
        for k,v in pairs(inv) do 
            if v.type == "Gun" then
                v.speedMax = 9999
                v.speedDropoff = 0
                v.projectileLifetime = 9999
            end 
        end
        local gunTemplates = game.ReplicatedStorage.devv.shared.Indicies.v3items.bin.Gun
        for _,v in pairs(gunTemplates:GetChildren()) do
            if v:IsA("ModuleScript") then
                local t = require(v)
                t.speedMax = 9999
                t.speedDropoff = 0
                t.projectileLifetime = 9999
            end
        end
    end
})

Tabs.ziaoxiTab:Button({
    Title = "快速换弹",
    Callback = function()
        local inv = require(game.ReplicatedStorage.devv).load("v3item").inventory.items
        for k,v in pairs(inv) do 
            if v.type == "Gun" then
                v.reloadTime = 0
            end 
        end
        local gunTemplates = game.ReplicatedStorage.devv.shared.Indicies.v3items.bin.Gun
        for _,v in pairs(gunTemplates:GetChildren()) do
            if v:IsA("ModuleScript") then
                local t = require(v)
                t.reloadTime = 0
            end
        end
    end
})

Tabs.PlayerTab:Paragraph({ Title = "━━━━━━ 通用 ━━━━━━", Desc = "都可用", Image = "dollar-sign", ImageSize = 42 })

Tabs.PlayerTab:Toggle({
    Title = "移速修改",
    Default = false,
    Callback = function(v)
        if v == true then
            sudu = game:GetService("RunService").Heartbeat:Connect(function()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character.Humanoid and game:GetService("Players").LocalPlayer.Character.Humanoid.Parent then
                    if game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game:GetService("Players").LocalPlayer.Character:TranslateBy(game:GetService("Players").LocalPlayer.Character.Humanoid.MoveDirection * Speed / 10)
                    end
                end
            end)
        elseif not v and sudu then
            sudu:Disconnect()
            sudu = nil
        end
    end
})

-- 飞行V4 - XIAOXI HUB
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera
local pgui = lp:WaitForChild("PlayerGui")

local ControlModule = require(lp.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

-- 飞行相关变量
local bv_new = nil
local bg_new = nil
local animCache_new = nil
local hrp_new = nil
local hum_new = nil
local isFlying_new = false
local flySpeed_new = 40
local isWallhack_new = false
local flyTurner_new = nil
local originalCollisions_new = {}

-- ============ 功能函数 ============
local function bypassFlyBan()
    local devv = ReplicatedStorage:FindFirstChild("devv")
    if devv then
        local remoteStorage = devv:FindFirstChild("remoteStorage")
        if remoteStorage then
            local makeExplosion = remoteStorage:FindFirstChild("makeExplosion")
            if makeExplosion then
                makeExplosion:Destroy()
            end
        end
    end
end

local function getBodyParts(character)
    local parts = {}
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local success, rigParts = pcall(function()
            return humanoid:GetRigParts()
        end)
        if success and rigParts then
            for _, part in rigParts do
                if part:IsA("BasePart") then
                    table.insert(parts, part)
                end
            end
        end
    end
    if #parts == 0 then
        local bodyNames = {
            "Head", "Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart",
            "Left Arm", "Right Arm", "Left Leg", "Right Leg",
            "LeftUpperArm", "LeftLowerArm", "RightUpperArm", "RightLowerArm",
            "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg"
        }
        for _, name in bodyNames do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

-- 平滑转身
local SmoothTurner = {}
SmoothTurner.__index = SmoothTurner

function SmoothTurner.new(rootPart, camera, options)
    options = options or {}
    local self = setmetatable({}, SmoothTurner)
    self.RootPart = rootPart
    self.Camera = camera or workspace.CurrentCamera
    self.Enabled = false
    self.BodyGyro = nil
    self.P = options.P or 10000
    self.D = options.D or 50
    self.MaxTorque = options.MaxTorque or Vector3.new(1e6, 1e6, 1e6)
    return self
end

function SmoothTurner:Start()
    if self.Enabled then return end
    if not self.RootPart or not self.RootPart.Parent then return end
    local gyro = Instance.new("BodyGyro")
    gyro.MaxTorque = self.MaxTorque
    gyro.P = self.P
    gyro.D = self.D
    gyro.CFrame = self.RootPart.CFrame
    gyro.Parent = self.RootPart
    self.BodyGyro = gyro
    self.Enabled = true
    self:_startHeartbeat()
end

function SmoothTurner:Stop()
    if self.BodyGyro then
        self.BodyGyro:Destroy()
        self.BodyGyro = nil
    end
    self.Enabled = false
    if self.HeartbeatConn then
        self.HeartbeatConn:Disconnect()
        self.HeartbeatConn = nil
    end
end

function SmoothTurner:SetDirection(direction)
    if not self.Enabled or not self.BodyGyro or not self.RootPart then return end
    local newCFrame = CFrame.lookAt(self.RootPart.Position, self.RootPart.Position + direction.Unit)
    self.BodyGyro.CFrame = newCFrame
end

function SmoothTurner:_startHeartbeat()
    if self.HeartbeatConn then self.HeartbeatConn:Disconnect() end
    self.HeartbeatConn = RunService.Heartbeat:Connect(function()
        if not self.Enabled or not self.BodyGyro or not self.RootPart or not self.Camera then return end
        local look = self.Camera.CFrame.LookVector
        self:SetDirection(look)
    end)
end

function SmoothTurner:Destroy()
    self:Stop()
    self.RootPart = nil
    self.Camera = nil
end

local function clearFlyRes_new()
    local char = lp.Character
    if char then
        local bodyParts = getBodyParts(char)
        for part, originalState in pairs(originalCollisions_new) do
            if part and part.Parent then
                for _, bp in bodyParts do
                    if bp == part then
                        part.CanCollide = originalState
                        break
                    end
                end
            end
        end
        originalCollisions_new = {}
    end
    if animCache_new and lp.Character then
        animCache_new.Parent = lp.Character
    end
    if bv_new then bv_new:Destroy() end
    if bg_new then bg_new:Destroy() end
    bv_new = nil
    bg_new = nil
    if flyTurner_new then
        flyTurner_new:Destroy()
        flyTurner_new = nil
    end
    if hum_new and hum_new.Parent then
        hum_new:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function ensurePhysics_new(hrp, useGyro)
    if hrp:FindFirstChild("LeipzigBV_new") then
        hrp.LeipzigBV_new:Destroy()
    end
    if hrp:FindFirstChild("LeipzigBG_new") then
        hrp.LeipzigBG_new:Destroy()
    end
    bv_new = Instance.new("BodyVelocity", hrp)
    bv_new.Name = "LeipzigBV_new"
    bv_new.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    if useGyro then
        if flyTurner_new then
            flyTurner_new:Destroy()
        end
        flyTurner_new = SmoothTurner.new(hrp, workspace.CurrentCamera)
        flyTurner_new:Start()
    end
end

local function applyWallhackState_new()
    local char = lp.Character
    if not char then return end
    if isWallhack_new then
        local bodyParts = getBodyParts(char)
        originalCollisions_new = {}
        for _, part in bodyParts do
            originalCollisions_new[part] = part.CanCollide
            part.CanCollide = false
        end
    else
        for part, originalState in originalCollisions_new do
            if part and part.Parent then
                part.CanCollide = originalState
            end
        end
        originalCollisions_new = {}
    end
end

local function startFlyNormal_new()
    local char = lp.Character
    if not char then return end
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    local ani = char:FindFirstChild("Animate")
    if ani then
        animCache_new = ani
        ani.Parent = nil
    end
    ensurePhysics_new(hrp_new, true)
    task.spawn(function()
        while isFlying_new and char.Parent do
            local mv = ControlModule:GetMoveVector()
            local cf = camera.CFrame
            local dir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
            if mv.Magnitude > 0 then
                bv_new.Velocity = dir.Unit * flySpeed_new
            else
                bv_new.Velocity = Vector3.new(0, 0.01, 0)
            end
            hum_new:ChangeState(Enum.HumanoidStateType.Climbing)
            RunService.RenderStepped:Wait()
        end
        clearFlyRes_new()
    end)
end

local function startFlyWallhack_new()
    local char = lp.Character
    if not char then return end
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    local ani = char:FindFirstChild("Animate")
    if ani then
        animCache_new = ani
        ani.Parent = nil
    end
    applyWallhackState_new()
    ensurePhysics_new(hrp_new, true)
    task.spawn(function()
        local lastPos = hrp_new.Position
        local lastTime = tick()
        while isFlying_new and char.Parent do
            local dt = tick() - lastTime
            lastTime = tick()
            local mv = ControlModule:GetMoveVector()
            local cf = camera.CFrame
            local dir = (cf.LookVector * -mv.Z) + (cf.RightVector * mv.X)
            local targetVelocity
            if mv.Magnitude > 0 then
                targetVelocity = dir.Unit * flySpeed_new
                bv_new.Velocity = targetVelocity
            else
                bv_new.Velocity = Vector3.new(0, 0.01, 0)
                targetVelocity = Vector3.new(0, 0.01, 0)
            end
            hum_new:ChangeState(Enum.HumanoidStateType.Climbing)
            RunService.RenderStepped:Wait()
            local expectedPos = lastPos + targetVelocity * dt
            local actualPos = hrp_new.Position
            local deviation = actualPos - expectedPos
            if deviation.Magnitude > 0.00001 then
                hrp_new.CFrame = CFrame.new(expectedPos) * hrp_new.CFrame.Rotation
                bv_new.Velocity = targetVelocity
                lastPos = expectedPos
            else
                lastPos = actualPos
            end
        end
        clearFlyRes_new()
    end)
end

local function startFly_new()
    if isFlying_new then return end
    isFlying_new = true
    bypassFlyBan()
    if isWallhack_new then
        startFlyWallhack_new()
    else
        startFlyNormal_new()
    end
end

local function stopFly_new()
    if not isFlying_new then return end
    isFlying_new = false
    clearFlyRes_new()
end

-- 角色重生绑定
local function bindCharacter_new()
    local char = lp.Character or lp.CharacterAdded:Wait()
    hrp_new = char:WaitForChild("HumanoidRootPart")
    hum_new = char:WaitForChild("Humanoid")
    clearFlyRes_new()
    char.AncestryChanged:Connect(function(_, parent)
        if not parent then
            clearFlyRes_new()
            bindCharacter_new()
        end
    end)
end
bindCharacter_new()

-- ============ 创建UI和Toggle ============
local UI_BG = Color3.fromRGB(20, 20, 20)
local BTN_OFF = Color3.fromRGB(50, 50, 50)
local BTN_ON = Color3.fromRGB(90, 90, 90)
local DESTROY_BTN = Color3.fromRGB(70, 70, 70)
local TEXT_COLOR = Color3.fromRGB(240, 240, 240)
local SPEED_BG = Color3.fromRGB(40, 40, 40)

local function createUI()
    -- 如果已存在就显示
    if pgui:FindFirstChild("NewFlightUI") then
        pgui.NewFlightUI.Enabled = true
        return
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NewFlightUI"
    ScreenGui.Parent = pgui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 150, 0, 195)
    MainFrame.Position = UDim2.new(0.5, -75, 0.3, 0)
    MainFrame.BackgroundColor3 = UI_BG
    MainFrame.BackgroundTransparency = 0.2
    MainFrame.Draggable = true
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local bgImage = Instance.new("ImageLabel", MainFrame)
    bgImage.Name = "CustomBackground"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://87099566895194"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = 0.3
    bgImage.ZIndex = -1
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Name = "GradientStroke"
    stroke.Thickness = 2
    stroke.Transparency = 0
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.LineJoinMode = Enum.LineJoinMode.Round

    local strokeGradient = Instance.new("UIGradient", stroke)
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })

    task.spawn(function()
        while MainFrame and MainFrame.Parent do
            strokeGradient.Rotation = (strokeGradient.Rotation + 2) % 360
            RunService.RenderStepped:Wait()
        end
    end)

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = "XIAOXI HUB飞行V4"
    Title.TextColor3 = TEXT_COLOR
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2

    local titleStroke = Instance.new("UIStroke", Title)
    titleStroke.Color = Color3.fromRGB(0, 0, 0)
    titleStroke.Thickness = 1.5
    titleStroke.Transparency = 0.5

    local SpeedInput = Instance.new("TextBox", MainFrame)
    SpeedInput.Size = UDim2.new(0, 120, 0, 24)
    SpeedInput.Position = UDim2.new(0.5, -60, 0, 30)
    SpeedInput.BackgroundColor3 = SPEED_BG
    SpeedInput.BackgroundTransparency = 0.4
    SpeedInput.Text = "40"
    SpeedInput.TextColor3 = TEXT_COLOR
    SpeedInput.TextSize = 11
    SpeedInput.PlaceholderText = "速度"
    SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SpeedInput.ZIndex = 2
    Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 7)

    local speedStroke = Instance.new("UIStroke", SpeedInput)
    speedStroke.Color = Color3.fromRGB(80, 80, 80)
    speedStroke.Thickness = 1
    speedStroke.Transparency = 0.5

    local BypassBtn = Instance.new("TextButton", MainFrame)
    BypassBtn.Size = UDim2.new(0, 120, 0, 26)
    BypassBtn.Position = UDim2.new(0.5, -60, 0, 64)
    BypassBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    BypassBtn.BackgroundTransparency = 0.35
    BypassBtn.Text = "绕过飞行封禁"
    BypassBtn.TextColor3 = TEXT_COLOR
    BypassBtn.TextSize = 11
    BypassBtn.Font = Enum.Font.GothamSemibold
    BypassBtn.AutoButtonColor = true
    BypassBtn.ZIndex = 2
    Instance.new("UICorner", BypassBtn).CornerRadius = UDim.new(0, 8)

    local bypassStroke = Instance.new("UIStroke", BypassBtn)
    bypassStroke.Color = Color3.fromRGB(100, 100, 100)
    bypassStroke.Thickness = 1

    BypassBtn.MouseButton1Click:Connect(function()
        bypassFlyBan()
        if isFlying_new then
            stopFly_new()
            task.wait(0.05)
            startFly_new()
        end
    end)

    local WallhackBtn = Instance.new("TextButton", MainFrame)
    WallhackBtn.Size = UDim2.new(0, 120, 0, 26)
    WallhackBtn.Position = UDim2.new(0.5, -60, 0, 99)
    WallhackBtn.BackgroundColor3 = BTN_OFF
    WallhackBtn.BackgroundTransparency = 0.35
    WallhackBtn.Text = "穿墙模式: 关闭"
    WallhackBtn.TextColor3 = TEXT_COLOR
    WallhackBtn.TextSize = 11
    WallhackBtn.Font = Enum.Font.GothamSemibold
    WallhackBtn.AutoButtonColor = true
    WallhackBtn.ZIndex = 2
    Instance.new("UICorner", WallhackBtn).CornerRadius = UDim.new(0, 8)

    local whStroke = Instance.new("UIStroke", WallhackBtn)
    whStroke.Color = Color3.fromRGB(100, 100, 100)
    whStroke.Thickness = 1

    local FlyBtn = Instance.new("TextButton", MainFrame)
    FlyBtn.Size = UDim2.new(0, 120, 0, 26)
    FlyBtn.Position = UDim2.new(0.5, -60, 0, 133)
    FlyBtn.BackgroundColor3 = BTN_OFF
    FlyBtn.BackgroundTransparency = 0.35
    FlyBtn.Text = "飞行"
    FlyBtn.TextColor3 = TEXT_COLOR
    FlyBtn.TextSize = 11
    FlyBtn.Font = Enum.Font.GothamSemibold
    FlyBtn.AutoButtonColor = true
    FlyBtn.ZIndex = 2
    Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)

    local flyStroke = Instance.new("UIStroke", FlyBtn)
    flyStroke.Color = Color3.fromRGB(100, 100, 100)
    flyStroke.Thickness = 1

    local DestroyUI = Instance.new("TextButton", MainFrame)
    DestroyUI.Size = UDim2.new(0, 120, 0, 26)
    DestroyUI.Position = UDim2.new(0.5, -60, 0, 167)
    DestroyUI.BackgroundColor3 = DESTROY_BTN
    DestroyUI.BackgroundTransparency = 0.35
    DestroyUI.Text = "销毁UI"
    DestroyUI.TextColor3 = TEXT_COLOR
    DestroyUI.TextSize = 11
    DestroyUI.Font = Enum.Font.GothamSemibold
    DestroyUI.AutoButtonColor = true
    DestroyUI.ZIndex = 2
    Instance.new("UICorner", DestroyUI).CornerRadius = UDim.new(0, 8)

    local destroyStroke = Instance.new("UIStroke", DestroyUI)
    destroyStroke.Color = Color3.fromRGB(100, 100, 100)
    destroyStroke.Thickness = 2

    -- 拖动功能
    local dragging = false
    local dragStart = nil
    local startPos = nil

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- 速度输入
    SpeedInput.FocusLost:Connect(function()
        local val = tonumber(SpeedInput.Text)
        if val then
            flySpeed_new = math.clamp(val, 10, 520131491781367)
        else
            flySpeed_new = 150
        end
        SpeedInput.Text = tostring(flySpeed_new)
    end)

    -- 穿墙按钮
    WallhackBtn.MouseButton1Click:Connect(function()
        isWallhack_new = not isWallhack_new
        WallhackBtn.Text = "穿墙模式: " .. (isWallhack_new and "开启" or "关闭")
        WallhackBtn.BackgroundColor3 = isWallhack_new and BTN_ON or BTN_OFF
        if isFlying_new then
            stopFly_new()
            task.wait(0.05)
            startFly_new()
        else
            applyWallhackState_new()
        end
    end)

    -- 飞行按钮
    FlyBtn.MouseButton1Click:Connect(function()
        if isFlying_new then
            stopFly_new()
            FlyBtn.Text = "飞行"
            FlyBtn.BackgroundColor3 = BTN_OFF
        else
            startFly_new()
            FlyBtn.Text = "飞行开"
            FlyBtn.BackgroundColor3 = BTN_ON
        end
    end)

    -- 销毁UI按钮
    DestroyUI.MouseButton1Click:Connect(function()
        stopFly_new()
        applyWallhackState_new()
        ScreenGui:Destroy()
    end)

    -- 动画效果
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame:TweenSize(
        UDim2.new(0, 150, 0, 195),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.4,
        true
    )
end

-- ============ 注册Toggle ============
Tabs.PlayerTab:Toggle({
    Title = "飞行（已绕过）",
    Default = false,
    Callback = function(v)
        if v == true then
            createUI()
        else
            -- 关闭UI并停止飞行
            stopFly_new()
            if pgui:FindFirstChild("NewFlightUI") then
                pgui.NewFlightUI.Enabled = false
            end
        end
    end
})

Tabs.PlayerTab:Slider({
    Title = "速度设置",
    Value = {
        Min = 1,
        Max = 100,
        Default = 1,
    },
    Callback = function(Value)
        Speed = Value
    end
})

Tabs.PlayerTab:Slider({
    Title = "瞄准强度",
Desc = "设置瞄准辅助敏感度",
Value = {
Min = 0,
Max = 20,
Default = 0
},
Callback = function(value)
aimAssistLevel = value
LocalPlayer:SetAttribute("aimAssistSensitivity", aimAssistLevel)
end
})

Tabs.PlayerTab:Toggle({
    Title = "显示聊天框",
    Desc = "开启/关闭游戏聊天窗口",
    Default = true,
    Callback = function(Value)
        game.TextChatService.ChatWindowConfiguration.Enabled = Value
    end
})

Tabs.PlayerTab:Toggle({
    Title = "防虚空",
Default = false,
Callback = function(Value)
task.spawn(function()
while Value and task.wait(0.1) do
local character = game:GetService("Players").LocalPlayer.Character
if character and character:FindFirstChild("HumanoidRootPart") then
local humanoidRootPart = character.HumanoidRootPart
local position = humanoidRootPart.Position
if position.Y < -200 then
humanoidRootPart.CFrame = CFrame.new(1339.9090576171875, 6.044891357421875, -660.3264770507812)
end
end
end
end)
end
})

Tabs.PlayerTab:Toggle({
Title = "防甩飞",
Default = false,
Callback = function(Value)
task.spawn(function()
while Value and task.wait(0.1) do
local character = game:GetService("Players").LocalPlayer.Character
if character then
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") then
part.CanCollide = false
end
end
end
end
end)
end
})

Tabs.PlayerTab:Toggle({
    Title = "无限跳跃",
    Default = false,
    Callback = function(Value)
        local jumpConn
        if Value then
            jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local humanoid = game:GetService("Players").LocalPlayer.Character and
                                 game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if jumpConn then
                jumpConn:Disconnect()
                jumpConn = nil
            end
        end
    end
})

local xeniox = {
    Data = {
        Identity = getidentity()
    },
    Helpers = {}
}

local devv = game:GetService("ReplicatedStorage").devv
local load = require(devv).load

xeniox.Helpers.SetIdentity = function(self, identity)
    setidentity(identity)
end

xeniox.Helpers.CallFuncSec = function(self, func, waited)
    self:SetIdentity(2)
    local result, err = pcall(func)
    if not result then
        warn("函数执行错误:", err)
    end
    if waited then
        task.wait(waited)
    end
    self:SetIdentity(xeniox.Data.Identity)
end

Tabs.MMMTab:Toggle({
    Title = "自动购买气球",
    Value = false,
    Callback = function(state)
        if not state then return end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        
        if character:FindFirstChild("Balloon") then return end
        
        local Signal = load("Signal")
        Signal.InvokeServer("attemptPurchase", "Balloon")
        
        task.wait(0.5)
        
        local v3item = load("v3item")
        local inventory = v3item.inventory
        local balloonItem = inventory.getFromName("Balloon")
        
        if balloonItem then
            xeniox.Helpers:CallFuncSec(function()
                balloonItem:SetEquipped(true)
            end)
        end
    end
})

Tabs.MMMTab:Button({
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
Tabs.MMMTab:Button({
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

Tabs.MMMTab:Button({
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

Tabs.MMMTab:Button({
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

Tabs.MMMTab:Toggle({
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

Tabs.MMMTab:Toggle({
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

Tabs.MMMTab:Toggle({
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

Tabs.MMMTab:Toggle({
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

Tabs.MHTab:Dropdown({
    Title = "选择美化皮肤",
    Values = { 
        "烟火", "虚空", "纯金", "暗物质", "反物质", "神秘", "虚空神秘", "战术", "纯金战术", 
        "白未来", "黑未来", "圣诞未来", "礼物包装", "猩红", "收割者", "虚空收割者", "圣诞玩具",
        "荒地", "隐形", "像素", "钻石像素", "黄金零下", "绿水晶", "生物", "樱花", "精英", 
        "黑樱花", "彩虹激光", "蓝水晶", "紫水晶", "红水晶", "零下", "虚空射线", "冰冻钻石",
        "虚空梦魇", "金雪", "爱国者", "MM2", "声望", "酷化", "蒸汽", "海盗", "玫瑰", "黑玫瑰",
        "激光", "烟花", "诅咒背瓜", "大炮", "财富", "黄金大炮", "四叶草", "自由", "黑曜石", "赛博朋克"
    },
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
Tabs.MHTab:Toggle({
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

local function getItemList()
    local itemList = {}
    for _, itemName in ipairs(items) do
        local displayName = itemDisplayNames[itemName] or itemName
        table.insert(itemList, displayName)
    end
    return itemList
end

local selectedItem = ""
Tabs.MHTab:Dropdown({
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

Tabs.MHTab:Button({
    Title = "免费获得选择的物品",
    Callback = function()
        if selectedItem and selectedItem ~= "" then
            local itemName = getItemNameByDisplayName(selectedItem)
            if itemName then
                addItem(itemName)
            end
        end
    end
})

Tabs.ACTab:Paragraph({
    Title = "━━━━━━ 彩蛋活动已结束 ━━━━━━",
    Desc = "活动已结束",
    Image = "egg",
    ImageSize = 42,
})

Tabs.ACTab:Paragraph({
    Title = "以下是修改类",
    Desc = "可以伪装成管理员 使用RPG再用此功能 直接给他们装一波逼 刚好也图一下新年的喜庆",
    Image = "crown",
    ImageSize = 42,
})

Tabs.ACTab:Button({
    Title = "全枪无限子弹",
    Callback = function()
        local function setInfiniteAmmo()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            local itemSystem = require(ReplicatedStorage.devv).load("v3item")
            local inventory = itemSystem.inventory
            
            for _, item in pairs(inventory.items) do
                if item and item.ammoManager then
                    item.ammoManager:setAmmo(9999)
                    item.ammoManager:setAmmoOut(9999)
                end
            end
        end
        
        setInfiniteAmmo()
        
        local infiniteAmmoLoop = task.spawn(function()
            while true do
                pcall(setInfiniteAmmo)
                task.wait(25)
            end
        end)
    end
})

Tabs.ACTab:Button({
    Title = "全枪射速提升",
    Callback = function()
        local function increaseFireRate()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            local itemSystem = require(ReplicatedStorage.devv).load("v3item")
            local inventory = itemSystem.inventory
            
            for _, item in pairs(inventory.items) do
                if item then
                    item.fireDebounce = 0.01
                    item.reloadTime = 0.1
                    if item.ammoManager then
                        item.ammoManager.ammo = 9999
                    end
                end
            end
        end
        
        increaseFireRate()
        
        local fireRateLoop = task.spawn(function()
            while true do
                pcall(increaseFireRate)
                task.wait(30)
            end
        end)
    end
})

Tabs.ACTab:Button({
    Title = "全枪无后坐力",
    Callback = function()
        local function removeRecoil()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            
            local itemSystem = require(ReplicatedStorage.devv).load("v3item")
            local inventory = itemSystem.inventory
            
            for _, item in pairs(inventory.items) do
                if item then
                    item.recoilAdd = 0
                    item.maxRecoil = 0
                    item.recoilDiminishFactor = 0
                    item.recoilFastDiminishFactor = 0
                    item.baseSpread = 0
                    item.baseAimSpread = 0
                    item.spread = 0
                    item.aimSpread = 0
                end
            end
        end
        
        removeRecoil()
        
        local recoilLoop = task.spawn(function()
            while true do
                pcall(removeRecoil)
                task.wait(30)
            end
        end)
    end
})

Tabs.MusicTab:Paragraph({ Title = "━━━━━━ 音乐 ━━━━━━", Desc = "可以搜索的", Image = "dollar-sign", ImageSize = 42 })

 Tabs.MusicTab:Button({
     Title = "网易云音乐",
     Callback = function()
         loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E7%BD%91%E6%98%93%E4%BA%91.lua"))()
     end
 })
 
 Tabs.zhuyaoTab:Button({
    Title = "重新加入当前服务器",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        if game.PlaceId and game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
        end
    end
})

Tabs.zhuyaoTab:Button({
    Title = "切换至低人数服务器",
    Callback = function()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer
        pcall(function()
            local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet(string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", game.PlaceId))).data
            for _, v in pairs(Servers) do
                if v.id ~= game.JobId and v.playing < v.maxPlayers and v.playing > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, localPlayer)
                    break
                end
            end
        end)
    end
})
Tabs.zhuyaoTab:Paragraph({
    Title = "当前服务器ID",
    Desc = game.JobId,
    Buttons = {{
        Title = "Copy",
        Callback = function()
            setclipboard(game.JobId);
        end
    }}
});
Tabs.zhuyaoTab:Input({
    Title = "输入服务器ID",
    Callback = function(value)
        _G.JobId = value;
    end
});
Tabs.zhuyaoTab:Button({
    Title = "加入服务器ID",
    Callback = function()
        (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, _G.JobId);
    end
})
local AimbotConfig = {
    Enabled = false,
    WallCheck = true,
    PredictAim = false,
    PredictValue = 1.5,
    AimPart = "Head",
    Radius = 200,
    CheckShield = true,
    AimMode = "Camera"
}

local spoofTarget = nil

Tabs.weiTab:Input({
    Title = "搜索名称",
    Value = "",
    Placeholder = "输入用户名按回车...",
    Callback = function(value)
        if value == "" then
            spoofTarget = nil
            return
        end
        
        local results = searchPlayers(value)
        if #results > 0 then
            spoofTarget = results[1]
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "搜索完成",
                Text = "已选择: @" .. spoofTarget.name,
                Duration = 3
            })
        else
            spoofTarget = nil
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "未找到",
                Text = "无结果",
                Duration = 2
            })
        end
    end
})

Tabs.weiTab:Button({
    Title = "确认伪装",
    Desc = "伪装为搜索到的玩家",
    Callback = function()
        if spoofTarget then
            local userInfo = getUserInfo(spoofTarget.id)
            if userInfo then
                spoofPlayer(spoofTarget.id, userInfo.name, userInfo.displayName)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "伪装成功",
                    Text = "已伪装成: @" .. userInfo.name,
                    Duration = 3
                })
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "请先搜索",
                Text = "输入用户名进行搜索",
                Duration = 2
            })
        end
    end
})

Tabs.ggiTab:Paragraph({
        Title = "欢迎使用 XIAOXI 脚本",
        Desc = "教程：第一步你们先去商店买几把枪然后去加油站那里然后里面有个工作台把那个枪全出售然后你们再翻一下就能找到了全局不会掉但退出服务器没办法得重新弄然后就是你死了就不用管他那个飞镖是循环利用的就算你手上没飞镖也能打如果还听不懂的话就看底下按钮顺序",
        ImageSize = 50,
        Thumbnail = "video:https://raw.githubusercontent.com/xiaoxi9008/hxjxnx/refs/heads/main/VID_20260508_060029.mp4",
        ThumbnailSize = 170
    })

Tabs.ggiTab:Button({
    Title = "第一步传送到传送到商店购买枪",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        root.CFrame = CFrame.new(674.0, 6.5, -707.6)
    end
})

Tabs.ggiTab:Button({
    Title = "第二步传送到工作台去合成飞镖",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        root.CFrame = CFrame.new(1042.5, 6.1, -660.2)
    end
})

Tabs.ESPTab:Toggle({
    Title = "总开关ESP", 
    Value = false, 
    Callback = function(state)
        vu85 = state
        if state then
            vu153() 
        else
            vu158() 
        end
    end
})

-- 队伍检测
Tabs.ESPTab:Toggle({
    Title = "队伍检测",
    Value = false,
    Callback = function(state)
        AttributesTeamCheck.Enabled = state
    end
})

-- 名字显示开关
Tabs.ESPTab:Toggle({
    Title = "玩家名字",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Names.Enabled = state
    end
})

-- 距离显示开关
Tabs.ESPTab:Toggle({
    Title = "距离显示",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Distances.Enabled = state
    end
})

-- 武器显示开关
Tabs.ESPTab:Toggle({
    Title = "武器显示",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Weapons.Enabled = state
    end
})

-- 血条开关
Tabs.ESPTab:Toggle({
    Title = "血条显示",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Healthbar.Enabled = state
    end
})

-- 血量文字开关
Tabs.ESPTab:Toggle({
    Title = "血量",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Healthbar.HealthText = state
    end
})

-- 箱子边框开关
Tabs.ESPTab:Toggle({
    Title = "边框",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Boxes.Full.Enabled = state
    end
})

-- 箱子填充开关
Tabs.ESPTab:Toggle({
    Title = "边框ESP",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Boxes.Filled.Enabled = state
    end
})

-- 四角边框开关
Tabs.ESPTab:Toggle({
    Title = "四角边框",
    Value = true,
    Callback = function(state)
        ESPSettings.Drawing.Boxes.Corner.Enabled = state
    end
})