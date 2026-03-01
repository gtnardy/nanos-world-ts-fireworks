Firework = Prop.Inherit("Firework")

-- This Asset Pack contains the following Particles, feel free to try them!
Firework.particles = {
	"ts-fireworks::PS_TS_Fireworks_Burst_Chrys",
	"ts-fireworks::PS_TS_Fireworks_Burst_Circle",
	"ts-fireworks::PS_TS_Fireworks_Burst_Palm",
	"ts-fireworks::PS_TS_Fireworks_Burst_Shaped",
	"ts-fireworks::PS_TS_Fireworks_Burst_ShellsWithinShells",
}


function Firework:Constructor(location, rotation, forward_vector)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "nanos-world::SM_None", CollisionType.StaticOnly, true, GrabMode.Disabled)

	-- Impulses the Projectile forward
	self:AddImpulse(forward_vector * 10000, true)

	-- After 1500 milliseconds, explode the firework
	Timer.Bind(
		Timer.SetTimeout(function()
			local particle_asset = Firework.particles[math.random(#Firework.particles)]

			-- Calls the client to spawn the 'Explosion' sound and particle at the projectile location
			self:BroadcastRemoteEvent("Explode", self:GetLocation(), rotation, particle_asset)

			-- Destroys the projectile
			self:Destroy()
		end, 1500),
	self)
end