if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local PitBull4 = _G.PitBull4
if not PitBull4 then
	error("PitBull4_LeaderIcon requires PitBull4")
end

local PitBull4_LeaderIcon = PitBull4:NewModule("LeaderIcon", "AceEvent-3.0", "AceTimer-3.0")

PitBull4_LeaderIcon:SetModuleType("icon")
PitBull4_LeaderIcon:SetName("Leader Icon")
PitBull4_LeaderIcon:SetDescription("Show an icon on the unit frame when the unit is the group leader.")
PitBull4_LeaderIcon:SetDefaults({
	attach_to = "root",
	location = "edge_bottom_left",
	position = 1,
})

function PitBull4_LeaderIcon:OnEnable()
	self:RegisterEvent("PARTY_LEADER_CHANGED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
end

local ACCEPTABLE_CLASSIFICATIONS = {
	player = true,
	party = true,
	raid = true,
}

function PitBull4_LeaderIcon:GetTexture(frame)
	local unit = frame.unit
	
	if unit == "player" then
		if not IsPartyLeader() then
			return nil
		end
	else
		local raid_num = unit:match("^raid(%d%d?)$")
		if raid_num then
			local _, rank = GetRaidRosterInfo(raid_num+0)
			if rank ~= 2 then
				return nil
			end
		else
			local party_num = unit:match("^party(%d)$")
			if not party_num or (party_num+0) ~= GetPartyLeaderIndex() then
				return nil
			end
		end
	end
	
	return [[Interface\GroupFrame\UI-Group-LeaderIcon]]
end

function PitBull4_LeaderIcon:GetTexCoord(frame, texture)
	return 0.1, 0.84, 0.14, 0.88
end

function PitBull4_LeaderIcon:PARTY_LEADER_CHANGED()
	self:ScheduleTimer("UpdateAll", 0.1)
end
PitBull4_LeaderIcon.PARTY_MEMBERS_CHANGED = PitBull4_LeaderIcon.PARTY_LEADER_CHANGED