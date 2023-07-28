fx_version 'cerulean'
games { 'gta5' };

shared_scripts {
    "config.lua",
}

client_scripts {
    "source/RageUI/RMenu.lua",
    "source/RageUI/menu/RageUI.lua",
    "source/RageUI/menu/Menu.lua",
    "source/RageUI/menu/MenuController.lua",
    "source/RageUI/components/*.lua",
    "source/RageUI/menu/elements/*.lua",
    "source/RageUI/menu/items/*.lua",
    "source/RageUI/menu/panels/*.lua",
    "source/RageUI/menu/windows/*.lua",

}

client_scripts {
    "@es_extended/locale.lua",
    "source/client.lua",

}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@es_extended/locale.lua",
    "source/server.lua",
}


