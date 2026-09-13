local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local WEBHOOK_URL = "DA_WEBHOOK_URL"

local Settings = {
	NotifyEveryone = true,

	OnlyVerified = false,

	OnlyOwner = false,

	GroupFilter = {
		Enabled = false,
		GroupId = 123456789,
		MinimumRank = 1
	}
}

local function shouldNotify(player)
	if Settings.NotifyEveryone then
		return true
	end

	if Settings.OnlyVerified and not player:IsVerified() then
		return false
	end

	if Settings.OnlyOwner and player.UserId ~= game.CreatorId then
		return false
	end

	if Settings.GroupFilter.Enabled then
		if not player:IsInGroup(Settings.GroupFilter.GroupId) then
			return false
		end

		if player:GetRankInGroup(Settings.GroupFilter.GroupId) < Settings.GroupFilter.MinimumRank then
			return false
		end
	end

	return true
end

local function sendJoinNotification(player)
	if not shouldNotify(player) then
		return
	end

	local message = string.format(
		"Yooo %s (@%s) just joined the game 🔥🔥🔥",
		player.DisplayName,
		player.Name
	)

	local data = {
		content = message,
		username = "Join Notifyer"
	}

	local success, err = pcall(function()
		HttpService:PostAsync(
			WEBHOOK_URL,
			HttpService:JSONEncode(data),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if not success then
		warn("Join Notifyer error:", err)
	end
end

Players.PlayerAdded:Connect(sendJoinNotification)
