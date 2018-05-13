-- Installer

print("Instaluji programy..")

for _, dir in pairs(fs.list("/downloads/cc-programs/")) do
	if fs.isDir("/downloads/cc-programs/"..dir) then
		if not fs.exists("/"..dir) then
			fs.makeDir("/"..dir)
		end
		for _, file in pairs(fs.list("/downloads/cc-programs/"..dir)) do
			fs.move("/downloads/cc-programs/"..dir.."/"..file, "/"..dir.."/"..file)
		end
	end
end

print("Hotovo!")