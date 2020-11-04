
local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"

do -- self test --
	local templates = { [1] = tmpl.prepare(eolcontrol("- !{1}!{^l}\n")) }
	local main = tmpl.prepare(eolcontrol("!{1>1}\n"))
	local data = {
		{
			"line 1",
			"line 2",
			"line 3",
		},
		l="\n",
	}

	local r = tmpl.render(main, data, templates)
	assert(r=="- line 1\n- line 2\n- line 3\n")
end
