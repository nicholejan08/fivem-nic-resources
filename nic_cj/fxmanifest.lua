fx_version 'adamant'
game 'gta5'

ui_page "html/ui.html"

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua',
    
    'stream/weapons/cj_ak47/*.lua',
    'stream/weapons/cj_bat/*.lua',
    'stream/weapons/cj_deagle/*.lua',
    'stream/weapons/cj_flower/*.lua',
    'stream/weapons/cj_grenade/*.lua',
    'stream/weapons/cj_heatseek/*.lua',
    'stream/weapons/cj_katana/*.lua',
    'stream/weapons/cj_m4/*.lua',
    'stream/weapons/cj_minigun/*.lua',
    'stream/weapons/cj_molotov/*.lua',
    'stream/weapons/cj_mp5/*.lua',
    'stream/weapons/cj_nightstick/*.lua',
    'stream/weapons/cj_pistol/*.lua',
    'stream/weapons/cj_rifle/*.lua',
    'stream/weapons/cj_rpg/*.lua',
    'stream/weapons/cj_sawnoff/*.lua',
    'stream/weapons/cj_shotgun/*.lua',
    'stream/weapons/cj_shovel/*.lua',
    'stream/weapons/cj_skate/*.lua',
    'stream/weapons/cj_sniper/*.lua',
    'stream/weapons/cj_spas/*.lua',
    'stream/weapons/cj_teargas/*.lua',
    'stream/weapons/cj_tec9/*.lua',
    'stream/weapons/cj_uzi/*.lua',
 }
 
server_scripts {
    'server/*.lua'
}

---------------------------------------------------------------------------
-- INCLUDED FILES
---------------------------------------------------------------------------

files {
    'meta/*.meta',
	'html/ui.html',
    'html/css/*.css',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/img/icons/*.png',
    'html/img/icons/*.jpg',
    'html/fonts/*.ttf',
    "html/sounds/*.ogg",

	'****/weaponarchetypes.meta',
	'****weaponanimations.meta',
	'****pedpersonality.meta',
	'****weapons.meta',
    
	-- '***/carcols.meta',
	-- '***/carvariations.meta',
	-- '***/handling.meta'
	-- '***/vehicles.meta',
}

---------------------------------------------------------------------------
-- DATA FILES
---------------------------------------------------------------------------

data_file 'PED_METADATA_FILE' 'meta/peds.meta'
data_file 'DLC_WEAPON_PICKUPS' 'meta/pickups.meta'

data_file 'DLC_ITYP_REQUEST' 'stream/props/data/cj_jetpack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props/data/cj_parachute.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props/data/cj_cellphone.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props/data/sa_camera.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props/data/sa_goggles.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props/data/sa_chainsaw.ytyp'

---------------------------------------------------------------------------
-- ADDON WEAPONS
---------------------------------------------------------------------------

data_file 'WEAPON_METADATA_FILE' '******/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' '****/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '****/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '****/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '****/weapons.meta'

---------------------------------------------------------------------------
-- ADDON VEHICLES
---------------------------------------------------------------------------

-- data_file 'HANDLING_FILE' '***/handling.meta'
-- data_file 'VEHICLE_METADATA_FILE' '***/vehicles.meta'
-- data_file 'CARCOLS_FILE' '***/carcols.meta'
-- data_file 'VEHICLE_VARIATION_FILE' '***/carvariations.meta'