if not is_game() then
  return
end
place_medkit = place_medkit or function()
  local pos, rot = ray_pos()
  if not pos or not rot then
    return
  end
  if Network:is_client() then
	managers.network:session():send_to_host('place_doctor_bag', pos, rot, 5)
  else
	DoctorBagBase.spawn(pos, rot, 5)
  end
end

place_medkit()