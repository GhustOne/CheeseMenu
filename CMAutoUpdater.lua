local status = true
local appdata_path = utils.get_appdata_path("PopstarDevs", "2Take1Menu")

local filePaths = {
	cheesemenu = appdata_path.."\\scripts\\",
	gltw = appdata_path.."\\scripts\\cheesemenu\\libs\\"
	getinput = appdata_path.."\\scripts\\cheesemenu\\libs\\"
}
local files = {
	cheesemenu = [[https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/cheesemenu.lua]],
	gltw = [[https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/cheesemenu/libs/GLTW.lua]],
	getinput = [[https://raw.githubusercontent.com/GhustOne/CheeseMenu/main/cheesemenu/libs/Get%20Input.lua]]
}

for k, v in pairs(files) do
	local responseCode, file = web.get(v)
	if responseCode == 200 then
		files[k] = file
	else
		status = false
		break
	end
end

if status then
	for k, v in pairs(files) do
		local currentFile = io.open(filePaths[k], "w+")
		if currentFile then
			currentFile:write(v)
			currentFile:flush()
			currentFile:close()
		else
			status = "ERROR REPLACING"
		end
	end
end

return status
