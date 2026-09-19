



local function get_crafts()
    local shown_crafts = {}
    for i, j in pairs(G.P_CENTER_POOLS['MC_Resources']) do
        if j.unlocked then
			local valid = true
            if valid then
                    shown_crafts[#shown_crafts + 1] = {j, true}
            end
        end
    end
    return shown_crafts
end

G.FUNCS.your_game_crafting_page = function(args)
    local shown_crafts = get_crafts()
    local adding = 12  * ((args.cycle_config.current_option) - 1)
    if not args or not args.cycle_config then return end
    for j = 1, #G.areas.resources do
        if G.areas.resources[j].cards[1] then
            local c = G.areas.resources[j].cards[1]
            c:remove()
            c = nil
            G.OVERLAY_MENU:get_UIE_by_ID("resource_square_"..j).config.ref_table.card_center = nil
        end
    end
    for j = 1, #G.areas.resources do
        if (1+(j-1)+adding) <= #shown_crafts then
            
            local center = shown_crafts[1+(j-1)+adding][1]
            if center then
                G.OVERLAY_MENU:get_UIE_by_ID("resource_square_"..j).config.ref_table.card_center = center
                local card = Card(G.areas.resources[j].T.x + G.areas.resources[j].T.w, G.areas.resources[j].T.y, G.CARD_W*0.75, G.CARD_W*0.75, nil, center)
                card:start_materialize(nil, j>1)
                G.areas.resources[j]:emplace(card)
            end
        end
    end
    
end



G.FUNCS.check_craft = function(e)
    local key
    local output_recipe_bool
    local ever_true = false 
    
    for i, j in pairs(G.P_CENTER_POOLS['Craft']) do
        
        output_recipe_bool = true
        for p, l in pairs(j.recipe) do
            if not G.areas.crafting[p].cards[1] then
                key = "air"
            else 
                key = G.areas.crafting[p].cards[1].config.center.key
            end
            if key ~= l then
                output_recipe_bool = false
            end
        end
        if output_recipe_bool then
            if not G.areas.final_craft.cards[1] then
                local card = Card(G.areas.final_craft.T.x + G.areas.final_craft.T.w, G.areas.final_craft.T.y, G.CARD_W, G.CARD_H, nil, j)

                card:start_materialize(nil, true)
                G.areas.final_craft:emplace(card)
                
            end
            ever_true = true
        end
    end
    if ever_true == false then
        if G.areas.final_craft.cards[1] then
            local c = G.areas.final_craft.cards[1]
            c:remove()
            c = nil
        end
    end 
end

G.FUNCS.regen_resource = function(e)
    if e.config.object.cards[1] then
        if e.config.ref_table.card_center ~= e.config.object.cards[1].config.center  then
            e.config.ref_table.card_center = e.config.object.cards[1].config.center
        end
    end
    if not e.config.object.cards[1] then
        if e.config.ref_table.card_center then
            local card = Card(e.config.object.T.x + e.config.object.T.w, e.config.object.T.y, G.CARD_W*0.75, G.CARD_W*0.75, nil, e.config.ref_table.card_center)
            card:start_materialize(nil, true)
            e.config.object:emplace(card)
        end
    end
end

G.FUNCS.uifun = function(e)
  e.states.hover.can = true
  e.states.collide.can = true

  if e.states.collide.is then
    if e.config.ref_table.card and not e.config.ref_table.card.states.drag.is and not e.config.object.cards[1] then
        draw_card(e.config.ref_table.card.area, e.config.object,nil,nil,nil, e.config.ref_table.card )
    end
    if e.config.ref_table.card == nil then
        for i = 1, #G.I.CARD do
            if G.I.CARD[i].states.drag.is then
                e.config.ref_table.card = G.I.CARD[i]
            end
        end
    end
  else
    e.config.ref_table.card = nil
  end
end

function G.UIDEF.learned_craft()
    local shown_crafts = get_crafts()
    if not use_page then
        crafts_resource_page = nil
    end
    
    local adding = 12  * ((crafts_resource_page or 1) - 1)
    local rows = {}	
    for i = 1, 3 do
        table.insert(rows, {})
        for j = 0, 4 do
            if shown_crafts[j+i+adding] then
            end
        end
    end
    G.areas = {}
    G.areas.resources = {}
    G.areas.crafting = {}
    G.areas.owned_jokers = {}
    

    local area_table = {}
    for j = 1, 12 do
        G.areas.resources[j] = CardArea(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,G.CARD_W*0.8,G.CARD_W*0.8, {card_limit = 1, type = 'joker', highlight_limit = 4, no_card_count = true, craft_table_resources = true})
    end
    for j = 1, 9 do
        G.areas.crafting[j] = CardArea(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,G.CARD_W*0.8,G.CARD_W*0.8, {card_limit = 1, type = 'joker', highlight_limit = 1, no_card_count = true,})
    end
    G.areas.final_craft = CardArea(G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h, G.CARD_W, 1.25*G.CARD_W, {card_limit = 1, type = 'joker', highlight_limit = 1, no_card_count = true, craft_table = true})

    local craft_options = {}
    for i = 1, math.ceil(math.max(1, math.ceil(#shown_crafts/12))) do
        table.insert(craft_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(math.max(1, math.ceil(#shown_crafts/12)))))
    end

    for j = 1, #G.areas.resources do    
        if (1+(j-1)+adding) <= #shown_crafts then
            local center = shown_crafts[1+(j-1)+adding][1]
            if center then
                local card = Card(G.areas.resources[j].T.x + G.areas.resources[j].T.w, G.areas.resources[j].T.y, G.CARD_W*0.75, G.CARD_W*0.75, nil, center)
                card:start_materialize(nil, j>1)
                G.areas.resources[j]:emplace(card)
            end
        end
    end

    local texti = "Crafting"
  
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
		{n=G.UIT.C, config={align = "cm", minw = 3,minh = 7, padding = 0, r = 0.1, colour =HEX("C6C6C6"), emboss = 0.05},nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.25,padding = 0, r = 0.1}, nodes={

            }},
            {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                {n = G.UIT.O, config = { object = G.areas.resources[1], id = "resource_square_1", func = 'regen_resource',ref_table = {card_center = nil}}},
                {n = G.UIT.O, config = { object = G.areas.resources[2], id = "resource_square_2", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[3], id = "resource_square_3", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
            }},
            {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                {n = G.UIT.O, config = { object = G.areas.resources[4], id = "resource_square_4", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[5], id = "resource_square_5", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[6], id = "resource_square_6", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
            }},
            {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                {n = G.UIT.O, config = { object = G.areas.resources[7], id = "resource_square_7", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[8], id = "resource_square_8", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[9], id = "resource_square_9", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
            }}, 
            {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                {n = G.UIT.O, config = { object = G.areas.resources[10], id = "resource_square_10", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[11], id = "resource_square_11", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
                {n = G.UIT.O, config = { object = G.areas.resources[12], id = "resource_square_12", func = 'regen_resource',ref_table = {card_center = nil}}, nodes = {
                }},
            }},
            {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                create_option_cycle({options = craft_options, w = 2, cycle_shoulders = true, opt_callback = 'your_game_crafting_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (crafts_resource_page or 1), colour = G.C.ORANGE,})
            }},
            
        }},
        
        {n=G.UIT.C, config={align = "tm", minw = 10, minh = 7, padding = 0.2, r = 0.1, colour = G.C.BLUE, emboss = 0.05}, nodes={
            {n=G.UIT.R, config={align = "tm", minw = 11 , minh = 1, padding = 0.2, r = 0.1, colour = G.C.GREEN, emboss = 0.05}, nodes={
                {n=G.UIT.T, config={text = texti, scale = 1.5, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", minw = 11, minh = 6, padding = 0.2, r = 0.1, colour = G.C.RED, emboss = 0.05}, nodes={
                {n=G.UIT.C, config={}, nodes={
                    {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                        {n = G.UIT.O, config = { object =  G.areas.crafting[1], func = 'uifun',ref_table = {card = nil}}},
                        {n = G.UIT.O, config = { object = G.areas.crafting[2],  func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                        {n = G.UIT.O, config = { object = G.areas.crafting[3], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                    }},
                    {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                        {n = G.UIT.O, config = { object = G.areas.crafting[4], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                        {n = G.UIT.O, config = { object = G.areas.crafting[5], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                        {n = G.UIT.O, config = { object = G.areas.crafting[6], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                    }},
                    {n=G.UIT.R, config={align = "tm", padding = 0, r = 0.1}, nodes={
                        {n = G.UIT.O, config = { object = G.areas.crafting[7], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                        {n = G.UIT.O, config = { object = G.areas.crafting[8], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                        {n = G.UIT.O, config = { object = G.areas.crafting[9], func = 'uifun',ref_table = {card = nil}}, nodes = {
                        }},
                    }}, 
                }},
                {n=G.UIT.C, config={align = "cm",  padding = 1 }, nodes={
                    {n = G.UIT.O, config = { object =  G.areas.final_craft, func = 'check_craft'}, nodes = {
                    }},
                }}
            }},
            {n=G.UIT.R, config={align = "tm", minw = 11, minh = 1, padding = 0.2, r = 0.1, colour = G.C.DARK_EDITION, emboss = 0.05}, nodes={}},
        }},
        {n=G.UIT.C, config={align = "cm", minw = 3, minh = 7, padding = 0.2, r = 0.1, colour = G.C.GREEN, emboss = 0.05}, nodes={
            --create_option_cycle({options = craft_options, w = 3.5, cycle_shoulders = true, opt_callback = 'your_game_crafting_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (crafts_page or 1), colour = G.C.ORANGE, no_pips = true})
        }}
      }}
    return t
end

-- function G.UIDEF.learned_craft()
--     local shown_crafts = get_crafts()
--     if not use_page then
--         crafts_page = nil
--     end
    
--     local adding = 15  * ((crafts_page or 1) - 1)
--     local rows = {}	
--     for i = 1, 3 do
--         table.insert(rows, {})
--         for j = 0, 4 do
--             if shown_crafts[j*5+i+adding] then
--                 table.insert(rows[i], shown_crafts[j*5+i+adding][1])
--             end
--         end
--     end
--     G.areas = {}
--     local area_table = {}
--     for j = 1, math.max(1,math.min(3, math.ceil(#shown_crafts/5))) do
--         G.areas[j] = CardArea(
--             G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
--             (5.25)*G.CARD_W,
--             1.25*G.CARD_W, 
--             {card_limit = 5, type = 'joker', highlight_limit = 1, craft_table = true})
--         table.insert(area_table, 
--         {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
--             {n=G.UIT.O, config={object = G.areas[j]}}
--         }}
--         )
--     end

--     local craft_options = {}
--     for i = 1, math.ceil(math.max(1, math.ceil(#shown_crafts/15))) do
--         table.insert(craft_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(math.max(1, math.ceil(#shown_crafts/15)))))
--     end

--     for j = 1, #G.areas do
--         for i = 1, 5 do
--             if (i+(j-1)*(5)+adding) <= #shown_crafts then
--                 local center = shown_crafts[i+(j-1)*(5)+adding][1]
--                 local card = Card(G.areas[j].T.x + G.areas[j].T.w, G.areas[j].T.y, G.CARD_W, G.CARD_H, nil, center)
--                 card:start_materialize(nil, i>1 or j>1)
--                 G.areas[j]:emplace(card)
--             end
--         end
--     end

--     local texti = "Crafts"
  
--     local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
-- 		{n=G.UIT.R, config={align = "cm"},nodes={
-- 			{n=G.UIT.T, config={text = texti, scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
--         }},
--         {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
--         {n=G.UIT.R, config={align = "cm"}, nodes={
--             create_option_cycle({options = craft_options, w = 3.5, cycle_shoulders = true, opt_callback = 'your_game_crafting_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (crafts_page or 1), colour = G.C.ORANGE, no_pips = true})
--         }}
--       }}
--     return t
-- end
function craft_joker(card)
    local obj = card.config.center
    local key = obj.key
    for i,j in pairs(obj.recipe) do
        if j ~= "air" then
		    G.GAME.craftr[j] = G.GAME.craftr[j] - 1
        end 
	end
    if key == "mc_bucket"  then
        local bucket = SMODS.create_card{key = "j_mc_bucket" }
		G.jokers:emplace(bucket)
		bucket:add_to_deck()
    end
	if key == "mc_dia_pickaxe"  then
        local pickaxe = SMODS.create_card{key = "j_mc_dia_pickaxe" }
		G.jokers:emplace(pickaxe)
		pickaxe:add_to_deck()
    end
    if key == "mc_gold_block"  then
        local gold_block = SMODS.create_card{key = "j_mc_gold_block" }
		G.jokers:emplace(gold_block)
		gold_block:add_to_deck()
    end
    if key == "mc_wooden_sword_craft"  then
        G.GAME.available_weapons.mc_wooden_sword = true
    end
     if key == "mc_planks_craft"  then
        G.GAME.craftr["mc_planks"] = G.GAME.craftr["mc_planks"] + 4
    end
     if key == "mc_sticks_craft"  then
        G.GAME.craftr["mc_sticks"] =  G.GAME.craftr["mc_sticks"] + 4
    end
end

G.FUNCS.can_craft = function(e)
    local craft_req = true
    if (e.config.ref_table.config.center.craft_type == "joker") and e.config.ref_table.config.center.key ~= "mc_orb_dom" then
	     craft_req = #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
    end
	if craft_req == false then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'craft_joker'
    end
end

G.FUNCS.craft_joker = function(e)
    craft_joker(e.config.ref_table)
    if G.OVERLAY_MENU then
        local tab_but = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_" .. localize('b_crafting'))
        use_page = true
        G.FUNCS.change_tab(tab_but)
        use_page = nil
    end
end

G.FUNCS.do_nothing = function(e)
end
G.FUNCS.can_plank = function(e)
	local craft_req = true
	
		if G.GAME.craftr["logs"] < 1 then craft_req = false end
	
	if not craft_req then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'craft_planks'
    end
end

G.FUNCS.can_stick = function(e)
		local craft_req = true
	
		if G.GAME.craftr["planks"] < 2 then craft_req = false end
	
	if not craft_req then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = 'do_nothing'
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'craft_sticks'
    end
end

G.FUNCS.craft_planks = function(e)
	G.GAME.craftr["logs"]= G.GAME.craftr["logs"] - 1
	G.GAME.craftr["planks"] = G.GAME.craftr["planks"] + 4
	if G.OVERLAY_MENU then
        local tab_but = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_" .. localize('b_resources'))
        use_page = true
        G.FUNCS.change_tab(tab_but)
        use_page = nil
    end
end


G.FUNCS.craft_sticks = function(e)
	G.GAME.craftr["planks"]= G.GAME.craftr["planks"] - 2
	G.GAME.craftr["sticks"] = G.GAME.craftr["sticks"] + 4
    if G.OVERLAY_MENU then
        local tab_but = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_" .. localize('b_resources'))
        use_page = true
        G.FUNCS.change_tab(tab_but)
        use_page = nil
    end
end


local card_highlight_ref = Card.highlight--(is_higlighted)


function Card:highlight(is_higlighted)
    local r = card_highlight_ref(self, is_higlighted)
    if self.ability.set == 'Craft' then
        local x_off = 0
        self.children.use_button = UIBox{
            definition = G.UIDEF.use_and_sell_buttons(self), 
            config = {align=
                    ((self.area == G.jokers) or (self.area == G.consumeables)) and "cr" or
                    "bmi"
                , offset = 
                    ((self.area == G.jokers) or (self.area == G.consumeables)) and {x=x_off - 0.4,y=0} or
                    {x=0,y=0.65},
                parent =self}
        }
    end
    return r
end


local G_UIDEF_use_and_sell_buttons_ref2 = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local r = G_UIDEF_use_and_sell_buttons_ref2(card)
    if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
		if card.ability.set == "Resource" then
			return {
				n = G.UIT.ROOT,
				config = { padding = -0.1, colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							minh = 0.7 * card.T.h,
							maxw = 0.7 * card.T.w - 0.15,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = "use_card",
							func = "can_reserve_card",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "PULL",
									colour = G.C.UI.TEXT_LIGHT,
									scale = 0.55,
									shadow = true,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = {
							ref_table = card,
							r = 0.08,
							padding = 0.1,
							align = "bm",
							minw = 0.5 * card.T.w - 0.15,
							maxw = 0.9 * card.T.w - 0.15,
							minh = 0.1 * card.T.h,
							hover = true,
							shadow = true,
							colour = G.C.UI.BACKGROUND_INACTIVE,
							one_press = true,
							button = "Do you know that this parameter does nothing?",
							func = "can_use_consumeable",
						},
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = " USE ",
									colour = G.C.UI.TEXT_LIGHT, 
									scale = 0.45,
									shadow = true,
								},
							},
						},
					},
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					{ n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
					-- Betmma can't explain it, neither can I
				},
	}
		end
	end
    
    if card and card.area and card.area.config and card.area.config.craft_table_resources == true then
         return {}
    end
	return r
end
