
local M = {}
local function cat(filename)
	local fd = assert(io.open(filename, "r"))
	local data = fd:read("*a")
	fd:close()
	return data
end
local function tableitem(k) return '["' .. k .. '"]' end


local function modcat(modname, filename)
	if not filename then
		modname, filename = modname:match("^(.*)%.lua$"):gsub("/","."), modname
	end
	return {k=tableitem(modname), v=cat(M.MODSDIR.."/"..filename)}
end
local function templatecat(x)
	-- if .txt, ignore
	-- if .eolc use eolcontrol()
	-- if .tmpl use prepare()
	return cat(M.TEMPLATEDIR.."/"..x)
end

local TEMPLATEDIR = "v3/templates"
local MODSDIR = "v3/mods"

M={
cat=cat,
tableitem=tableitem,
TEMPLATEDIR=TEMPLATEDIR,
MODSDIR=MODSDIR,
modcat=modcat,
templatecat=templatecat,
}

return M
