-- codex.lua
-- ... list of spells 
-- ... on magic oriented programming paradigm, codexs are made mainly with help of oracles (A.I.'s) or scrapped 
-- ... is the dirty part of the code wrapped in easy to use spells 

local Codex = {
    MLEFT   = 0, -- Primary button
    MRIGHT  = 1, -- Secondary button
    MMIDDLE = 2, -- Wheel click
    MX1     = 3, -- Side button 1
    MX2     = 4  -- Side button 2
}

-- variables 
local PLAYER = nil 
local CORE = nil 

-- colors 
local getTempColor_object_2 = nil 
function Codex.getTempColor(temp_min, blue_cyan, cyan_green, green_yellow, temp_max) 
	if not temp_min then temp_min = 14 end
    if not blue_cyan then blue_cyan = 20 end
    if not cyan_green then cyan_green = 24 end
    if not green_yellow then green_yellow = 26 end
    if not temp_max then temp_max = 30 end
    local R = nil
    local G = nil 
    local B = nil
    local scale = nil
    local cte = nil
    getTempColor_object_2 = getTempColor_object_2 or getPlayer()
    local player_temp = getTempColor_object_2:getTemperature()
    local temp = (player_temp - 13) + 3*(player_temp-37)
    if temp <= blue_cyan then -- (0,0,255) -> (0,255,255)
        R = 0
        B = 1
        scale = 1/(blue_cyan-temp_min)
        cte = 1 - scale*blue_cyan
        G = scale*temp + cte
    elseif temp <= cyan_green then -- (0,255,255) -> (0,255,0)
        R = 0
        G = 1
        scale = 1/(blue_cyan-cyan_green)
        cte = 1 - scale*blue_cyan
        B = scale*temp+cte
    elseif temp <= green_yellow then -- (0,255,0) -> (255,255,0)
        B = 0
        G = 1
        scale = 1/(green_yellow - cyan_green)
        cte = 1 - scale*green_yellow
        R = scale*temp+ cte
    elseif temp <= temp_max then -- (255,255,0) -> (255,0,0)
        R = 1
        B = 0
        scale = 1/(green_yellow - temp_max)
        cte = 1 - scale*green_yellow
        G = scale*temp+cte
    else 
        R = 1
        G = 0
        B = 0
    end
    return R,G,B
end
function Codex.getColorGradient_RedToGreen(current, min_val, max_val)
    local mid = min_val + (max_val - min_val) / 2
    local R, G, B
    if current <= mid then
        -- red -> yellow
        R = 1
        G = (current - min_val) / (mid - min_val)
        B = 0
    elseif current <= max_val then
        -- yellow -> green
        R = (max_val - current) / (max_val - mid)
        G = 1
        B = 0
    else
        -- clamp to green
        R, G, B = 0, 1, 0
    end
    return R, G, B
end

-- messages 
function Codex.here() 
	if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end
	if not PLAYER then return end 
	PLAYER:Say("here!") 
end
function Codex.print(text) 
	if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end
	if not PLAYER then return end 
	if type(text)~="string" then text = tostring(text) end 
	PLAYER:Say(text) 
end
function Codex.item_print(item) 
	local function get(text) 
		if type(text) ~= "string" then return tostring(text) end 
		return text 
	end
	local result = (
		get(item:getType()).."\n"..
		get(item:getFullType()).."\n"..
		get(item:getLootType()).."\n"..
		get(item:getCategory() ).."\n"..
		get(item:getDisplayCategory()).."\n"..
		get(item:getDisplayName()).."\n"..
		get(item:getGunType()).."\n"
	)
	Codex.print( result )
end
function Codex.object_print(object) 
	local function get(text) 
		if type(text) ~= "string" then return tostring(text) end 
		return text 
	end
	local result = (
		get(object:getName()).."\n"..
		get(object:getTextureName()).."\n"..
		get(object:getTileName()).."\n"..
		get(object:getObjectName()).."\n"
	)
	Codex.print( result )
end
local function table_tostring(t, indent, visited)
    indent = indent or 0
    visited = visited or {}
    local result = {}

    if visited[t] then
        return string.rep(" ", indent) .. "*recursive*"
    end
    visited[t] = true

    if type(t) ~= "table" then
        return string.rep(" ", indent) .. tostring(t)
    end

    table.insert(result, string.rep(" ", indent) .. "{\n")
    for k, v in pairs(t) do
        local keyStr = tostring(k)
        if type(v) == "table" then
            table.insert(result,
                string.rep(" ", indent + 2) .. "[" .. keyStr .. "] = " ..
                table_tostring(v, indent + 2, visited) .. "\n")
        else
            table.insert(result,
                string.rep(" ", indent + 2) .. "[" .. keyStr .. "] = " .. tostring(v) .. "\n")
        end
    end
    table.insert(result, string.rep(" ", indent) .. "}")
    return table.concat(result)
end
function Codex.table_print(t) 
	Codex.print( table_tostring(t) )
end
function Codex.EMessage(p_text, x,y, r,g,b) 
	if not p_text then p_text = {} end 
	Events.OnGameStart.Add( function() 
		Events.OnRenderTick.Add( function() 
			getTextManager():DrawString(x or 50, y or 50, p_text[0] or "", r or 1.0, g or 1.0, b or 1.0, 1.0)
		end )
	end )
end
function Codex.vehicle_print() 
	Codex.table_print( Codex.getVehicleInfo( getPlayer() ) )
end

-- zoom 
function Codex.zoom_in() 
	if not CORE then CORE = getCore() end
	CORE:doZoomScroll(0,-1) 
end 
function Codex.zoom_out() 
	if not CORE then CORE = getCore() end 
	CORE:doZoomScroll(0,1)
end 
function Codex.getZoom() 
	if not CORE then CORE = getCore() end 
	return CORE:getZoom(0) 
end

-- compare 
function Codex.is_approx(num1,num2,tol) 
	return math.abs(num1-num2)<=tol
end
function Codex.is_changing(p_last, get_current) 
	local last = p_last.value 
	local current = get_current() 
	if last and ( last~=current ) then 
		p_last.value = current 
		return true 
	else 
		p_last.value = current
		return false 
	end 
end
function Codex.is_increasing(p_last, get_current)
	local last = p_last.value 
	local current = get_current() 
	if last and ( last<current ) then 
		p_last.value = current 
		return true 
	else 
		p_last.value = current
		return false 
	end 
end 
function Codex.is_decreasing(p_last, get_current)
	local last = p_last.value 
	local current = get_current() 
	if last and ( last>current ) then 
		p_last.value = current 
		return true 
	else 
		p_last.value = current
		return false 
	end 
end 

-- checkers
function Codex.is_melee_equipped(player)
	if not player then return false end 
    local primaryItem = player:getPrimaryHandItem()
	if not primaryItem then return false end 
	return (
		primaryItem:IsWeapon() and 
		primaryItem:getLootType()~="RangedWeapon"
	)
end
function Codex.is_eating(player) 
	return ISTimedActionQueue.hasActionType(player, "Eat")
end

-- iterators/foreach
function Codex.FArrayList(f_call, list)
	local element = nil 
	local result = nil 
	for i = 0, list:size() - 1 do
		element = list:get(i)
		result = f_call(element, i)
		if result == nil then 
			-- contiue 
		elseif result == true then 
			break 
		else 
			return result 
		end
	end
end
function Codex.FAdjacentSquare(f_call, player) 
	local neighbor = nil 
	local result = nil
	if not player then return nil end 
	local square = player:getCurrentSquare()
	if not square then return nil end 
	local x = square:getX() 
	local y = square:getY() 
	local z = player:getZ() 
	for dx = -1, 1 do for dy = -1, 1 do
		neighbor = square:getCell():getGridSquare(x + dx, y + dy, z)
		if not neighbor then return nil end 
		result = f_call(neighbor) 
		if result == nil then 
			-- continue 
		elseif result == true then 
			break 
		else 
			return result 
		end
    end end
	return nil 
end
function Codex.FAdjacentObjects(f_call, player) 
	local object = nil
	local objects = nil 
	local result = nil
	return Codex.FAdjacentSquare( function(square) 
		objects = square:getObjects() 
		for i = 0, objects:size() - 1 do
			object = objects:get(i)
			result = f_call(object) 
			if result == nil then 
				-- continue 
			elseif result == true then 
				return true 
			else 
				return result 
			end
		end
		return nil 
	end, player )
end
function Codex.FInventory(f_call, player) 
	local inv = player:getInventory() 
	local item = nil
	local result = nil 
	for i = 0, inv:getItems():size() - 1 do
		item = inv:getItems():get(i) 
		result = f_call(item)
		if result == nil then 
			-- continue 
		elseif result == true then 
			break 
		else 
			return result 
		end
	end
end 
function Codex.FBackpack(f_call, player) 
	-- Get the equipped container (on the back)
	local backpack = player:getClothingItem_Back()
	if backpack and backpack:getItemContainer() then
		local bagItems = backpack:getItemContainer():getItems()
		local item = nil 
		local result = nil 
		for i = 0, bagItems:size() - 1 do
			item = bagItems:get(i)
			result = f_call(item)
			if result == nil then 
				-- continue 
			elseif result == true then 
				break 
			else 
				return result 
			end
		end 
	end
end 
function Codex.FAdjacentMovingObjects(f_call, player) 
	local object = nil
	local objects = nil 
	local result = nil
	return Codex.FAdjacentSquare( function(square) 
		objects = square:getMovingObjects() 
		for i = 0, objects:size() - 1 do
			object = objects:get(i)
			result = f_call(object) 
			if result == nil then 
				-- continue 
			elseif result == true then 
				return true 
			else 
				return result 
			end
		end
		return nil 
	end, player )
end 
function Codex.FAdjacentContainer(f_call, player) 
	-- ItemContainer 
	local result = nil 
	return Codex.FAdjacentObjects( function(object) 
		if not instanceof(object, "ItemContainer") then return nil end 
		result = f_call(object)
		if result == nil then return nil end 
		if result == true then return true end 
		return result 
	end, player) 
end
function Codex.FAdjacentCorpses(f_call, player) end 
function Codex.FEquipItems(f_call, player) 
	local slots = {
		player:getClothingItem_Back(),
		player:getClothingItem_Feet(),
		player:getClothingItem_Hands(),
		player:getClothingItem_Head(),
		player:getClothingItem_Legs(),
		player:getClothingItem_Torso(),
		player:getPrimaryHandItem(),
		player:getSecondaryHandItem() 
	}
	local result = nil 
	for k,v in ipairs(slots) do 
		result = f_call(v,k)
		if result == nil then 
			-- continue 
		elseif result == true then 
			break 
		else 
			return result 
		end
	end
	return nil 
end
function Codex.FEquipBags(f_call, player) 
	local container = nil 
	return Codex.FEquipItems( function(item, index) 
		container = item:getContainer() 
		if not container then return nil end 
		return f_call(container) 
	end, player) 
end
function Codex.FEquipBagItems(f_call, player) 
	local item = nil 
	local result = nil 
	return Codex.FEquipBags( function(bag) 
		list = bag:getItems()
		if not list then return nil end 
		if list:size()==0 then return nil end 
		for i = 0, list:size() - 1 do
			item = list:get(i)
			result = f_call(item)
			if result == nil then 
				-- continue 
			elseif result == true then 
				return true 
			else 
				return result 
			end
		end
	end, player) 
end
function Codex.FItemContainer(f_call, square) 
	if not square then return nil end 
	local list = square:getObjects()
	if not list then return nil end 
	if list:size()==0 then return nil end 
	local container = nil 
	return Codex.FArrayList( function(object) 
		if not object then return nil end 
		if instanceof(object,"InventoryItem") then 
			container = object:getContainer() 
		else 
			container = object:getItemContainer() 
		end
		if not container then return nil end 
		return f_call(container) 
	end, list) 
end
function Codex.FUserInterface(f_call) 
	local list = UIManager.getUI() 
	local item = nil 
	local result = nil
	for i=0, list:size()-1 do 
		item = list:get(i)
		result = f_call(item)
		if result == nil then 
			-- continue 
		elseif result == true then 
			break 
		else 
			return result 
		end
	end
end

-- getters 
function Codex.getFirstAdjacentVehicle() 
	return Codex.FAdjacentMovingObjects( function(object) 
		if not instanceof(object, "BaseVehicle") then return nil end
		return object 
	end, getPlayer() ) 
end
local vehicle_info = {}
function Codex.getVehicleInfo(player) 
	local vehicle = player:getVehicle() 
	if not vehicle then return nil end 
	vehicle_info.speed = vehicle:getCurrentSpeedKmHour() 
	vehicle_info.steering = vehicle:getCurrentSteering() 
	return vehicle_info
end

-- gui 
local function build_menu(context, structure, callbacks)
    for _, item in ipairs(structure.items or {}) do
        if type(item) == "table" then
            -- Nested submenu
            local submenu = ISContextMenu:getNew(context)
            build_menu(submenu, item, callbacks)
            context:addSubMenu(
                context:addOption(item.name or "Submenu"),
                submenu
            )
        elseif type(item) == "string" then
            -- Regular clickable option
            local callback = callbacks[item]
            if callback then
                context:addOption(item, nil, callback)
            else
                context:addOption(item, nil, function()
                    print("No callback for menu option: " .. item)
                end)
            end
        end
    end
end
function Codex.new_context_menu(parent_context, structure, callbacks) 
    if structure.name and structure.name ~= "" then
        -- Create submenu attached to parent_context
        local submenu = ISContextMenu:getNew(parent_context)
        build_menu(submenu, structure, callbacks)
        parent_context:addSubMenu(
            parent_context:addOption(structure.name),
            submenu
        )
    else
        -- Add options directly to parent_context
        build_menu(parent_context, structure, callbacks)
    end
end
function Codex.new_window(name, x, y, width, height)
	if not width then width = 500 end 
	if not height then height = 400 end 
	if not x then x = 150 end 
	if not y then y = 150 end 
    -- create a collapsable window
    local win = ISCollapsableWindow:new(x, y, width, height)
    win:setTitle(name or "Window")
    win:initialise()
    win:addToUIManager()
    -- prevent resizing unless you want it
    win.resizable = true
    return win
end
function Codex.draw_scaled_image(path,screen_perc_width, scree_perc_height) 
	-- to be used on render tick using UIManager.DrawTexture 
end
function Codex.arrange_vertically(ui_table,y, pad)
    pad = pad or 10
    local currentY = y or 25

    for _, element in ipairs(ui_table) do
        if element and element.setY and element.getHeight then
            element:setY(currentY)
            currentY = currentY + element:getHeight() + pad
        end
    end
end
function Codex.arrange_horizontally(ui_table, x, pad)
    pad = pad or 10
    local currentX = x or 5

    for _, element in ipairs(ui_table) do
        if element and element.setX and element.getWidth then
            element:setX(currentX)
            currentX = currentX + element:getWidth() + pad
        end
    end
end
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
function Codex.new_button(parent, name, text, callback, x, y, width, height) 
    --
    local bottom = parent:getHeight()
    local btnWid = 60
    local btnHgt = math.max(FONT_HGT_SMALL + 3 * 2, 25)
    --
    if not x then x = 10 end
    if not y then y = bottom - btnHgt - 10 end
    if not width then width = btnWid end
    if not height then height = btnHgt end
    --
    parent[name] = ISButton:new(x, y, width, height, text, parent, callback)
    parent[name].internal = name;
    parent[name]:initialise();
    parent[name]:instantiate();
    parent[name].borderColor = {r=1, g=1, b=1, a=0.1};
    parent:addChild(parent[name])
    return parent[name]
end
function Codex.new_multiline_entry(parent, name, text,x, y, width, height) 
    -- optional arguments
    if not x then x = 5 end
    if not y then y = 25 end
    if not width then width = parent:getWidth()*0.8 end
    if not height then height = parent:getHeight()*0.6 end
    if not text then text = "" end
    --
    parent[name] = ISTextEntryBox:new(text,x,y,width,height)
    parent[name]:initialise()
    parent[name]:instantiate()
    parent[name]:setMultipleLine(true)
    parent[name].javaObject:setMaxLines(10)
    parent[name].javaObject:setMaxTextLength(500)
    parent:addChild( parent[name] )
    parent[name]:setEditable(true) 
    return parent[name]
end
function Codex.new_slider_percentage(parent, name, callback, default_value, x, y, width, height)
    if not x then x = 5 end
    if not y then y = 25 end
    if not width then width = parent:getWidth()*0.95 end
    if not height then height = 20 end
    if not default_value then default_value = 0.0 end
    parent[name] = ISSliderPanel:new( x, y, width, height, parent, nil )
    parent[name]:initialise()
    parent[name]:instantiate()
    parent[name].valueLabel = true
    parent[name]:setValues(0.0, 100.0, 0.1, 1.0)
	parent[name]:setCurrentValue(default_value, true)
    local old = parent[name].doOnValueChange
    parent[name].doOnValueChange = function( self, _newValue )
        old(self, _newValue)
        return callback(parent, name)
    end
    parent:addChild(parent[name])
    return parent[name]
end
function Codex.new_label(parent, name, height, x,y) 
	if not x then x = 5 end 
	if not y then y = 25 end 
	if not height then height = FONT_HGT_SMALL end
	local label = ISLabel:new(x, y, height, name, 1, 1, 1, 1,UIFont.Small, true)
    label:initialise()
    label:instantiate()
	parent:addChild(label)
	return label 
end
function Codex.new_floating_image(texture, f_call,x, y, width, height) 
	--> DrawTextureAngle(Texture tex, double centerX, double centerY, double angle) 
	if not width then width = 500 end 
	if not height then height = 500 end 
	if not x then x = 150 end 
	if not y then y = 150 end 
	if type(texture)=="string" then 
		texture = getTexture(texture) 
	end
    -- create a collapsable window
    local win = ISPanel:new(x, y, width, height)
	win.backgroundColor.a = 0.0 
	win.borderColor.a = 1.0 
    win:initialise()
    win:addToUIManager()
    win.resizable = false 
	-- 
	Codex.singlePrototypeOverride(function(old, self) 
		local result = old(self)
		f_call(self, texture) 
		return result 
	end,win,"render") 
	-- 
	return win 
end
function Codex.new_slider(parent, name, callback, default_value, min_v, max_v, step, x, y) 
	if not x then x = 5 end
    if not y then y = 25 end
    local width = parent:getWidth()*0.95 
    local height = 20 
    if not default_value then default_value = min_v end
    parent[name] = ISSliderPanel:new(x, y, width, height, parent, nil)
    parent[name]:initialise()
    parent[name]:instantiate()
    parent[name].valueLabel = true
    parent[name]:setValues(min_v, max_v, step, step) 
	parent[name]:setCurrentValue(default_value, true)
    local old = parent[name].doOnValueChange
    parent[name].doOnValueChange = function( self, _newValue )
        old(self, _newValue)
        return callback(parent, name)
    end
    parent:addChild(parent[name])
    return parent[name]
end

-- mouse 
function Codex.screenToIso(x,y,z) 
	if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end 
	if not PLAYER then return nil, nil end 
	local playerNum = PLAYER:getPlayerNum()
	local IsoX = screenToIsoX(playerNum,x,y,z)
	local IsoY = screenToIsoY(playerNum,x,y,z)
	return IsoX, IsoY
end
function Codex.is_inventory_active() 
	PLAYER = getPlayer()
	if not PLAYER then return end 
	local invPage = PLAYER:getInventoryPane() 
	return invPage and invPage:getIsVisible() and invPage:isMouseOver()
end

-- events 
function Codex.EOnDoubleClick(f_call, p_data)	
	if not p_data then return end 
	if not p_data.lastClickTime then p_data.lastClickTime = 0 end 
	if not p_data.doubleClickDelay then p_data.doubleClickDelay = 150 end 
	Events.OnObjectLeftMouseButtonDown.Add( function(object, x, y)
		local now = getTimestampMs()
		if (now - p_data.lastClickTime) <= p_data.doubleClickDelay then 
			f_call(object, x, y)
		end
		p_data.lastClickTime = now 
	end )
end
Codex._timeouts = {}
Events.OnRenderTick.Add(function()
    local now = getTimestampMs()
    for i = #Codex._timeouts, 1, -1 do
        local t = Codex._timeouts[i]
        if not t.status.active then
            -- canceled
            table.remove(Codex._timeouts, i)
        elseif now >= t.expire then
            -- time reached
            t.f_call()
            t.status.active = false
            table.remove(Codex._timeouts, i)
        end
    end
end)
function Codex.EOnTimeOut(ms_delay, f_call, status)
    if not status then status = {} end
    status.active = true
    table.insert(Codex._timeouts, {
        expire = getTimestampMs() + ms_delay,
        f_call = f_call,
        status = status,
    })
    return status
end
function Codex.EOnSingleOrDoubleClick(f_call, p_data)
    if not p_data then return end
    if not p_data.lastClickTime then p_data.lastClickTime = 0 end
    if not p_data.doubleClickDelay then p_data.doubleClickDelay = 170 end
	local single_click_timeout_status = {} 
    Events.OnObjectLeftMouseButtonDown.Add( function(object, x, y)
        local now = getTimestampMs()
        if (now - p_data.lastClickTime) <= p_data.doubleClickDelay then
            single_click_timeout_status.active = false 
            f_call(object, x, y, true)
        else
            Codex.EOnTimeOut(p_data.doubleClickDelay, function() 
				f_call(object, x, y, false)
			end, single_click_timeout_status )
        end
        p_data.lastClickTime = now
    end)
end

-- actions 
function Codex.equip_primary(player, item) end
function Codex.equip_secondary(player, item) end
function Codex.drop_primary(player) end
function Codex.drop_secondary(player) end
function Codex.drop_back(player) end 
function Codex.grab_primary(player, item) end
function Codex.grab_secondary(player, item) end

-- utils 
function Codex.euclidian_distance(object_1, x,y) 
	if not object_1 then return nil end 
	local ox = object_1:getX() 
	local oy = object_1:getY() 
	if ox == nil or oy == nil then return nil end 
	local dx = ox - x 
	local dy = oy - y
	return math.sqrt( dx*dx+dy*dy )
end
function Codex.mouse_player_iso_distance() 
	local mx = getMouseX() 
	local my = getMouseY() 
	if mx==nil or my==nil then return -1 end 
	local player = getPlayer() 
	if not player then return -1 end 
	mx, my = Codex.screenToIso(mx,my,player:getZ()) 
	local dx = mx - player:getX()
	local dy = my - player:getY()
	return math.sqrt( dx*dx + dy*dy )
end

-- override 
function Codex.singlePrototypeOverride(f_call,prototype,function_name) 
    if not prototype then return nil end
    if not prototype[function_name] then return nil end
    local old = prototype[function_name]
    prototype[function_name] = function(self)
        return f_call(old,self)
    end
end
function Codex.multiplePrototypesOverride(f_call,function_name,prototype_array_table) 
    for i,v in ipairs(prototype_array_table) do 
        Codex.singlePrototypeOverride(f_call, v,function_name)
    end
end

-- END 
return Codex 































