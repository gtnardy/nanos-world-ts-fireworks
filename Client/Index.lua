-- Subscribes to spawn and attach the Firework launch sound
Events:Subscribe("SpawnFireworkSound", function(firework)
    local sound = Sound(Vector(), "TS_Fireworks::A_Firework_Launch", false, true, SoundType.SFX, 1, 1, 400, 100000)
    sound:AttachTo(firework)
end)

-- Subscribes to spawn the Firework explosion sound
Events:Subscribe("ExplodeFireworkSound", function(location)
    Sound(location, "TS_Fireworks::A_Firework_Explosion_Fizz", false, true, SoundType.SFX, 3, 1, 400, 100000)
end)

Package:Subscribe("Load", function()
	-- Adds the default NanosWorld tools
	Package:Call("Sandbox", "AddSpawnMenuItem", {"TS_Fireworks", "tools", "firework_gun", "Firework Gun", "assets/TS_Fireworks/SK_FlareGun.jpg"})
end)
