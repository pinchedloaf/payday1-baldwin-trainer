if not is_game() then
  return
end

if managers.network.game and Network:is_server() then
  managers.network:game():spawn_players()
end