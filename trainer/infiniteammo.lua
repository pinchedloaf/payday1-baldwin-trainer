RaycastWeaponBase.__fire = normaliser:backup('RaycastWeaponBase.fire', nil, true)

__infinite_ammo = not __infinite_ammo

function RaycastWeaponBase:fire(from_pos, direction, dmg_mul, shoot_player)
    if not __infinite_ammo then
	  return self:__fire(from_pos, direction, dmg_mul, shoot_player)
	end
	local user_unit = self._setup.user_unit
	self:_check_ammo_total(user_unit)
	World:effect_manager():spawn(self._muzzle_effect_table)
	local ray_res = self:_fire_raycast(user_unit, from_pos, direction, dmg_mul, shoot_player)
	if self._alert_events and ray_res.rays then
		self:_check_alert(ray_res.rays, from_pos, direction, user_unit)
	end
	return ray_res
end