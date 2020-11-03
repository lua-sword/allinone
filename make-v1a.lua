
local function cat(filename)
	local fd = assert(io.open(filename, "r"))
	local data = fd:read("*a")
	fd:close()
	return data
end
local function tableitem(k) return '["' .. k .. '"]' end


local tmpl = require "lua-mini-tmpl.tmpl"
local eolcontrol = require "lua-mini-tmpl.tmpl.eolcontrol"
local prepare = tmpl.prepare

local TEMPLATEDIR = "v1a/templates"
local MODSDIR = "v1a/mods"
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
		[1]		= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
		["module"]	= prepare(eolcontrol(templatecat "module.tmpl.eolc.txt")),
		["footer"]	= prepare(eolcontrol(templatecat "footer.tmpl.eolc.txt")),
	}

	local main = templates[1]
	--local main = prepare("!{1>1}")

	local data = {
		l="\n",
		modules = {
			modcat("foo.lua"),
			modcat("bar.lua"),
		}
	}

	local r = tmpl.render(main, data, templates)
	io.stdout:write(r)
end
