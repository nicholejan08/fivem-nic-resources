fx_version 'bodacious'
games { 'rdr3', 'gta5' }

ui_page "html/ui.html"

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}
 
server_scripts {
    'server.lua'
}

---------------------------------------------------------------------------
-- INCLUDED FILES
---------------------------------------------------------------------------
files {
    'html/ui.html',
    'html/style.css',
    'html/*.png',
    'html/*.jpg',
    'peds.meta'
}

---------------------------------------------------------------------------
-- DATA FILES
---------------------------------------------------------------------------
data_file 'PED_METADATA_FILE' 'peds.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/[addon]/flashlight/c_flashlight.ytyp'