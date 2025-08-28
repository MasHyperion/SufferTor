local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Servers = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
local Server, Next = nil, nil
local function ListServers(cursor)
    local Raw = game:HttpGet(Servers .. ((cursor and "&cursor=" .. cursor) or ""))
    return HttpService:JSONDecode(Raw)
end

repeat
    local Servers = ListServers(Next)
    Server = Servers.data[math.random(1, (#Servers.data / 3))]
    Next = Servers.nextPageCursor
until Server

if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
    TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, game.Players.LocalPlayer)
end
			for _, Server in pairs(Body.data) do
				if
					typeof(Server) ~= "table"
					or not Server.id
					or not tonumber(Server.playing)
					or not tonumber(Server.maxPlayers)
				then
					continue
				end

				if Server.playing < Server.maxPlayers and not table.find(Data.Jobs, Server.id) then
					table.insert(Servers, 1, Server.id)
				end
			end
		end)

		if Body.nextPageCursor then
			Cursor = Body.nextPageCursor
		end
	end

	while #Servers > 0 and task.wait(Config.TeleportInterval / 1000) do
		local Server = Servers[math.random(1, #Servers)]
		TeleportService:TeleportToPlaceInstance(PlaceId, Server, Player)
	end
end
