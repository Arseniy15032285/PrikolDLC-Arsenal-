local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- == 1. НАСТРОЙКИ И СОСТОЯНИЕ ==
_G.CheatSettings = {
	Aimbot = false,
	Smoothness = false,
	HeadAim = false,
	FOVCheck = false,
	FOVRadius = 150,
	ESP = false,
	BoxESP = false,
	Tracers = false,
	Fullbright = false,
	Watermark = true,
	InfAmmo = false -- Добавлена настройка
}

-- == 2. БЕЗОПАСНЫЙ UI ==
local function getSafeParent()
	local success, result = pcall(function() return gethui() end)
	if success and result then return result end
	success, result = pcall(function() return CoreGui end)
	if success and result then return result end
	return LocalPlayer:WaitForChild("PlayerGui")
end

-- == 3. ТЕМА ==
local Theme = {
	Background = Color3.fromRGB(15, 15, 15),
	SectionBG = Color3.fromRGB(25, 25, 25),
	TextDark = Color3.fromRGB(120, 120, 120),
	TextLight = Color3.fromRGB(240, 240, 240),
	Accent = Color3.fromRGB(255, 65, 65),
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

-- == 4. СОЗДАНИЕ UI ==
for _, child in pairs(getSafeParent():GetChildren()) do
	if child.Name == "ZenMenu_V3" then child:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenMenu_V3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getSafeParent()

-- [[ WATERMARK ]]
local WatermarkFrame = Instance.new("Frame")
WatermarkFrame.Name = "Watermark"
WatermarkFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
WatermarkFrame.BorderSizePixel = 0
WatermarkFrame.Size = UDim2.new(0, 230, 0, 22)
WatermarkFrame.Position = UDim2.new(0, 15, 0, 15)
WatermarkFrame.Visible = _G.CheatSettings.Watermark
WatermarkFrame.Parent = ScreenGui

local WMLine = Instance.new("Frame")
WMLine.Name = "AccentLine"
WMLine.Size = UDim2.new(1, 0, 0, 1)
WMLine.Position = UDim2.new(0, 0, 1, 0)
WMLine.BackgroundColor3 = Theme.Accent
WMLine.BorderSizePixel = 0
WMLine.Parent = WatermarkFrame

local WMLabel = Instance.new("TextLabel")
WMLabel.Size = UDim2.new(1, 0, 1, 0)
WMLabel.BackgroundTransparency = 1
WMLabel.Text = "zenin | t.me/zenindlc | internal free"
WMLabel.Font = Enum.Font.GothamBold
WMLabel.TextSize = 12
WMLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WMLabel.Parent = WatermarkFrame

-- [[ MAIN MENU ]]
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Хедер
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "ZENIN DLC"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 250, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Theme.Accent
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 22
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = HeaderFrame

-- Контейнер для страниц
local PagesContainer = Instance.new("Frame")
PagesContainer.Name = "PagesContainer"
PagesContainer.Size = UDim2.new(1, 0, 1, -100)
PagesContainer.Position = UDim2.new(0, 0, 0, 50)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

-- Футер
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 50)
Footer.Position = UDim2.new(0, 0, 1, 0)
Footer.AnchorPoint = Vector2.new(0, 1)
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

local FooterLayout = Instance.new("UIListLayout")
FooterLayout.FillDirection = Enum.FillDirection.Horizontal
FooterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FooterLayout.Padding = UDim.new(0, 20)
FooterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
FooterLayout.Parent = Footer

-- == 5. ФУНКЦИИ КОМПОНЕНТОВ ==

local function createPage(pageName)
	local Page = Instance.new("Frame")
	Page.Name = pageName
	Page.Size = UDim2.new(1, -20, 1, 0)
	Page.Position = UDim2.new(0, 10, 0, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = PagesContainer

	local Grid = Instance.new("UIGridLayout")
	Grid.CellSize = UDim2.new(0.5, -5, 1, 0)
	Grid.CellPadding = UDim2.new(0, 10, 0, 0)
	Grid.Parent = Page
	return Page
end

local function createColumn(parent, title)
	local ColFrame = Instance.new("Frame")
	ColFrame.BackgroundColor3 = Theme.SectionBG
	ColFrame.BackgroundTransparency = 1 
	ColFrame.Parent = parent
	
	local Line = Instance.new("Frame")
	Line.Size = UDim2.new(1, 0, 0, 2)
	Line.Position = UDim2.new(0, 0, 0, 30)
	Line.BackgroundColor3 = Theme.Accent
	Line.BorderSizePixel = 0
	Line.Parent = ColFrame

	local Label = Instance.new("TextLabel")
	Label.Text = title
	Label.Size = UDim2.new(1, 0, 0, 30)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Theme.TextLight
	Label.Font = Theme.FontBold
	Label.TextSize = 14
	Label.Parent = ColFrame

	local Scroll = Instance.new("ScrollingFrame")
	Scroll.Size = UDim2.new(1, 0, 1, -35)
	Scroll.Position = UDim2.new(0, 0, 0, 35)
	Scroll.BackgroundTransparency = 1
	Scroll.BorderSizePixel = 0
	Scroll.ScrollBarThickness = 3
	Scroll.ScrollBarImageColor3 = Theme.Accent
	Scroll.Parent = ColFrame
	
	local List = Instance.new("UIListLayout")
	List.Padding = UDim.new(0, 5)
	List.Parent = Scroll
	
	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Scroll.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
	end)

	return Scroll
end

local function createToggle(parent, text, settingKey, callback)
	local Frame = Instance.new("Frame")
	Frame.Size = UDim2.new(1, -10, 0, 30)
	Frame.BackgroundTransparency = 1
	Frame.Parent = parent

	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Size = UDim2.new(0.7, 0, 1, 0)
	Label.Position = UDim2.new(0, 5, 0, 0)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Theme.TextDark
	Label.Font = Theme.Font
	Label.TextSize = 13
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Frame

	local Button = Instance.new("TextButton")
	Button.Text = ""
	Button.Size = UDim2.new(0, 14, 0, 14)
	Button.Position = UDim2.new(1, -20, 0.5, 0)
	Button.AnchorPoint = Vector2.new(0, 0.5)
	Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Button.AutoButtonColor = false
	Button.Parent = Frame
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 3)
	Corner.Parent = Button
	
	local Indicator = Instance.new("Frame")
	Indicator.Size = UDim2.new(1, 0, 1, 0)
	Indicator.BackgroundColor3 = Theme.Accent
	Indicator.BackgroundTransparency = 1
	Indicator.Parent = Button
	local IndCorner = Instance.new("UICorner")
	IndCorner.CornerRadius = UDim.new(0, 3)
	IndCorner.Parent = Indicator

	local enabled = _G.CheatSettings[settingKey] or false
	
	local function update()
		if enabled then
			Indicator.BackgroundTransparency = 0
			Label.TextColor3 = Theme.TextLight
		else
			Indicator.BackgroundTransparency = 1
			Label.TextColor3 = Theme.TextDark
		end
		if settingKey then 
			_G.CheatSettings[settingKey] = enabled 
		end
		if callback then callback(enabled) end
	end
	update()
	
	Button.MouseButton1Click:Connect(function()
		enabled = not enabled
		update()
	end)
end

-- == 6. СОЗДАНИЕ КОНТЕНТА ==

local LegitPage = createPage("Legit")
local LegitLeft = createColumn(LegitPage, "AIMBOT")
local LegitRight = createColumn(LegitPage, "SETTINGS")

createToggle(LegitLeft, "Enable Aimbot", "Aimbot")
createToggle(LegitLeft, "Smooth Aim", "Smoothness")
createToggle(LegitLeft, "Only Head", "HeadAim")
createToggle(LegitLeft, "FOV Check", "FOVCheck")
createToggle(LegitLeft, "Visible Check", "AimVisibleCheck")
createToggle(LegitRight, "RCS (Recoil)", nil) 
createToggle(LegitRight, "TriggerBot", nil)

local RagePage = createPage("Rage")
local RageLeft = createColumn(RagePage, "RAGE")
local RageRight = createColumn(RagePage, "SETTINGS")

createToggle(RageLeft, "BunnyHop", "BunnyHop")
createToggle(RageLeft, "Fly", "Fly")
createToggle(RageLeft, "NoClip", "Noclip")
createToggle(RageLeft, "SpeedHack", "SpeedHack", function(state)
	if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)
createToggle(RageRight, "TeleKill", "TeleKill")
createToggle(RageRight, "MassKill", "MassKill")
createToggle(RageRight, "Anti-Aim", "antiaim")
createToggle(RageRight, "Third Person", "thirdperson")
createToggle(RageRight, "Infinity Ammo", "InfAmmo")


local VisualsPage = createPage("Visuals")
local VisLeft = createColumn(VisualsPage, "ESP PLAYERS")
local VisRight = createColumn(VisualsPage, "WORLD")

createToggle(VisLeft, "Enable ESP", "ESP")
createToggle(VisLeft, "Box ESP", "BoxESP")
createToggle(VisLeft, "Tracers", "Tracers")

createToggle(VisRight, "Fullbright", "Fullbright", function(state)
	if state then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	else
		Lighting.Brightness = 1
		Lighting.GlobalShadows = true
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127) 
	end
end)

local SettingsPage = createPage("Settings")
local SetCol = createColumn(SettingsPage, "MENU SETTINGS")

createToggle(SetCol, "Watermark", "Watermark", function(state)
	WatermarkFrame.Visible = state
end)
createToggle(SetCol, "Save Config", nil)

-- == 7. ЛОГИКА ВКЛАДОК ==

local function switchTab(pageInstance, buttonInstance)
	for _, child in pairs(PagesContainer:GetChildren()) do
		if child:IsA("Frame") then child.Visible = false end
	end
	for _, child in pairs(Footer:GetChildren()) do
		if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(80, 80, 80) end
	end
	if pageInstance then pageInstance.Visible = true end
	if buttonInstance then buttonInstance.TextColor3 = Theme.Accent end
end

local function createFooterBtn(icon, linkToPage, isDefault)
	local Btn = Instance.new("TextButton")
	Btn.Text = icon
	Btn.Size = UDim2.new(0, 40, 0, 40)
	Btn.BackgroundTransparency = 1
	Btn.TextSize = 24
	Btn.Font = Enum.Font.Gotham
	Btn.TextColor3 = Color3.fromRGB(80,80,80)
	Btn.Parent = Footer
	Btn.MouseButton1Click:Connect(function() switchTab(linkToPage, Btn) end)
	if isDefault then switchTab(linkToPage, Btn) end
end

createFooterBtn("☠", LegitPage, true)
createFooterBtn("😈", RagePage, false)
createFooterBtn("👁", VisualsPage, false)
createFooterBtn("⚙", SettingsPage, false)

-- == 8. DRAG & TOGGLE ==
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then updateDrag(input) end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then 
		MainFrame.Visible = not MainFrame.Visible 
	end
end)

-- == 9. ЛОГИКА (БЭКЕНД) ==

local function createHollowBox(player)
	if not player.Character then return end
	local box = Instance.new("BoxHandleAdornment")
	box.Name = "PlayerBox"
	box.Size = Vector3.new(4, 5.5, 4)
	box.Color3 = Theme.Accent
	box.Transparency = 0.5
	box.ZIndex = 5
	box.AlwaysOnTop = true
	return box
end

local function isVisible(targetPart, targetCharacter)
	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
	raycastParams.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, raycastParams)

	if result then
		if result.Instance:IsDescendantOf(targetCharacter) then
			return true
		else
			return false
		end
	end
	return true
end

local function getClosestEnemy()
    local closestPart = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            
            local isTeammate = (LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team)
            
            if not isTeammate then
                local targetPart = nil
                
                if _G.CheatSettings.HeadAim then
                    targetPart = p.Character:FindFirstChild("Head")
                else
                    targetPart = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                end
                
                if targetPart then
                	if _G.CheatSettings.AimVisibleCheck then
                		if not isVisible(targetPart, p.Character) then
                			continue 
                		end
                	end

                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distance = (mousePos - Vector2.new(pos.X, pos.Y)).Magnitude
                        if _G.CheatSettings.FOVCheck then
                            if distance <= _G.CheatSettings.FOVRadius then
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    closestPart = targetPart
                                end
                            end
                        else
                            if distance < shortestDistance then
                                shortestDistance = distance
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

local function getClosestEnemyForTeleport()
	local closestRoot = nil
	local shortestDist = math.huge
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local isTeammate = (LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team)
			if not isTeammate then
				local hrp = p.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					local dist = (hrp.Position - myRoot.Position).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						closestRoot = hrp
					end
				end
			end
		end
	end
	return closestRoot
end

RunService.Stepped:Connect(function()
    if _G.CheatSettings.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    
    -- [[ AIMBOT ]]
    if _G.CheatSettings.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestEnemy()
        if target then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
            
            if _G.CheatSettings.Smoothness then
                Camera.CFrame = currentCFrame:Lerp(targetCFrame, 0.2)
            else
                Camera.CFrame = targetCFrame
            end
        end
    end

    -- [[ TELEKILL / MASSKILL ]]
    if _G.CheatSettings.TeleKill or _G.CheatSettings.MassKill then
        local targetRoot = getClosestEnemyForTeleport()
        if targetRoot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3) 
        end
    end
    
    -- [[ INFINITY AMMO (Исправлено) ]]
    if _G.CheatSettings.InfAmmo then
        -- Используем pcall, чтобы скрипт не падал, если интерфейс еще не загрузился
        pcall(function()
            if LocalPlayer.PlayerGui:FindFirstChild("GUI") and 
               LocalPlayer.PlayerGui.GUI:FindFirstChild("Client") and 
               LocalPlayer.PlayerGui.GUI.Client:FindFirstChild("Variables") then
                
                local vars = LocalPlayer.PlayerGui.GUI.Client.Variables
                if vars:FindFirstChild("ammocount") then
                    vars.ammocount.Value = 999
                end
                if vars:FindFirstChild("ammocount2") then
                    vars.ammocount2.Value = 999
                end
            end
        end)
    end

    -- [[ BUNNYHOP ]]
    if _G.CheatSettings.BunnyHop then
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum.Jump = true
            end
        end
    end

    -- [[ SPEEDHACK ]]
    if _G.CheatSettings.SpeedHack then
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 80 
            end
        end
    end
    
    -- [[ ANTI-AIM (SPINBOT + HEAD PITCH) ]]
    if _G.CheatSettings.antiaim then
        if LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local head = LocalPlayer.Character:FindFirstChild("Head")
            
            -- 1. Вращение тела (Yaw)
            if root and hum then
                hum.AutoRotate = false
                local spin = root:FindFirstChild("SpinBotVelocity")
                if not spin then
                    spin = Instance.new("BodyAngularVelocity")
                    spin.Name = "SpinBotVelocity"
                    spin.Parent = root
                    spin.MaxTorque = Vector3.new(0, math.huge, 0)
                    spin.P = 1250
                end
                spin.AngularVelocity = Vector3.new(0, 50, 0)
            end

            -- 2. Вращение головы (Pitch - вверх/вниз)
            if head then
                local neck = head:FindFirstChild("Neck")
                if neck then
                    local pitch = math.sin(tick() * 30) * 1.5 
                    local pos = neck.C0.Position 
                    neck.C0 = CFrame.new(pos) * CFrame.Angles(pitch, 0, 0)
                end
            end
        end
    else
        -- СБРОС Anti-Aim
        if LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local head = LocalPlayer.Character:FindFirstChild("Head")
            
            if root then
                local spin = root:FindFirstChild("SpinBotVelocity")
                if spin then spin:Destroy() end
            end
            
            if hum then
                hum.AutoRotate = true
            end

            if head then
                local neck = head:FindFirstChild("Neck")
                if neck then
                    local pos = neck.C0.Position
                    neck.C0 = CFrame.new(pos) * CFrame.Angles(0, 0, 0)
                end
            end
        end
    end
    
    -- [[ THIRD PERSON ]]
    if _G.CheatSettings.thirdperson then
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMinZoomDistance = 10
        LocalPlayer.CameraMaxZoomDistance = 100
    else
        if LocalPlayer.CameraMinZoomDistance == 10 then
            LocalPlayer.CameraMinZoomDistance = 0.5
            LocalPlayer.CameraMaxZoomDistance = 400
        end
    end

    -- [[ FLY ЛОГИКА ]]
    if _G.CheatSettings.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local bv = root:FindFirstChild("ZenFlyVelocity") or Instance.new("BodyVelocity", root)
        bv.Name = "ZenFlyVelocity"
        bv.MaxForce = Vector3.new(1,1,1) * 1000000 
        
        local bg = root:FindFirstChild("ZenFlyGyro") or Instance.new("BodyGyro", root)
        bg.Name = "ZenFlyGyro"
        bg.MaxTorque = Vector3.new(1,1,1) * 1000000
        bg.P = 10000
        bg.D = 100
        bg.CFrame = Camera.CFrame 

        local flySpeed = 50
        local velocity = Vector3.zero
        local camCF = Camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0, 1, 0) end
        
        bv.Velocity = velocity * flySpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            if root:FindFirstChild("ZenFlyVelocity") then root.ZenFlyVelocity:Destroy() end
            if root:FindFirstChild("ZenFlyGyro") then root.ZenFlyGyro:Destroy() end
        end
    end
    
    -- [[ ESP ]]
    if _G.CheatSettings.ESP then
        for _, p in pairs(Players:GetPlayers()) do
             local isTeammate = (LocalPlayer.Team ~= nil and p.Team == LocalPlayer.Team)
             if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and not isTeammate then
                 if not p.Character:FindFirstChild("PlayerBox") then
                     local box = createHollowBox(p)
                     if box then
                        box.Adornee = p.Character
                        box.Parent = p.Character
                     end
                 end
             else
                 if p.Character and p.Character:FindFirstChild("PlayerBox") then
                     p.Character.PlayerBox:Destroy()
                 end
             end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
             if p.Character and p.Character:FindFirstChild("PlayerBox") then
                 p.Character.PlayerBox:Destroy()
             end
        end
    end
end)

print("ZeninDLC internal Loaded. Press INSERT to toggle.")
