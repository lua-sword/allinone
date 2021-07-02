local function dec(s)
	return s
end
local longstringtrap={["\n"]="\n",["\r"]="\n",}
local function enc(data)
	for i=0,100000 do
		local m = ("="):rep(i)
		if not string.find(data,"]"..m.."]",nil, true) then
			local notrap = longstringtrap[data:sub(1,1)] or ""
			local e = "["..m.."["..notrap..data.."]"..m.."]"
			return e, nil
		end
	end
	error("data too hard to enc") -- in this case the data is greater than ~4GB
end
return enc
