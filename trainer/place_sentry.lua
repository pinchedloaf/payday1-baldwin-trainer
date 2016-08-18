if not is_game() then
  return
end

place_sentry = place_sentry or function()
  local pos, rot = ray_pos()
  if not pos or not rot then
    return
  end
  if Network:is_client() and not Global.game_settings.single_player then
    managers.network:session():send_to_host('place_sentry_gun', pos, rot, 3, 3, 0, nil)
  else
    SentryGunBase.spawn(pos,rot,5,5)
  end
end

place_sentry()