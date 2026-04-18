local WindUI

do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)

    if ok then
        WindUI = result
    else 
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Potato5466794/Wind/refs/heads/main/Wind.luau"))()
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

WindUI:Popup({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#222222'>I</font>",
    IconThemed = true,
    Content = "尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#222222'>I</font>",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#222222'>I</font>",
    Folder = "ftgshub",
    NewElements = true,
    HideSearchBar = false,
    Size = UDim2.fromOffset(200, 395),
    Theme = "Dark",  -- 保持深色主题
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/Video_1773198866292_902.mp4",
    
    OpenButton = {
        Title = "<font color='#FFFFFF'>X</font><font color='#CCCCCC'>I</font><font color='#999999'>A</font><font color='#666666'>O</font><font color='#444444'>X</font><font color='#222222'>I</font>",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
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

do
    Window:Tag({
        Title = "加载器",
        Color = Color3.fromHex("FFFFFF")  -- 改为白色
    })
end

-- 黑白配色方案
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
    Title = "欢迎使用 XIAOXI 脚本",
    Desc = "作者：小西｜本人已经回归加载器怎么说呢挺方便的|服务器加载有时候老是错误没办法",
    ImageSize = 50,
    Thumbnail = "https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/Image_1774762956572_963.jpg",
    ThumbnailSize = 170
})

AboutTab:Divider()

AboutTab:Button({
    Title = "显示欢迎通知",
    Icon = "bell",
    Color = Gray,  -- 灰色
    Callback = function()
        WindUI:Notify({
            Title = "欢迎!",
            Content = "感谢使用XIAOXI",
            Icon = "heart",
            Duration = 3
        })
    end
})

AboutTab:Button({
    Title = "销毁窗口",
    Color = Color3.fromHex("#666666"),  -- 深灰色代替红色
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        Window:Destroy()
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

-- 脚本列表区域
local ScriptSection = ScriptTab:Section({
    Title = "服务器列表",
    Description = "点击下方按钮执行对应脚本"
})

-- 创建脚本按钮的函数，统一使用灰色系
local function createScriptButton(title, url)
    ScriptTab:Button({
        Title = title,
        Color = Color3.fromHex("999999"),  -- 灰色
        Justify = "Center",
        Icon = "shredder",
        IconAlign = "Left",
        Callback = function()
            Window:Destroy()
            if url then
                loadstring(game:HttpGet(url))()
            end
        end
    })
end

-- 使用灰色系按钮
ScriptTab:Button({
    Title = "赛马娘",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        Window:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E8%B5%9B%E9%A9%AC%E5%A8%98.lua"))()
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/拉大便.lua"))()   
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/99夜.lua"))() 
    end
})

ScriptTab:Button({
    Title = "决斗场",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        Window:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/决斗场.lua"))() 
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/DOORS加载器。.lua"))() 
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/终极战场.lua"))()
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/最强战场.lua"))() 
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI手枪竞技场.lua"))()
    end
})

ScriptTab:Button({
    Title = "被遗弃（更新中）",
    Color = Color3.fromHex("999999"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        Window:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXIHUB被遗弃.lua"))() 
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
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/自然灾害.lua"))() 
    end
})

ScriptTab:Button({
    Title = "卡塔娜竞技场（进群问我要白名单）",
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
        Window:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI无限旅馆（阉割版）.lua"))() 
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
    
    -- 黑白渐变色
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