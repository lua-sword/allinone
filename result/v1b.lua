local sources = {}

sources["foo"] = [===[

local x = "iks"
local function getx(y)
        return x, y
end
return {getx=getx}
]===]

sources["bar"] = [===[
return "BAR"
]===]

local function preloadgeneric(modname, p)
	local src = sources[modname]
	if not src then return nil end
	sources[modname]=nil
	return assert(load(src, "t", nil, nil))()
end
package.preload["foo"] = preloadgeneric
package.preload["bar"] = preloadgeneric

local foo = require "foo"
print(foo.getx(123) )
print(require"bar")
print(not not sources.foo, not not sources.bar)

package.preload["buz"] = preloadgeneric
print(require"buz")
