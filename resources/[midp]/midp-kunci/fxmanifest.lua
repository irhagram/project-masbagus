fx_version 'bodacious'
game 'gta5'
shared_script '@es_extended/imports.lua'
client_scripts {
 'config.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

exports {
 'givePlayerKeys',
 'ToggleLocks',
}

 