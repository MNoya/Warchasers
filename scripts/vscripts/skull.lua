"modifier_warchasers_guldan_powers"
{
	"IsBuff"				"1"
	"Passive"           	"1"
	"IsHidden"				"0"
	"Properties"
    {
        "MODIFIER_PROPERTY_ATTACK_RANGE_BONUS"      "100"
        "MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE"	"100"
        "MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT"	"-10"
    }
	"Attributes"	"MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE"
	"OnCreated"
	{
		"AttachEffect"
        {
            "Target" "CASTER"
            "EffectName" "particles/items2_fx/satanic_buff.vpcf"
            "EffectAttachType" "follow_origin"
            "EffectLifeDurationScale" "1"
        }
        "RunScript"
		{
			"ScriptFile"		"scripts/vscripts/items.lua"
			"Function"			"GuldanSkull"
		}
	}
}


function GuldanSkull(event)
	--[[Modifier: SetRender black, black/red glow, TB meta transform particle, fire feet particle, change model TB, 
	if melee just add 100 range, if ranged change projectile and set 666 range. 
	Add 100% damage bonus but apply debuff (hp degen (apply in permanent combat if solo buff is active), armlet glow)]]
	event.caster:SetRenderColor(0, 0, 0)
	event.caster:SetModel("TB MODEL")
	local feet_particle = ParticleManager:CreateParticle("TB PARTICLES", PATTACH_ABSORIGIN_FOLLOW, event.caster)
    ParticleManager:SetParticleControl(feet_particle, int controlIndex, Vector controlData) --[[Returns:void
    Set the control point data for a control on a particle effect
    ]]

	--GetAttackCapability
	--SetAttackCapability

	if event.caster:IsRangedAttacker() then
		event.caster:SetRangedProjectileName("TB PROJECTILE")

	else
		event.caster:SetAttackCapability(1) 
		--[[Attack Capabilities
		DOTA_UNIT_CAP_MELEE_ATTACK
		DOTA_UNIT_CAP_RANGED_ATTACK
		DOTA_UNIT_CAP_NO_ATTACK
		]]
		event.caster:SetRangedProjectileName("TB PROJECTILE")
	end

	--Projectile Speed?

	if event.caster:HasModifier("warchasers_solo_buff")	then
		event.caster:RemoveModifierByName("warchasers_solo_buff")
	end

end
