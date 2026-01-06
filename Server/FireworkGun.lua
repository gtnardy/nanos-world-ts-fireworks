FireworkGun = Weapon.Inherit("FireworkGun")

function FireworkGun:Constructor(location, rotation)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "nanos-world::SK_FlareGun_Short")

	self:SetAmmoSettings(10000000, 0)
	self:SetDamage(0)
	self:SetSpread(0)
	self:SetRecoil(0)
	self:SetSightTransform(Vector(0, 0, -4), Rotator(0, 0, 0))
	self:SetLeftHandTransform(Vector(0, 1, -5), Rotator(0, 60, 100))
	self:SetRightHandOffset(Vector(-25, -5, 0))
	self:SetHandlingMode(HandlingMode.SingleHandedWeapon)
	self:SetCadence(0.7)
	self:SetParticlesBarrel("nanos-world::P_Weapon_BarrelSmoke")
	self:SetParticlesShells("nanos-world::P_Weapon_Shells_762x39")
	self:SetSoundDry("nanos-world::A_Pistol_Dry")
	self:SetSoundZooming("nanos-world::A_AimZoom")
	self:SetSoundAim("nanos-world::A_Rattle")
	self:SetSoundFire("nanos-world::A_HeavyShot")
	self:SetAnimationCharacterFire("nanos-world::A_Mannequin_Sight_Fire_Pistol")
	self:SetCrosshairMaterial("nanos-world::MI_Crosshair_Tee")
	self:SetUsageSettings(false, false)
end

function FireworkGun:OnFire(character)
	-- We get the position at the front of the weapon
	local control_rotation = character:GetControlRotation()
	local forward_vector = control_rotation:GetForwardVector()
	local spawn_location = self:GetLocation() + Vector(0, 0, 40) + forward_vector * 100

	-- Spawns the Firework entity
	local firework = Firework(spawn_location, Rotator(0, control_rotation.Yaw - 90, 0), forward_vector)
end

-- Let's subscribe for 'Fire' event from this weapon, this will be triggered for every fire it shoots
FireworkGun.SubscribeRemote("Fire", FireworkGun.OnFire)
