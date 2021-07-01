package = "aio2"
version = "0.1-0"
source = {
	url = "git://github.com/lua-sword/lua-aio2.git",
	tag = "0.1"
}
description = {
	summary = "FILLME",
	detailed = [[
		FILLME
	]],
	homepage = "https://github.com/lua-sword/lua-aio2",
	maintainer = "TsT",
	license = "MIT/X11"
}
dependencies = {
	"lua >= 5.1"
}
build = {
	type = 'builtin',
	modules = {
--		['lunajson'] = 'src/lunajson.lua',

local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"
	--print(require"tprint"(templates,{inline=false}))

./make-v1d.lua

./mini-table-walk3.lua
./mini-string-split.lua
./mini-string-split


["mini-tmpl"]			= "mini-tmpl.lua",
["mini-tmpl.eolcontrol"]	= "mini-tmpl/eolcontrol.lua",

./tprint

./v1d/mods/main.lua
./v1d/mods/foo.lua
./v1d/mods/bar.lua
./v1d/templates/1.tmpl.eolc.txt
./v1d/templates/module/part2.tmpl.eolc.txt
./v1d/templates/module/part1.tmpl.eolc.txt

--		['lunajson.decoder'] = 'src/lunajson/decoder.lua',
--		['lunajson.encoder'] = 'src/lunajson/encoder.lua',
--		['lunajson.sax'    ] = 'src/lunajson/sax.lua',
	}
}


