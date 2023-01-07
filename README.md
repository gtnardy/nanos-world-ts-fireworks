# nanos-world-ts-fireworks

nanos world Firework Tool using TS Fireworks assets


This Package exposes the `Firework` and `FireworkGun` classes, which you can spawn like:

```lua
local forward_vector = Vector(1, 0, 0)
local my_firework = Firework(Vector(100, 200, 300), forward_vector)

local my_firework_gun = FireworkGun(Vector(100, 200, 300), Rotator(0, 0, 0))
```