
local function cat(filename)
	local fd = assert(io.open(filename, "r"))
	local data = fd:read("*a")
	fd:close()
	return data
end
local function tableitem(k) return '["' .. k .. '"]' end


local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"
local prepare = tmpl.prepare

local TEMPLATEDIR = "v1d/templates"
local MODSDIR = "v1d/mods"

local function modcat(filename)
	local modname = filename:match("^(.*)%.lua$")
	return {k=tableitem(modname), v=cat(MODSDIR.."/"..filename)}
end
local function templatecat(x)
	-- if .txt, ignore
	-- if .eolc use eolcontrol()
	-- if .tmpl use prepare()
	return cat(TEMPLATEDIR.."/"..x)
end

do
	local templates = {
		[1]			= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
		["module/part1"]	= prepare(eolcontrol(templatecat "module/part1.tmpl.eolc.txt")),
		["module/part2"]	= prepare(eolcontrol(templatecat "module/part2.tmpl.eolc.txt")),
	}

local r = require"tprint"(templates,{inline=false})
--[[
	local data = {
		l="\n",
		modules = {
			modcat("foo.lua"),
			modcat("bar.lua"),
		},
		main = (cat(MODSDIR.."/main.lua")),
	}

	local r = tmpl.render(templates, data)
]]--
	io.stdout:write(r)
end
