include('shared.lua')

local ghostEntity = nil

local ghostEntColor = Color(255, 0, 0, 200)

--[[
    Interpolation Math Code
]]--

local prevPos;
local currentVel; -- didn't trust gmods velocity so i just used this instead
local interpolatedPos, interpolatedVel;
local k1, k2, k3; -- three float constants used to interpolate the value, calculated via freq, damp, and undershot

function InitializeConstants(frequency, dampening, undershot) -- initialize the float constants, call this to change the freq, damp, and undershot
    k1 = dampening / (math.pi * frequency)
    k2 = 1 / ((2 * math.pi * frequency) * (2 * math.pi * frequency))
    k3 = undershot * dampening / (2 * math.pi * frequency)
end

function InitializePosVariables(startPos) -- initialize the default position vars for the entity
    prevPos = startPos
    interpolatedPos = startPos
    interpolatedVel = Vector(0, 0, 0)
end

function StabalizeK2(deltaTime) -- if deltatime gets too big k2 can go all fucko and break, this ensures it always gets dampened
    return math.max(k2, 1.1 * (deltaTime*deltaTime/4 + deltaTime*k1/2))
end

function IncrementInterpolation(newPos, deltaTime) -- increments the interpolation towards newPos based on the time passed
    if not currentVel then
        currentVel = (newPos - prevPos) / deltaTime
        prevPos = newPos
    end

    local stableK2 = StabalizeK2(deltaTime)
    interpolatedPos = interpolatedPos + deltaTime * interpolatedVel
    interpolatedVel = interpolatedVel + deltaTime * (newPos + (k3 * currentVel) - interpolatedPos - (k1 * interpolatedVel)) / stableK2

    return interpolatedPos
end

--[[
    Garry's Mod Handling Code
]]--

local prevFreq, prevDamp, prevUndr;

function UpdateGhostEntity(parent)
    if not ghostEntity then
        ghostEntity = ClientsideModel("models/hunter/blocks/cube075x075x075.mdl")
        ghostEntity:Spawn()
        ghostEntity:SetColor(ghostEntColor)
        ghostEntity:SetRenderMode(RENDERMODE_TRANSCOLOR)
    end

    local newPos = IncrementInterpolation(parent:GetPos(), FrameTime())

    ghostEntity:SetPos(newPos)
    ghostEntity:SetAngles(parent:GetAngles())
end

function ENT:Initialize()
    local startPos = self:GetPos()

    local freq = self:GetFrequency()
    local damp = self:GetDampening()
    local undr = self:GetUndershot()

    prevFreq = freq
    prevDamp = damp
    prevUndr = undr

    InitializeConstants(freq, damp, undr)
    InitializePosVariables(startPos)
end

function ENT:Draw()
    self:DrawModel()

    local freq = self:GetFrequency()
    local damp = self:GetDampening()
    local undr = self:GetUndershot()

    if(prevFreq != freq || prevDamp != damp || prevUndr != undr) then
        prevFreq = freq
        prevDamp = damp
        prevUndr = undr

        InitializeConstants(freq, damp, undr)
    end

    UpdateGhostEntity(self)
end

function ENT:OnRemove()
    ghostEntity:Remove()
    ghostEntity = nil
end