require 'config'
require 'trainer/origbackuper'

normaliser = normaliser or Backuper:new('normaliser')

if not baldwin_config then
  error('config.lua isn\' loaded!')
end

if baldwin_config.EnableDebug then
  core:import( "CoreFreeFlight" )
  Global.DEBUG_MENU_ON = true
end

if baldwin_config.EnableDLC then
  for dlc_name, dlc_data in pairs( Global.dlc_manager.all_dlc_data ) do
  dlc_name = { app_id = "24240", no_install = true }
  dlc_data.verified = true
  end
end

if baldwin_config.EnableNameSpoof then
  --normaliser:backup('rawget(getmetatable(Application),"username")') --Are you sure you want to make namespoof normalisable ?
  rawset(getmetatable(Steam),'username',function() return baldwin_config.name or "Bodhi" end)
end

function is_game()
  if not game_state_machine then
    return
  end
  local any_ingame = {
    ingame_standard = true,
    ingame_mask_off = true,
    ingame_clean = true,
    ingame_bleed_out = true,
    ingame_fatal = true,
    ingame_arrested = true,
    ingame_incapacitated = true,
    ingame_waiting_for_players = true,
    ingame_waiting_for_respawn = true,
    ingame_access_camera = true,
  }
  return any_ingame[game_state_machine:last_queued_state_name()]
end

if baldwin_config.AllMasks then

--normaliser:backup('NetworkAccountSTEAM.has_mask') --Do we really need to normalise that ? If you think yes, just uncomment this line.
function NetworkAccountSTEAM:has_mask(...) --All masks
  return true
end

end

if baldwin_config.DisablePause then

normaliser:backup('NetworkGame.load')
function NetworkGame:load(game_data) --Pause patch
  if managers.network:session():is_client() then
    Network:set_client(managers.network:session():server_peer():rpc())
  end
  if game_data then
    for k,v in pairs(game_data.members) do
      self._members[k] = NetworkMember:new()
      self._members[k]:load(v)
    end
  end
end

normaliser:backup('NetworkGame.on_drop_in_pause_request_recieved')
function NetworkGame:on_drop_in_pause_request_received( peer_id, nickname, state )
    print( "[NetworkGame:on_drop_in_pause_request_received]", peer_id, nickname, state )
    local status_changed = false
    local is_playing = BaseNetworkHandler._gamestate_filter.any_ingame_playing[ game_state_machine:last_queued_state_name() ]
    if state then
      if not managers.network:session():closing() then
        status_changed = true
        self._dropin_pause_info[ peer_id ] = nickname
        --if is_playing then
        --managers.menu:show_person_joining( peer_id, nickname )
        --end
      end
      elseif self._dropin_pause_info[ peer_id ] then
        status_changed = true
        if peer_id == managers.network:session():local_peer():id() then
          self._dropin_pause_info[ peer_id ] = nil
          managers.menu:close_person_joining( peer_id )
        else
          self._dropin_pause_info[ peer_id ] = nil
          managers.menu:close_person_joining( peer_id )
        end
                end
  
      if status_changed then
        if state then
          if not managers.network:session():closing() then
            if table.size( self._dropin_pause_info ) == 1 then
              managers.hud:show_hint( { text = managers.localization:text( "dialog_dropin_title", { USER = string.upper( nickname ) } ) } )
              --print( "DROP-IN PAUSE" )
              --Application:set_pause( true )
              --SoundDevice:set_rtpc( "ingame_sound", 0 ) -- mute gameplay sounds
            end
          if Network:is_client() then
            managers.network:session():send_to_host( "drop_in_pause_confirmation", peer_id )
          end
        end
      elseif not next( self._dropin_pause_info ) then
        print( "DROP-IN UNPAUSE" )
        --Application:set_pause( false )
        --SoundDevice:set_rtpc( "ingame_sound", 1 ) -- unmute gameplay sounds
      else
        print( "MAINTAINING DROP-IN UNPAUSE. # dropping peers:", table.size( self._dropin_pause_info ) )
      end
    end
end

end
