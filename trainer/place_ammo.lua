if not is_game() then
  return
end
place_ammo = place_ammo or function()
  local pos, rot = ray_pos()
  if not pos or not rot then
    return
  end
  if Network:is_client() then
	managers.network:session():send_to_host('place_ammo_bag', pos, rot, 5)
  else
    AmmoBagBase.spawn(pos, rot, 5)
  end
end

place_ammo()