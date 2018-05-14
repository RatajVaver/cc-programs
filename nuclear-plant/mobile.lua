term.clear()
term.setCursorPos(1,1)
term.setTextColor(colors.red)
rednet.open("back")
print("NUCLEAR POWER PLANT CONTROL CLIENT")

term.setCursorPos(1, 3)
write("Prikaz: ")

local input = read()
if input == "switch" then
	rednet.send(8, "switch", "NPPCS:1297")
	print("Prikaz odeslan!")
else
	print("Neznamy prikaz!")
end

os.shutdown()