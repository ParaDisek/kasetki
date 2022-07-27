fx_version 'adamant'

game 'gta5'

author 'Infram'
description 'Kasetki - wymagają ingerencji developerów MYSTORY (KONFIGURACJA)'
version '1.0.0'

client_scripts {
    'config.lua',
    'client/*.lua',
}

server_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}
