Package.Require("Firework.lua")


Package.Subscribe("Load", function()
	Package.Call("sandbox", "AddSpawnMenuItem", "tools", "FireworkGun", "Firework Gun", "assets://nanos-world/Thumbnails/SK_FlareGun.jpg")
end)
