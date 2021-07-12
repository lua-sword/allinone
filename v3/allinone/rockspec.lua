
--[[
local ltcn = require "ltcn"
local t1 = assert(ltcn.parse_file("allinone-0.0-0.rockspec"))
]]--

local arg1 = arg[1] and arg[1]..": " or ""

local uniform_load = require "uniformapi"(_G).load

local function rockspecreader(rockspecfile)
	local fd = io.open(rockspecfile,"r")
	local filecontent = fd:read("*a")
	fd:close()
	local e = {}
	local f = uniform_load(filecontent,"@"..rockspecfile,"t",e)
	if not f then
		error(arg1.."error in file "..rockspecfile)
	end
	f()
	return e
end


local function table_keys(t)
	local r = {}
	for k in pairs(t) do
		table.insert(r,k)
	end
	return r
end
local function namespace(keys)
	local r = {}
	for _i,k in ipairs(keys) do
		local w1,w2 = k:match("^([^%./]+)[^%./]?(.*)$")
		if not r[w1] then
			r[w1]=true
			r[#r+1]=w1
		end
	end
	return r
end

local function moduleslist(t)
	if type(t.build)=="table" and t.build.type=="builtin" and type(t.build.modules)=="table" then
		local m=t.build.modules
		local keys = table_keys(m)
		table.sort(keys)
		local main
		local names = namespace(keys)
		if #names == 1 then
			main = names[1]
			if not m[main] then
				main = names[1]..".init"
				if not m[main] then
					error(arg1.."multiple module with only one namespace but no "..main.." or "..main..".init")
				end
			else
				assert(not (m[main] and m[main..".init"]), arg1.."both exists: "..main.. " and "..main..".init")
			end
		else 
			error(arg1.."multiple namespace: "..table.concat(names,", "))
		end
		for i,k in ipairs(keys) do
			if k==main then
				table.remove(keys,i)
				break
			end
		end
		return m, main, keys
	else
		--error("rockspec: no suck build.modules or unsupported build.type")
		print(arg1.."a voir")
		os.exit(1)
	end
end

return {reader=rockspecreader,moduleslist=moduleslist}
