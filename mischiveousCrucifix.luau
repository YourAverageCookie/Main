require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("Warning : script incompatible with crucifix on anything",true)
wait(3)
require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("YOU SHOULD STOP CALLING THIS RED CRUCIFIX , ITS MISCHIEVOUS CRUCIFIX",true)
-- the script is open source , doors only supported
_G.Uses = 414141414141
_G.Range = 30
_G.OnAnything = true
_G.Fail = false
_G.Variant = "Electric"
loadstring(game:HttpGet('https://raw.githubusercontent.com/PenguinManiack/Crucifix/main/Crucifix.lua'))()
wait(0.4)

local function setRedProperties(object)
    if object:IsA("BasePart") then
        object.Color = Color3.fromRGB(255, 0, 0)
        if object.Name == "Base" then
            local decal1 = Instance.new("Decal")
            decal1.Texture = "rbxassetid://87574334780421"
            decal1.Parent = object
            local decal2 = decal1:Clone()
            decal2.Texture = "rbxassetid://75468531252659"
            decal2.Parent = object

            for _, face in pairs(Enum.NormalId:GetEnumItems()) do
                local decalClone1 = decal1:Clone()
                decalClone1.Face = face
                decalClone1.Parent = object

                local decalClone2 = decal2:Clone()
                decalClone2.Face = face
                decalClone2.Parent = object
            end

            local particleEmitter = Instance.new("ParticleEmitter")
            particleEmitter.Texture = "rbxassetid://74695235577665"
            particleEmitter.Rate = 50
            particleEmitter.Speed = NumberRange.new(20, 40)
            particleEmitter.Lifetime = NumberRange.new(1, 2)
            particleEmitter.SpreadAngle = Vector2.new(360, 360)
            particleEmitter.Parent = object

            delay(5.5, function()
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local goal = {Transparency = 1}
                local tween = game:GetService("TweenService"):Create(decal2, tweenInfo, goal)
                tween:Play()
                tween.Completed:Connect(function()
                    decal2:Destroy()
                end)
            end)

            delay(5.9, function()
                local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local goal = {Transparency = 1}
                local tween = game:GetService("TweenService"):Create(decal1, tweenInfo, goal)
                tween:Play()
                tween.Completed:Connect(function()
                    decal1:Destroy()
                    particleEmitter:Destroy()
                    local explosion = Instance.new("Explosion")
                    explosion.BlastRadius = 15
                    explosion.BlastPressure = 75000
                    explosion.Position = object.Position
                    explosion.Parent = workspace

                    explosion.Hit:Connect(function(hit)
                        local humanoid = hit.Parent:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                        end
                    end)

                    local explosionSound = Instance.new("Sound", object)
                    explosionSound.SoundId = "rbxassetid://5801257793"
                    explosionSound.Volume = 7.5
                    explosionSound:Play()

                    local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
                    local frame = Instance.new("Frame", gui)
                    frame.Size = UDim2.new(1.5, 0, 1.5, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    frame.BackgroundTransparency = 0.7

                    game:GetService("TweenService"):Create(
                        frame,
                        TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}
                    ):Play()

                    wait(5.5)
                    gui:Destroy()

                    if game.ReplicatedStorage:FindFirstChild("GameStats") then
                        if game.ReplicatedStorage.GameStats:FindFirstChild("Player_"..game.Players.LocalPlayer.Name) then
                            game.ReplicatedStorage.GameStats["Player_"..game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Mischievious Light"
                        end
                    end
                end)
            end)
        end
    elseif object:IsA("Light") then
        object.Color = Color3.fromRGB(255, 0, 0)
    elseif object:IsA("ParticleEmitter") then
        object.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    elseif object:IsA("Decal") or object:IsA("Texture") then
        object.Color3 = Color3.fromRGB(255, 0, 0)
    elseif object:IsA("Attachment") then
        local parent = object.Parent
        if parent:IsA("BasePart") then
            parent.Color = Color3.fromRGB(255, 0, 0)
        end
    elseif object:IsA("MeshPart") or object:IsA("SpecialMesh") then
        object.VertexColor = Vector3.new(1, 0, 0)
    elseif object:IsA("Beam") then
        object.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    end
end

local function replaceCrucifixSounds(crucifix)
    local glow = crucifix:FindFirstChild("Glow")
    if glow then
        local soundFail = glow:FindFirstChild("SoundFail")
        if soundFail and soundFail:IsA("Sound") then
            for _, obj in pairs(crucifix:GetDescendants()) do
                if obj:IsA("Sound") and obj ~= soundFail then
                    obj:Stop()
                end
            end
            soundFail.Looped = false
            soundFail.Volume = 1
            soundFail:Play()

            local extraSound = Instance.new("Sound", glow)
            extraSound.SoundId = "rbxassetid://107674700312648"
            extraSound.Volume = 10
            extraSound:Play()

            local particleEmitter = Instance.new("ParticleEmitter")
            particleEmitter.Texture = "rbxassetid://74695235577665"
            particleEmitter.Rate = 50
            particleEmitter.Speed = NumberRange.new(20, 40)
            particleEmitter.Lifetime = NumberRange.new(1, 2)
            particleEmitter.SpreadAngle = Vector2.new(360, 360)
            particleEmitter.Parent = glow
        end
    end
end

local function modifyEverythingInModel(targetModel)
    for _, obj in pairs(targetModel:GetDescendants()) do
        setRedProperties(obj)
    end
end

local function checkAndModifyRepentanceModel(object)
    if object:IsA("Model") and object.Name == "Repentance" then
        local pentagram = object:FindFirstChild("Pentagram")
        if pentagram and pentagram:IsA("Model") then
            modifyEverythingInModel(pentagram)
        end

        local crucifix = object:FindFirstChild("Crucifix")
        if crucifix and crucifix:IsA("Model") then
            modifyEverythingInModel(crucifix)
            replaceCrucifixSounds(crucifix)
        end
    end
end

local function applyCrucifixToolTexture()
    local crucifixTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Crucifix")
    if crucifixTool and crucifixTool:IsA("Tool") then
        crucifixTool.TextureId = "rbxassetid://122333399537225"
    end
end

applyCrucifixToolTexture()

for _, obj in pairs(game:GetDescendants()) do
    checkAndModifyRepentanceModel(obj)
end

game.DescendantAdded:Connect(function(obj)
    checkAndModifyRepentanceModel(obj)
end)
