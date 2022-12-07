--OnLoad stuff
local f = CreateFrame("Frame"); -- this is the frame for message sending thing
local f2 = CreateFrame("Frame"); -- this is the frame for initialization of the addon
f2:RegisterEvent("PLAYER_LOGIN");

-- This is the thing that sends messages
function f:onUpdate(sinceLastUpdate)

	self.sinceLastUpdate = (self.sinceLastUpdate or 0) + sinceLastUpdate;
	if ( self.sinceLastUpdate >= rate*60 ) then -- in seconds
		local worldnumber = GetChannelName("World")
		SendChatMessage(messages[i], "CHANNEL","ORCISH",worldnumber);
		i=i+1;
		self.sinceLastUpdate = 0;
		if (i>#messages) then
			i=1;
		end
	end
end

--Stuff for the /commands

SLASH_PHRASE1 = "/gr";
SLASH_PHRASE2 = "/guildrecruitment";

SlashCmdList["PHRASE"] = function(msg)
	if msg == "" then
		print("/gr show -- will show all messages")
		print("/gr rate [number in minutes] -- will set time between messages")
		print("Current rate =",rate,"min")
		print("/gr add [your new message] -- adds a new message to the list")
		print("/gr remove [index] --removes messages from the list")
	
	elseif msg.sub(msg,1,4) == "show" then
		for x = 1,#messages,1 do
			print ("[",x,"] - ",messages[x])
		end
	
	elseif msg.sub(msg,1,4) == "rate" then
		rate = tonumber(msg.sub(msg,6,#msg ))
		print("rate set to",rate,"min")
		
	elseif msg.sub(msg,1,3) == "add" then
		table.insert(messages,msg.sub(msg,5,#msg))
	
	elseif msg.sub(msg,1,6) == "remove" then
		table.remove(messages,tonumber(msg.sub(msg,7,#msg)))
	
	else
		print("Command not recognized. Type /gr to see command options")
		
	end
	
end


--Event handler for the message sender
f:SetScript("OnUpdate",f.onUpdate)

-- Event handler for the initialization
f2:SetScript("OnEvent", function(self,event,...)

	if event == "PLAYER_LOGIN" then
		if messages == nil then
			messages = {"My Guild is Recruiting! PST for more info"}
			print("Guild Recruitment has initialized for the first time on this account! /grecruit to config")
		end
		
		if rate == nil then
			rate = 10
			print("default rate set to 10 minutes")
		end
		i = math.random(#messages); -- this just starts list from random messages
	end
end)
