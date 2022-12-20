Firework = Prop.Inherit("Firework")

-- This Asset Pack contains the following Particles, feel free to try them!
Firework.particles = {
	"ts-fireworks::PS_TS_Fireworks_Burst_Chrys",
	"ts-fireworks::PS_TS_Fireworks_Burst_Circle",
	"ts-fireworks::PS_TS_Fireworks_Burst_Palm",
	"ts-fireworks::PS_TS_Fireworks_Burst_Shaped",
	"ts-fireworks::PS_TS_Fireworks_Burst_ShellsWithinShells",
}


function Firework:Constructor(location, forward_vector)
	self.Super:Constructor(location or Vector(), Rotator(), "nanos-world::SM_None")

	-- Impulses the Projectile forward
	self:AddImpulse(forward_vector * 10000, true)

	-- After 1500 miliseconds, explode the firework
	Timer.Bind(
		Timer.SetTimeout(function(firework)
			local particle_asset = Firework.particles[math.random(#Firework.particles)]

			-- Calls the client to spawn the 'Explosion' sound and paticle at the projectile location
			firework:BroadcastRemoteEvent("Explode", firework:GetLocation(), firework:GetRotation(), particle_asset)

			-- Destroys the projectile
			firework:Destroy()
		end, 1500, self),
	self)
end