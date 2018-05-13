-- Bank client - Debug command line

BANK_ID = 2

term.clear()
term.setCursorPos(10,1)
term.setTextColor(colors.orange)
print("BANK CLIENT")
term.setCursorPos(1,3)
rednet.open("top")

write("Command: ")

local input = read()
rednet.send(BANK_ID, input, "BANK:4471")

local senderId, message, protocol = rednet.receive("BANK:4471", 5)
if senderId and message and senderId == BANK_ID then
	print(message)
end