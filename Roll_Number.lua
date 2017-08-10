local AceGUI = LibStub("AceGUI-3.0")

Stop_Random_Roll = true

-- function that draws the widgets for the first tab
local function DrawGroup1(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 1")
    desc:SetFullWidth(true)
    container:AddChild(desc)
    
    local button = AceGUI:Create("Button")
    button:SetText("停止Roll点")
    button:SetWidth(200)
    button:SetCallback("OnClick", function() Stop_Random_Roll = true end)
    container:AddChild(button)
end

local function Start_Random()
    Stop_Random_Roll = false
    RandomRoll(1, 100)
end 

-- function that draws the widgets for the second tab
local function DrawGroup2(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 2")
    desc:SetFullWidth(true)
    container:AddChild(desc)
    
    local button = AceGUI:Create("Button")
    button:SetText("开始Roll点")
    button:SetWidth(200)
    button:SetCallback("OnClick", Start_Random)
    container:AddChild(button)
end

-- function that draws the widgets for the second tab
local function DrawGroup3(container)
    local desc = AceGUI:Create("Label")
    desc:SetText("This is Tab 3")
    desc:SetFullWidth(true)
    container:AddChild(desc)
    -- Create a button
    local btn = AceGUI:Create("Button")
    btn:SetWidth(170)
    btn:SetText("roll币")
    btn:SetCallback("OnClick", say_hello)
    -- Add the button to the container
    container:AddChild(btn)
    
    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel("Insert text:")
    editbox:SetWidth(200)
    editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
    container:AddChild(editbox)
    
end


-- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
    container:ReleaseChildren()
    if group == "tab1" then
        DrawGroup1(container)
    elseif group == "tab2" then
        DrawGroup2(container)
    elseif group == "tab3" then
        DrawGroup3(container)
    end
end

-- Create 
RollNumber = LibStub("AceAddon-3.0"):NewAddon("RollNumber", "AceConsole-3.0", "AceEvent-3.0")
RollNumber:RegisterChatCommand("rn", "MySlashProcessorFunc")

local function say_hello()   
    -- CHAT_MSG_LOOT
end 

function RollNumber:ZONE_CHANGED()
    self:Print("You have changed zones!")
end


function RollNumber:OnInitialize()
    -- Code that you want to run when the addon is first loaded goes here.
    self:Print("RollNumber:OnInitialize()")
end

function RollNumber:OnEnable()
    -- Called when the addon is enabled
    self:Print("RollNumber:OnEnable()")
    RollNumber:RegisterEvent("CHAT_MSG_SYSTEM")
end

function RollNumber:OnDisable()
    -- Called when the addon is disabled
    self:Print("RollNumber:OnDisable()")
end

function RollNumber:CHAT_MSG_SYSTEM(event, arg1, arg2)
    --self:Print("event:".. event.. " arg1:" .. arg1)
    local player_name, RealmName = UnitFullName("player")
    --print(player_name)
    -- self:Print("..["..RANDOM_ROLL_RESULT.."]")
    -- self:Print("..["..RANDOM_ROLL_RESULT_X.."]")
    local RANDOM_ROLL_RESULT_X = player_name .. "掷出(%d+)（(%d+)-(%d+)）"
    local format = RANDOM_ROLL_RESULT_X
    local num1, low, high = strmatch(arg1, format) 
    if num1 ~= nil and low ~= nil and high ~= nil then
        -- self:Print(num1)
        -- self:Print("Stop_Random_Roll:" .. tostring(Stop_Random_Roll))
        -- self:Print(low .. "," .. high)
        if tonumber(num1) == 99 then
            self:Print("Stop Random Roll!")
            Stop_Random_Roll = true
        elseif not(Stop_Random_Roll) then
            RandomRoll(1, 100)
            --self:Print(" call RandomRoll") 
        end 
    end 
end

function RollNumber:MySlashProcessorFunc(input)
  -- Process the slash command ('input' contains whatever follows the slash command)
  self:CreateWindow()
end

function RollNumber:CreateWindow()
    -- body
    -- Create a container frame
    local f = AceGUI:Create("Frame")
    f:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    f:SetTitle("AceGUI-3.0 Example")
    f:SetStatusText("Status Bar")
    f:SetLayout("Fill")
    
    -- Create the TabGroup
    local tab =  AceGUI:Create("TabGroup")
    local tab_text_tables = {
        {text = "Tab 1", value = "tab1"},     
        {text = "Tab 2", value = "tab2"}, 
        {text = "Tab 3", value = "tab3"}
    }
    tab:SetLayout("Flow")
    -- Setup which tabs to show
    tab:SetTabs(tab_text_tables)
    -- Register callback
    tab:SetCallback("OnGroupSelected", SelectGroup)
    -- Set initial Tab (this will fire the OnGroupSelected callback)
    tab:SelectTab("tab1")
    
    -- add to the frame container
    f:AddChild(tab)
end

