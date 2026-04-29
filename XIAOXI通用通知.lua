local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local playerName = game:GetService("Players").LocalPlayer.Name
Library:Notify({
    Title = "XIAOXI HUB",
    Description = "欢迎付费用户: " .. playerName .. " 丨 正在加载XIAOXI | 通用",
    Time = 6
})
local startTime = tick()      
loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E7%89%88%E9%80%9A%E7%94%A8.lua"))()
local endTime = tick()
local loadTime = string.format("%.2f", endTime - startTime)
Library:Notify({
    Title = "XIAOXI HUB",
    Description = "加载器加载完成！耗时: " .. loadTime .. "秒",
    Time = 6
})
local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://81718058778338"
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 5
Sound:Play()
Sound.Ended:Wait()
Sound:Destroy()