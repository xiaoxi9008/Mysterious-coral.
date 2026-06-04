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

local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)

    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/-UI/refs/heads/main/Wind.lua"))()
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local function createUI()
    local Window = WindUI:CreateWindow({
        Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
        Folder = "ftgshub",
        NewElements = true,
        HideSearchBar = false,
        Size = UDim2.fromOffset(600, 450),
        Theme = "Dark",  
        UserEnabled = true,
        SideBarWidth = 135,
        HasOutline = true,
        Background = "video:https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/extracted_1_3.mp4",
        
        OpenButton = {
            Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font><font color='#FFAEC4'></font>",
            CornerRadius = UDim.new(1,0),
            StrokeThickness = 1.5,
            Enabled = true,
            Draggable = true,
            OnlyMobile = false,
            Color = ColorSequence.new(
                Color3.fromHex("FFFFFF"), 
                Color3.fromHex("FFFFFF")
            )
        },
        Topbar = {
            Height = 44,
            ButtonsType = "Mac",
        }
    })
    
AddSnowEffect(Window.UIElements.Main.Background, 30, 14, 0.5)

    Window:Tag({
    Title = "付费版",
    Radius = 10,  -- 改这里，数值越大越圆
    Color = Color3.fromHex("#ffffff"),
})

Window:Tag({
    Title = "加载器",
    Radius = 10,  -- 改这里
    Color = Color3.fromHex("#ffffff"),
})

    local White = Color3.fromHex("#FFFFFF")
    local LightGray = Color3.fromHex("#CCCCCC")
    local Gray = Color3.fromHex("#999999")
    local DarkGray = Color3.fromHex("#666666")
    local AlmostBlack = Color3.fromHex("#333333")

    local AboutTab = Window:Tab({
        Title = "公告",
        Desc = "脚本信息", 
        Icon = "solar:info-square-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

    AboutTab:Paragraph({
    Title = "服务器状态",
    Desc = [[
1.终极战场√
2.偷走一粒红√
3.自然灾害√
4.99个森林夜√
5.忍者传奇√
6.种植花园√
7.被遗弃√
8.Ohio√
9.doors√
10.刀刃球√
11.鱼√
12.最强战场√
13.赛马娘√
14.闪光√
15.狙击竞技场（正在添加）
16.无限旅馆（正在更新无法使用）
17.无限旅馆第2章√
18.凹凸世界（正在修）
19.兵工厂√
20.防御√
21.摧毁师（正在加）
22.破坏者谜团2√
23.po大po√
24.手枪竞技场√
25.卡塔娜竞技场√
26.撕咬之夜√
27.决斗场（正在更新无法使用）
28.nico的下一个机器人√
29.竞争对手√
30.枪地FFA√
31.数学谋杀案√
32.手枪竞技场√
33.犯罪√
34.鱼（正在更新）
35.GB√
36.力量传奇（正在更新）
37.战斗勇士（测试中）
38.死铁轨（更新中）
39.木筏101生存（有bug正在修）
40.51区√
    ]],
    BackgroundColor3 = Color3.fromHex("#FFFFFF"),  -- 白色背景
    BackgroundTransparency = 0,                     -- 0=完全不透明
    Color = Color3.fromHex("#000000"),              -- 黑色文字
    OutlineColor = Color3.fromHex("#CCCCCC"),       -- 浅灰边框
    OutlineThickness = 1
})
    AboutTab:Divider()

AboutTab:Button({
    Title = "XIAOXIV3全局汉化",
    Icon = "pausel",
    Color = Gray,
    Callback = function()
        local CoreGui = game:GetService("CoreGui")
        local RunService = game:GetService("RunService")

        local hintGui = Instance.new("ScreenGui")
        hintGui.Parent = CoreGui
        hintGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local hintLabel = Instance.new("TextLabel")
        hintLabel.Parent = hintGui
        hintLabel.BackgroundTransparency = 1
        hintLabel.Position = UDim2.new(1, -20, 1, -40)
        hintLabel.AnchorPoint = Vector2.new(1, 1)
        hintLabel.Size = UDim2.new(0, 220, 0, 32)
        hintLabel.Font = Enum.Font.SourceSansBold
        hintLabel.TextSize = 20
        hintLabel.TextColor3 = Color3.new(1, 1, 1)
        hintLabel.TextStrokeTransparency = 0
        hintLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        hintLabel.Text = "by小西全局汉化已启动"

        task.delay(3, function()
            for i = 1, 0, -0.05 do
                hintLabel.TextTransparency = i
                hintLabel.TextStrokeTransparency = i
                RunService.Heartbeat:Wait()
            end
            hintGui:Destroy()
        end)

        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local translationSpeed = 2
        local translatedTexts = {}

        local function translateText(text)
            if not text or text == "" or #text < 2 then return nil end
            if translatedTexts[text] then return translatedTexts[text] end

            local success, result = pcall(function()
                local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=zh-CN&dt=t&q=" .. HttpService:UrlEncode(text)
                local response = game:HttpGet(url)
                local decoded = HttpService:JSONDecode(response)
                return decoded and decoded[1] and decoded[1][1] and decoded[1][1][1] or nil
            end)

            if success and result then
                translatedTexts[text] = result
                return result
            end
            return nil
        end

        local function isEnglish(text)
            if not text or text == "" then return false end
            local englishCount, totalCount = 0, 0
            for char in text:gmatch(".") do
                local byte = string.byte(char)
                if byte then
                    totalCount = totalCount + 1
                    if (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) then
                        englishCount = englishCount + 1
                    end
                end
            end
            return totalCount > 0 and (englishCount / totalCount) > 0.5
        end

        local function processTextObject(textObject)
            if not textObject:IsA("TextLabel") and not textObject:IsA("TextButton") and not textObject:IsA("TextBox") then return end
            local originalText = textObject.Text
            if not originalText or originalText == "" or not isEnglish(originalText) then return end
            local translatedText = translateText(originalText)
            if translatedText and translatedText ~= originalText then
                textObject.Text = translatedText
            end
        end

        local function scanAndTranslate(parent)
            for _, descendant in pairs(parent:GetDescendants()) do
                task.spawn(function()
                    processTextObject(descendant)
                end)
            end
        end

        local function onDescendantAdded(descendant)
            task.delay(0.1, function()
                processTextObject(descendant)
            end)
        end

        local function startTranslation()
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local playerGuiConnection = PlayerGui.DescendantAdded:Connect(onDescendantAdded)
            local coreGuiConnection = CoreGui.DescendantAdded:Connect(onDescendantAdded)
            
            local lastScanTime = tick()
            local scanInterval = 1.5 / translationSpeed
            local heartbeatConnection = RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                if currentTime - lastScanTime >= scanInterval then
                    lastScanTime = currentTime
                    task.spawn(function() scanAndTranslate(PlayerGui) end)
                    pcall(function()
                        for _, gui in pairs(CoreGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then task.spawn(function() scanAndTranslate(gui) end) end
                        end
                    end)
                end
            end)

            scanAndTranslate(PlayerGui)
            pcall(function()
                for _, gui in pairs(CoreGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then scanAndTranslate(gui) end
                end
            end)

            return {
                PlayerGui = playerGuiConnection,
                CoreGui = coreGuiConnection,
                Heartbeat = heartbeatConnection
            }
        end

        local translationConnections = startTranslation()
        
        WindUI:Notify({
            Title = "汉化已启动",
            Content = "全局汉化成功",
            Icon = "check-circle",
            Duration = 3
        })
    end
})

    local ScriptTab = Window:Tab({
        Title = "支持服务器",
        Desc = "点击即可",
        Icon = "solar:code-square-bold",
        IconColor = Gray,
        IconShape = "Square",
        Border = true,
    })

    local ScriptSection = ScriptTab:Section({
        Title = "服务器列表",
        Description = "点击下方按钮执行对应脚本"
    })

     ScriptTab:Button({
        Title = "XIAOXI通用中心",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E9%80%9A%E7%94%A8%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })

    -- 脚本按钮列表
    ScriptTab:Button({
        Title = "赛马娘",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/%E8%B5%9B%E9%A9%AC%E5%A8%98.lua"))()
        end
    })

    ScriptTab:Button({
        Title = "po大po",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/拉大便.lua"))()   
        end
    })

    ScriptTab:Button({
        Title = "99个森林夜",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%8899%E5%A4%9C.lua"))() 
        end
    })

    ScriptTab:Button({
    Title = "决斗场",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 播放音频
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Parent = game:GetService("SoundService")
        Sound.Volume = 5
        Sound:Play()
        
        local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
        local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
        
        -- 显示通知
        Library:Notify({
            Title = "XIAOXI HUB",
            Description = "该服务器正在更新中无法加载",
            Time = 6
        })
        
        Sound.Ended:Wait()
        Sound:Destroy()
    end
})

    ScriptTab:Button({
        Title = "DOORS（推荐游玩）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/DOORS通知.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "终极战场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/终极战场通知.lua"))()
        end
    })

    ScriptTab:Button({
        Title = "最强战场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/最强战场.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "手枪竞技场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E6%89%8B%E6%9E%AA%E7%AB%9E%E6%8A%80%E5%9C%BA%E4%BB%98%E8%B4%B9%E7%89%88.lua"))()
        end
    })

    ScriptTab:Button({
        Title = "自然灾害",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/自然灾害.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "卡塔娜竞技场",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("http://121.43.37.20:8885/output/enc/084b2e5e3026"))() 
        end
    })

    ScriptTab:Button({
    Title = "PETAPETA（无限旅馆）",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 播放音频
        local Sound = Instance.new("Sound")
        Sound.SoundId = "rbxassetid://4590662766"
        Sound.Parent = game:GetService("SoundService")
        Sound.Volume = 5
        Sound:Play()
        
        local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
        local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
        
        -- 显示通知
        Library:Notify({
            Title = "XIAOXI HUB",
            Description = "该服务器正在更新中无法加载",
            Time = 6
        })
        
        Sound.Ended:Wait()
        Sound:Destroy()
    end
})

    ScriptTab:Button({
        Title = "防御",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/%E4%BB%98%E8%B4%B9%E7%89%88%E9%98%B2%E5%BE%A1XIAOXI.lua"))() 
        end
    })

    ScriptTab:Button({
        Title = "nico下一个机器人",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI的nico下一个机器.lua"))() 
        end
    })


ScriptTab:Button({
        Title = "PETAPETA无限旅馆第2章",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI无限旅馆第2章付费版.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "GB（内脏与黑火药）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/GB通知.lua"))() 
        end
    })
    
ScriptTab:Button({
        Title = "GB（更新频率快）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/GB通知2.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "Forsaken（被遗弃）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%88%E8%A2%AB%E9%81%97%E5%BC%83%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })

ScriptTab:Button({
        Title = "犯罪",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/%E7%8A%AF%E7%BD%AA%E9%80%9A%E7%9F%A5.lua"))() 
        end
    })
    
ScriptTab:Button({
        Title = "亡命速递",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%88%E4%BA%A1%E5%91%BD%E9%80%9F%E9%80%92.lua"))() 
        end
    })
 
ScriptTab:Button({
        Title = "数学谋杀案（残疾人专用）",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI付费版数学谋杀案.lua"))() 
        end
    })    

ScriptTab:Button({
        Title = "闪光",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/闪光.lua"))() 
        end
    })    
ScriptTab:Button({
        Title = "兵工厂",
        Color = Color3.fromHex("999999"),
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Server./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E5%85%B5%E5%B7%A5%E5%8E%82.lua"))() 
        end
    })    
                                                 
    task.wait(0.5)

    -- 黑白渐变边框效果
    local function startGrayscaleBorder()
        local mainFrame = Window.UIElements and Window.UIElements.Main
        if not mainFrame then
            task.wait(0.2)
            mainFrame = Window.UIElements and Window.UIElements.Main
            if not mainFrame then
                warn("无法找到窗口主框架")
                return
            end
        end
        
        local corner = mainFrame:FindFirstChildOfClass("UICorner")
        if not corner then
            corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 16)
            corner.Parent = mainFrame
        end
        
        local oldStroke = mainFrame:FindFirstChild("GrayscaleStroke")
        if oldStroke then oldStroke:Destroy() end
        
        local colorScheme = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),
            ColorSequenceKeypoint.new(0.25, Color3.fromHex("CCCCCC")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("999999")),
            ColorSequenceKeypoint.new(0.75, Color3.fromHex("666666")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("333333"))
        })
        
        local stroke = Instance.new("UIStroke")
        stroke.Name = "GrayscaleStroke"
        stroke.Thickness = 3
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Parent = mainFrame
        
        local gradient = Instance.new("UIGradient")
        gradient.Color = colorScheme
        gradient.Rotation = 0
        gradient.Parent = stroke
        
        local runService = game:GetService("RunService")
        local angle = 0
        local animationConnection = runService.Heartbeat:Connect(function(deltaTime)
            if not stroke or stroke.Parent == nil then
                animationConnection:Disconnect()
                return
            end
            angle = (angle + 180 * deltaTime) % 360
            gradient.Rotation = angle
        end)
        
        print("黑白渐变边框动画已启动")
        return animationConnection
    end

    startGrayscaleBorder()
end

WindUI:Popup({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>",
    IconThemed = true,
    Content = "尊贵付费版用户" .. game.Players.LocalPlayer.Name .. "使用<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#333333'>I</font> <font color='#666666'>S</font><font color='#444444'>C</font><font color='#222222'>R</font><font color='#111111'>I</font><font color='#000000'>P</font><font color='#000000'>T</font>付费版",
    Buttons = {
        {
            Title = "取消",
            Callback = function() 
                createUI()
            end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                createUI()
            end,
            Variant = "Primary",
        }
    }
})