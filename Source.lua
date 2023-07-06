if not game.Loaded then
	game.Loaded:Wait()
end

local Gui

if not getfenv().Gui then
    Gui = Instance.new("ScreenGui")
    getfenv().Gui = Gui
else
    Gui:Destroy()
    getfenv().Gui = Instance.new("ScreenGui")
end

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new(Color3.new(0.584314, 0, 1),Color3.new(0,0,0))
local versionLabel = Instance.new("TextLabel")
local template = Instance.new("TextButton")
local credits = Instance.new("TextLabel")
local frame = Instance.new("Frame")
local commandsframe = Instance.new("ScrollingFrame")
local tweenservice = game:GetService("TweenService")
local title = Instance.new("TextLabel")
local twinfo = TweenInfo.new(1, Enum.EasingStyle.Exponential)
local Close = tweenservice:Create(frame, twinfo, { Size = UDim2.new(0, 0, 0, 0) })
local Open = tweenservice:Create(frame, twinfo, {Size = UDim2.new(0, 347,0, 306) })
local uiLayout = Instance.new("UIGridLayout")

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local uiElements = {frame,commandsframe,}

local IsOpen = false

local function getCurrentVersion()
	-- Code to retrieve the current version dynamically
	return "1.2.5"
end

function setUp()

	for i, v in ipairs(uiElements) do
		uiGradient:Clone().Parent = v
	end

	Gui.Parent = game.CoreGui
    Gui.Name = randomString()

	frame.Parent = Gui
	frame.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
	frame.Position = UDim2.new(-0.013, 10,0.405, -100)
	frame.Size = UDim2.new(0, 0,0,0)
	frame.ClipsDescendants = true
    frame.Name = randomString()

	commandsframe.Parent = frame
	commandsframe.BackgroundTransparency = 1
	commandsframe.Position = UDim2.new(0, 10, 0.1, 0)
	commandsframe.Size = UDim2.new(0.6, 0, 0.8, 0)
	commandsframe.ScrollBarThickness = 0
    commandsframe.Name = randomString()

	uiLayout.Parent = commandsframe
	uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Name = randomString()

	title.Parent = frame
	title.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
	title.Position = UDim2.new(0, 10,-0.001, 0)
	title.Size = UDim2.new(0.9, 0, 0.1, 0)
	title.FontSize = Enum.FontSize.Size24
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Text = "The Great Commands"
	title.Name = randomString()

	versionLabel.Parent = title
	versionLabel.Text = "Version: " .. getCurrentVersion()
	versionLabel.BackgroundTransparency = 1
	versionLabel.Position = UDim2.new(0.696, 0,1.347, 0)
	versionLabel.Size = UDim2.new(0.281, 0,0.898, 0)
	versionLabel.Name = randomString()
	versionLabel.FontSize = Enum.FontSize.Size14
	versionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	versionLabel.TextScaled = true

	credits.Parent = title
	credits.Text = "Made by: BRUSDHDFhd"
	credits.BackgroundTransparency = 1
	credits.Size = UDim2.new(0.929, 0,0.702, 0)
	credits.Position = UDim2.new(0.069, 0,9.298, 0)
	credits.Name = randomString()
	credits.FontSize = Enum.FontSize.Size14
	credits.TextColor3 = Color3.fromRGB(255, 255, 255)
	credits.TextScaled = true
end

function OpenClose()
	if IsOpen then
		Close:Play()
	else
		Open:Play()
	end
	IsOpen = not IsOpen
end

local commands = {
    KillPlayer = function()
        game.Players.LocalPlayer.Character.Humanoid.Health -= 99999999999999999999
    end,
    Ragdoll = function()
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(0)
    end,
    SaveGame = function()
        game.Players.LocalPlayer:SaveInstance("game", game)
    end,
    RandomPlayerTp = function()
        local players = game.Players:GetPlayers()
        local picked = players[math.random(1, #players)]
        game.Players.LocalPlayer.Character:PivotTo(picked.Character.HumanoidRootPart.CFrame)
    end,
    Explode = function()
        local explosion = Instance.new("Explosion")
        explosion.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        explosion.BlastRadius = 10
        explosion.Parent = game.Workspace
    end,
    headlessDeath = function ()
        local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
        if head:IsA("BasePart") then
            head:BreakJoints()
            head.AssemblyLinearVelocity = Vector3.new(0,20,-10)
            head.AssemblyAngularVelocity = Vector3.new(550,0,0)
        end
    end,
    lookatNearestTorso = function ()
        local closestTorso = nil
        local closestDistance = math.huge
        for _,v in ipairs(workspace:GetDescendants()) do
            if v.Name == "Torso" and v:IsA("BasePart") then
                local distance = (game.Players.LocalPlayer.Character.Torso.Position - v.Position).Magnitude
                if closestDistance > distance then
                    closestTorso = v
                    closestDistance = distance
                end
            end
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.lookAt(game.Players.LocalPlayer.Character.HumanoidRootPart.Position,closestTorso.Position)
    end,
    -- Additional commands
    TeleportToSpawn = function()
        local spawn = game:GetService("Workspace").SpawnLocation
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame
    end,
    GodMode = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end,
    Fly = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local fly = character and character:FindFirstChild("FlyVelocity")

        if not fly then
            fly = Instance.new("BodyVelocity")
            fly.Velocity = Vector3.new(0, 0, 0)
            fly.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            fly.Name = "FlyVelocity"
            fly.Parent = character.HumanoidRootPart
            humanoid.PlatformStand = true

            -- Bind keys for movement
            local keysPressed = {}
            local function onKeyPress(input)
                keysPressed[input.KeyCode] = true
            end
            local function onKeyRelease(input)
                keysPressed[input.KeyCode] = nil
            end
            game:GetService("UserInputService").InputBegan:Connect(onKeyPress)
            game:GetService("UserInputService").InputEnded:Connect(onKeyRelease)

            -- Start the fly loop
            while fly.Parent do
                local
velocity = Vector3.new(0, 0, 0)
                if keysPressed[Enum.KeyCode.W] then
                    velocity = velocity + character.HumanoidRootPart.CFrame.LookVector * 50
                end
                if keysPressed[Enum.KeyCode.A] then
                    velocity = velocity - character.HumanoidRootPart.CFrame.RightVector * 50
                end
                if keysPressed[Enum.KeyCode.S] then
                    velocity = velocity - character.HumanoidRootPart.CFrame.LookVector * 50
                end
                if keysPressed[Enum.KeyCode.D] then
                    velocity = velocity + character.HumanoidRootPart.CFrame.RightVector * 50
                end
                fly.Velocity = velocity
                game:GetService("RunService").Heartbeat:Wait()
            end
        else
            fly:Destroy()
            humanoid.PlatformStand = false
        end
    end,
    -- More additional commands
    Noclip = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local noclip = character and character:FindFirstChild("Noclip")

        if not noclip then
            noclip = Instance.new("BoolValue")
            noclip.Name = "Noclip"
            noclip.Parent = character

            local function onCharacterAdded(char)
                noclip.Parent = char
            end
            player.CharacterAdded:Connect(onCharacterAdded)

            local function onPartTouched(otherPart)
                local otherCharacter = otherPart.Parent
                if otherCharacter and otherCharacter:IsA("Model") and otherCharacter ~= character then
                    for _, part in ipairs(otherCharacter:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
            character:GetDescendants()[1].Touched:Connect(onPartTouched)

            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            noclip:Destroy()
        end
    end,
    SuperJump = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            wait()
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            humanoid.JumpPower = 50
        end
    end,
    InfiniteJump = function()
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        mouse.KeyDown:Connect(function(key)
            if key == "space" then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                wait()
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
    end,
    Speed = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = tonumber(value) or 16
        end
    end,
}

function addCmd(name, func)
	local command = template:Clone()
	command.Parent = commandsframe
	command.BackgroundColor3 = Color3.fromRGB(86, 86, 86)
	command.BorderSizePixel = 0
	command.Position = UDim2.new(0.5, -50, 0, 0)
	command.Size = UDim2.new(0, 100, 0, 50)
	command.TextColor3 =  Color3.fromRGB(255, 255, 255)
	command.FontSize = Enum.FontSize.Size14
	command.TextScaled = true
	command.Text = name

	command.MouseButton1Click:Connect(function()
		func()
	end)
end

function createCommands()
	for name, func in pairs(commands) do
		addCmd(name, func)
	end
end

setUp()
createCommands()

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.X then
		OpenClose()
	end
end)

OpenClose()
