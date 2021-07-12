#!/usr/bin/env lua
local templates_ast = require "allinone.templates_ast"
local fd = io.open("allinone/templates.lua","w")
fd:write("return "..require"tprint"(templates_ast,{inline=true}).."\n")
fd:close()
