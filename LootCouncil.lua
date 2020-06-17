local addonName, _ = ...;

-- NIL = 240
-- INT = 241
-- TRUE = 242
-- FALSE = 243
-- STRING = 244

local serialize, deserialize = {}, {};
serialize["nil"] = function() return "\240" end
serialize["number"] = function(n) return "\241" .. n end
serialize["boolean"] = function(bool) return bool and "\242" or "\243" end
serialize["string"] = function(str) return "\244" .. str end
deserialize["\240"] = function() return nil end
deserialize["\241"] = function(str) return tonumber(str) end
deserialize["\242"] = function() return true end
deserialize["\243"] = function() return false end
deserialize["\244"] = function(str) return str end

local function Serialize(...)
	local t = {};
	for i = 1, select("#", ...) do
    local v = select(i, ...);
		table.insert(t, serialize[type(v)](v));
	end
	return table.concat(t);
end

local function Deserialize(str)
	local t = {};
	for type, v in string.gmatch(str, "([\240-\244])([^\240-\244]*)") do
		table.insert(t, deserialize[type](v));
	end
	return unpack(t);
end

-- Frame

LootCouncilMixin = {
	channel = "RAID",
	events = {
		"CHAT_MSG_ADDON",
		"LOOT_READY",
		"LOOT_OPENED",
		"LOOT_CLOSED"
	}
};

function LootCouncilMixin:OnLoad()
	_G.C_ChatInfo.RegisterAddonMessagePrefix(addonName);
	for _, event in pairs(self.events) do
		self:RegisterEvent(event);
	end
end

function LootCouncilMixin:OnEvent(event, ...)
	LootCouncilMixin[event](self, ...);
end

function LootCouncilMixin:CHAT_MSG_ADDON(prefix, message, channel, sender, ...)
	if prefix ~= addonName or channel ~= self.channel then return end
	print(sender, Deserialize(message));
	MasterLootFrame:Show();
end

function LootCouncilMixin:LOOT_READY(autoloot)
	-- print("LOOT_READY");

	--[[
	for index = 1, MAX_RAID_MEMBERS do
		local candidate = GetMasterLootCandidate(slot, index);
		if not candidate then break end
		print("    " .. index .. " -> " .. candidate);
	end
	]]--
end

function LootCouncilMixin:LOOT_OPENED(autoLoot, isFromItem)
	-- print("LOOT_OPENED");
	for slot, info in pairs(GetLootInfo()) do
		local message = Serialize(info.item, info.quality, info.quantity, info.texture);
	  _G.C_ChatInfo.SendAddonMessage(addonName, message, self.channel);
	end
end

function LootCouncilMixin:LOOT_CLOSED()
	-- print("LOOT_CLOSED");
end
