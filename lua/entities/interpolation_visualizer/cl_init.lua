include('shared.lua')

local ghostEntColor = Color(255, 0, 0, 200)

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

function ENT:CreateGhostEntity()
    self.ghostEnt = ClientsideModel("models/hunter/blocks/cube075x075x075.mdl")
    self.ghostEnt:Spawn()
    self.ghostEnt:SetColor(ghostEntColor)
    self.ghostEnt:SetRenderMode(RENDERMODE_TRANSCOLOR)
end

function ENT:UpdateGhostEntity()
    local newPos = self.positionDynamics:Update(FrameTime(), self:GetPos())

    self.ghostEnt:SetPos(newPos)
    self.ghostEnt:SetAngles(self:GetAngles())
end

function ENT:Initialize()
    local freq = self:GetFrequency()
    local damp = self:GetDampening()
    local ovrs = self:GetOvershoot()

    self.prevFreq = freq
    self.prevDamp = damp
    self.prevOvrs = ovrs

    self.positionDynamics = SecondOrderDynamics:New(nil, freq, damp, ovrs, self:GetPos())

    self:CreateGhostEntity()
end

function ENT:Draw()
    self:DrawModel()

    local freq = self:GetFrequency()
    local damp = self:GetDampening()
    local ovrs = self:GetOvershoot()

    if(self.prevFreq != freq || self.prevDamp != damp || self.prevOvrs != ovrs) then
        self.prevFreq = freq
        self.prevDamp = damp
        self.prevOvrs = ovrs

        self.positionDynamics:UpdateConstants(freq, damp, ovrs)
    end

    self:UpdateGhostEntity()
end

function ENT:OnRemove()
    self.ghostEnt:Remove()
end