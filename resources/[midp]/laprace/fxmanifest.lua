fx_version 'adamant'

game 'gta5'

ui_page "html/index.html"


shared_script '@es_extended/imports.lua'

client_scripts {
    'client/main.lua',
    'config.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'config.lua',
}

files {
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'html/fonts/*.otf',
    'html/img/*',
}

exports {
    'IsInRace',
    'IsInEditor',
}