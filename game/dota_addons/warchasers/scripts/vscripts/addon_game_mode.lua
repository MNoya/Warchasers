---------------------------------------------------------------------------
-- Warchasers class
---------------------------------------------------------------------------
if Warchasers == nil then
	_G.Warchasers = class({})
	--Convar:SendToConsole("sv_cheats 1")
end


--dota_launch_custom_game warchasers warchasers
---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------

require( 'statcollection/init' )
require( 'warchasers' )
require( 'camera' )
require( 'abilities' )
require( 'timers')
require( 'teleport')
require( 'ai' )
require( 'spawn' )
require( 'hints' )
require( 'sounds' )
require( 'popups' )

function Precache( context )

	print("Starting precache")

	-- These units could be on Async if we just waited a bit more to spawn them
	PrecacheUnitByNameSync("npc_soul_keeper", context)
	PrecacheUnitByNameSync("npc_doom_miniboss", context)
	PrecacheUnitByNameSync("npc_tb_miniboss", context)
	PrecacheUnitByNameSync("npc_boss", context)

	-- Precache sounds
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context)
	PrecacheResource( "soundfile", "soundevents/music/valve_dota_001/stingers/game_sounds_stingers.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_stingers_diretide.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context )
	PrecacheResource( "soundfile", "soundevents/warchasers_sounds_custom.vsndevts", context )	

	-- Precache particles required by various world effects
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", context)
	PrecacheResource( "particle", "particles/sweep_generic/sweep_2.vpcf", context)
	PrecacheResource( "particle", "particles/sweep_generic/sweep_1.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_b.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_rain_storm.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_replicate_finish.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_frost_armor.vpcf" , context)
	PrecacheResource( "particle", "particles/units/heroes/hero_broodmother/broodmother_portrait_spiderling.vpcf", context)
	PrecacheResource( "particle", "particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_feast.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_berserker_blood_hero_effect.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", context)
	PrecacheResource( "particle", "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld.vpcf", context)
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf", context)
	PrecacheResource( "particle", "particles/econ/items/warlock/warlock_staff_glory/warlock_upheaval_hellborn_debuff.vpcf", context)

	-- Cosmetic item particles, should precache them individually
	--PrecacheResource( "particle_folder", "particles/econ/items", context )

	-- Precache custom particles
	PrecacheResource( "particle_folder", "particles/warchasers", context )
	PrecacheResource( "particle_folder", "particles/test_particle", context )

	-- Precache world models
	PrecacheResource( "model", "models/kappakey.vmdl", context )
	PrecacheResource( "model", "models/props_items/monkey_king_bar01.vmdl", context )
	PrecacheResource( "model", "models/props_items/blinkdagger.vmdl" , context )
	PrecacheResource( "model", "models/props_items/assault_cuirass.vmdl", context )  
	PrecacheResource( "model", "models/props_items/necronomicon.vmdl", context )
	PrecacheResource( "model", "models/items/necrolyte/heretic_weapon/heretic_weapon.vmdl", context )

	PrecacheUnitByNameSync("npc_dota_lycan_wolf1", context)
	PrecacheUnitByNameSync("npc_dota_dark_troll_warlord_skeleton_warrior", context)
	PrecacheUnitByNameSync("npc_avatar_of_vengeance", context)
	PrecacheUnitByNameSync("npc_spirit_of_vengeance", context)
	PrecacheUnitByNameSync("npc_rock_golem", context)
	PrecacheUnitByNameSync("npc_skeleton_archer", context)
	PrecacheUnitByNameSync("npc_kitt_steamtank", context)
	PrecacheUnitByNameSync("npc_red_drake", context)

	--[[PrecacheUnitByNameSync("npc_dota_hero_warlock", context)
	PrecacheUnitByNameSync("npc_dota_hero_techies", context)
	--tranquility
	PrecacheUnitByNameSync("npc_dota_hero_luna", context)
	PrecacheUnitByNameSync("npc_dota_hero_huskar", context)

	PrecacheUnitByNameSync("npc_dota_hero_mirana", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_treant", context)
	PrecacheUnitByNameSync("npc_dota_hero_lich", context)

	PrecacheUnitByNameSync("npc_dota_hero_slark", context)
	PrecacheUnitByNameSync("npc_dota_hero_doom_bringer", context)
	PrecacheUnitByNameSync("npc_dota_hero_zuus", context)
	PrecacheUnitByNameSync("npc_dota_hero_treant", context)
	PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
	PrecacheUnitByNameSync("npc_dota_hero_ogre_magi", context)
	]]

	print('Precache End')

end

function Activate()
	-- Create our game mode and initialize it
	Warchasers:InitGameMode()
end

-----------------------------------------------