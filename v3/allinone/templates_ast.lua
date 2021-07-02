
local util = require "util"
util.TEMPLATEDIR = "templates"
util.MODSDIR     = "mods"

local templatecat=util.templatecat

local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"
local prepare = tmpl.prepare

local templates = {
	[1]			= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
	["module/part1"]	= prepare(eolcontrol(templatecat "module/part1.tmpl.eolc.txt")),
	["module/part2"]	= prepare(eolcontrol(templatecat "module/part2.tmpl.eolc.txt")),
}

return templates
