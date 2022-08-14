-- Made by GhostOne
-- L00naMods "Even if you say L00na is a bitch just put my name in there somewhere"
-- Ghost's Lua Table Writer
--[[
nil			gltw.write(table table, string name, string path|nil, table index exclusions, skip empty tables)
-- example gltw.write({name = "l00na", iq = -1, braincells = {}}, "something", "folder1\\", {"name"}, true) < this will not write 'name' (excluded) or 'braincells' (empty)

table[]		gltw.read(string name, string path|nil(in same path as lua), table|nil, bool|nil)
-- if a table is the 3rd arg then whatever is read from the file will be added to it without overwriting stuff that isn't in the saved file
-- if the 4th arg is true the function won't throw an error if the file doesn't exist and will return nil
]]

gltw = {}

function gltw.write_table(file, tableTW, indentation, exclusions, exclude_empty)
	local l_next = next
	for k, v in pairs(tableTW) do
		if not exclusions[k] then
			local typeofv = type(v)
			local index
			if type(k) == "number" then
				index = "["..k.."] = "
			else
				index = "[\""..k.."\"] = "
			end

			if typeofv == "string" then
				file:write(indentation..index.."[=["..v.."]=],\n")
			elseif typeofv ~= "function" and typeofv ~= "table" then
				file:write(indentation..index..tostring(v)..",\n")
			elseif typeofv == "table" and (l_next(v) or not exclude_empty) then
				file:write(indentation..index.."{\n")
				gltw.write_table(file, v, indentation.."	", exclusions, exclude_empty)
				file:write(indentation.."},\n")
			end
		end
	end
end

function gltw.write(tableTW, name, path, exclusions, exclude_empty)
	local convertedExclusions = {}
	if exclusions then
		for k, v in pairs(exclusions) do
			convertedExclusions[v] = true
		end
	end

	name = name or "set a name next time"
	assert(tableTW, "no table was provided to write for file '"..name.."'")
	path = path or ""
	assert(type(name) == "string" and type(path) == "string", "name or path isn't a string")

	local file = io.open(path..name..".lua", "w+")
	assert(file, "'"..name.."' was not created.")

	file:write("return {\n")
	gltw.write_table(file, tableTW, "	", convertedExclusions, exclude_empty)
	file:write("}")

	file:flush()
	file:close()
end

function gltw.add_to_table(getTable, addToTable)
	assert(type(getTable) == "table" and type(addToTable) == "table", "args have to be tables")
	for k, v in pairs(getTable) do
		if type(v) ~= "table" then
			addToTable[k] = getTable[k]
		else
			if type(addToTable[k]) == "table" then
				gltw.add_to_table(getTable[k], addToTable[k])
			end
		end
	end
end

function gltw.read(name, path, addToTable, overrideError)
	if overrideError and not utils.file_exists(path..name..".lua") then
		return
	end
	
	path = path or ""
	if type(tableRT) == "string" then
		name, path = tableRT, name or path
		tableRT = nil
	end

	if addToTable then
		local readTable = dofile(path..name..".lua")
		assert(readTable, "file not found")
		gltw.add_to_table(readTable, addToTable)
		return readTable
	else
		return dofile(path..name..".lua")
	end
end
