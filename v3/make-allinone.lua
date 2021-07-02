#!/usr/bin/lua

local allinone = require "allinone.init"

local util = require "allinone.util"
local templates = require "allinone.templates"
local enc = require "allinone.longstringdump1dynamic"

util.TEMPLATEDIR = "allinone.templates"
util.MODSDIR     = "."

local modcat = util.modcat
local cat = util.cat

--local tmpl = require "mini-tmpl"
local tmpl_render = require "mini-tmpl.render"

do
	local function auto(k) return k:gsub("%.","/")..".lua" end
	local modules1 = {
		{["allinone"] = "allinone/init.lua"},
		{["allinone.longstringdump1dynamic"] = auto},
		{["allinone.templates"] = auto},
		{["allinone.util"] = auto},

		{["mini-string-split"] = auto},
		{["mini-string-split.plain"] = auto},

		{["mini-table-walk3"] = auto},

		--{["mini-tmpl"] = auto},
		{["mini-tmpl.common"] = auto},
		{["mini-tmpl.render"] = auto},
		{["mini-tmpl.astoptim.desoptimize"] = auto},
		{["mini-tmpl.astrender"] = auto},
		{["mini-tmpl.astrender.eval"] = auto},
		{["mini-tmpl.astrender.if"] = auto},
		{["mini-tmpl.astrender.include"] = auto},
		{["mini-tmpl.astrender.pipe"] = auto},
		{["mini-tmpl.astrender.template"] = auto},
		{["mini-tmpl.astrender.var"] = auto},
		--{["mini-tmpl.eolcontrol"] = auto},
		--{["mini-tmpl.mkast"] = auto},
		--{["mini-tmpl.prepare"] = auto},
		--{["mini-tmpl.prepare.varpathsplit"] = auto},
	}
	for i,item in ipairs(modules1) do
		local k,v = next(item)
		if type(v)=="function" then
			item[k]=v(k)
		end
	end

	local main = cat(util.MODSDIR.."/"..modules1[1].allinone)
	table.remove(modules1,1)

	local modules = {}
	for i,item in ipairs(modules1) do
		local k,v = next(item)
		modules[#modules+1] = modcat(k, v)
	end

	local dec
	for i,m in ipairs(modules) do
		m.v,dec = enc(m.v)
		if dec then
			m.v = dec(m.v)
		end
	end

	local data = {
		l="\n",
		main = main,
		modules = modules,
	}
	data.modules = modules

	--print(require"tprint"(templates,{inline=false}))
	local r = tmpl_render(templates, data)
	io.stdout:write(r)
end
