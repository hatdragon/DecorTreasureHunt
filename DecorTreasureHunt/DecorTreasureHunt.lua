-- Decor Treasure Hunt Addon
-- Helps find Neighborhood Decor Treasure Hunt clues for Alliance and Horde

local addonName, addon = ...

-- Map IDs for neighborhoods
local ALLIANCE_MAP_ID = 2352
local HORDE_MAP_ID = 2351

-- Alliance Riddles (Map ID 2352)
local AllianceRiddles = {
    {riddle = "Stone laid by lost hands. His name swallowed by the tide. Look where lilies listen.", x = 63.2, y = 38.3, item = "Sturdy Wooden Bookcase"},
    {riddle = "Sentinel of stone. First to greet each new neighbor. Seek out the deep shade.", x = 58.1, y = 30.1, item = "Sturdy Wooden Shelf"},
    {riddle = "Clouds bow to the stone. Heights where gryphons dare not fly. Above all, it waits.", x = 69.2, y = 26.7, item = "Sturdy Wooden Interior Door"},
    {riddle = "Highland rime meets mists. Gateway to the dusky wood. The dead point the way.", x = 63.1, y = 46.7, item = "Goldshire Window"},
    {riddle = "Stone eye scans the shade. Forest breathes beneath its gaze. Look to the lone pine.", x = 64.8, y = 50.9, item = "Tall Sturdy Wooden Bookcase"},
    {riddle = "No leaves, yet it blooms. Still limbs cradle gentle glows. Wade where violet grows.", x = 59.8, y = 52.4, item = "Sturdy Wooden Chair"},
    {riddle = "Fireflies glow and flit. Falls feed the whispering wood. The drowned cave awaits.", x = 66.9, y = 57.0, item = "Stormwind Interior Narrow Wall"},
    {riddle = "Names worn down by time. Stone weeps where the water sings. Drop a coin, then dig.", x = 58.3, y = 65.0, item = "Stormwind Interior Doorway"},
    {riddle = "Trellis frames the torch. A seat above misty shores. Seek the ledge below.", x = 52.8, y = 66.8, item = "Stormwind Interior Wall"},
    {riddle = "Tribute to the lost. Where seaspray climbs ancient cliffs. A lonely bell tolls.", x = 55.3, y = 71.3, item = "Sturdy Wooden Bench"},
    {riddle = "Salt clings to old wood. Crow's nests watch the tide retreat. A cave holds secrets.", x = 61.6, y = 79.4, item = "Wicker Basket"},
    {riddle = "A weary roof sighs. Ships rot just beyond the reach. Look beneath the bow.", x = 54.2, y = 73.6, item = "Reinforced Wooden Chest"},
    {riddle = "Across from the bight. The oyster shuckers have gone. Search the lonely dock.", x = 64.5, y = 85.6, item = "Iron-Reinforced Cupboard"},
    {riddle = "Awnings span river's flow. Gold to the west, darkness east. Look beneath stunted tree.", x = 47.7, y = 61.9, item = "Stormwind Beam Platform"},
    {riddle = "Pale moonlight rises. Wisps guard what the dusk holds dear. Look where roots rise up.", x = 49.9, y = 56.6, item = "Stormwind Round Platform"},
    {riddle = "Aboveground tunnel. Lights mark where life's blood once flowed. Look atop the falls.", x = 54.9, y = 50.6, item = "Stormwind Large Platform"},
    {riddle = "Water flows below. While fresh cider flows above. Dig where the wheel churns.", x = 46.3, y = 58.0, item = "Small Wooden Stool"},
    {riddle = "Below autumn soil. Gargled seaweed and dead fish. Stone mouth drinks the sea.", x = 45.4, y = 64.4, item = "Small Wooden Nightstand"},
    {riddle = "Cows low in their pen. Leaves fall on the roundabout. Treasure waits within.", x = 40.8, y = 61.3, item = "Carved Wooden Crate"},
    {riddle = "Small farmer's homestead. Where cows bask in golden light. Dig between the rows.", x = 39.1, y = 59.9, item = "Tall Sturdy Wooden Chair"},
    {riddle = "Light sweeps open sea. A beacon upon the bluff. Look behind its back.", x = 33.9, y = 72.8, item = "Short Wooden Cabinet"},
    {riddle = "Blades turn in the wind. Amber leaves drift toward the sea. Check beneath the stairs.", x = 34.6, y = 60.2, item = "Three-Candle Wrought Iron Chandelier"},
    {riddle = "Hollow nurse log yawns. Waters reflect gold above. Dry leaves hide riches.", x = 36.6, y = 57.8, item = "Wrought Iron Floor Lamp"},
    {riddle = "Harvest hangs from boughs. Crimson against autumn gold. Trust the lantern's light.", x = 36.6, y = 54.2, item = "Wrought Iron Chandelier"},
    {riddle = "Prism of the cove. Where worn stone endures the roar. Dive deep to prevail.", x = 37.1, y = 45.9, item = "Wooden Chamberstick"},
    {riddle = "Beneath gryphon wings. On the small aerie's low slopes. Find the broken tree.", x = 42.6, y = 53.8, item = "Sturdy Wooden Bed"},
    {riddle = "Covered connection. Over the lilied waters. Search the banks below.", x = 42.5, y = 44.7, item = "Covered Wooden Table"},
    {riddle = "Beyond smugglers cove. Wrecks hide a sunken saloon. Look for the good stuff.", x = 61.0, y = 82.0, item = "Sturdy Fireplace"},
    {riddle = "Watcher on the shore. Where ships drop anchor and make berth. Look where crabs scuttle.", x = 29.8, y = 48.4, item = "Wide Charming Couch"},
    {riddle = "Gulls scream for free meals. Salt clings to fishmonger scales. Seek the barnacles.", x = 28.5, y = 44.8, item = "Iron-Reinforced Standing Mirror"},
    {riddle = "Boardwalk lies broken. Sand bars cradle what remains. Seek out the lone plank.", x = 28.3, y = 40.1, item = "Carved Wooden Bar Table"},
    {riddle = "An old flag flutters. A platform grants ocean views. Look below the stairs.", x = 26.2, y = 37.9, item = "Large Covered Wooden Table"},
    {riddle = "Outside outer banks. Where crabs claim an island shore. Sift through the driftwood.", x = 21.0, y = 30.0, item = "Large Sturdy Wooden Table"},
    {riddle = "Stairs snake up the bluffs. A pier juts over shallows. Seek the shade below.", x = 29.0, y = 28.1, item = "Charming Couch"},
    {riddle = "A lone flag flutters. Covered bridge over dry ground. Sift the sand beneath.", x = 30.9, y = 31.1, item = "Elegant Table Lamp"},
    {riddle = "Petals sway in the breeze. Wooden arms sweep floral scents. Look where pink meets gold.", x = 36.9, y = 32.8, item = "Bel'ameth Interior Wall"},
    {riddle = "Twin silos stand watch. Meandering rows slumber. Search among the rocks.", x = 39.9, y = 32.0, item = "Bel'ameth Round Interior Pillar"},
    {riddle = "Vines climb the hillside. Their yield crushed in tubs of wood. Look where juice stains earth.", x = 40.9, y = 28.3, item = "Bel'ameth Interior Doorway"},
    {riddle = "Cool waters, unfed. Still against blue sky and green. Sheltered by the cliff.", x = 49.1, y = 27.1, item = "Bel'ameth Beam Platform"},
    {riddle = "Lush trees grow skyward. A stream threads through leafy glades. Look where waters churn.", x = 49.7, y = 42.5, item = "Bel'ameth Round Platform"},
    {riddle = "Seek the smallest house. Where pawsteps mark the sand. Now dig where dogs lie.", x = 53.6, y = 41.9, item = "Bel'ameth Large Platform"},
    {riddle = "Six sides, but no walls. Afloat above chill waters. Secrets wait below.", x = 52.0, y = 29.0, item = "Ornate Stonework Fireplace"},
    {riddle = "Azure and gold sway. While beneath pretenders play. Investigate stage left.", x = 57.3, y = 39.2, item = "Gemmed Elven Chest"},
    {riddle = "Earth, fire, smoke, and steam. Blade or plow, the shaper's choice. Look where metals bend.", x = 53.6, y = 39.7, item = "Small Elegant Padded Chair"},
    {riddle = "Mushrooms mark the ring. Deep within the shadowed wood. Dig where fireflies swarm.", x = 60.3, y = 56.8, item = "Grand Elven Bookcase"},
    {riddle = "Where trees have no roots. A gate has no door or hinge. Will call for treasure.", x = 55.0, y = 40.0, item = "Circular Elven Table"},
    {riddle = "Arcane power thrums. Journey home with a mere step. Dig beside the roost.", x = 56.6, y = 27.5, item = "Elegant Padded Chaise"},
    {riddle = "Where roses are red. The perfect venue awaits. Throw some rice, then dig.", x = 57.7, y = 42.0, item = "Elegant Elven Desk"},
    {riddle = "Cart lost in the dark. Growth consumes all that remains. Search beside the road.", x = 56.8, y = 52.3, item = "Elven Floral Window"},
    {riddle = "Near the twilit wood. Falls give a cave's mouth its roar. Look beneath the torch.", x = 59.0, y = 45.7, item = "Elegant Padded Footstool"},
}

-- Horde Riddles (Map ID 2351)
local HordeRiddles = {
    {riddle = "Between mighty tusks. A doorway shimmers and hums. Look where the carts park.", x = 53.5, y = 50.0, item = "Orgrimmar Interior Doorway"},
    {riddle = "Two towers stand guard. Worn bridge spans the falls below. Go smell some flowers.", x = 55.6, y = 49.9, item = "Orgrimmar Interior Wall"},
    {riddle = "Though it may have leaks. Wooden wall diverts the stream. Check the ledge below.", x = 56.4, y = 47.9, item = "Orgrimmar Round Interior Pillar"},
    {riddle = "Back steps to the wood. Above needled canopy. Stop halfway and search.", x = 58.0, y = 48.9, item = "Rugged Stool"},
    {riddle = "Three falls feed the flows. Fishers hunt with spear and trap. Look below the traps.", x = 63.5, y = 44.7, item = "Iron Chain Chandelier"},
    {riddle = "Six tables are dressed. Conifers observe the feast. Compliment the chef.", x = 62.2, y = 48.9, item = "Iron-Reinforced Door"},
    {riddle = "Mist threads through the pines. Sellers ring the roundabout. Search the succulents.", x = 62.6, y = 51.6, item = "Iron-Studded Wooden Window"},
    {riddle = "From sagging rope bridge. Torches mark a steep descent. Search the water's edge.", x = 72.0, y = 50.0, item = "Orgrimmar Chair"},
    {riddle = "Cedar scents the air. Where kneaded muscles soak deep. Search between the tubs.", x = 68.9, y = 52.5, item = "Rugged Brazier"},
    {riddle = "Platform high above. At the edge of sea and wood. Look where the lights sway.", x = 72.1, y = 41.8, item = "Orgrimmar Nightstand"},
    {riddle = "Through an arch of bone. A stream cradles what once moved. Search the vertebrae.", x = 60.7, y = 64.5, item = "Durable Wooden Chest"},
    {riddle = "Near the scorching songs. Arbor frames the setting sun. Dig beyond the vows.", x = 38.6, y = 80.2, item = "Orgrimmar Beam Platform"},
    {riddle = "Below the towers. Townsfolk guarded from the spray. Dig in awning's shade.", x = 55.5, y = 52.4, item = "Orgrimmar Round Platform"},
    {riddle = "Below forest deck. Secret straw-floored writer's nook. Seek the wheelbarrow.", x = 63.7, y = 56.2, item = "Orgrimmar Large Platform"},
    {riddle = "Deep in the forest. Where the hookah haze rises. Treasure waits below.", x = 64.6, y = 58.0, item = "High-Backed Orgrimmar Chair"},
    {riddle = "Where the desert blooms. Fire burns at circle's center. Look to the shadows.", x = 57.7, y = 63.4, item = "Short Orgrimmar Bench"},
    {riddle = "Wave-swept sandy knoll. Follow the bridge to nowhere. Dig among the palms.", x = 68.3, y = 68.9, item = "Iron-Reinforced Crate"},
    {riddle = "Seagulls await ships. Tower watches, fountain spits. Look where wyverns perch.", x = 68.1, y = 75.7, item = "Large Orgrimmar Bookcase"},
    {riddle = "One boardwalk above. A second boardwalk below. Search near the canoes.", x = 64.8, y = 73.0, item = "Short Orgrimmar Bookcase"},
    {riddle = "Nature carved a gate. Sea and sand mingle below. Search atop the arch.", x = 61.8, y = 78.4, item = "Tusked Candleholder"},
    {riddle = "Two huts crowd the isle. Beach grass sways in the sea breeze. Swim with the starfish.", x = 63.2, y = 92.5, item = "Horned Hanging Sconce"},
    {riddle = "Wooden mask tends bar. Pineapples lift the spirits. Dig near the fire pit.", x = 58.0, y = 86.2, item = "Spiky Banded Barrel"},
    {riddle = "Boasting two bridges. Isle's lone palm leans toward the shore. Search the coconuts.", x = 58.0, y = 79.9, item = "Horned Banded Barrel"},
    {riddle = "Sea's greatest hunter. Hanging in the salted air. Search below the deck.", x = 53.8, y = 82.0, item = "Crude Banded Crate"},
    {riddle = "Hot air fills the canvas. Where boardwalk crowns stoney arch. Look where paths cross.", x = 52.1, y = 81.8, item = "Small Orgrimmar Chair"},
    {riddle = "Salt and sky collide. Tower guards the fisher's catch. Dig at the front steps.", x = 53.4, y = 84.6, item = "Razorwind Storage Table"},
    {riddle = "Oceanside ravine. Pirate camp awaits above. Anchor marks the spot.", x = 50.3, y = 83.0, item = "Hide-Covered Wall Shelf"},
    {riddle = "Seek the bone tunnel. In sight of a broken hull. Trace the sunken chain.", x = 47.8, y = 88.6, item = "Orgrimmar Bureaucrat's Desk"},
    {riddle = "Dead hulk in the tide. A mast lies against the dunes. The crow's nest sees all.", x = 44.2, y = 86.7, item = "Tusked Fireplace"},
    {riddle = "Stone mouth, wooden teeth. Mast as toothpick, should it eat. Go down its gullet.", x = 39.8, y = 72.8, item = "Orgrimmar Tusked Bed"},
    {riddle = "Oasis watcher. Perched above crystal waters. Find the bench below.", x = 42.1, y = 66.3, item = "Razorwind Bar Table"},
    {riddle = "Where palm trees grow thick. Platform sits on stone's old spine. Look to the low flame.", x = 44.0, y = 66.0, item = "Wide Hide-Covered Bench"},
    {riddle = "Old watering hole. Take a swing or take a dive. Hold your breath and dig.", x = 42.4, y = 50.4, item = "Razorwind Wall Mirror"},
    {riddle = "Down below the bluffs. Water flows below stone bridge. Dive to the shipwreck.", x = 51.6, y = 82.6, item = "Long Orgrimmar Bench"},
    {riddle = "From atop the falls. Stargazers peer past the palms. Dig through their notes.", x = 45.2, y = 56.3, item = "Lovely Elven Shelf"},
    {riddle = "Where clear waters churn. The earth opens wide to breathe. What waits in its maw?", x = 45.4, y = 57.3, item = "Silvermoon Round Interior Pillar"},
    {riddle = "Oasis bears fruit. Seek not the greens, but purple. Harvest at center.", x = 47.1, y = 59.6, item = "Silvermoon Interior Wall"},
    {riddle = "Steam bursts toward the sky. Blue pools swirl with ancient heat. Look for the tether.", x = 51.7, y = 72.7, item = "Silvermoon Interior Doorway"},
    {riddle = "Penned in desert bloom. Loyal steeds water and feed. Needles in haystacks.", x = 59.0, y = 73.7, item = "Silvermoon Large Platform"},
    {riddle = "Three huts in spire's shade. Wooden overlook curves out front. Search near a planter.", x = 64.5, y = 69.1, item = "Silvermoon Round Platform"},
    {riddle = "Where kodos take rest. Past gate marked with bone and fire. Dig near the hay bale.", x = 57.8, y = 59.0, item = "Silvermoon Beam Platform"},
    {riddle = "Just like Thunder Bluff. Tower watches three swaying paths. Look to the platform.", x = 50.3, y = 76.8, item = "Elegant Elven Chandelier"},
    {riddle = "Near where farmers toil. Beast of burden raises young. Seek the broadest shade.", x = 50.8, y = 61.5, item = "Open Elegant Elven Barrel"},
    {riddle = "Overlooking fields. Bushels brim with bloom and seed. Check for stock in back.", x = 49.5, y = 59.9, item = "Elegant Padded Chair"},
    {riddle = "Highest wyvern perch. Circling above the sea. Look to the center.", x = 50.9, y = 89.6, item = "Carved Elven Bookcase"},
    {riddle = "Across gentle falls. Bridge broken, chains given way. Look to the east end.", x = 43.2, y = 69.4, item = "Elegant Almond Table"},
    {riddle = "Smugglers scheme above. Tortollans tend bar below. Search through the seaweed.", x = 39.2, y = 74.0, item = "Elegant Padded Divan"},
    {riddle = "A secret beast den. Hidden behind narrow falls. Search the oasis.", x = 39.4, y = 57.6, item = "Elegant Wooden Dresser"},
    {riddle = "The fire never ends. Gather for sorrow or mirth. Search behind the fuel.", x = 39.8, y = 78.7, item = "Elegant Curved Table"},
    {riddle = "Life stirs from dry soil. Camp where fishers may take rest. Fire warms the treasure.", x = 58.0, y = 69.0, item = "Small Elegant End Table"},
}

-- Local state
local playerFaction = nil
local selectedFaction = nil
local uiFrame = nil

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
        return AllianceRiddles, ALLIANCE_MAP_ID
    else
        return HordeRiddles, HORDE_MAP_ID
    end
end

-- Create the main UI
local function CreateUI()
    uiFrame = CreateFrame("Frame", "DecorTreasureHuntFrame", UIParent, "BasicFrameTemplateWithInset")
    uiFrame:SetSize(600, 500)
    uiFrame:SetPoint("CENTER")
    uiFrame:SetMovable(true)
    uiFrame:EnableMouse(true)
    uiFrame:RegisterForDrag("LeftButton")
    uiFrame:SetScript("OnDragStart", uiFrame.StartMoving)
    uiFrame:SetScript("OnDragStop", uiFrame.StopMovingOrSizing)
    uiFrame:SetFrameStrata("HIGH")
    tinsert(UISpecialFrames, "DecorTreasureHuntFrame")

    -- Title
    uiFrame.title = uiFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    uiFrame.title:SetPoint("TOP", 0, -5)
    uiFrame.title:SetText("Decor Treasure Hunt")

    -- Faction tabs
    uiFrame.allianceTab = CreateFrame("Button", nil, uiFrame, "UIPanelButtonTemplate")
    uiFrame.allianceTab:SetSize(100, 25)
    uiFrame.allianceTab:SetPoint("TOPLEFT", 15, -30)
    uiFrame.allianceTab:SetText("Alliance")

    uiFrame.hordeTab = CreateFrame("Button", nil, uiFrame, "UIPanelButtonTemplate")
    uiFrame.hordeTab:SetSize(100, 25)
    uiFrame.hordeTab:SetPoint("LEFT", uiFrame.allianceTab, "RIGHT", 5, 0)
    uiFrame.hordeTab:SetText("Horde")

    -- Search box
    uiFrame.searchLabel = uiFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    uiFrame.searchLabel:SetPoint("LEFT", uiFrame.hordeTab, "RIGHT", 20, 0)
    uiFrame.searchLabel:SetText("Search:")

    uiFrame.searchBox = CreateFrame("EditBox", nil, uiFrame, "InputBoxTemplate")
    uiFrame.searchBox:SetSize(180, 20)
    uiFrame.searchBox:SetPoint("LEFT", uiFrame.searchLabel, "RIGHT", 10, 0)
    uiFrame.searchBox:SetAutoFocus(false)

    -- Result count
    uiFrame.countText = uiFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    uiFrame.countText:SetPoint("LEFT", uiFrame.searchBox, "RIGHT", 10, 0)
    uiFrame.countText:SetTextColor(0.7, 0.7, 0.7)

    -- Scroll frame
    uiFrame.scrollFrame = CreateFrame("ScrollFrame", nil, uiFrame, "UIPanelScrollFrameTemplate")
    uiFrame.scrollFrame:SetPoint("TOPLEFT", 10, -65)
    uiFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    uiFrame.scrollChild = CreateFrame("Frame")
    uiFrame.scrollFrame:SetScrollChild(uiFrame.scrollChild)
    uiFrame.scrollChild:SetWidth(540)
    uiFrame.scrollChild:SetHeight(1)

    uiFrame.buttons = {}

    -- Tab click handlers
    local function UpdateTabAppearance()
        if selectedFaction == "Alliance" then
            uiFrame.allianceTab:SetEnabled(false)
            uiFrame.hordeTab:SetEnabled(true)
        else
            uiFrame.allianceTab:SetEnabled(true)
            uiFrame.hordeTab:SetEnabled(false)
        end
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

    -- Hide existing buttons
    for _, btn in ipairs(uiFrame.buttons) do
        btn:Hide()
    end

    local yOffset = 0
    local index = 0
    local totalShown = 0

    for i, data in ipairs(riddles) do
        local matchesFilter = filter == "" or
            data.riddle:lower():find(filter, 1, true) or
            (data.item and data.item:lower():find(filter, 1, true))

        if matchesFilter then
            index = index + 1
            totalShown = totalShown + 1
            local btn = uiFrame.buttons[index]

            if not btn then
                btn = CreateFrame("Button", nil, uiFrame.scrollChild)
                btn:SetHeight(60)

                btn.bg = btn:CreateTexture(nil, "BACKGROUND")
                btn.bg:SetAllPoints()
                btn.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)

                btn.number = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                btn.number:SetPoint("TOPLEFT", 8, -8)
                btn.number:SetTextColor(0.5, 0.8, 1)

                btn.item = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                btn.item:SetPoint("LEFT", btn.number, "RIGHT", 10, 0)

                btn.riddle = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                btn.riddle:SetPoint("TOPLEFT", 8, -28)
                btn.riddle:SetPoint("TOPRIGHT", -8, -28)
                btn.riddle:SetJustifyH("LEFT")
                btn.riddle:SetWordWrap(true)
                btn.riddle:SetTextColor(0.9, 0.9, 0.9)

                btn.coords = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                btn.coords:SetPoint("BOTTOMRIGHT", -8, 5)
                btn.coords:SetTextColor(0.4, 0.7, 0.4)

                btn:SetScript("OnEnter", function(self)
                    self.bg:SetColorTexture(0.2, 0.2, 0.3, 0.7)
                end)
                btn:SetScript("OnLeave", function(self)
                    self.bg:SetColorTexture(0.1, 0.1, 0.1, 0.5)
                end)

                uiFrame.buttons[index] = btn
            end

            btn:SetPoint("TOPLEFT", 0, -yOffset)
            btn:SetPoint("TOPRIGHT", 0, -yOffset)

            btn.number:SetText("#" .. i)
            btn.item:SetText(data.item or "")
            btn.riddle:SetText(data.riddle)
            btn.coords:SetText(string.format("%.1f, %.1f", data.x, data.y))

            local riddleData = data
            local riddleNum = i
            btn:SetScript("OnClick", function()
                SetWaypoint(mapId, riddleData.x, riddleData.y, riddleData.item or ("Riddle #" .. riddleNum))
                print(string.format("|cff00ff00[Decor Treasure Hunt]|r Waypoint set: |cfffff000%s|r (%.1f, %.1f)",
                    riddleData.item or ("Riddle #" .. riddleNum), riddleData.x, riddleData.y))
            end)

            btn:Show()
            yOffset = yOffset + 65
        end
    end

    uiFrame.scrollChild:SetHeight(math.max(yOffset, 1))
    uiFrame.countText:SetText(totalShown .. " / 50")
end

function addon.ToggleUI()
    if uiFrame and uiFrame:IsShown() then
        uiFrame:Hide()
        return
    end

    if not uiFrame then
        CreateUI()
    end

    -- Reset to player's faction when opening
    selectedFaction = playerFaction
    if selectedFaction == "Alliance" then
        uiFrame.allianceTab:SetEnabled(false)
        uiFrame.hordeTab:SetEnabled(true)
    else
        uiFrame.allianceTab:SetEnabled(true)
        uiFrame.hordeTab:SetEnabled(false)
    end

    uiFrame.searchBox:SetText("")
    addon.PopulateUI()
    uiFrame:Show()
end

-- Single slash command to open UI
SLASH_DECORTREASUREHUNT1 = "/dth"
SlashCmdList["DECORTREASUREHUNT"] = function()
    addon.ToggleUI()
end
