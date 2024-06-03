fx_version 'cerulean'
game 'gta5'
name 'goods'
author 'FMScripts'
version '1.0'

shared_script 'config.lua'
server_script 'server.lua'
client_scripts {
    'client/variables.lua',
    'client/functions.lua',
    'client/main.lua'
}

ui_page 'html/index.html'
files {
    -- UI
    'html/index.html',
    'html/style.css',
    'html/functions.js',
    'html/main.js',
    -- Connection with LUA
    'html/connection.js',
    -- images
    'images/*'
}