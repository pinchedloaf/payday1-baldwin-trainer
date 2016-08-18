if not is_game() then
  return
end

for i = 1,4 do
  if verify_player_id(i) then
    if Network:is_server() then
    IngameWaitingForRespawnState.request_player_spawn(i)
  else
      managers.network:session():server_peer():send("request_spawn_member", i)
  end
  end
end
