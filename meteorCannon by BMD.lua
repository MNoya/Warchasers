-- itemMeteorCannon(channelTime, point, keys.ability, caster)
--[[
	channelTime = now - start
		but we want to remove this channeling for our meteor launcher
	point = keys.target_points[1]
	caster = keys.caster
	item = keys.ability
  ]]


function itemMeteorCannon( channelTime, point, item , caster)
  --print ('[REFLEX] itemMeteorCannon called: ' .. channelTime .. " -- point: " .. tostring(point) .. " -- item: " ..item:GetAbilityName())
  
  local info = {
    EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
    Ability = item,
    vSpawnOrigin = caster:GetOrigin(),
    fDistance = 5000,
    fStartRadius = 125,
    fEndRadius = 125,
    Source = caster,
    bHasFrontalCone = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER,
    --fMaxSpeed = 5200,
    fExpireTime = GameRules:GetGameTime() + 8.0,
  }

  local speed = tonumber(item:GetSpecialValueFor("speed")) + (item:GetLevel() - 1) * 100 --1000
  --print ('[REFLEX] Meteor Speed: ' .. tostring(speed))
  --print ('[REFLEX] ' .. tostring(point))
  --PrintTable(point)
  --PrintTable(getmetatable(point)) 
  -- caster:GetAngles() .y is angle with 270 being straight down i think
  --local angles = caster:GetAngles()
  --print ('[REFLEX] ' .. tostring(angles))
  --PrintTable(angles)
  --PrintTable(getmetatable(angles))
  
  -- x pos is left
  -- y pos is down
  
  point.z = 0
  local pos = caster:GetAbsOrigin()
  pos.z = 0
  --print ('[REFLEX] ' .. tostring(pos))
  local diff = point - pos
  --print ('[REFLEX] ' .. tostring(diff))
  
  --point = point:Normalized()
  info.vVelocity = diff:Normalized() * speed * channelTime
  --info.vVelocity = point:Normalized() * speed * channelTime--( RotatePosition( Vec3( 0, 0, 0 ), angle, Vec3( 1, 0, 0 ) ) ) * speed
  --info.vAcceleration = info.vVelocity * -0.15

  ProjectileManager:CreateLinearProjectile( info )
end