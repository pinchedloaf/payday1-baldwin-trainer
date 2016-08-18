if not is_game() then
  return
end

function god_mode(state)
  if not managers.player or not managers.player:player_unit() then
    return
  end
  managers.player:player_unit():character_damage():set_god_mode( state )
end

current_godmode_state = not current_godmode_state

god_mode(current_godmode_state)