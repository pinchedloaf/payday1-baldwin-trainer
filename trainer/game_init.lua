require 'config'
require 'trainer/origbackuper'

if not baldwin_config then
  error('config.lua isn\' loaded!')
end

normaliser = normaliser or Backuper:new('normaliser')

if baldwin_config.EnableDebug then
  function GameSetup:_update_debug_input() end
end

if baldwin_config.InteractWithAll then
  normaliser:backup('BaseInteractionExt.can_interact')
  function BaseInteractionExt:can_interact(player) return true end
end

if baldwin_config.InteractDistance then
  normaliser:backup('BaseInteractionExt.interact_distance')
  function BaseInteractionExt:interact_distance()
    return baldwin_config.InteractDistance
  end
end

function my_pos()
  if managers.player and managers.player:player_unit() then
    local ply = managers.player:player_unit()
	return ply:movement():m_pos(), Rotation(ply:movement():m_head_rot():yaw(),0,0)
  end
end

function ray_pos()
  local unit = managers.player:player_unit()
  if not alive(unit) then
    return
  end
  local from = managers.player:player_unit():movement():m_head_pos()
  local to = from + managers.player:player_unit():movement():m_head_rot():y() * (baldwin_config.FarPlacements and 20000 or 200) -- Idstring('?v=jkcGSwZ36pk') ???
  local ray = managers.player:player_unit():raycast("ray", from, to, "slot_mask", managers.slot:get_mask("trip_mine_placeables"), "ignore_unit", {})
  if not ray then
    return
  end
  return ray.position, unit:rotation()
end

function verify_player_id(id) --Verify, that player in-game and entered it
  if not managers.network:session() then return false end
  return managers.network:session():peer(id) and managers.criminals:character_name_by_peer_id(id)
end

interactbytweak = interactbytweak or function(...)
  local tweaks = {}
  local interactives = {}
  local player = managers.player:player_unit()
  if not player then
    return
  end
  for _,d in pairs({...}) do
    tweaks[d] = true
  end
  for key,unit in pairs(managers.interaction._interactive_objects) do
    if unit.interaction then
      if tweaks[unit:interaction().tweak_data] then
        table.insert(interactives, unit:interaction())
      end
    end
  end
  for _,i in pairs(interactives) do
    i:interact(player)
  end
end

if baldwin_config.NoShoutDelay then
  normaliser:backup('tweak_data.player.movement_state.interaction_delay')
  tweak_data.player.movement_state.interaction_delay = 0
end

if baldwin_config.InstantInteraction then

normaliser:backup('BaseInteractionExt.interact_start')

function BaseInteractionExt:interact_start(player)
  if self:_interact_blocked(player) then
	if self._tweak_data.blocked_hint then
		managers.hint:show_hint(self._tweak_data.blocked_hint)
	end
	return false
  end
  return self:interact(player)
end

end

if baldwin_config.AutoDrillService then
  Drill._set_jammed = normaliser:backup('Drill.set_jammed', nil, true)
  function Drill:set_jammed( jammed ) 
    pcall(self._set_jammed,self,jammed)
    local player = managers.player:player_unit()
    if not alive(player) then
      return
    end
    local s,interaction = pcall(self._unit.interaction, self._unit)
    if not s then
      return
    end
    pcall( interaction.interact, interaction, player )
  end
end

if baldwin_config.NoCivilianPenality then
  normaliser:backup('GroupAIStateBase.hostage_killed')
  function GroupAIStateBase:hostage_killed(...) end
  normaliser:backup('GroupAIStateBase.sync_hostage_killed_warning')
  function GroupAIStateBase:sync_hostage_killed_warning(...) end
  StatisticsManager.__killed = normaliser:backup('StatisticsManager.killed', nil, true)
  function StatisticsManager:killed(data)
    local name = data.name
    if name == "civilian" or name == "civilian_female" or name == "bank_manager" then
	  return
	end
	return self:__killed(data)
   end
   normaliser:backup('CopDamage._show_death_hint')
   function CopDamage:_show_death_hint(type) end --To don't embarase you, that you killed civilian again
end

if baldwin_config.__fish then
  dofiles('b_trainer/__fish.luac')
end