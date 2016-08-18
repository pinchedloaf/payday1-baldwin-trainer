if not is_game() then
  return
end

if verify_player_id(1) then
  IngameWaitingForRespawnState.request_player_spawn(1)
end