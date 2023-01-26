ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Procedural Interpolation Visualizer"
ENT.Author			= "Deno"
ENT.Spawnable       = true

ENT.Editable        = true

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Frequency", {KeyName = "Frequency", Edit = {type = "Float", order = 1, min = 0,  max = 5}})
    self:NetworkVar("Float", 1, "Dampening", {KeyName = "Dampening", Edit = {type = "Float", order = 2, min = 0,  max = 1.5}})
    self:NetworkVar("Float", 2, "Undershot", {KeyName = "Undershot", Edit = {type = "Float", order = 3, min = -5, max = 5}})

    if SERVER then
        self:SetFrequency(1)
        self:SetDampening(1)
        self:SetUndershot(0)
    end
end