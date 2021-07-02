#!/usr/bin/env lua
local templates_ast = require "templates_ast"
local fd = io.open("templates.lua","w")
fd:write("return "..require"tprint"(require"templates_ast",{inline=true}).."\n")
fd:close()
