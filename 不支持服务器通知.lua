local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local playerName = game:GetService("Players").LocalPlayer.Name

local serverName
local success, result = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if success then
    serverName = result.Name
else
    serverName = "未知服务器"
end

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://4590662766"
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 5

Library:Notify({
    Title = "XIAOXI HUB",
    Description = "暂不支持 " .. serverName .. " 此服务器",
    Time = 6
})
Sound:Play()

Sound.Ended:Wait()
Sound:Destroy()