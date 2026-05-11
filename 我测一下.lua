local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "XIAOXI HUB"
Junkie.identifier = "1051580"
Junkie.provider = "XIAOXI HUB"

local result = Junkie.check_key(SCRIPT_KEY)

if result and result.valid then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/xiaoxi9008/Paid-version./refs/heads/main/XIAOXI%E9%80%89%E6%8B%A9%E7%89%88%E6%9C%AC%E4%BB%98%E8%B4%B9%E7%89%88.lua"))()
else
    game.Players.LocalPlayer:Kick("卡密无效")
end