
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

do -- self test --
	local templates = { [1] = prepare(eolcontrol("- !{1}!{^l}\n")) }
	local main = prepare(eolcontrol("!{1>1}\n"))

	local data = {l="\n", {
		"line 1",
		"line 2",
		"line 3",
	}}

	local b = tmpl.render(main, data, templates)
	--io.stdout:write(b)
	assert(b=="- line 1\n- line 2\n- line 3\n")
	--print("ok")
end

local TEMPLATEDIR = "templates/v1a"
local MODSDIR = "mods"
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


if false then
	TEMPLATEDIR = "templates/v1a"
	local templates = {
		[1]		= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
		["module"]	= prepare(eolcontrol(templatecat "module.tmpl.eolc.txt")),
		["footer"]	= prepare(eolcontrol(templatecat "footer.tmpl.eolc.txt")),
	}

	local main = templates[1]
	local main = prepare("!{1>1}")

	local data = {
		l="\n",
		modules = {
			modcat("foo.lua"),
			modcat("bar.lua"),
		}
	}

	local b = tmpl.render(main, data, templates)
	io.stdout:write(b)
else

	TEMPLATEDIR = "templates/v1b"
	local templates = {
		[1]			= prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
		["module/part1"]	= prepare(eolcontrol(templatecat "module/part1.tmpl.eolc.txt")),
		["module/part2"]	= prepare(eolcontrol(templatecat "module/part2.tmpl.eolc.txt")),
		["footer"]		= prepare(eolcontrol(templatecat "footer.tmpl.eolc.txt")),
	}

	local main = templates[1]
	--local main = prepare("!{>1}")

	local data = {l="\n", modules = {
		modcat("foo.lua"),
		modcat("bar.lua"),
	}}

	local b = tmpl.render(main, data, templates)
	io.stdout:write(b)
end
