if not is_game() then
  return
end

function set_mask_off()
  if not managers.player or not managers.player:player_unit() then
    return
  end
  managers.player:set_player_state('mask_off')
end

set_mask_off()