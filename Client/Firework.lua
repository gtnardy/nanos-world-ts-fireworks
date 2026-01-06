Firework = Prop.Inherit("Firework")

function Firework:OnSpawn()
	-- Spawns the trail/shell particle, this particle is not auto destroyed as it should follow the projectile,
	-- this way we must destroy it manually after all
	-- The Asset Pack which we are using to get the particles contains two Shells: 'PS_TS_FireworksShell' and 'PS_TS_FireworksShell_Palm'
	-- You can use the another one to get more cool effects!
	local particle = Particle(Vector(), Rotator(), "ts-fireworks::PS_TS_FireworksShell", false, true)

	-- Attaches the particle to the projectile prop, will be auto destroyed after 1 seconds after the prop is destroyed
	particle:AttachTo(self, AttachmentRule.SnapToTarget, "", 1)

	local sound = Sound(Vector(), "ts-fireworks::A_Firework_Launch_Cue", false, true, SoundType.SFX, 1, 1.5, 400, 100000)
	sound:AttachTo(self)
end

-- Subscribes to spawn the Firework explosion sound
function Firework:OnExplode(location, rotation, particle_asset)
	-- Doesn't explode if it's in water
	if (self:IsInWater()) then
		return
	end

	-- Explosion sound
	Sound(location, "ts-fireworks::A_Firework_Explosion_Fizz_Cue", false, true, SoundType.SFX, 3, 1, 400, 100000)

	-- Spawns the Particle Explosion.
	local particle_burst = Particle(location, Rotator(0, rotation.Yaw, 0), particle_asset, true, true)

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
end

Firework.Subscribe("Spawn", Firework.OnSpawn)
Firework.SubscribeRemote("Explode", Firework.OnExplode)