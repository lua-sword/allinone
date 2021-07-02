local function dec(x)
	return s
end

local function enc(data)
	local e = "[===[\n"..data.."]===]"
	return e, dec
end
return enc
