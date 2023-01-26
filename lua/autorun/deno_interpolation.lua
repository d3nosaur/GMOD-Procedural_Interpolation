SecondOrderDynamics = {
    prevPosition = nil,
    currentVelocity = nil,
    interpolatedPosition = nil,
    interpolatedVelocity = nil,
}

function SecondOrderDynamics:UpdateConstants(frequency, dampening, undershot)
    self.k1 = dampening / (math.pi * frequency)
    self.k2 = 1 / ((2 * math.pi * frequency) * (2 * math.pi * frequency))
    self.k3 = (undershot * dampening) / (2 * math.pi * frequency)
end

function SecondOrderDynamics:InitializeVariables(startPos)
    self.prevPosition = startPos
    self.interpolatedPosition = startPos
    self.interpolatedVelocity = Vector(0, 0, 0)
end

function SecondOrderDynamics:Update(dTime, newPos)
    if not currentVelocity then
        self.currentVelocity = (newPos - self.prevPosition) / dTime
        self.prevPosition = newPos
    end

    local stableK2 = math.max(self.k2, 1.1 * ((dTime*dTime/4) + (dTime*self.k1/2)))
    self.interpolatedPosition = self.interpolatedPosition + dTime * self.interpolatedVelocity
    self.interpolatedVelocity = self.interpolatedVelocity + dTime * (newPos + (self.k3 * self.currentVelocity) - self.interpolatedPosition - (self.k1 * self.interpolatedVelocity)) / stableK2

    return self.interpolatedPosition
end

function SecondOrderDynamics:New(obj, frequency, dampening, undershot, startPos)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self

    self:UpdateConstants(frequency, dampening, undershot)
    self:InitializeVariables(startPos)

    return obj
end