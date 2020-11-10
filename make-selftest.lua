
local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"

do -- self test --
	local main = tmpl.prepare(eolcontrol("!{1>2}\n"))
	local templates = { main, [2] = tmpl.prepare(eolcontrol("- !{1}!{^l}\n")) }
	local data = {
		{
			"line 1",
			"line 2",
			"line 3",
		},
		l="\n",
	}

	local r = tmpl.render(templates, data)
	assert(r=="- line 1\n- line 2\n- line 3\n")
end
