-- Aura.lua : Core setup of the Aura module and event processing

if select(6, GetAddOnInfo("PitBull4_" .. (debugstack():match("[o%.][d%.][u%.]les\\(.-)\\") or ""))) ~= "MISSING" then return end

local _G = getfenv(0)
local PitBull4 = _G.PitBull4
if not PitBull4 then
        error("PitBull4_Aura requires PitBull4")
end

local PitBull4_Aura= PitBull4:NewModule("Aura", "AceEvent-3.0", "AceTimer-3.0")

PitBull4_Aura:SetModuleType("custom")
PitBull4_Aura:SetName("Aura")
PitBull4_Aura:SetDescription("Shows buffs and debuffs for PitBull4 frames.")

function PitBull4_Aura:OnEnable()
	self:RegisterEvent("UNIT_AURA")
	self:ScheduleRepeatingTimer("OnUpdate", 0)
end

local units_to_update = {}

function PitBull4_Aura:UNIT_AURA(event, unit)
	-- UNIT_AURA updates are throttled to 1 per frame
	-- by collecting them in units_to_update and then updating
	-- the relevent frames once per frame.
	units_to_update[unit] = true	
end

-- Function to execute the throttled updates
function PitBull4_Aura:OnUpdate()
	for frame in PitBull4:IterateFrames() do
		if units_to_update[frame.unit] then
			if self:GetLayoutDB(frame).enabled then
				self:UpdateFrame(frame)
			else
				self:ClearFrame(frame)
			end
		end
	end
	table.wipe(units_to_update)

	self:UpdateCooldownTexts()
end

function PitBull4_Aura:ClearFrame(frame)
	self:ClearAuras(frame)
end

function PitBull4_Aura:UpdateFrame(frame)
	self:UpdateAuras(frame)
	self:LayoutAuras(frame)
end