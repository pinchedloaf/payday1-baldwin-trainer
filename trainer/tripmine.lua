if not is_game() then
  return
end

local player = managers.player:player_unit()
if not player then
  return
end
local from = managers.player:player_unit():movement():m_head_pos()
local to = from + managers.player:player_unit():movement():m_head_rot():y() * (baldwin_config.FarPlacements and 20000 or 200)
local ray = managers.player:player_unit():raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {})
if ray then
  local pos = ray.hit_position
  if Network:is_client() then
    managers.network:session():send_to_host( "attach_device", pos, ray.normal, sensor_upgrade )
  else
    local unit = TripMineBase.spawn(pos, Rotation(ray.normal, math.UP))
  unit:base():set_active( true, player )
  end
end
