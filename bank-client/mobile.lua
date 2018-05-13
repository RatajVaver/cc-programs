-- Bank client - Mobile

BANK_ID = 2

term.clear()
term.setCursorPos(6,1)
term.setTextColor(colors.orange)
print("BANK CLIENT")
term.setCursorPos(1,3)
rednet.open("back")

function split(message)
	local args = {}
	for arg in message:gmatch('%S+') do
		table.insert(args, arg)
	end
	return args
end

local prikazy = {
	{ "stav", "Zkontroluje stav uctu" },
	{ "poslat [Ucet] [Castka]", "Odesle castku na jiny ucet" },
}

write("Seznam prikazu:")

local line = 1

for _, val in pairs(prikazy) do
	term.setCursorPos(2,4+line)
	write(val[1])
	term.setCursorPos(4,4+line+1)
	write(val[2])
	line = line + 2
end

term.setCursorPos(1, 6+line)
write("Prikaz: ")

local input = read()
local table = split(input)
local cmd = table[1]

if cmd == "stav" then
	rednet.send(BANK_ID, "check 0 0", "BANK:4471")
	
	local senderId, message, protocol = rednet.receive("BANK:4471", 5)
	if senderId and message and senderId == BANK_ID then
		print("Soucasny stav uctu: $"..message)
	else
		print("Nepodarilo se zjistit stav uctu!")
	end
elseif cmd == "poslat" then
	local target = nil
	local amount = nil
	if table[2] and table[3] then
		target = tonumber(table[2])
		amount = tonumber(table[3])
	end
	if target and amount then
		rednet.send(BANK_ID, "send "..target.." "..amount, "BANK:4471")
	
		local senderId, message, protocol = rednet.receive("BANK:4471", 5)
		if senderId and message and senderId == BANK_ID then
			if message == "ok" then
				print("Platba $"..amount.." na ucet "..target.." byla odeslana.")
			else
				print("Vyskytla se chyba v prevodu penez!")
			end
		else
			print("Nepodarilo se zjistit stav uctu!")
		end
	else
		print("Prikaz byl spatne vyplnen!")
	end
end

print("")
print("Pokracuj stiskem libovolne klavesy..")

os.pullEvent("key")

os.shutdown()