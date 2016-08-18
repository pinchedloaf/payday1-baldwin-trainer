if baldwin_config.EnableNormalisation and normaliser then
  normaliser:restore_all() --This will literally disable all cheats.
  if is_game() and god_mode then
    god_mode(false)
  end
end