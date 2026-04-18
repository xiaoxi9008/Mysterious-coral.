pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "欢迎使用XIAOXI HUB",
        Text = "正在为你打开加载器…",
        Duration = 3 
    })
end)

print("✅ XIAOXI HUB - 正在加载...")
task.wait(3) 

if game.PlaceId == 7239319209 then 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/XIAOXIBUXINB/refs/heads/main/%E4%BF%84%E4%BA%A5%E4%BF%84%E5%B7%9E%E6%BA%90%E7%A0%81.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Mysterious-coral./refs/heads/main/XIAOXI%E4%BB%98%E8%B4%B9%E5%8A%A0%E8%BD%BD%E5%99%A8.lua"))()
end