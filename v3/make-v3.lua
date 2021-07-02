#!/usr/bin/lua

--local allinone = require "allinone.init"	-- dev
local allinone = require "allinone"     	-- result

local util = require "allinone.util"
--util.TEMPLATEDIR = "allinone/templates"
allinone.util.MODSDIR     = "allinone/mods"

--local templatecat=util.templatecat
local modcat = util.modcat
local cat = util.cat

local enc = require "allinone.longstringdump1dynamic"

--local tmpl = require "mini-tmpl"
local tmpl_render = require "mini-tmpl.render"

--local eolcontrol = require "mini-tmpl.eolcontrol"
--local prepare = tmpl.prepare

do
--	local templates = {
--		[1]			= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
--		["module/part1"]	= prepare(eolcontrol(templatecat "module/part1.tmpl.eolc.txt")),
--		["module/part2"]	= prepare(eolcontrol(templatecat "module/part2.tmpl.eolc.txt")),
--	}

	local templates = require "allinone.templates"
	--local main = templates[1]

	local modules = {}
	--modules[#modules+1] = modcat("foo.lua")
	--modules[#modules+1] = modcat("bar.lua")

	modules[#modules+1] = modcat("foo", "foo.lua")
	modules[#modules+1] = modcat("bar", "bar.lua")
	modules[#modules+1] = modcat("trap", "trap.lua")

	local dec
	for i,m in ipairs(modules) do
		m.v,dec = enc(m.v)
		if dec then
			m.v = dec(m.v)
		end
	end

	local data = {
		l="\n",
		main = (cat(util.MODSDIR.."/main.lua")),
		modules = modules,
	}
	data.modules = modules

	--print(require"tprint"(templates,{inline=false}))
	local r = tmpl_render(templates, data)
	io.stdout:write(r)
end
