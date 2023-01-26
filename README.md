# GMOD-Procedural_Interpolation
Client side code to interpolate a position value depending on a few constants. 

This could be useful for vehicles, weapon sway, player movement, and various other projects. 
Edit the constants through the c menu properties on the example entity.

If using this demo on a practical project, I recommend removing the net code and initializing the frequency, dampening and undershot values manually. The net code provided is not optimized for server use.

Based on https://www.youtube.com/watch?v=KPoeNZZ6H4s

 
Initialize a dynamics class using:
```lua
-- obj: SecondOrderDynamics table, nullable (initialize constructor using existing object)
-- frequency: float > 0 (how fast the position will be interpolated)
-- dampening: float >= 0 (how fast will the interpolated position return to the target)
-- overshoot: float (whether or not the interpolated position will overshoot the target, negative values add a slingshot charging effect)
-- startPos: Vector
SecondOrderDynamics:New(existingObject, frequency, dampening, overshoot, startPos)
```
Obtain an interpolated vector with:
```lua
-- deltaTime: float (the time between last update and now, usually just FrameTime())
-- newPos: Vector (the new target position)
-- returns: Vector (the new interpolated value)
dynamicsObject:Update(deltaTime, newPos)
```
Update the constants by using:
```lua
-- frequency: float
-- dampening: float
-- overshoot: float
dynamicsObject:UpdateConstants(frequency, dampening, overshoot)
```

 
For an example, look at the visualizer entity code here
https://github.com/d3nosaur/GMOD-Procedural_Interpolation/blob/main/lua/entities/interpolation_visualizer/cl_init.lua
