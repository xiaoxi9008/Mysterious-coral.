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
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    IconThemed = true,
    Content = "尊贵的付费版用户" .. game.Players.LocalPlayer.Name .. "使用<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
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
    Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
    Folder = "ftgshub",
    NewElements = true,
    HideSearchBar = false,
    Size = UDim2.fromOffset(200, 395),
    Theme = "Dark",
    UserEnabled = true,
    SideBarWidth = 135,
    HasOutline = true,
    Background = "video:https://raw.githubusercontent.com/xiaoxi9008/chesksks/refs/heads/main/舞蹈.mp4",
    
    OpenButton = {
        Title = "<font color='#FFB6C1'>X</font><font color='#FFA0B5'>I</font><font color='#FF8AA9'>A</font><font color='#FF749D'>O</font><font color='#FF5E91'>X</font><font color='#FF4885'>I</font>",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("FF69B4"), 
            Color3.fromHex("FF69B4")
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
        Color = Color3.fromHex("FF69B4")
    })
end

local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Green = Color3.fromHex("#10C550")
local Grey = Color3.fromHex("#83889E")
local Blue = Color3.fromHex("#257AF7")
local Red = Color3.fromHex("#EF4F1D")

local AboutTab = Window:Tab({
    Title = "公告",
    Desc = "脚本信息", 
    Icon = "solar:info-square-bold",
    IconColor = Grey,
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
    Color = Color3.fromHex("#ff4830"),
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
    IconColor = Green,
    IconShape = "Square",
    Border = true,
})

-- 脚本列表区域
local ScriptSection = ScriptTab:Section({
    Title = "服务器列表",
    Description = "点击下方按钮执行对应脚本"
})

ScriptTab:Button({
    Title = "赛马娘",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E8%B5%9B%E9%A9%AC%E5%A8%98.lua"))()

    end
})

ScriptTab:Button({
    Title = "po大po",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/拉大便.lua"))()   
    end
})

ScriptTab:Button({
    Title = "99个森林夜",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/99夜.lua"))() 
    end
})

ScriptTab:Button({
    Title = "决斗场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/决斗场.lua"))() 
    end
})

ScriptTab:Button({
    Title = "DOORS（推荐游玩）",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/DOORS加载器。.lua"))() 
    end
})

ScriptTab:Button({
    Title = "终极战场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/终极战场.lua"))()
    end
})

ScriptTab:Button({
    Title = "最强战场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/最强战场.lua"))() 
    end
})

ScriptTab:Button({
    Title = "手枪竞技场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI手枪竞技场.lua"))()
    end
})

ScriptTab:Button({
    Title = "被遗弃（更新中）",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXIHUB被遗弃.lua"))() 
    end
})

ScriptTab:Button({
    Title = "手枪竞技场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI手枪竞技场.lua"))()
    end
})

ScriptTab:Button({
    Title = "自然灾害",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/自然灾害.lua"))() 
    end
})

ScriptTab:Button({
    Title = "卡塔娜竞技场",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("http://121.43.37.20:8885/output/enc/084b2e5e3026"))() 
    end
})

ScriptTab:Button({
    Title = "PETAPETA（无限旅馆）",
    Color = Color3.fromHex("FF69B4"),
    Justify = "Center",
    Icon = "shredder",
    IconAlign = "Left",
    Callback = function()
        -- 第一步：先销毁窗口
        Window:Destroy()
        
        -- 第二步：再执行脚本
        loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/XIAOXI无限旅馆（阉割版）.lua"))() 
    end
})


task.wait(0.5)

local function startRainbowBorder()
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
    
    local oldStroke = mainFrame:FindFirstChild("RainbowStroke")
    if oldStroke then oldStroke:Destroy() end
    
    local colorScheme = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(0.25, Color3.fromHex("FF1493")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFB6C1")),
        ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF69B4")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("FF1493"))
    })
    
    local stroke = Instance.new("UIStroke")
    stroke.Name = "RainbowStroke"
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
    
    print("彩虹边框动画已启动")
    return animationConnection
end

startRainbowBorder()