local status = true
local appdata_path = utils.get_appdata_path("PopstarDevs", "2Take1Menu")

local filePaths = {
	["cheesemenu.lua"] = appdata_path.."\\scripts\\cheesemenu.lua",
	["GLTW.lua"] = appdata_path.."\\scripts\\cheesemenu\\libs\\GLTW.lua",
	["Get Input.lua"] = appdata_path.."\\scripts\\cheesemenu\\libs\\Get Input.lua",
	["CheeseUtilities.lua"] = appdata_path.."\\scripts\\cheesemenu\\libs\\CheeseUtilities.lua",
	["Proddy's Script Manager.lua"] = appdata_path.."\\scripts\\cheesemenu\\libs\\Proddy's Script Manager.lua",
}

local responseCode, responseBody = web.get([[https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/aioUpdate.lua]])
if responseCode ~= 200 then
	print("Failed to download update.")
	status = false
end
local chunk = load(responseBody)
if not chunk then
	status = false
	return status
end
local updatedFiles = chunk()

if status then
	for _, v in pairs(filePaths) do
		local currentFile = io.open(v, "a+")
		if not currentFile then
			status = "ERROR REPLACING"
			break
		end
        currentFile:close()
	end
	if status ~= "ERROR REPLACING" then
		for k, v in pairs(filePaths) do
			local currentFile = io.open(v, "w+b")
			if currentFile then
				currentFile:write(updatedFiles[k])
				currentFile:flush()
				currentFile:close()
			else
				status = "ERROR REPLACING"
				break
			end
		end
	end
end

return status
