-- Made by GhostOne
-- L00naMods "Even if you say L00na is a bitch just put my name in there somewhere"
-- Ghost's Lua Table Writer
--[[
table[] string	gltw.write(table, string name, string path|nil, table index exclusions, skip empty tables, compile)
example: gltw.write({name = "l00na", iq = -1, braincells = {}}, "something", "folder1\\", {"name"}, true) < this will not write 'name' (excluded) or 'braincells' (empty)

table[]	        gltw.read(string name, string path|nil(in same path as lua), table|nil, bool|nil, bool|nil)
-- if a table is the 3rd arg then whatever is read from the file will be added to it without overwriting stuff that isn't in the saved file
-- if the 4th arg is true it will compare types of entries in 3rd arg table and the read one, if they match or are nil it will write to 3rd arg table
-- if the 5th arg is true the function won't throw an error if the file doesn't exist and will return nil
]]

local gltw				<const>	= {}
local type				<const> = type
local l_next			<const> = next
local ipairs			<const> = ipairs
local tostring			<const> = tostring
local string_format		<const> = string.format
local string_match		<const> = string.match

local long_str_levels	<const> = {}
for i = 0, 100 do
	long_str_levels[i]			= string.rep("=", i+1)
end

local str_level_pattern <const> = "%](=*)%]"

-- Thanks to Proddy for tips on optimization
local write_table
function gltw.write_table(tableTW, indentation, exclusions, exclude_empty, string_lines, string_lines_count)
	for k, v in l_next, tableTW do
		if not exclusions[k] then
			local typeofv <const> = type(v)
			local index
			if type(k) == "number" then
				index = "["..k.."] = "
			else
				index = "["..string_format("%q", k).."] = "
			end

			if typeofv == "string" then
				string_lines_count = string_lines_count + 1

				local long_str_level = string_match(v, str_level_pattern)
				long_str_level = long_str_level and long_str_levels[#long_str_level] or ""
				string_lines[string_lines_count] = indentation..index.."["..long_str_level.."["..v.."]"..long_str_level.."],"

			elseif typeofv ~= "function" and typeofv ~= "table" then
				string_lines_count = string_lines_count + 1
				string_lines[string_lines_count] = indentation..index..tostring(v)..","

			elseif typeofv == "table" and (exclude_empty and l_next(v) or not exclude_empty) then
				string_lines_count = string_lines_count + 1
				string_lines[string_lines_count] = indentation..index.."{"
				string_lines_count = write_table(v, indentation.."	", exclusions, exclude_empty, string_lines, string_lines_count)

				string_lines_count = string_lines_count + 1
				string_lines[string_lines_count] = indentation.."},"
			end
		end
	end

	return string_lines_count
end
write_table = gltw.write_table

function gltw.write(tableTW, name, path, exclusions, exclude_empty, compiled)
	local convertedExclusions = {}
	if exclusions then
		for _, v in ipairs(exclusions) do
			convertedExclusions[v] = true
		end
	end
	assert(tableTW, "no table was provided"..(name and " to write for file '"..name.."'" or ""))

	if name then
		path = path or ""
		assert(type(name) == "string" and type(path) == "string", "name or path isn't a string")
	end

	local string_lines = {}
	local string_lines_count = 1

	string_lines[string_lines_count] = "return {"
	gltw.write_table(tableTW, "	", convertedExclusions, exclude_empty, string_lines, string_lines_count)
	string_lines[#string_lines + 1] = "}"

	if name then
		local file = io.open(path..name..".lua", "wb")
		assert(file, "'"..name.."' was not created.")

		local stringified = table.concat(string_lines, "\n")

		file:write(compiled and string.dump(load(stringified), true) or stringified)

		file:flush()
		file:close()
	end

	return string_lines
end

function gltw.add_to_table(getTable, addToTable, typeMatched)
	assert(type(getTable) == "table" and type(addToTable) == "table", "args have to be tables")
	for k, v in l_next, getTable do
		if type(v) ~= "table" then
			if typeMatched and (type(getTable[k]) == type(addToTable[k]) or not addToTable[k]) or not typeMatched then
				addToTable[k] = getTable[k]
			end
		else
			if type(addToTable[k]) ~= "table" and not typeMatched then
				addToTable[k] = {}
			end
			if type(addToTable[k]) == "table" then
				gltw.add_to_table(getTable[k], addToTable[k])
			end
		end
	end
end

function gltw.read(name, path, addToTable, typeMatched, overrideError)
	name = string_match(name, "%.%w+") and name or name..".lua"
	if overrideError and not utils.file_exists(path..name) then
		return
	end

	path = path or ""
	if not (path:sub(-1) == "\\" or path:sub(-1) == "/") then
		path = path .. "\\"
	end

	local readTable = loadfile(path..name, "tb")()
	if addToTable then
		gltw.add_to_table(readTable, addToTable, typeMatched)
	end
	return readTable
end

return gltw
