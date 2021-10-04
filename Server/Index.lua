FireworkParticles = {
	"ts-fireworks::PS_TS_Fireworks_Burst_Chrys",
	"ts-fireworks::PS_TS_Fireworks_Burst_Circle",
	"ts-fireworks::PS_TS_Fireworks_Burst_Palm",
	"ts-fireworks::PS_TS_Fireworks_Burst_Shaped",
	"ts-fireworks::PS_TS_Fireworks_Burst_ShellsWithinShells",
}

-- Function to spawn the ToolGun weapon
function FireworkGun(location, rotation)
	local tool_gun = Weapon(location or Vector(), rotation or Rotator(), "nanos-world::SK_FlareGun_Short")

	tool_gun:SetAmmoSettings(10000000, 0)
	tool_gun:SetDamage(0)
	tool_gun:SetSpread(0)
	tool_gun:SetRecoil(0)
	tool_gun:SetSightTransform(Vector(0, 0, -4), Rotator(0, 0, 0))
	tool_gun:SetLeftHandTransform(Vector(0, 1, -5), Rotator(0, 60, 100))
	tool_gun:SetRightHandOffset(Vector(-25, -5, 0))
	tool_gun:SetHandlingMode(HandlingMode.SingleHandedWeapon)
	tool_gun:SetCadence(0.7)
	tool_gun:SetParticlesBarrel("nanos-world::P_Weapon_BarrelSmoke")
	tool_gun:SetParticlesShells("nanos-world::P_Weapon_Shells_762x39")
	tool_gun:SetSoundDry("nanos-world::A_Pistol_Dry")
	tool_gun:SetSoundZooming("nanos-world::A_AimZoom")
	tool_gun:SetSoundAim("nanos-world::A_Rattle")
	tool_gun:SetSoundFire("nanos-world::A_HeavyShot")
	tool_gun:SetAnimationCharacterFire("nanos-world::A_Mannequin_Sight_Fire_Pistol")
	tool_gun:SetCrosshairMaterial("nanos-world::MI_Crosshair_Tee")
	tool_gun:SetUsageSettings(false, false)

	-- Let's subscribe for 'Fire' event from this weapon, this will be triggered for every fire it shoots
	tool_gun:Subscribe("Fire", function(weap, shooter)
		-- We get the position at the front of the weapon
		local control_rotation = shooter:GetControlRotation()
		local forward_vector = control_rotation:GetForwardVector()
		local spawn_location = weap:GetLocation() + Vector(0, 0, 40) + forward_vector * Vector(200)

		-- We will spawn an empty/invisible Prop, to be our projectile - using our Invisible mesh 'SM_None'
		local prop = Prop(spawn_location, control_rotation, "nanos-world::SM_None")

		-- Spawns the trail/shell particle, this particle is not auto destroyed as it should follow the projectile,
		-- this way we must destroy it manually after all
		-- The Asset Pack which we are using to get the particles contains two Shells: 'PS_TS_FireworksShell' and 'PS_TS_FireworksShell_Palm'
		-- You can use the another one to get more cool effects!
		local particle = Particle(Vector(), Rotator(), "ts-fireworks::PS_TS_FireworksShell", false, true)

		-- Attaches the particle to the projectile prop, will be auto destroyed after 1 seconds after the prop is destroyed
		particle:AttachTo(prop, AttachmentRule.SnapToTarget, "", 1)

		-- Impulses the Projectile forward
		prop:AddImpulse(forward_vector * Vector(10000), true)

		-- Calls the client to spawn the 'Launch' sound
		Events.BroadcastRemote("SpawnFireworkSound", particle)

		-- After 1500 miliseconds, explode the firework
		Timer.SetTimeout(function(pr)
			-- Calls the client to spawn the 'Explosion' sound at the projectile location
			Events.BroadcastRemote("ExplodeFireworkSound", pr:GetLocation())

			-- Spawns the Particle Explosion.
			-- This Asset Pack also contains the following Particles, feel free to try them!
			-- 'PS_TS_Fireworks_Burst_Chrys', 'PS_TS_Fireworks_Burst_Circle', 'PS_TS_Fireworks_Burst_Palm',
			-- 'PS_TS_Fireworks_Burst_Shaped' and 'PS_TS_Fireworks_Burst_ShellsWithinShells'
			local particle_asset = FireworkParticles[math.random(#FireworkParticles)]
			local particle_burst = Particle(pr:GetLocation(), Rotator(0, pr:GetRotation().Yaw + 90, 0), particle_asset, true, true)

			-- Destroys the projectile
			pr:Destroy()

			-- Those particles make it available to tweak some of their properties, let's set the BlastColor to red
			particle_burst:SetParameterColor("BlastColor", Color.RandomPalette())
			particle_burst:SetParameterColor("SparkleColor", Color.RandomPalette())
			particle_burst:SetParameterColor("BurstColor", Color.RandomPalette())
			particle_burst:SetParameterBool("BlastSmoke", math.random(0, 1) and true or false)
			particle_burst:SetParameterFloat("BurstMulti", math.random(50, 300) / 100)
			particle_burst:SetParameterFloat("SparkleMulti", math.random(50, 300) / 100)

			-- Those particles exposes the following parameters:
			--  Color: 'BurstColor', 'SparkleColor', 'FlareColor', 'TailColor'
			--  bool: 'BlastSmoke', 'TailSmoke'
			--  float: 'BurstMulti', 'SparkleMulti'
		end, 1500, prop, particle)
	end)

	return tool_gun
end

-- Exports the function to be called by the Sandbox to spawn the Firework Tool
Package.Export("SpawnFireworkGun", FireworkGun)


Package.Subscribe("Load", function()
	-- Adds the Firework Gun to the Sandbox Spawn Menu
	-- Parameters: asset_pack, category, id, package_name, package_function_name
	Package.Call("sandbox", "AddSpawnMenuItem", "ts-fireworks", "tools", "FireworkGun", "ts-fireworks-tools", "SpawnFireworkGun")
	return false
end)
