
local function cat(filename)
	local fd = assert(io.open(filename, "r"))
	local data = fd:read("*a")
	fd:close()
	return data
end
local function tableitem(k) return '["' .. k .. '"]' end


local tmpl = require "mini-tmpl"
local eolcontrol = require "mini-tmpl.eolcontrol"

local TEMPLATEDIR = "open-close/templates"
local MODSDIR = "open-close/mods"

local function modcat(filename)
	local modname = filename:match("^(.*)%.lua$")
	return {k=tableitem(modname), v=cat(MODSDIR.."/"..filename)}
end
local function templatecat(x)
	-- if .txt, ignore
	-- if .eolc use eolcontrol()
	-- if .tmpl use prepare()
	return cat(TEMPLATEDIR.."/"..x)
end

local function table_remove_range(t,b,e)
	for i=e,b,-1 do
		table.remove(t,i)
	end
	return t
end

do

	local templates = {
		[1]			= tmpl.prepare(eolcontrol(templatecat "1.tmpl.eolc.txt")),
	}

	local const = require "mini-tmpl.common".const

	local function postprepare(ast)

		local function varname(ast)
			if type(ast)=="table" and ast[1]==const.VAR then
				return ast[3]
			end
			return nil
		end
		local function openname(name)
			return name and name:sub(1,1)=="#"
		end
		local function closename(name)
			return name and name:sub(1,1)=="/"
		end
		local function samename_samescope(a,b)
			return a[3]:sub(2)==b[3]:sub(2) and a[4]==b[4]
		end

		local function searchandbuffer(ast)
			local skip=ast[2]

			local open=nil -- name of the open ast
			local b -- begin
			local buffer={}

			local function buffer2astif(buffer, open)
				assert(#open==4,"var ast must has 4 arguments")
				table.insert(buffer, 1, assert(const.IF))
				table.insert(buffer, 2, 2)
				table.insert(buffer, 3, assert(open[3]:sub(2)))
				table.insert(buffer, 4, assert(open[4]))
				return buffer
			end

			for i=3+skip,#ast do
				local v=ast[i]
				local name = varname(v)
				if open then
					if closename(name) and samename_samescope(v,open) then -- closing
						buffer = buffer2astif(buffer, open)
						if b then
							ast[b] = postprepare(buffer)
							--table_remove_range(ast,b+1,e)
							for i2=b+1,i do ast[i2]="" end
						end
						open=nil b=nil buffer={}
					else
						table.insert(buffer, v)
					end
				else -- not open
					local name = varname(v)
					if openname(name) then -- opening
						open=v
						b=i
					end
				end
				i=i+1
			end
			for i=#ast,3+skip,-1 do
				if ast[i]=="" then
					table.remove(ast,i)
				end
			end
			return ast
		end
		return searchandbuffer(ast)
	end
	local function ast_flat_to_struct(ast)
		local templates={}
		--TODO: parcourir l'ast et quand on trouve un "#xx" ... bufferiser jusqu'au "/xx" puis si cest pour definir un template il faut transformer ca en objet de type template
		
	end
	print("avant = "..require"tprint"(require"mini-tmpl.debugast"(templates[1]),{inline=false}))
	templates[1] = postprepare(templates[1])
	print("apres = "..require"tprint"(templates[1],{inline=false}))
	print("apres = "..require"tprint"(require"mini-tmpl.debugast"(templates[1]),{inline=false}))

	local etu = require "tmpl-ast-etd2etu"
	astetu = etu(templates[1])
	print("etu = "..require"tprint"(astetu,{inline=false}))

	local function cutsubtemplate(astetu)
		local TYPE_VAR = 3
		local function is_open(ast)
			return ast.type==TYPE_VAR and ast.args[1]:sub(1,1)=="#"
		end
		local function is_close(ast, current_open_name)
print("ast.args[1]="..tostring(ast.args[1]), "current_open_name="..current_open_name)
			return ast.type==TYPE_VAR and ast.args[1]=="/"..current_open_name
		end
		local stack = {}
		local r = {}
		for i,v in ipairs(astetu) do
			if is_open(v) then
				local substack={name=v.args[1]:sub(2), open=v, parent=stack}
				stack[#stack+1]=substack
				stack=substack
			elseif stack.name and is_close(v, stack.name) then
				stack.close=v
				stack=stack.parent
			else
				stack.content = stack.content or {}
				stack.content[#stack+1] = v
			end
		end
		r = stack
		return r
	end

	print("etu2= "..require"tprint"(cutsubtemplate(astetu.args[1]),{inline=false}))


	--local data={}
	--local r = tmpl.render(templates, data)
	--io.stdout:write(r.."\n")
end
