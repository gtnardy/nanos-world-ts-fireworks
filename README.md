# TS Fireworks Tools

A Firework Gun and Firework entity using the beautiful TS Fireworks assets. Shoot colorful fireworks into the sky with random bursts, colors and sounds.

Made to work with [Sandbox](https://github.com/nanos-world/nanos-world-sandbox): the Firework Gun shows up in the Spawn Menu under the Tools tab. It is also a great example of how to create a custom Weapon and Prop with networked effects.


## Features

- **Firework Gun**: a flare gun that launches fireworks where you aim
- **Firework**: a projectile that flies with a trail and explodes after 1.5 seconds
- 5 different burst particles (Chrysanthemum, Circle, Palm, Shaped and Shells within Shells)
- Random colors, smoke and intensity on every explosion
- Launch and explosion sounds


## Requirements

- Asset Pack: `ts-fireworks` (loaded automatically)


## Installation

Load it together with Sandbox in your server `Config.toml`:

```toml
[game]
    game_mode = "sandbox"
    packages = [
        "ts-fireworks",
    ]
```


## Usage

This package exposes the `FireworkGun` and `Firework` classes (server side):

```lua
-- Spawns a Firework Gun on the ground
local gun = FireworkGun(Vector(100, 200, 300), Rotator())

-- Launches a Firework: Firework(location, rotation, forward_vector)
local firework = Firework(Vector(0, 0, 100), Rotator(), Vector(0, 0, 1))
```


## Examples

Give everyone a Firework Gun:

```lua
for _, character in pairs(Character.GetAll()) do
	character:PickUp(FireworkGun(Vector(), Rotator()))
end
```

A fireworks show every 30 seconds:

```lua
Timer.SetInterval(function()
	for i = 1, 10 do
		local location = Vector(math.random(-1000, 1000), math.random(-1000, 1000), 100)
		local direction = Vector(math.random(-20, 20) / 100, math.random(-20, 20) / 100, 1)
		Firework(location, Rotator(), direction)
	end
end, 30000)
```
