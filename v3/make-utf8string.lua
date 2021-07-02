#!/usr/bin/lua

local allinone = require "allinone"
local util = require "allinone.util"
--util.TEMPLATEDIR = "allinone/templates"
util.MODSDIR     = "utf8string"

local enc = require "allinone.longstringdump1dynamic"

local templatecat=util.templatecat
local modcat = util.modcat
local cat = util.cat

local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"
local prepare = tmpl.prepare

do
--	local templates = {
--		[1]			= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
--		["module/part1"]	= prepare(eolcontrol(templatecat "module/part1.tmpl.eolc.txt")),
--		["module/part2"]	= prepare(eolcontrol(templatecat "module/part2.tmpl.eolc.txt")),
--	}

	local templates = require "allinone.templates"
	--local main = templates[1]

	local modules1 = {
		{["utf8string"]						= "init.lua"},

		{["utf8string.functions.lua53"]				= "functions/lua53.lua"},
		{["utf8string.primitives.dummy"]			= "primitives/dummy.lua"},
		{["utf8string.primitives.init"]				= "primitives/init.lua"},
		{["utf8string.primitives.native"]			= "primitives/native.lua"},
		{["utf8string.primitives.tarantool"]			= "primitives/tarantool.lua"},
		{["utf8string.util"]					= "util.lua"},

		{["utf8string.begins.compiletime.parser"]		= "begins/compiletime/parser.lua"},
		{["utf8string.begins.compiletime.vanilla"]		= "begins/compiletime/vanilla.lua"},
		{["utf8string.charclass.compiletime.builder"]		= "charclass/compiletime/builder.lua"},
		{["utf8string.charclass.compiletime.parser"]		= "charclass/compiletime/parser.lua"},
		{["utf8string.charclass.compiletime.range"]		= "charclass/compiletime/range.lua"},
		{["utf8string.charclass.compiletime.stub"]		= "charclass/compiletime/stub.lua"},
		{["utf8string.charclass.compiletime.vanilla"]		= "charclass/compiletime/vanilla.lua"},
		{["utf8string.charclass.runtime.base"]			= "charclass/runtime/base.lua"},
		{["utf8string.charclass.runtime.dummy"]			= "charclass/runtime/dummy.lua"},
		{["utf8string.charclass.runtime.init"]			= "charclass/runtime/init.lua"},
		{["utf8string.charclass.runtime.native"]		= "charclass/runtime/native.lua"},
		{["utf8string.context.compiletime"]			= "context/compiletime.lua"},
		{["utf8string.context.runtime"]				= "context/runtime.lua"},
		{["utf8string.ends.compiletime.parser"]			= "ends/compiletime/parser.lua"},
		{["utf8string.ends.compiletime.vanilla"]		= "ends/compiletime/vanilla.lua"},
		{["utf8string.modifier.compiletime.frontier"]		= "modifier/compiletime/frontier.lua"},
		{["utf8string.modifier.compiletime.parser"]		= "modifier/compiletime/parser.lua"},
		{["utf8string.modifier.compiletime.simple"]		= "modifier/compiletime/simple.lua"},
		{["utf8string.modifier.compiletime.stub"]		= "modifier/compiletime/stub.lua"},
		{["utf8string.modifier.compiletime.vanilla"]		= "modifier/compiletime/vanilla.lua"},
		{["utf8string.regex_parser"]				= "regex_parser.lua"},
	}

	local main = cat(util.MODSDIR.."/"..modules1[1].utf8string)
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
	local r = tmpl.render(templates, data)
	io.stdout:write(r)

	--for k,v in pairs(package.loaded) do print(k) end
end
