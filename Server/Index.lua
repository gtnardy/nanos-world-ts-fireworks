Package.Require("Firework.lua")
Package.Require("FireworkGun.lua")


-- Exports the function to be called by the Sandbox to spawn the Firework Tool
Package.Export("SpawnFireworkGun", function(location, rotation)
	return FireworkGun(location, rotation)
end)

Package.Subscribe("Load", function()
	-- Adds the Firework Gun to the Sandbox Spawn Menu
	-- Parameters: asset_pack, category, id, package_name, package_function_name
	Package.Call("sandbox", "AddSpawnMenuItem", "tools", "FireworkGun", Package.GetPath(), "SpawnFireworkGun")
end)