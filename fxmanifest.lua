fx_version 'cerulean'
game 'gta5'

author 'skap'
version '1.0.1'

escrow_ignore {
    'config.lua',
    'locales/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}

lua54 'yes'

--version '1.0.1' added: locales