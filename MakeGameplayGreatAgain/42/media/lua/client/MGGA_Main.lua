-- [ Make Gameplay Great Again ]
-- Features: 
-- 1. Aiming Auto Zoom - Aim Zoom In, Run Zoom Out 
-- 2. Vehicle Auto Zoom ~ By speed 
-- 3. Mouse Auto Facing 
-- 4. Mouse Auto Zoom ~ By Distance from Player Object 
-- 5. Temperature Display on Hotbar Border ~ By Color 
-- 6. Active WalkTo 
-- 7. User Interface to Control the GUI Transparency and Colors 
-- 8. Condition Color Indicators for HUDButtons 
-- 9. Auto Hide Graphical Interface when Aiming or Running 
-- 10. Steering Indicator 
-- TODO 
-- -> Pan The Camera on Auto Facing / seems not possible on lua-side 

local Codex = require("MGGA_Codex")

-- Variables 
local MD = nil -- mod data 
local MD_KEY = "MGGA_DATA" 
local CORE = getCore() 
local PLAYER = getPlayer() 
local p_last_zoom = {}
local p_last_vehicle_speed = {}
local vehicle = nil 
local vehicle_speed = 0 
local f_outside = 0.25 
local f_ranged = 0.5 
local square = nil 
local fl = nil  
local config_window = nil
local steering_wheel_image_window = nil 
local context_menu_callbacks = {} 
local steering_wheel_img_path = "media/textures/steering_wheel.png" 
-- functions 
local function style_override(window) 
	if not MD then return end 
	if not window then return end 
	if window:isMouseOver() then 
		window.backgroundColor.a = math.max(0.72, MD.background_color_a) 
		window.borderColor.a = 0.75 
	else 
		window.backgroundColor.a = MD.background_color_a 
		window.borderColor.a = 0.5
	end 
	window.backgroundColor.r = MD.background_color_r 
	window.backgroundColor.g = MD.background_color_g
	window.backgroundColor.b = MD.background_color_b 
end

-- Mod Data 
Events.OnInitGlobalModData.Add( function() 
	MD = ModData.getOrCreate(MD_KEY) 
	-- Debug Mode 
	if not MD.b_debug then MD.b_debug = false end 
	-- Auto Zoom 
	if not MD.b_aiming_auto_zoom then MD.b_aiming_auto_zoom = true end 
	if not MD.b_vehicle_auto_zoom then MD.b_vehicle_auto_zoom = true end 
	if not MD.b_steering_indicator then MD.b_steering_indicator = true end 
	if not MD.f_aim then MD.f_aim = 0.5 end 
	if not MD.f_run then MD.f_run = 1.5 end 
	-- Mouse Tweaks
	if not MD.b_click_to_move then MD.b_click_to_move = true end 
	if not MD.b_mouse_facing then MD.b_mouse_facing = true end 
	if not MD.zoom_in_out_rad then MD.zoom_in_out_rad = 2 end 
	-- Window Style 
	if not MD.background_color_r then MD.background_color_r = 0.0 end 
	if not MD.background_color_g then MD.background_color_g = 0.0 end 
	if not MD.background_color_b then MD.background_color_b = 0.0 end 
	if not MD.background_color_a then MD.background_color_a = 0.25 end 
	-- EquippedItems Tweaks 
	if not MD.b_display_eq_condition then MD.b_display_eq_condition = true end 
	-- Hotbar 
	if not MD.slot_size then MD.slot_size = 35 end 
	if not MD.hotbar_spacing then MD.hotbar_spacing = 3 end 
	-- Auto Hide 
	if not MD.b_autohide_ui then MD.b_autohide_ui = true end 
	-- Steering Wheel Indicator 
	if not MD.scale_factor_steering_wheel then MD.scale_factor_steering_wheel = 200 end 
end )

-- Graphical User Interface 
Events.OnGameStart.Add( function() 
	config_window = Codex.new_window("Mod Settings", nil,nil,nil, 600) 
	config_window:setVisible(false) 
	Codex.arrange_vertically( { 
		Codex.new_label(config_window, "GENERAL WINDOWS SETTINGS"),
		Codex.new_label(config_window, "Red (Background)"),
		Codex.new_slider_percentage(config_window, "Red Background Slider", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.background_color_r = parent[name]:getCurrentValue()/100.0
		end, MD.background_color_r*100),
		Codex.new_label(config_window, "Green (Background)"),
		Codex.new_slider_percentage(config_window, "Green Background Slider", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.background_color_g = parent[name]:getCurrentValue()/100.0
		end, MD.background_color_g*100),
		Codex.new_label(config_window, "Blue (Background)"),
		Codex.new_slider_percentage(config_window, "Blue Background Slider", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.background_color_b = parent[name]:getCurrentValue()/100.0
		end, MD.background_color_b*100),
		Codex.new_label(config_window, "Alpha (Background)"),
		Codex.new_slider_percentage(config_window, "Alpha Background Slider", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.background_color_a = math.max(0.01, parent[name]:getCurrentValue()/100.0) 
		end, MD.background_color_a*100),
		Codex.new_label(config_window, "MOUSE SETTINGS"),
		Codex.new_label(config_window, "Mouse Distance From Player (Auto Zoom)"),
		Codex.new_slider_percentage(config_window, "Mouse Distance From Player", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.zoom_in_out_rad = 20*parent[name]:getCurrentValue()/100.0 
		end, MD.zoom_in_out_rad*100.0/20.0),
		Codex.new_label(config_window, "HOTBAR SETTINGS"),
		Codex.new_label(config_window, "Slot Size"),
		Codex.new_slider(config_window, "Hotbar Slot Size", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.slot_size = parent[name]:getCurrentValue() 
		end, MD.slot_size, 25, 80, 2 ),
		Codex.new_label(config_window, "Border Spacing"),
		Codex.new_slider(config_window, "Hotbar Border Spacing", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.hotbar_spacing = parent[name]:getCurrentValue() 
		end, MD.hotbar_spacing, 1, 10, 1), 
		Codex.new_label(config_window, "INDICATOR SETTINGS"),
		Codex.new_label(config_window, "Steering Wheel Scale Factor"),
		Codex.new_slider(config_window, "Steering Wheel Scale Factor", function(parent, name) 
			if not parent[name]:isVisible() then return nil end 
			MD.scale_factor_steering_wheel = parent[name]:getCurrentValue() 
		end, MD.scale_factor_steering_wheel, 100, 400, 25) 
	} )
	Codex.singlePrototypeOverride( function(old, self) 
		style_override(self) 
		return old(self)
	end ,config_window,"prerender") 
	-- 
	steering_wheel_image_window = Codex.new_floating_image( steering_wheel_img_path, function(self, texture) 
		if not PLAYER or PLAYER:isDead() then return end 
		vehicle = PLAYER:getVehicle() 
		if not vehicle then return end 
		local centerX = self:getWidth()/2 
		local centerY = self:getHeight()/2
		self:setX( getMouseX() - self:getWidth()/2 ) 
		self:setY( getMouseY() + 50 ) 
		self:DrawTextureAngle( 
			texture, 
			centerX, 
			centerY, 
			-MD.scale_factor_steering_wheel*vehicle:getCurrentSteering()
		)
	end, nil, nil, 50, 50) 
	-- 
	Events.OnPostUIDraw.Add( function() 
		if not PLAYER or PLAYER:isDead() then return end 
		vehicle = PLAYER:getVehicle() 
		if not vehicle or not MD.b_steering_indicator then 
			steering_wheel_image_window:setVisible(false) 
		else 
			steering_wheel_image_window:setVisible(true) 
		end 
	end )
end )

-- Auto Zoom | Auto Hide UI 
Events.OnGameStart.Add( function() 
	local function zoom_in() 
		if Codex.is_changing(p_last_zoom, Codex.getZoom) then return end 
		local level = CORE:getZoom(0)
		local zoom_target = MD.f_aim 
		-- if PLAYER:isOutside() then 
		zoom_target = zoom_target+f_outside 
		-- end  
		if not Codex.is_melee_equipped(PLAYER) then 
			zoom_target = zoom_target+f_ranged
		end 
		zoom_target = math.max( zoom_target,CORE:getMinZoom() )
		if level<=zoom_target then return end 
		Codex.zoom_in()
	end
	local function zoom_out() 
		if Codex.is_changing(p_last_zoom, Codex.getZoom) then return end 
		local level = CORE:getZoom(0)		
		local zoom_target = 0
		local md = Codex.mouse_player_iso_distance()
		if PLAYER:isRunning() or PLAYER:isSprinting() or md>4 then 
			zoom_target = MD.f_run 
		else 
			zoom_target = MD.f_aim+0.25
		end
		if PLAYER:isOutside() then zoom_target = zoom_target+f_outside end 
		zoom_target = math.min( zoom_target,CORE:getMaxZoom() )
		if level>=zoom_target then return end 
		Codex.zoom_out() 
	end 
	local function get_vehicle_speed() 
		if not vehicle then return 0 end 
		return vehicle:getCurrentSpeedKmHour()
	end
	local function get_steering()
		if not vehicle then return 0 end 
		return vehicle:getCurrentSteering() 
	end
	local function get_target_zoom_for_vehicle() 
		if not vehicle then return math.min( 2.25, CORE:getMaxZoom() ) end 
		if not PLAYER:getVehicle() then return math.min( 2.25, CORE:getMaxZoom() ) end 
		local target_zoom = CORE:getMinZoom() 
		vehicle_speed = get_vehicle_speed() 
		if isKeyDown(CORE:getKey("PanCamera")) and vehicle_speed<=5 then 
			return math.min( 2.0, CORE:getMaxZoom() )
		end
		if vehicle_speed<=5 then 
			target_zoom = 1.25
		elseif vehicle_speed<=20 then 
			target_zoom = 1.5
		elseif vehicle_speed<=30 then 
			target_zoom = 1.75
		elseif vehicle_speed<=40 then 
			target_zoom = 2.0
		elseif vehicle_speed<=55 then 
			target_zoom = 2.0
		elseif vehicle_speed<=65 then 
			target_zoom = 2.25
		elseif vehicle_speed<=75 then 
			target_zoom = 2.25
		elseif vehicle_speed<=85 then 
			target_zoom = 2.25
		else 
			target_zoom = 2.25
		end
		return math.min( target_zoom, CORE:getMaxZoom() )
	end 
	local function vehicle_zoom_in() 
		if Codex.is_changing(p_last_zoom, Codex.getZoom) then return end 
		if CORE:getZoom(0)<=get_target_zoom_for_vehicle() then return end 
		Codex.zoom_in()
	end 
	local function vehicle_zoom_out() 
		if Codex.is_changing(p_last_zoom, Codex.getZoom) then return end 
		if CORE:getZoom(0)>=get_target_zoom_for_vehicle() then return end 
		Codex.zoom_out()
	end 
	local function hide_ui(b_value) 
		if not MD.b_autohide_ui then b_value = false end 
		ISUIHandler.allUIVisible = not b_value 
		ISUIHandler.setVisibleAllUI(ISUIHandler.allUIVisible) 
		if PLAYER then 
			steering_wheel_image_window:setVisible( not PLAYER:isDead() and not (not PLAYER:getVehicle()) )
		end 
	end
	-- auto zoom | auto hide ui 
	Events.OnTick.Add( function() 
		if not CORE then return end 
		if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end 
		if not PLAYER then return end
		vehicle = PLAYER:getVehicle() 
		if vehicle then 
			local b_is_aiming = isKeyDown(CORE:getKey("Aim"))
			hide_ui(b_is_aiming) 
			if Codex.is_increasing(p_last_vehicle_speed, get_vehicle_speed) or b_is_aiming then 
				vehicle_zoom_out()
			else 
				vehicle_zoom_in() 
			end
		else 
			if not MD.b_aiming_auto_zoom then return end 
			local md = Codex.mouse_player_iso_distance()
			local b_outside = PLAYER:isOutside()
			local b_bmoving = PLAYER:isBehaviourMoving()
			local b_run_or_sprint = ( PLAYER:isRunning() or PLAYER:isSprinting() )
			local b_is_aiming = PLAYER:isAiming() 
			local b_is_pan_camera = isKeyDown(CORE:getKey("PanCamera"))
			hide_ui(b_is_aiming or b_is_pan_camera) 
			if b_is_aiming or (
				md < MD.zoom_in_out_rad and 
				b_outside and 
				not b_bmoving and 
				not b_run_or_sprint 
			) then 
				zoom_in() 
			elseif 
				(b_bmoving and b_outside) or 
				b_run_or_sprint or 
				(md >= MD.zoom_in_out_rad and b_outside)
			then 
				zoom_out() 
			end
		end 
	end )
end )

-- Mouse Tweaks 
Events.OnGameStart.Add( function() 
	-- display the square 
	Events.OnRenderTick.Add( function() 
		if not square then return end 
		if not PLAYER then return end 
		fl = square:getFloor() 
		if not fl then return end 
		fl:setHighlightColor(0.0, 1.0, 0.0, 1.0) 
		fl:setHighlighted(PLAYER:isBehaviourMoving())
	end )
	-- prevent context menu to open when fighting 
	Events.OnFillWorldObjectContextMenu.Add( function(player, context)
		-- ;altCode:10001
		if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end 
		if not PLAYER then return end 
		if PLAYER:isAiming() then
			context:clear()
			return true 
		end 
	end )
	-- click actions 
	local p_data = {}
	Codex.EOnSingleOrDoubleClick( function(object,x,y,b_double) 
		-- guards 
		if not PLAYER or PLAYER:isDead() then PLAYER = getPlayer() end 
		if not PLAYER then 
			square = nil 
			return 
		end 
		if PLAYER:getVehicle() then 
			square = nil 
			return 
		end 
		if PLAYER:isAiming() then 
			square = nil 
			return 
		end 
		-- 
		if b_double then -- double click 
			if not MD.b_debug then return end 
			if object then 
				square = object:getSquare() 
			else 
				square = nil 
			end 
			if not square then return end 
			-- 
			if     square:getPlayer() == PLAYER then 
				Codex.print("is player")
			elseif square:getDeadBody() then 
				Codex.print("is a dead body")
			else 
				Codex.table_print(object)
			end
		else -- single click 
			if not MD.b_click_to_move then 
				square = nil 
				return 
			end 
			if object then 
				square = object:getSquare() 
			else 
				square = nil 
			end 
			if not object or not square then 
				square = nil 
				return 
			end 
			if PLAYER:isRunning() or PLAYER:isSprinting() then 
				ISTimedActionQueue.clear(PLAYER) 
			elseif PLAYER:isBehaviourMoving() then  
				ISTimedActionQueue.clear(PLAYER) 
			end
			ISTimedActionQueue.add( ISWalkToTimedAction:new(
				PLAYER, 
				square
			) )
		end 
	end, p_data )
	-- auto mouse facing 
	Events.OnMouseMove.Add( function(x,y) 
		if not MD.b_mouse_facing then return end 
		PLAYER = getPlayer()
		if not PLAYER then return end 
		if Codex.getFirstAdjacentVehicle() then return end 
		local ui_name = ""
		if Codex.FUserInterface( function(ui) 
			if not ui:isVisible() then return nil end 
			ui_name = ui:getUIName() 
			-- if MD.b_debug then Codex.print(ui_name) end 
			if ui_name == "ISContextMenu" then return ui end 
			if string.find(ui_name, "Dialog") or string.find(ui_name, "dialog") then return ui end 
			if not ui:isMouseOver() then return nil end 
			return ui 
		end ) then return end 
		if PLAYER:isBehaviourMoving() then return end 
		if PLAYER:isAiming() then return end 
		if not CORE then return end 
		if PLAYER:isRunning() and not isKeyDown(CORE:getKey("PanCamera")) then return end 
		if PLAYER:isSprinting() and not isKeyDown(CORE:getKey("PanCamera")) then return end 
		if isKeyDown(CORE:getKey("Forward")) then return end
		if isKeyDown(CORE:getKey("Backward")) then return end
		if isKeyDown(CORE:getKey("Left")) then return end
		if isKeyDown(CORE:getKey("Right")) then return end
		local x,y = Codex.screenToIso(x,y, PLAYER:getZ())
		if x==nil or y==nil then return end 
		PLAYER:faceLocation(x,y) 
	end )
end )

-- Hotbar Tweaks 
Events.OnGameStart.Add( function() 
	Codex.singlePrototypeOverride( function(old, self) 
		self.slotWidth = MD.slot_size
		self.slotHeight = MD.slot_size
		self.slotPad = MD.hotbar_spacing
		self.margins = MD.hotbar_spacing
		self.height = self.slotHeight + MD.hotbar_spacing*2+2;
		self:setSizeAndPosition()
		self.borderColor.r, self.borderColor.g, self.borderColor.b = Codex.getTempColor()
		return old(self)
	end, ISHotbar, "render")
end )

-- Style Override 
Events.OnGameStart.Add( function() 
	Codex.multiplePrototypesOverride( function(old, self) 		
		style_override(self) 
		return old(self)
	end,"prerender", { 
        ISInventoryPage, 
		ISUIWriteJournal, 
        ISFitnessUI, 
        ISFishingUI, 
        ISMiniMapOuter,
		ISAlarmClockDialog,
		ISCraftingCategoryUI,
		ISCraftingUI, 
		ISBuildWindow,
		ISBBQInfoWindow,
		ISVehicleAnimalUI,
		ISHandcraftWindow,
		ISGarmentUI,
		ISHotbar,
		ISUserPanelUI,
		ISContextMenu,
		ISPanelJoypad,
		ISCollapsableWindow
    } ) 
end )

-- EquippedItem Tweaks 
Events.OnGameStart.Add( function() 
	local function set_condition_color(self) 
		if not MD.b_display_eq_condition then return end 
		PLAYER = getPlayer() 
		if not PLAYER or PLAYER:isDead() then return end
		local primary = PLAYER:getPrimaryHandItem() 
		local secondary = PLAYER:getSecondaryHandItem() 
		local main_hand = self.mainHand 
		if primary and primary:IsWeapon() then 
			main_hand.backgroundColor.r, main_hand.backgroundColor.g, main_hand.backgroundColor.b = Codex.getColorGradient_RedToGreen(
				primary:getCondition(), 
				0.0, 
				primary:getConditionMax()
			) 
		else 
			main_hand.backgroundColor.r = 1.0
			main_hand.backgroundColor.g = 1.0
			main_hand.backgroundColor.b = 1.0
		end 
		local off_hand = self.offHand 
		if secondary and secondary:IsWeapon() then 
			off_hand.backgroundColor.r, off_hand.backgroundColor.g, off_hand.backgroundColor.b = Codex.getColorGradient_RedToGreen(
				secondary:getCondition(), 
				0.0, 
				secondary:getConditionMax()
			) 
		else 
			off_hand.backgroundColor.r = 1.0 
			off_hand.backgroundColor.g = 1.0
			off_hand.backgroundColor.b = 1.0
		end
	end
	Codex.singlePrototypeOverride( function(old, self) 
		set_condition_color(self)
		return old(self)
	end, ISEquippedItem, "prerender") 
end )

-- Context Menu 
Events.OnGameStart.Add( function() 
	context_menu_callbacks["toggle auto zoom"] = function() 
		MD.b_aiming_auto_zoom = not MD.b_aiming_auto_zoom
	end
	context_menu_callbacks["toggle click to move"] = function() 
		MD.b_click_to_move = not MD.b_click_to_move 
	end
	for ZL = 0.25, 2.25, 0.25 do 
		local aim_name = tostring(ZL).." (aim zoom)"	
		context_menu_callbacks[aim_name] = function() MD.f_aim = ZL end 
		local run_name = tostring(ZL).." (run zoom)"
		context_menu_callbacks[run_name] = function() MD.f_run = ZL end 
	end
	context_menu_callbacks["toggle debug"] = function()   
		MD.b_debug = not MD.b_debug 
	end
	context_menu_callbacks["god mode on"] = function()   
		if not PLAYER then return end 
		PLAYER:setGodMod(MD.b_debug)
		Codex.print("god mode: "..tostring(PLAYER:isGodMod()))
	end
	context_menu_callbacks["god mode off"] = function()   
		if not PLAYER then return end 
		PLAYER:setGodMod(false)
		Codex.print("god mode: "..tostring(PLAYER:isGodMod()))
	end
	context_menu_callbacks["toggle mouse facing"] = function() 
		MD.b_mouse_facing = not MD.b_mouse_facing
	end
	context_menu_callbacks["Open Settings Window"] = function() 
		if not config_window then return end 
		config_window:setVisible(true) 
	end
	context_menu_callbacks["toggle condition indicator"] = function() 
		MD.b_display_eq_condition = not MD.b_display_eq_condition 
	end
	context_menu_callbacks["toggle auto hide user interface"] = function() 
		MD.b_autohide_ui = not MD.b_autohide_ui 
	end
	context_menu_callbacks["toggle steering indicator"] = function()
		MD.b_steering_indicator = not MD.b_steering_indicator 
	end 
	-- 
	Events.OnFillWorldObjectContextMenu.Add( function(playerIndex, context, worldobjects) 
		Codex.new_context_menu(context, { 
			name = "MGGA : MOD OPTIONS",
			items = { -- mod options 
				"Open Settings Window",
				"toggle auto hide user interface",
				"toggle steering indicator", 
				{ -- auto zoom options 
					name = "Auto Zoom ("..tostring(MD.b_aiming_auto_zoom)..")",
					items = {
						"toggle auto zoom",
						{
							name = "Set Aiming Zoom Target ("..tostring(MD.f_aim)..")", 
							items = {"0.25 (aim zoom)", "0.5 (aim zoom)","0.75 (aim zoom)", "1 (aim zoom)", "1.25 (aim zoom)", "1.5 (aim zoom)", "1.75 (aim zoom)", "2.0 (aim zoom)", "2.25 (aim zoom)"} 
						},
						{
							name = "Set Running Zoom Target ("..tostring(MD.f_run)..")",
							items = {"0.25 (run zoom)", "0.5 (run zoom)","0.75 (run zoom)", "1 (run zoom)", "1.25 (run zoom)", "1.5 (run zoom)", "1.75 (run zoom)", "2.0 (run zoom)", "2.25 (run zoom)"} 
						}
					}
				},
				{ -- mouse options 
					name = "Mouse Tweaks ("..tostring(MD.b_click_to_move).."/"..tostring(MD.b_mouse_facing)..")",
					items = {
						"toggle click to move",
						"toggle mouse facing"
					}
				},
				{ -- equipped items options 
					name = "Equipped Items Options",
					items = {
						"toggle condition indicator"
					}
				},
				{ -- debug options 
					name = "Debug ("..tostring(MD.b_debug).."/"..tostring(PLAYER:isGodMod())..")",
					items = {
						"toggle debug",
						"god mode on",
						"god mode off"
					}
				}
			}	
		}, context_menu_callbacks )
	end )
end )

-- END 