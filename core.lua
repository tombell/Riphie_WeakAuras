local A, L = ...

local LSM = LibStub("LibSharedMedia-3.0")
LSM:Register("statusbar", "Skullflower", "Interface\\AddOns\\"..A.."\\media\\Skullflower")
LSM:Register("statusbar", "Skullflower 2", "Interface\\AddOns\\"..A.."\\media\\Skullflower2")
LSM:Register("statusbar", "Skullflower 3", "Interface\\AddOns\\"..A.."\\media\\Skullflower3")
LSM:Register("statusbar", "Skullflower Light", "Interface\\AddOns\\"..A.."\\media\\SkullflowerLight")

if not IsAddOnLoaded("WeakAuras") then return end

local function CreateBackdrop(frame)
  if frame.backdrop then return end

  local backdrop = CreateFrame("Frame", nil, frame)
  backdrop:ClearAllPoints()
  backdrop:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
  backdrop:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

  backdrop:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
    tile = false,
    tileSize = 0,
    edgeSize = 1,
    insets = { left = 0, right = 0, top = 0, bottom = 0 },
  })

  backdrop:SetBackdropBorderColor(0, 0, 0)
  backdrop:SetBackdropColor(0, 0, 0, 1)

  if frame:GetFrameLevel() - 1 >= 0 then
    backdrop:SetFrameLevel(frame:GetFrameLevel() - 1)
  else
    backdrop:SetFrameLevel(0)
  end

  frame.backdrop = backdrop
end

local function SkinWeakAuras(frame, ftype)
  if not frame.backdrop then
    CreateBackdrop(frame)

    if ftype == "icon" then
      frame.backdrop:HookScript("OnUpdate", function(self)
        self:SetAlpha(self:GetParent().icon:GetAlpha())

        if frame:GetFrameLevel() - 1 >= 0 then
          self:SetFrameLevel(frame:GetFrameLevel() - 1)
        else
          self:SetFrameLevel(0)
        end
      end)
    end
  end

  if ftype == "aurabar" then frame.backdrop:Show() end
end

local CreateIcon = WeakAuras.regionTypes.icon.create
WeakAuras.regionTypes.icon.create = function(parent, data)
  local region = CreateIcon(parent, data)
  SkinWeakAuras(region, "icon")
  region.icon:SetTexCoord(.08, .92, .08, .92)
  return region
end

local ModifyIcon = WeakAuras.regionTypes.icon.modify
WeakAuras.regionTypes.icon.modify = function(parent, region, data)
  ModifyIcon(parent, region, data)
  SkinWeakAuras(region, "icon")
  region.icon:SetTexCoord(.08, .92, .08, .92)
end

local CreateAuraBar = WeakAuras.regionTypes.aurabar.create
WeakAuras.regionTypes.aurabar.create = function(parent)
  local region = CreateAuraBar(parent)
  SkinWeakAuras(region, "aurabar")
  region.icon:SetTexCoord(.08, .92, .08, .92)
  return region
end

local ModifyAuraBar = WeakAuras.regionTypes.aurabar.modify
WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
  ModifyAuraBar(parent, region, data)
  SkinWeakAuras(region, "aurabar")
  region.icon:SetTexCoord(.08, .92, .08, .92)
end

for aura, _ in pairs(WeakAuras.regions) do
  local ftype = WeakAuras.regions[aura].regionType

  if ftype == "icon" or ftype == "aurabar" then
    SkinWeakAuras(WeakAuras.regions[aura].region, ftype)
  end
end
