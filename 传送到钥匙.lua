local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 彩虹渐变效果
local function createRainbowEffect(object, isText)
    local hue = 0
    local function updateColor()
        hue = (hue + 0.002) % 1
        local color = Color3.fromHSV(hue, 1, isText and 1 or 0.5)
        if isText then
            object.TextColor3 = color
        else
            object.BackgroundColor3 = color
        end
    end
    RunService.RenderStepped:Connect(updateColor)
end

-- 传送函数
local function TeleportToKey()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v.Name:find("Key") and v:IsA("BasePart") then
            hrp.CFrame = v.CFrame
            break
        end
    end
end

-- 创建按钮（放在CoreGui中）
local function createControlButton()
    -- 使用CoreGui替代PlayerGui，这样角色重生不会消失
    local CoreGui = game:GetService("CoreGui")
    
    -- 检查是否已经存在，避免重复创建
    if CoreGui:FindFirstChild("KeyTeleportGUI") then
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    local button = Instance.new("TextButton")

    screenGui.Name = "KeyTeleportGUI"
    screenGui.Parent = CoreGui  -- 改到这里

    button.Name = "TeleportKeyButton"
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, 0, 100)
    button.Text = "点击传送钥匙"
    button.TextScaled = true
    button.Parent = screenGui

    -- 彩虹渐变效果
    createRainbowEffect(button, false)  -- 背景渐变
    createRainbowEffect(button, true)   -- 文字渐变

    -- 拖拽功能
    local dragging = false
    local dragInput, mousePos, framePos

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = button.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            button.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    -- 点击传送
    button.MouseButton1Click:Connect(function()
        TeleportToKey()
    end)
end

-- 如果使用Synapse X等执行器，可能需要额外处理
local success, err = pcall(function()
    createControlButton()
end)

if not success then
    -- 如果CoreGui被禁止，降级使用PlayerGui并监听重生事件
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeyTeleportGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- 角色重生时重新创建GUI
    LocalPlayer.CharacterAdded:Connect(function()
        if not screenGui.Parent then
            screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end)
    
    -- 然后正常创建按钮...
    -- (把上面的按钮创建代码复制到这里)
end