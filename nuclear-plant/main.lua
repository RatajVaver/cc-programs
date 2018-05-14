term.clear()
term.setCursorPos(8,5)
term.setTextColor(colors.red)
rednet.open("back")
print("NUCLEAR POWER PLANT CONTROL SERVER")

while true do
	local senderId, message, protocol = rednet.receive("NPPCS:1297")
	if senderId == 3 and message == "switch" then
		redstone.setOutput("top", true)
		sleep(1)
		redstone.setOutput("top", false)
	end
end