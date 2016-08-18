if not is_game() then
  return
end

local function nukeunit(unit)
	local col_ray = { }
	col_ray.ray = Vector3(1, 0, 0)
	col_ray.position = unit:position()
	local action_data = {}
	action_data.variant = "explosion"
	action_data.damage = 10000
	action_data.attacker_unit = managers.player:player_unit()
	action_data.col_ray = col_ray
	unit:character_damage():damage_explosion(action_data)
end
for u_key,u_data in pairs(managers.enemy:all_civilians()) do
  nukeunit(u_data.unit)
end
for u_key,u_data in pairs(managers.enemy:all_enemies()) do
  nukeunit(u_data.unit)
end