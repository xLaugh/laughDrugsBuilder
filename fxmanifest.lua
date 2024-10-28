fx_version 'cerulean'
game 'gta5'
author 'Laugh'
version '0.1.0'
lua54 'yes'

escrow_ignore {
  "config.lua",
  "locales/*.lua",
}

shared_scripts {
	"config.lua",
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
}

client_scripts {
    "locales/*.lua",
    "config.lua",
    "client/*.lua",
}

server_scripts {
    "@es_extended/locale.lua",
    "@oxmysql/lib/MySQL.lua",
    "locales/*.lua",
    "config.lua",
    "server/*.lua",
}
