local repo = 'https://raw.githubusercontent.com/DevSloPo/obsidian_UI/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "XIAOXI HUB"
Junkie.identifier = "1051580"
Junkie.provider = "XIAOXI HUB"

-- 从卡密系统获取密钥
repeat wait() until getgenv().SCRIPT_KEY

local keyInfo = Junkie.check_key(getgenv().SCRIPT_KEY)

if keyInfo and keyInfo.valid then
    -- 弹出欢迎通知
    local desc = "欢迎使用 XIAOXI HUB"
    
    if keyInfo.message == "KEYLESS" then
        desc = desc .. "\n类型: 永久"
    elseif keyInfo.expire then
        local expireTime = tonumber(keyInfo.expire)
        if expireTime and expireTime > 0 then
            local now = os.time()
            local daysLeft = math.ceil((expireTime - now) / 86400)
            local cardType
            if daysLeft <= 1 then
                cardType = "天卡"
            elseif daysLeft <= 7 then
                cardType = "周卡"
            elseif daysLeft <= 31 then
                cardType = "月卡"
            else
                cardType = "年卡"
            end
            desc = desc .. "\n" .. cardType .. "到期时间: " .. os.date("%Y年%m月%d日", expireTime)
        end
    end
    
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://4590662766"
    Sound.Parent = game:GetService("SoundService")
    Sound.Volume = 5
    
    Library:Notify({
        Title = "XIAOXI HUB",
        Description = desc,
        Time = 6
    })
    Sound:Play()
    Sound.Ended:Wait()
    Sound:Destroy()
    
    -- 加载主脚本
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Paid-version./refs/heads/main/XIAOXI%E9%80%89%E6%8B%A9%E7%89%88%E6%9C%AC%E4%BB%98%E8%B4%B9%E7%89%88.lua"))()
else
    game.Players.LocalPlayer:Kick("请输入有效卡密，如果卡密错误请去群公告解绑")
end