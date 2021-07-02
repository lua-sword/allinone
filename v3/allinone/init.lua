local util = require "allinone.util"
local templates = require "allinone.templates"
local longstringdump1dynamic = require "allinone.longstringdump1dynamic"

util.TEMPLATEDIR = "nope"
util.MODSDIR     = "."

local tmpl_render = require "mini-tmpl.render"

return {
	util=util,
	templates=templates,
	longstringdump1dynamic=longstringdump1dynamic,
	tmpl_render=tmpl_render,
}
