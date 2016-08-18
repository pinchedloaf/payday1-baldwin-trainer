__extreme_shooting = not __extreme_shooting

if not __extreme_shooting and not baldwin_config.ExtremeFirerateUnstable then
  normaliser:restore('RaycastWeaponBase.trigger_held', nil, true)
  normaliser:restore('RaycastWeaponBase.trigger_pressed', nil, true)
  --normaliser:restore('RaycastWeaponBase.fire_mode', nil, true)
  return
end

if not baldwin_config.ExtremeFirerateUnstable then
  normaliser:backup('RaycastWeaponBase.trigger_held', nil, true)
  normaliser:backup('RaycastWeaponBase.trigger_pressed', nil, true)
  --normaliser:backup('RaycastWeaponBase.fire_mode', nil, true)
end

function RaycastWeaponBase:trigger_held(...)
  return self:fire( ... )
end


function RaycastWeaponBase:trigger_pressed(...)
  return self:fire(...)
end

if baldwin_config.ExtremeFirerateUnstable then

function RaycastWeaponBase:fire_mode()
  return "auto"
end

end