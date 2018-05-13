-- Bank server

term.clear()
term.setCursorPos(10,1)
term.setTextColor(colors.orange)
print("BANK SERVER")
term.setCursorPos(1,3)
rednet.open("top")

function split(message)
	local args = {}
	for arg in message:gmatch('%S+') do
		table.insert(args, arg)
	end
	return args
end

while true do
	local senderId, message, protocol = rednet.receive("BANK:4471")
	print(senderId.." > "..message)
	if message:match(" ") then
		local cmd, arg1, arg2 = unpack(split(message))
		arg1 = tonumber(arg1)
		arg2 = tonumber(arg2)
		if arg1 and arg2 then
			local money = 0
			
			if fs.exists("bank/"..senderId) then
				local file = fs.open("bank/"..senderId, "r")
				money = tonumber(file.readAll())
				file.close()
			else
				local file = fs.open("bank/"..senderId, "w")
				file.write("0")
				file.close()
				print("Vytvoren novy ucet: "..senderId)
			end
			
			if(cmd == "check")then
				rednet.send(senderId, money, "BANK:4471")
			elseif(cmd == "send")then
				if arg1 ~= senderId and fs.exists("bank/"..arg1) and arg2 > 0 and arg2 <= money then
					local file = fs.open("bank/"..senderId, "w")
					file.write(money - arg2)
					file.close()
					local file = fs.open("bank/"..arg1, "w")
					file.write(money + arg2)
					file.close()
					rednet.send(senderId, "ok", "BANK:4471")
				else
					rednet.send(senderId, "error", "BANK:4471")
				end
			end
		end
	end
end