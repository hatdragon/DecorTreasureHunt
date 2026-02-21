-- Decor Treasure Hunt Addon
-- Helps find Neighborhood Decor Treasure Hunt clues for Alliance and Horde

local addonName, addon = ...

-- Local state
local playerFaction = nil
local selectedFaction = nil
local uiFrame = nil
local filteredData = {}
local scrollOffset = 0

-- Style palette
local COLORS = {
    title        = { 0.6, 0.85, 1.0 },
    bg           = { 0.08, 0.08, 0.08, 0.85 },
    border       = { 0.3, 0.3, 0.3, 0.8 },
    titleBg      = { 0.12, 0.12, 0.12, 0.95 },
    controlsBg   = { 0.10, 0.10, 0.10, 0.90 },
    rowBg        = { 0.1, 0.1, 0.1, 0.5 },
    rowHover     = { 0.15, 0.15, 0.25, 0.7 },
    number       = { 0.5, 0.8, 1.0 },
    riddle       = { 0.85, 0.85, 0.85 },
    coords       = { 0.4, 0.7, 0.4 },
    searchBg     = { 0.06, 0.06, 0.06, 0.9 },
    searchBorder = { 0.25, 0.25, 0.25, 0.8 },
    tabActive    = { 0.2, 0.2, 0.3, 0.9 },
    tabInactive  = { 0.12, 0.12, 0.12, 0.7 },
    tabActiveBorder = { 0.4, 0.4, 0.6, 0.9 },
    tabText      = { 0.8, 0.8, 0.8 },
    tabTextActive = { 1, 1, 1 },
    count        = { 0.5, 0.5, 0.5 },
}

local FRAME_WIDTH = 600
local ROW_HEIGHT = 62
local TITLE_HEIGHT = 28
local CONTROLS_HEIGHT = 34
local PADDING = 8
local ROW_POOL_SIZE = 15
local SCROLL_STEP = 1
local MIN_VISIBLE_ROWS = 3
local DEFAULT_VISIBLE_ROWS = 7
local MIN_WIDTH = 400
local visibleRows = DEFAULT_VISIBLE_ROWS

-- Initialize addon
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        playerFaction = UnitFactionGroup("player")
        selectedFaction = playerFaction
        print("|cff00ff00[Decor Treasure Hunt]|r Loaded! Type |cfffff000/dth|r to open.")
    end
end)

-- Set waypoint using TomTom or built-in system
local function SetWaypoint(mapId, x, y, title)
    if TomTom then
        TomTom:AddWaypoint(mapId, x/100, y/100, {title = title, persistent = false, minimap = true, world = true})
    else
        C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapId, x/100, y/100))
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    end
end

-- Get riddle data for selected faction
local function GetRiddleData()
    if selectedFaction == "Alliance" then
        return addon.AllianceRiddles, addon.ALLIANCE_MAP_ID
    else
        return addon.HordeRiddles, addon.HORDE_MAP_ID
    end
end

-- Tab factory
local function CreateTab(parent, text)
    local tab = CreateFrame("Button", nil, parent, "BackdropTemplate")
    tab:SetSize(80, 22)
    tab:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    tab:SetNormalFontObject("GameFontNormalSmall")
    tab:SetText(text)
    tab.active = false

    function tab:SetActive(active)
        self.active = active
        if active then
            self:SetBackdropColor(unpack(COLORS.tabActive))
            self:SetBackdropBorderColor(unpack(COLORS.tabActiveBorder))
            self:GetFontString():SetTextColor(unpack(COLORS.tabTextActive))
        else
            self:SetBackdropColor(unpack(COLORS.tabInactive))
            self:SetBackdropBorderColor(unpack(COLORS.border))
            self:GetFontString():SetTextColor(unpack(COLORS.tabText))
        end
    end

    tab:SetScript("OnEnter", function(self)
        if not self.active then
            self:SetBackdropColor(0.18, 0.18, 0.25, 0.8)
        end
    end)
    tab:SetScript("OnLeave", function(self)
        self:SetActive(self.active)
    end)

    return tab
end

-- Create the main UI
local function CreateUI()
    -- Main frame
    uiFrame = CreateFrame("Frame", "DecorTreasureHuntFrame", UIParent, "BackdropTemplate")
    uiFrame:SetSize(FRAME_WIDTH, TITLE_HEIGHT + CONTROLS_HEIGHT + (DEFAULT_VISIBLE_ROWS * ROW_HEIGHT) + PADDING)
    uiFrame:SetPoint("CENTER")
    uiFrame:SetFrameStrata("HIGH")
    uiFrame:SetClampedToScreen(true)
    uiFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    uiFrame:SetBackdropColor(unpack(COLORS.bg))
    uiFrame:SetBackdropBorderColor(unpack(COLORS.border))
    tinsert(UISpecialFrames, "DecorTreasureHuntFrame")
    uiFrame:SetResizable(true)
    uiFrame:SetResizeBounds(
        MIN_WIDTH, TITLE_HEIGHT + CONTROLS_HEIGHT + (MIN_VISIBLE_ROWS * ROW_HEIGHT) + PADDING,
        900, TITLE_HEIGHT + CONTROLS_HEIGHT + (ROW_POOL_SIZE * ROW_HEIGHT) + PADDING
    )

    -- Title bar
    local titleBar = CreateFrame("Frame", nil, uiFrame, "BackdropTemplate")
    titleBar:SetHeight(TITLE_HEIGHT)
    titleBar:SetPoint("TOPLEFT", uiFrame, "TOPLEFT", 0, 0)
    titleBar:SetPoint("TOPRIGHT", uiFrame, "TOPRIGHT", 0, 0)
    titleBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    titleBar:SetBackdropColor(unpack(COLORS.titleBg))

    -- Draggable via title bar
    titleBar:EnableMouse(true)
    titleBar:RegisterForDrag("LeftButton")
    titleBar:SetScript("OnDragStart", function() uiFrame:StartMoving() end)
    titleBar:SetScript("OnDragStop", function() uiFrame:StopMovingOrSizing() end)
    uiFrame:SetMovable(true)

    -- Title text
    local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("LEFT", titleBar, "LEFT", PADDING, 0)
    title:SetText("Decor Treasure Hunt")
    title:SetTextColor(unpack(COLORS.title))

    -- Close button
    local closeBtn = CreateFrame("Button", nil, titleBar)
    closeBtn:SetSize(TITLE_HEIGHT - 6, TITLE_HEIGHT - 6)
    closeBtn:SetPoint("RIGHT", titleBar, "RIGHT", -4, 0)
    closeBtn:SetNormalFontObject("GameFontNormal")
    closeBtn:SetText("x")
    closeBtn:GetFontString():SetTextColor(0.7, 0.7, 0.7)
    closeBtn:SetScript("OnClick", function() uiFrame:Hide() end)
    closeBtn:SetScript("OnEnter", function(self) self:GetFontString():SetTextColor(1, 0.3, 0.3) end)
    closeBtn:SetScript("OnLeave", function(self) self:GetFontString():SetTextColor(0.7, 0.7, 0.7) end)

    -- Controls bar (tabs + search)
    local controlsBar = CreateFrame("Frame", nil, uiFrame, "BackdropTemplate")
    controlsBar:SetHeight(CONTROLS_HEIGHT)
    controlsBar:SetPoint("TOPLEFT", titleBar, "BOTTOMLEFT", 0, 0)
    controlsBar:SetPoint("TOPRIGHT", titleBar, "BOTTOMRIGHT", 0, 0)
    controlsBar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
    controlsBar:SetBackdropColor(unpack(COLORS.controlsBg))

    -- Faction tabs
    uiFrame.allianceTab = CreateTab(controlsBar, "Alliance")
    uiFrame.allianceTab:SetPoint("LEFT", controlsBar, "LEFT", PADDING, 0)

    uiFrame.hordeTab = CreateTab(controlsBar, "Horde")
    uiFrame.hordeTab:SetPoint("LEFT", uiFrame.allianceTab, "RIGHT", 4, 0)

    -- Search label
    local searchLabel = controlsBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    searchLabel:SetPoint("LEFT", uiFrame.hordeTab, "RIGHT", 16, 0)
    searchLabel:SetText("Search:")
    searchLabel:SetTextColor(0.6, 0.6, 0.6)

    -- Search box with styled wrapper
    local searchWrapper = CreateFrame("Frame", nil, controlsBar, "BackdropTemplate")
    searchWrapper:SetSize(180, 20)
    searchWrapper:SetPoint("LEFT", searchLabel, "RIGHT", 8, 0)
    searchWrapper:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    searchWrapper:SetBackdropColor(unpack(COLORS.searchBg))
    searchWrapper:SetBackdropBorderColor(unpack(COLORS.searchBorder))

    uiFrame.searchBox = CreateFrame("EditBox", nil, searchWrapper)
    uiFrame.searchBox:SetPoint("TOPLEFT", 4, -2)
    uiFrame.searchBox:SetPoint("BOTTOMRIGHT", -4, 2)
    uiFrame.searchBox:SetFontObject("GameFontHighlightSmall")
    uiFrame.searchBox:SetAutoFocus(false)

    -- Result count
    uiFrame.countText = controlsBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    uiFrame.countText:SetPoint("LEFT", searchWrapper, "RIGHT", 10, 0)
    uiFrame.countText:SetTextColor(unpack(COLORS.count))

    -- Content area
    local content = CreateFrame("Frame", nil, uiFrame)
    content:SetPoint("TOPLEFT", controlsBar, "BOTTOMLEFT", 0, 0)
    content:SetPoint("BOTTOMRIGHT", uiFrame, "BOTTOMRIGHT", 0, 0)

    -- Row pool
    uiFrame.rows = {}
    for i = 1, ROW_POOL_SIZE do
        local row = CreateFrame("Button", nil, content)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", content, "TOPLEFT", 0, -((i - 1) * ROW_HEIGHT))
        row:SetPoint("TOPRIGHT", content, "TOPRIGHT", 0, -((i - 1) * ROW_HEIGHT))
        row:RegisterForClicks("AnyUp")

        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        row.bg:SetColorTexture(unpack(COLORS.rowBg))

        -- Separator line
        local sep = row:CreateTexture(nil, "BORDER")
        sep:SetHeight(1)
        sep:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 0, 0)
        sep:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 0)
        sep:SetColorTexture(0.2, 0.2, 0.2, 0.5)

        row.number = row:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        row.number:SetPoint("TOPLEFT", PADDING, -8)
        row.number:SetTextColor(unpack(COLORS.number))

        row.item = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        row.item:SetPoint("LEFT", row.number, "RIGHT", 10, 0)

        row.riddle = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.riddle:SetPoint("TOPLEFT", PADDING, -28)
        row.riddle:SetPoint("TOPRIGHT", -PADDING, -28)
        row.riddle:SetJustifyH("LEFT")
        row.riddle:SetWordWrap(true)
        row.riddle:SetTextColor(unpack(COLORS.riddle))

        row.coords = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.coords:SetPoint("BOTTOMRIGHT", -PADDING, 6)
        row.coords:SetTextColor(unpack(COLORS.coords))

        row:SetScript("OnEnter", function(self)
            self.bg:SetColorTexture(unpack(COLORS.rowHover))
        end)
        row:SetScript("OnLeave", function(self)
            self.bg:SetColorTexture(unpack(COLORS.rowBg))
        end)

        uiFrame.rows[i] = row
    end

    -- Resize handle
    local resizeHandle = CreateFrame("Button", nil, uiFrame)
    resizeHandle:SetSize(16, 16)
    resizeHandle:SetPoint("BOTTOMRIGHT", -1, 1)
    resizeHandle:SetFrameLevel(uiFrame:GetFrameLevel() + 10)
    resizeHandle.dots = {}
    for gx = 0, 2 do
        for gy = 0, 2 do
            if gx + gy >= 2 then
                local dot = resizeHandle:CreateTexture(nil, "OVERLAY")
                dot:SetSize(2, 2)
                dot:SetPoint("BOTTOMRIGHT", -(gx * 4 + 2), gy * 4 + 2)
                dot:SetColorTexture(0.4, 0.4, 0.4, 0.6)
                table.insert(resizeHandle.dots, dot)
            end
        end
    end
    resizeHandle:SetScript("OnMouseDown", function() uiFrame:StartSizing("BOTTOMRIGHT") end)
    resizeHandle:SetScript("OnMouseUp", function() uiFrame:StopMovingOrSizing() end)
    resizeHandle:SetScript("OnEnter", function(self)
        for _, dot in ipairs(self.dots) do dot:SetColorTexture(0.6, 0.6, 0.8, 0.8) end
    end)
    resizeHandle:SetScript("OnLeave", function(self)
        for _, dot in ipairs(self.dots) do dot:SetColorTexture(0.4, 0.4, 0.4, 0.6) end
    end)

    -- Recalculate visible rows on resize
    uiFrame:SetScript("OnSizeChanged", function(self, width, height)
        visibleRows = math.floor((height - TITLE_HEIGHT - CONTROLS_HEIGHT - PADDING) / ROW_HEIGHT)
        visibleRows = math.max(MIN_VISIBLE_ROWS, math.min(visibleRows, ROW_POOL_SIZE))
        local maxOffset = math.max(0, #filteredData - visibleRows)
        scrollOffset = math.min(scrollOffset, maxOffset)
        addon.RefreshRows()
    end)

    -- Mouse wheel scrolling
    uiFrame:EnableMouseWheel(true)
    uiFrame:SetScript("OnMouseWheel", function(_, delta)
        local maxOffset = math.max(0, #filteredData - visibleRows)
        scrollOffset = math.max(0, math.min(scrollOffset - delta * SCROLL_STEP, maxOffset))
        addon.RefreshRows()
    end)

    -- Tab click handlers
    local function UpdateTabAppearance()
        uiFrame.allianceTab:SetActive(selectedFaction == "Alliance")
        uiFrame.hordeTab:SetActive(selectedFaction == "Horde")
    end

    uiFrame.allianceTab:SetScript("OnClick", function()
        selectedFaction = "Alliance"
        UpdateTabAppearance()
        addon.PopulateUI(uiFrame.searchBox:GetText())
    end)

    uiFrame.hordeTab:SetScript("OnClick", function()
        selectedFaction = "Horde"
        UpdateTabAppearance()
        addon.PopulateUI(uiFrame.searchBox:GetText())
    end)

    uiFrame.UpdateTabAppearance = UpdateTabAppearance

    -- Search handlers
    uiFrame.searchBox:SetScript("OnTextChanged", function(self)
        addon.PopulateUI(self:GetText())
    end)
    uiFrame.searchBox:SetScript("OnEnterPressed", function(self)
        self:ClearFocus()
    end)
    uiFrame.searchBox:SetScript("OnEscapePressed", function(self)
        self:SetText("")
        self:ClearFocus()
    end)

    UpdateTabAppearance()
end

function addon.PopulateUI(filter)
    local riddles, mapId = GetRiddleData()
    filter = filter and filter:lower() or ""

    filteredData = {}
    for i, data in ipairs(riddles) do
        local matchesFilter = filter == "" or
            data.riddle:lower():find(filter, 1, true) or
            (data.item and data.item:lower():find(filter, 1, true))
        if matchesFilter then
            table.insert(filteredData, { index = i, data = data, mapId = mapId })
        end
    end

    scrollOffset = 0
    addon.RefreshRows()
end

function addon.RefreshRows()
    for i = 1, ROW_POOL_SIZE do
        local row = uiFrame.rows[i]
        local dataIdx = i + scrollOffset
        local entry = filteredData[dataIdx]

        if i <= visibleRows and entry then
            row.number:SetText("#" .. entry.index)
            row.item:SetText(entry.data.item or "")
            row.riddle:SetText(entry.data.riddle)
            row.coords:SetText(string.format("%.1f, %.1f", entry.data.x, entry.data.y))

            local riddleData = entry.data
            local riddleNum = entry.index
            local mapId = entry.mapId
            row:SetScript("OnClick", function()
                SetWaypoint(mapId, riddleData.x, riddleData.y, riddleData.item or ("Riddle #" .. riddleNum))
                print(string.format("|cff00ff00[Decor Treasure Hunt]|r Waypoint set: |cfffff000%s|r (%.1f, %.1f)",
                    riddleData.item or ("Riddle #" .. riddleNum), riddleData.x, riddleData.y))
            end)

            row:Show()
        else
            row:Hide()
        end
    end

    -- Update count with scroll position
    local total = #filteredData
    if total > 0 then
        local first = scrollOffset + 1
        local last = math.min(scrollOffset + visibleRows, total)
        uiFrame.countText:SetText(string.format("%d-%d of %d", first, last, total))
    else
        uiFrame.countText:SetText("0 results")
    end
end

function addon.ToggleUI()
    if uiFrame and uiFrame:IsShown() then
        uiFrame:Hide()
        return
    end

    if not uiFrame then
        CreateUI()
    end

    selectedFaction = playerFaction
    uiFrame.UpdateTabAppearance()
    uiFrame.searchBox:SetText("")
    addon.PopulateUI()
    uiFrame:Show()
end

-- Single slash command to open UI
SLASH_DECORTREASUREHUNT1 = "/dth"
SlashCmdList["DECORTREASUREHUNT"] = function()
    addon.ToggleUI()
end
