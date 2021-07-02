local split = require "mini-string-split"
local tprint = require "tprint"

local longstringtrap={["\n"]=true,["\r"]=true,}

local function longstringprint(s)
	assert(type(s)=="string")
	local notrap=""
	if longstringtrap[s:sub(1,1)] then
		notrap="--\n"
	end
	return "[["..notrap..s.."]]"
end

local function dec_s(x)
	return x
end
local function dec_t(x)
	return 'table.concat('..x..',"]]")'
end

local function enc(data)
	local e = split(data, "]]", true)
	if #e == 1 then
		e = e[1]
		e = longstringprint(e)
		return e, dec_s
	end
	local r = {}
	for i,v in ipairs(e) do
		r[i] = longstringprint(v)
	end
	e = "{"..table.concat(r,",").."}"
	--e = tprint(e)
	return e, dec_t
end
return enc
