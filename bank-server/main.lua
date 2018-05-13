term.clear()
term.setCursorPos(10,1)
term.setTextColor(colors.orange)
print("BANK SERVER")
term.setCursorPos(1,3)
rednet.open("top")

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

while true do
	local senderId, message, protocol = rednet.receive("BANK:4471")
	if message:match(";") then
		local cmd, arg1, arg2 = unpack(message:split(";"))
		arg1 = tonumber(arg1)
		arg2 = tonumber(arg2)
		local money = 0
		
		if fs.exists("bank/"..senderId) then
			local file = fs.open("bank/"..senderId, "r")
			money = tonumber(file.readAll())
			file.close()
		else
			local file = fs.open("bank/"..senderId, "w")
			file.write("0")
			file.close()
		end
		
		if(cmd == "check")then
			rednet.send(senderId, money, "BANK:4471")
		elseif(cmd == "send")then
			if arg1 and arg2 and fs.exists("bank/"..arg1) and arg2 <= money then
				local file = fs.open("bank/"..senderId, "w")
				file.write(money - arg2)
				file.close()
				local file = fs.open("bank/"..arg1, "w")
				file.write(money + arg2)
				file.close()
				rednet.send(senderId, true, "BANK:4471")
			else
				rednet.send(senderId, false, "BANK:4471")
			end
		end
	end
end