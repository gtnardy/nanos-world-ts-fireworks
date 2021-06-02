FireworkParticles = {
	"TS_Fireworks::PS_TS_Fireworks_Burst_Chrys",
	"TS_Fireworks::PS_TS_Fireworks_Burst_Circle",
	"TS_Fireworks::PS_TS_Fireworks_Burst_Palm",
	"TS_Fireworks::PS_TS_Fireworks_Burst_Shaped",
	"TS_Fireworks::PS_TS_Fireworks_Burst_ShellsWithinShells",
}

-- Function to spawn the ToolGun weapon
function FireworkGun(location, rotation)
	local tool_gun = Weapon(
		location or Vector(),
		rotation or Rotator(),
		"NanosWorld::SK_FlareGun_Short",	-- Model
		0,						-- Collision (Normal)
		true,					-- Gravity Enabled
		10000000,				-- Ammo in the Clip
		0,						-- Ammo in the Bag
		10000000,				-- Clip Capacity
		0,						-- Base Damage
		0,						-- Spread
		1,						-- Bullet Count (1 for common weapons, > 1 for shotguns)
		10000000,				-- Ammo to Reload (Ammo Clip for common weapons, 1 for shotguns)
		20000,					-- Max Bullet Distance
		20000,					-- Bullet Speed (visual only)
		Color(),				-- Bullet Color
		0.6,					-- Sight's FOV multiplier
		Vector(0, 0, -13.75),	-- Sight Location
		Rotator(-0.5, 0, 0),	-- Sight Rotation
		Vector(2, -1.5, 0),		-- Left Hand Location
		Rotator(0, 50, 130),	-- Left Hand Rotation
		Vector(-35, -5, 5),		-- Right Hand Offset
		HandlingMode.SingleHandedWeapon,
		0.40,					-- Cadence
		false,					-- Can Hold Use (keep pressing to keep firing, common to automatic weapons)
		false,					-- Need to release to Fire (common to Bows)
		"",						-- Bullet Trail Particle
		"NanosWorld::P_Weapon_BarrelSmoke",					-- Barrel Particle
		"NanosWorld::P_Weapon_Shells_762x39",				-- Shells Particle
		"NanosWorld::A_Pistol_Dry",							-- Weapon's Dry Sound
		"NanosWorld::A_Pistol_Load",						-- Weapon's Load Sound
		"NanosWorld::A_Pistol_Unload",						-- Weapon's Unload Sound
		"NanosWorld::A_AimZoom",							-- Weapon's Zooming Sound
		"NanosWorld::A_Rattle",								-- Weapon's Aiming Sound
		"NanosWorld::A_HeavyShot",							-- Weapon's Shot Sound
		"NanosWorld::AM_Mannequin_Reload_Pistol",			-- Character's Reloading Animation
		"NanosWorld::AM_Mannequin_Sight_Fire_Heavy",		-- Character's Aiming Animation
		"NanosWorld::SM_Glock_Mag_Empty",					-- Magazine Mesh
		CrosshairType.Tee
	)

	-- Let's subscribe for 'Fire' event from this weapon, this will be triggered for every fire it shoots
	tool_gun:Subscribe("Fire", function(weap, shooter)
		-- We get the position at the front of the weapon
		local control_rotation = shooter:GetControlRotation()
		local forward_vector = control_rotation:GetForwardVector()
		local spawn_location = weap:GetLocation() + Vector(0, 0, 40) + forward_vector * Vector(200)

		-- We will spawn an empty/invisible Prop, to be our projectile - using our Invisible mesh 'SM_None'
		local prop = Prop(spawn_location, control_rotation, "NanosWorld::SM_None")

		-- Spawns the trail/shell particle, this particle is not auto destroyed as it should follow the projectile,
		-- this way we must destroy it manually after all
		-- The Asset Pack which we are using to get the particles contains two Shells: 'PS_TS_FireworksShell' and 'PS_TS_FireworksShell_Palm'
		-- You can use the another one to get more cool effects!
		local particle = Particle(Vector(), Rotator(), "TS_Fireworks::PS_TS_FireworksShell", false, true)

		-- Attaches the particle to the projectile prop
		particle:AttachTo(prop)

		-- Impulses the Projectile forward
		prop:AddImpulse(forward_vector * Vector(10000), true)

		-- Sets the shooter to be the Network Authority of this Projectile for the next 1000 miliseconds
		-- This way only the shooter will be reponsible to handle the physics of this object (for 1 second)
		prop:SetNetworkAuthority(shooter:GetPlayer(), 1000)

		-- Calls the client to spawn the 'Launch' sound
		Events:BroadcastRemote("SpawnFireworkSound", {particle})

		-- After 500 miliseconds, explode the firework
		Timer:SetTimeout(1500, function(pr)
			-- Calls the client to spawn the 'Explosion' sound at the projectile location
			Events:BroadcastRemote("ExplodeFireworkSound", {pr:GetLocation()})

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

			return false
		end, {prop, particle})

		-- After 2500 miliseconds, destroy the particle (so the trail can keep a little bit longer)
		Timer:SetTimeout(2500, function(pa)
			pa:Destroy()
			return false
		end, {particle})
	end)

	return tool_gun
end

-- Exports the function to be called by the Sandbox to spawn the Firework Tool
Package:Export("SpawnFireworkGun", FireworkGun)

-- Waits 100 ms so the Sandbox can be loaded first
Timer:SetTimeout(100, function()
	-- Adds the Firework Gun to the Sandbox Spawn Menu
	-- Parameters: asset_pack, category, id, package_name, package_function_name
	Package:Call("Sandbox", "AddSpawnMenuItem", {"TS_Fireworks", "tools", "FireworkGun", "nanos-world-ts-fireworks", "SpawnFireworkGun"})
	return false
end)
