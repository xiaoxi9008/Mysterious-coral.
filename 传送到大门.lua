local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- 目标坐标 (X: 8.77, Y: 4.44, Z: 117.57)
local TARGET_POSITION = Vector3.new(8.77, 4.44, 117.57)

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
local function TeleportToPosition()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    hrp.CFrame = CFrame.new(TARGET_POSITION)
end

-- 创建按钮
local function createControlButton()
    -- 尝试使用CoreGui（不会随角色重生消失）
    local success, err = pcall(function()
        local CoreGui = game:GetService("CoreGui")
        
        -- 检查是否已经存在，避免重复创建
        if CoreGui:FindFirstChild("TeleportGUI") then
            return
        end
        
        local screenGui = Instance.new("ScreenGui")
        local button = Instance.new("TextButton")

        screenGui.Name = "TeleportGUI"
        screenGui.Parent = CoreGui  -- 使用CoreGui而不是PlayerGui

        button.Name = "TeleportButton"
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0.5, -100, 0, 100)
        button.Text = "📍 XIAOXI传送 📍"
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
        button.MouseButton1Click:Connect(TeleportToPosition)
    end)
    
    -- 如果CoreGui被禁止，降级使用PlayerGui并监听重生事件
    if not success then
        warn("CoreGui访问失败，使用PlayerGui降级方案:", err)
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "TeleportGUI"
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local button = Instance.new("TextButton")
        button.Name = "TeleportButton"
        button.Size = UDim2.new(0, 200, 0, 50)
        button.Position = UDim2.new(0.5, -100, 0, 100)
        button.Text = "点击传送到开锁大门"
        button.TextScaled = true
        button.Parent = screenGui
        
        -- 彩虹渐变效果
        createRainbowEffect(button, false)
        createRainbowEffect(button, true)
        
        -- 拖拽功能（同上）
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
        
        button.MouseButton1Click:Connect(TeleportToPosition)
        
        -- 角色重生时重新将GUI放回PlayerGui
        LocalPlayer.CharacterAdded:Connect(function()
            if not screenGui.Parent then
                screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            end
        end)
    end
end

createControlButton()