function Fire(data)
  local target = data.caller
  if target ~= nil then
    local trap = thisEntity:FindAbilityByName("warchasers_fire_trap")
    thisEntity:CastAbilityOnPosition(target:GetOrigin(), trap, -1 )
  end
end

function Mine(data)
  local target = data.caller
  if target ~= nil then
    local trap = thisEntity:FindAbilityByName("warchasers_mine_trap")
    thisEntity:CastAbilityOnPosition(target:GetOrigin(), trap, -1 )
  end
end

function Meteor(data)
  local target = data.caller
  if target ~= nil then
    local trap = thisEntity:FindAbilityByName("warchasers_meteor_trap")
    thisEntity:CastAbilityOnPosition(target:GetOrigin(), trap, -1 )
  end
end