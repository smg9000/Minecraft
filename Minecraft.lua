--- STEAMODDED HEADER
--- MOD_NAME: Minecraft
--- MOD_ID: Minecraft
--- PREFIX: mc
--- MOD_AUTHOR: [SMG9000, Mathguy ]
--- MOD_DESCRIPTION: a mod that adds minecraft to balatro in a way that you would not expect
--- DEPENDENCIES: [Talisman]
--- VERSION: 0.0.2

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Crafts = {}
    SMODS.Craft = SMODS.GameObject:extend {
        obj_table = SMODS.Crafts,
        obj_buffer = {},
        set = 'Craft',
        required_params = {
            'key',
			"req",
        },
        inject = function(self)
            G.P_CRAFTS[self.key] = {}
			table.insert(G.P_CENTER_POOLS.Craft, self)
        end,
		post_inject_class = function(self)
			table.sort(G.P_CENTER_POOLS[self.set], function(a, b) return a.order < b.order end)
		end,
        process_loc_text = function(self)
            SMODS.process_loc_text(G.localization.misc.labels, "k_"..self.key:lower(), self.loc_txt, 'name')
            SMODS.process_loc_text(G.localization.misc.dictionary, "k_"..self.key:lower(), self.loc_txt, 'name')
        end,
    }
SMODS.Craft {
        order = 1,
		key = 'mc_bucket',
		unlocked = true,
		discovered = true,
		atlas = 'mc_crafted_jokers',
		cost = 8,
		name = "Bucket",
		req = {iron = 3},
		pos = {x=0,y=0},
		set = "Craft",
		config = {},			
    }
SMODS.Craft {
        order = 1,
		key = 'mc_dia_pickaxe',
		unlocked = true,
		discovered = true,
		atlas = 'mc_crafted_jokers',
		cost = 8, name = "Diamond_Pickaxe",
		req = {diamond = 3, sticks = 2},
		pos = {x=1,y=0},
		set = "Craft",
		config = {},
    }



local function get_crafts()
    local shown_crafts = {}
    for i, j in pairs(G.P_CENTER_POOLS['Craft']) do
        if j.unlocked then
			local valid = true
            if valid then
                    shown_crafts[#shown_crafts + 1] = {j, true}
            end
        end
    end
    return shown_crafts
end




function G.UIDEF.learned_craft()
    local shown_crafts = get_crafts()
    if not use_page then
        crafts_page = nil
    end
    local adding = 15  * ((crafts_page or 1) - 1)
    local rows = {}	
    for i = 1, 3 do
        table.insert(rows, {})
        for j = 0, 4 do
            if shown_crafts[j*5+i+adding] then
                table.insert(rows[i], shown_crafts[j*5+i+adding][1])
            end
        end
    end
    G.areas = {}
    area_table = {}
    for j = 1, math.max(1,math.min(3, math.ceil(#shown_crafts/5))) do
        G.areas[j] = CardArea(
            G.ROOM.T.x + 0.2*G.ROOM.T.w/2,G.ROOM.T.h,
            (5.25)*G.CARD_W,
            1.25*G.CARD_W, 
            {card_limit = 5, type = 'joker', highlight_limit = 1, craft_table = true})
        table.insert(area_table, 
        {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
            {n=G.UIT.O, config={object = G.areas[j]}}
        }}
        )
    end

    local craft_options = {}
    for i = 1, math.ceil(math.max(1, math.ceil(#shown_crafts/15))) do
        table.insert(craft_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(math.max(1, math.ceil(#shown_crafts/15)))))
    end

    for j = 1, #G.areas do
        for i = 1, 5 do
            if (i+(j-1)*(5)+adding) <= #shown_crafts then
                local center = shown_crafts[i+(j-1)*(5)+adding][1]
                local card = Card(G.areas[j].T.x + G.areas[j].T.w, G.areas[j].T.y, G.CARD_W, G.CARD_H, nil, center)
                card:start_materialize(nil, i>1 or j>1)
                G.areas[j]:emplace(card)
            end
        end
    end

    local texti = "Crafts"
  
    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
		{n=G.UIT.R, config={align = "cm"},nodes={
			{n=G.UIT.T, config={text = texti, scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
            {n=G.UIT.R, config={align = "cm"}, nodes={
                create_option_cycle({options = craft_options, w = 3.5, cycle_shoulders = true, opt_callback = 'your_game_crafting_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (crafts_page or 1), colour = G.C.ORANGE, no_pips = true})
        }}
      }}
    return t
end

function craft_joker(card)
    local obj = card.config.center
    local key = obj.key
    for i,j in pairs(obj.req) do
		G.GAME.craftr[i] = G.GAME.craftr[i] - j 
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
end

G.FUNCS.can_craft = function(e)
	local craft_req = #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
	for i,j in pairs(e.config.ref_table.config.center.req) do
		if G.GAME.craftr[i] < j then craft_req = false end
	end
	if not craft_req then
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

G.FUNCS.your_game_craft_page = function(args)
    local shown_crafts = get_crafts()
    if not args or not args.cycle_config then return end
    crafts_page = args.cycle_config.current_option
    for j = 1, #G.areas do
        for i = #G.areas[j].cards,1, -1 do
            local c = G.areas[j]:remove_card(G.areas[j].cards[i])
            c:remove()
            c = nil
        end
    end
    for i = 1, 5 do
        for j = 1, 3 do
            local adding = 3  * (args.cycle_config.current_option - 1)
            local center = shown_crafts[i+(j-1)*5 + 5 * adding]
            if not center then break end
            local card = Card(G.areas[j].T.x + G.areas[j].T.w, G.areas[j].T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center[1])
            G.areas[j]:emplace(card)
        end
    end
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

local function create_resource_sprite(x, y, w, h, pos1, pos2)
	return Sprite(x, y, w, h, G.ASSET_ATLAS['mc_resource_sprites'], {x=pos1,y=pos2})
end

function G.UIDEF.resource_list()
	_scale = 1
		local dirt_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 0, 0)
		dirt_sprite.states.drag.can = false
		local cobble_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 0, 0)
		cobble_sprite.states.drag.can = false
		local coal_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 1, 0)
		coal_sprite.states.drag.can = false
		local copper_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 2, 0)
		copper_sprite.states.drag.can = false
		local iron_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 3, 0)
		iron_sprite.states.drag.can = false
		local gold_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 4, 0)
		gold_sprite.states.drag.can = false
		local diamond_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 5, 0)
		diamond_sprite.states.drag.can = false
		local emerald_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 6, 0)
		emerald_sprite.states.drag.can = false
		local netherite_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 7, 0)
		netherite_sprite.states.drag.can = false	
		local lapis_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 8, 0)
		lapis_sprite.states.drag.can = false
		local redstone_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 9, 0)
		redstone_sprite.states.drag.can = false
		local quartz_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 10, 0)
		quartz_sprite.states.drag.can = false
		local M_sprite = create_resource_sprite(0, 0, _scale*0.5, _scale*0.5, 10, 0)
		M_sprite.states.drag.can = false




	
    local text = "Resources"
    local dirt = localize("dirt") .. ": " .. tostring(G.GAME.craftr["dirt"])
    local cobble = localize("cobblestone") .. ": " .. tostring(G.GAME.craftr["cobblestone"])
    local coal = localize("coal") .. ": " .. tostring(G.GAME.craftr["coal"])
    local copper = localize("copper") .. ": " .. tostring(G.GAME.craftr["copper"])
    local iron = localize("iron") .. ": " .. tostring(G.GAME.craftr["iron"])
    local gold = localize("gold") .. ": " .. tostring(G.GAME.craftr["gold"])
    local diamond = localize("diamond") .. ": " .. tostring(G.GAME.craftr["diamond"])
    local emerald = localize("emerald") .. ": " .. tostring(G.GAME.craftr["emerald"])
    local netherite = localize("netherite") .. ": " .. tostring(G.GAME.craftr["netherite"])
    local logs = localize("logs") .. ": " .. tostring(G.GAME.craftr["logs"])
    local planks = localize("planks") .. ": " .. tostring(G.GAME.craftr["planks"])
    local sticks = localize("sticks") .. ": " .. tostring(G.GAME.craftr["sticks"])
    local lapis = localize("lapis") .. ": " .. tostring(G.GAME.craftr["lapis"])
    local redstone = localize("redstone") .. ": " .. tostring(G.GAME.craftr["redstone"])
    local quartz = localize("quartz") .. ": " .. tostring(G.GAME.craftr["quartz"])
	local M = localize("m") .. ": " .. tostring(G.GAME.craftr["m"])
    
    local texti = "  " 
    local t = {n=G.UIT.ROOT, config={align = "tl", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "tl"},nodes={
            {n=G.UIT.T, config={text = text, scale = 0.42, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = dirt_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = dirt, scale = 0.35, colour = HEX("B38159"), shadow = true}},
        }},
	{n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = cobble_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = cobble, scale = 0.35, colour = HEX("B38159"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = coal_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = coal, scale = 0.35, colour = HEX("252525"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = copper_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = copper, scale = 0.35, colour = HEX("E27753"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = iron_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = iron, scale = 0.35, colour = HEX("D1D1D1"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = gold_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = gold, scale = 0.35, colour = HEX("F4ED5C"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = diamond_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = diamond, scale = 0.35, colour = HEX("6CEEE6"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = emerald_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = emerald, scale = 0.35, colour = HEX("16D65F"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = netherite_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = netherite, scale = 0.35, colour = HEX("101010"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = lapis_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = lapis, scale = 0.35, colour = HEX("26619c"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = redstone_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = redstone, scale = 0.35, colour = HEX("d40000"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = quartz_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = quartz, scale = 0.35, colour = HEX("ddd4c6"), shadow = true}},
        }},
		{n=G.UIT.R, config={align = "tl"},nodes={
			{n=G.UIT.O, config = {object = M_sprite, hover = true, can_collide = false}},
            {n=G.UIT.T, config={text = M, scale = 0.35, colour = HEX("ddd4c6"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
            {n=G.UIT.T, config={text = logs, scale = 0.35, colour = HEX("c7892a"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
            {n=G.UIT.T, config={text = planks, scale = 0.35, colour = HEX("c7892a"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
            {n=G.UIT.T, config={text = sticks, scale = 0.35, colour = HEX("c7892a"), shadow = true}},
        }},
        {n=G.UIT.R, config={align = "tl"},nodes={
            {n=G.UIT.T, config={text = texti, scale = 0.35, colour = HEX("101010"), shadow = true}},
        }},
        {n=G.UIT.B, config={h=0.5,w=0,align = "cm"},nodes={}},
        {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "bm", minw = 0.5 - 0.15, maxw = 1.5 - 0.15, minh = 0.5, hover = true, shadow = true, colour = HEX('966a2c'), button = 'craft_planks',func = "can_plank"}, nodes={
            {n=G.UIT.T, config={text = localize('b_craft_planks'),colour = G.C.UI.TEXT_LIGHT, scale = 0.6, shadow = true}},
        }},
        {n=G.UIT.R, config={align = "cm"},nodes={
            {n=G.UIT.T, config={text = texti, scale = 0.35, colour = HEX("101010"), shadow = true}},
        }},
        {n=G.UIT.R, config={ r = 0.08, padding = 0.05, align = "bm", minw = 0.5 - 0.15, maxw = 1.5- 0.15, minh = 0.5, hover = true, shadow = true, colour = HEX('966a2c'), button = 'craft_sticks',func = "can_stick"}, nodes={
            {n=G.UIT.T, config={text = localize('b_craft_sticks'),colour = G.C.UI.TEXT_LIGHT, scale = 0.6, shadow = true}}
        }}
    }}
    return t
end

function add_craft_resource(section, amount, card, message_)
    local message = true
    if message_ ~= nil then
        message = message_
    end
        G.GAME.craftr[section] = G.GAME.craftr[section] + amount
    
    if card and message and (amount ~= 0) then
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='gain_craftr',vars={amount, localize(section)}},colour = HEX("a37c12")	, delay = 0.45})
    end
end

function SMODS.current_mod.process_loc_text()
    G.localization.misc.quips['aww_man'] ={ "Aww Man"}
    G.localization.misc.v_dictionary["gain_craftr"] = "+#1# #2#"
    G.localization.misc.dictionary['b_crafting'] = "Crafting"
    G.localization.misc.dictionary['b_resources'] = "Resources"
    G.localization.misc.dictionary["b_craft"] = "CRAFT"
    G.localization.misc.dictionary["b_craft_planks"] = "Craft Planks"
    G.localization.misc.dictionary["b_craft_sticks"] = "Craft Sticks"
    G.localization.misc.dictionary["k_craft"] = "Craft"
    G.localization.misc.dictionary['dirt'] = "Dirt"
    G.localization.misc.dictionary['cobblestone'] = "Cobblestone"
    G.localization.misc.dictionary['coal'] = "Coal"
    G.localization.misc.dictionary['copper'] = "Copper"
    G.localization.misc.dictionary['iron'] = "Iron"
    G.localization.misc.dictionary['gold'] = "Gold"
    G.localization.misc.dictionary['diamond'] = "Diamond"
    G.localization.misc.dictionary['emerald'] = "Emerald"
    G.localization.misc.dictionary['netherite'] = "Netherite"
    G.localization.misc.dictionary['lapis'] = "Lapis"
    G.localization.misc.dictionary['redstone'] = "Redstone"
    G.localization.misc.dictionary['quartz'] = "Quartz"
    G.localization.misc.dictionary['logs'] = "Logs"
	G.localization.misc.dictionary['sticks'] = "Sticks"
	G.localization.misc.dictionary['planks'] = "Planks"
    G.localization.misc.dictionary['m'] = "M"
 
	G.localization.descriptions.Craft = {
        mc_bucket = {
            name = "Bucket",
            text = {
                "Carry over {C:attention}5%{} of total ",
                "overscored {C:blue}chips{} to next {C:attention}blind{}",
                "{C:inactive}Ex: blind is 300 chips and you score 400{}",
                "{C:inactive}the overscored chips is 100 and 5% of that is 5{}",
                "{C:inactive}so you start the next blind with 5 chips{}",
            }
        },
		mc_dia_pickaxe = {
            name = "Diamond Pickaxe",
            text = {
				"Destroy {C:attention}Stone cards{} in {C:attention}played hand{} ",
				"to gain {C:attention}1{} random {C:attention}resource{}",
                "Destroy {C:attention}Deepslate cards{} in {C:attention}played hand{} ",
                "to gain {C:attention}2{} random {C:attention}resources{}",
              	"{C:dark_edition,s:0.7}Art by : lolxDdj{}",
            }
        }
    }
    G.localization.descriptions.Other["enchant_sharpness"] = {
        text = {
            "{C:purple}Sharpness #1#{}"
        }
    }
    G.localization.descriptions.Other["tooltip_sharpness"] = {
        name = "Sharpness",
        text = {
            "{C:red}+#1#{} Mult"
        }
    }
    
end

enchants = {
    sharpness = {
        Joker = true,
        Card = true,
        Consumable = true,
        max = 5,
        loc_txt = 'Sharpness',
        loc_vars = function(value)
            return {2 * value}
        end
    }
}

function random_enchant(card, level)
    if not level then
        level = 0
    end
    local enchanted = false
    local result = {}
    local type_ = "Other"
    if card.ability.set == "Joker" then
        type_ = "Joker"
    elseif card.ability.consumeable then
        type_ = "Consumable"
    elseif card.config.card.suit then
        type_ = "Card"
    end
    for i, j in pairs(enchants) do
        if j[type_] then
            local base = 0
            while pseudorandom('mc_enchant') < 0.10 + 0.05* level do
                base = base + 1
                if base == j.max then
                    break
                end
            end
            if base > 0 then
                result[i] = base
                enchanted = true
            end
        end
    end
    if (level >= 1) and not enchanted then
        local pool = {}
        for i, j in pairs(enchants) do
            if j[type_] then
                table.insert(pool, i)
            end
        end
        if #pool > 0 then
            local enchant = pseudorandom_element(pool, pseudoseed("mc_enchant"))
            enchanted = true
            result[enchant] = 1
        end
    end
    if enchanted then
        return result
    end
end

function Card:add_enchant(enchant)
    self.ability.enchant = enchant
    if self.ability.enchant then
        self.ability.enchanted = true
    end
end

function Card:get_enchant()
    if self.debuff then return end
    if self.ability.enchant then
        local ret = {card = self}
        if self.ability.enchant.sharpness then
            ret.mult_mod = 1 + self.ability.enchant.sharpness
        end
        return ret
    end
end

SMODS.Sticker {
    key = 'enchant',
    rate = 0,
    pos = { x = 0, y = 0 },
    colour = HEX '97F1EF',
    badge_colour = HEX '97F1EF',
    should_apply = function(self, card, center, area)
        return true
    end,
    loc_txt = {
        name = "",
        text = {
            "",
        },
        label = ""
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    apply = function(self, card, val)
        card:add_enchant(random_enchant(card, 0))
    end,
    sets = { 
        Joker = true,
        Tarot = true,
        Planet = true,
        Spectral = true,
        Tarot_Planet = true,
    },
}

--Shader--

SMODS.Shader {
    key = 'enchant',
    path = 'enchant.fs'
}

--Consumables--

local resourceType = SMODS.ConsumableType {
    key = "Resource",
    primary_colour = HEX("6A5700"),
    secondary_colour = HEX("02BF0E"),
    collection_rows = {4,4}, 
    loc_txt = {
        collection = "Resource Cards",
        name = "Resource",
        label = "Resource",
        undiscovered = {
            name = 'Undiscovered Resource',
            text = { 'no' },
        },
    },
    shop_rate = 1,
    default = 'c_mc_dirt',
    can_stack = true,
    can_divide = true,
}

SMODS.MC_Resource = SMODS.Consumable:extend {
    set = "Resource",
    steveEat = false,
    can_use = function(self, card) 
        return true
    end,
    
    set_badges = function(self, card, badges)
        local colours = {
            Common = HEX('FE5F55'),
            Uncommon =  HEX('8867a5'),
            Rare = HEX("fda200"),
            Legendary = {0,0,0,1}
        }
        if G and G.C and G.C.DARK_EDITION then
            colours["Legendary"] = G.C.DARK_EDITION
        end
        local len = string.len(self.rarity)
        local size = 1.3 - (len > 5 and 0.02 * (len - 5) or 0)
        badges[#badges + 1] = create_badge(self.rarity, colours[self.rarity], nil, size)
    end,
	
    --This makes it so much nicer to add shit to the resource cards Oh my god
}

SMODS.UndiscoveredSprite {
    key = 'Resource',
    atlas = 'resource',
    pos = {x = 0, y = 2},
}
    
SMODS.MC_Resource({
    key = "mc_dirt",
    steveEat = true,
    pos = {x=0,y=0},
    loc_txt = {
        name = 'Dirt',
        text = {
            "Gives {C:attention}#1# Dirt{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}",
			"I've Got a jar o' Dirrrt."
        },
    },
    cost = 4,
    atlas = "resource",
	rarity = "Common",
	use = function(self, card, area, copier)
		return add_craft_resource("dirt",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("dirt",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_coal",
    steveEat = true,
    pos = {x=1,y=0},
    loc_txt = {
        name = 'Coal',
        text = {
			"Gives {C:attention}#1# Coal{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 4,
    atlas = "resource",
	rarity = "Common",
	use = function(self, card, area, copier)
		return add_craft_resource("coal",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("coal",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_copper",
    steveEat = true,
    pos = {x=3,y=0},
    loc_txt = {
        name = 'Copper',
        text = {
			"Gives {C:attention}#1# Copper{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 6,
    atlas = "resource",
	rarity = "Uncommon",
	use = function(self, card, area, copier)
		return add_craft_resource("copper",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("copper",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_iron",
    steveEat = true,
    pos = {x=2,y=0},
    loc_txt = {
        name = 'Iron',
        text = {
			"Gives {C:attention}#1# Iron{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 6,
    atlas = "resource",
	rarity = "Uncommon",
	use = function(self, card, area, copier)
		return add_craft_resource("iron",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("iron",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_gold",
    steveEat = true,
    pos = {x=0,y=1},
    loc_txt = {
        name = 'Gold',
        text = {
			"Gives {C:attention}#1# Gold{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 8,
    atlas = "resource",
	rarity = "Rare",
	use = function(self, card, area, copier)
		return add_craft_resource("gold",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("gold",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_diamond",
    steveEat = true,
    pos = {x=1,y=1},
    loc_txt = {
        name = 'Diamond',
        text = {
			"Gives {C:attention}#1# Diamond{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 8,
    atlas = "resource",
	rarity = "Rare",
	use = function(self, card, area, copier)
		return add_craft_resource("diamond",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("diamond",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_emerald",
    steveEat = true,
    pos = {x=2,y=1},
    loc_txt = {
        name = 'Emerald',
        text = {
			"Gives {C:attention}#1# Emerald{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 8,
    atlas = "resource",
	rarity = "Rare",
	use = function(self, card, area, copier)
		return add_craft_resource("emerald",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("emerald",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_netherite",
    steveEat = true,
    pos = {x=3,y=1},
    loc_txt = {
        name = 'Netherite',
        text = {
			"Gives {C:attention}#1# Netherite{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 10,
    atlas = "resource",
	rarity = "Legendary",
	use = function(self, card, area, copier)
		return add_craft_resource("netherite",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("netherite",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_lapis",
    pos = {x=1,y=2},
    loc_txt = {
        name = 'Lapis',
        text = {
			"Gives {C:attention}#1# Lapis{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 6,
    atlas = "resource",
	rarity = "Uncommon",
	use = function(self, card, area, copier)
		return add_craft_resource("lapis",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("lapis",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_redstone",
    pos = {x=2,y=2},
    loc_txt = {
        name = 'Redstone',
        text = {
			"Gives {C:attention}#1# Redstone{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 6,
    atlas = "resource",
	rarity = "Uncommon",
	use = function(self, card, area, copier)
		return add_craft_resource("redstone",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("redstone",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.MC_Resource({
    key = "mc_quartz",
    set = "Resource",
    pos = {x=3,y=2},
    loc_txt = {
        name = 'Quartz',
        text = {
			"Gives {C:attention)}#1# Quartz{} Resource",
			"{C:inactive}Go to Run Info and Crafting to see the crafts{}"
        },
    },
    cost = 8,
    atlas = "resource",
	rarity = "Rare",
	use = function(self, card, area, copier)
		return add_craft_resource("quartz",card.ability.extra.amount,card,true)
	end,
	bulk_use = function(self, card, area, copier, number)
		return add_craft_resource("quartz",card.ability.extra.amount*number,card,true)
	end,
	can_use = function(self, card)
        return true
    end,
	config = {extra = {amount = 1 }},
    loc_vars = function(self)
        return {vars = {self.config.extra.amount} }
    end
})

SMODS.Spectral {
    key = 'deep',
    loc_txt = {
        name = "Deep",
        text = {
            "Enhances {C:attention}#1#",
            "selected card to",
            "{C:attention}#2#s"
        }
    },
    atlas = "consumables",
    pos = {x = 0, y = 0},
    config = {mod_conv = 'm_mc_deepslate', max_highlighted = 1},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card and card.ability.mod_conv or 'm_mc_deepslate']
        return {vars = {(card and card.ability.max_highlighted or 1), localize{type = 'name_text', set = 'Enhanced', key = (card and card.ability.mod_conv or 'm_mc_deepslate')}}}
    end,
}

--Consumable--

local deepslate_card = SMODS.Enhancement {
    key = 'deepslate',
	name = 'Deepslate Card',
    loc_txt = {
        name = 'Deepslate Card',
        text = {
            "{C:chips}+#1#{} Chips",
			"no rank or suit",
        }
    },
    atlas = 'enhancement',
    config = {bonus = 150},
	no_suit = true,
	no_rank = true,
	replace_base_card = true,
	always_scores = true,
    pos = {x = 0, y = 0},
	loc_vars = function(self, info_queue, card)
        return {vars = {card and card.ability.bonus or 150}}
    end,
}

deepslate_card.loc_subtract_extra_chips = deepslate_card.config.bonus
-- @smg9000 please add comment

--Blinds--

SMODS.Blind{
	key = "creeper",
	loc_txt = {
 		name = 'The Creeper',
 		text = { "Ends run if not",
			"beaten in #1#"},
 	},
	name = "The Creeper",
	dollars = 5,
	mult = 2,
	boss= {min = 3, max = 10},
	boss_colour = HEX("297711"),
	atlas = "mc_blinds",
    pos = { x = 0, y = 0},
    vars = {"0:20"},
	config = {},
	set_blind = function(self)
        G.GAME.blind.config.creepertiming = 20
    end,
    loc_vars = function(self, info_queue, card)
        if G.GAME.blind.config.creepertiming == nil then
            return {vars = {"0:20.00"}}
        end
        local m = math.floor(G.GAME.blind.config.creepertiming / 60)
        local s = (G.GAME.blind.config.creepertiming - (60 * m))
        local d = math.floor(100 * (s - math.floor(s)))
        s = tostring(math.floor(s))
        if string.len(s) == 1 then
            s = "0" .. s
        end
        d = tostring(d)
        if string.len(d) == 1 then
            d = "0" .. d
        end
        m = tostring(m)
        return {vars = {m .. ":" .. s .. "." .. d}}
    end,
}

SMODS.Blind{
	key = "wither",
	loc_txt = {
 		name = 'Midnight Wither',
 		text = { "All cards scored gain",
			"Wither sticker"},
 	},
	dollars = 5,
	mult = 3,
	boss= {showdown = true, min = 10, max = 10}, 
	boss_colour = HEX("1a1a1a"),
	atlas = "mc_blinds",
    pos = { x = 0, y = 1},
    vars = {},
	config = {},
}

--Atlas--

SMODS.Atlas({
    key = "resource",
    path = "resource.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "jokeratlas",
    path = "jokeratlas.png",
    px = 71,
    py = 95,
})
SMODS.Atlas({
    key = "resource_sprites",
    path = "resource_sprites.png",
    px = 34,
    py = 34	,
})

SMODS.Atlas({
    key = "placeholder",
    path = "j_placeholder.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
	key = "crafted_jokers",
	atlas_table = "ASSET_ATLAS",
	path = "crafted_jokers.png",
	px = 71,
	py = 95
})

SMODS.Atlas({
    key = "enhancement",
    path = "enhancement.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "consumables",
    path = "consumables.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "mc_blinds",
	atlas_table = "ANIMATION_ATLAS",
    path = "mc_blinds.png",
    px = 34,
    py = 34,
	frames = 21,
})

SMODS.Atlas({
    key = "mc_packs",
    path = "mc_packs.png",
    px = 71,
    py = 95,
})

--Packs-

SMODS.Booster {
    key = 'resource_normal1',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 2,
    cost = 4,
    name = "Resource Pack",
    pos = {x = 0, y = 0},
    config = {extra = 2, choose = 2},
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_normal2',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 2,
    cost = 4,
    name = "Resource Pack",
    pos = {x = 1, y = 0},
    config = {extra = 2, choose = 2},
	create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_jumbo',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Jumbo Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 1.5,
    cost = 4,
    name = "Jumbo Resource Pack",
    pos = {x = 2, y = 0},
    config = {extra = 3, choose = 3},
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}

SMODS.Booster {
    key = 'resource_mega',
    atlas = 'mc_packs',
    group_key = 'k_mc_resource_pack',
    loc_txt = {
        name = "Mega Resource Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{C:attention} Resource{} cards to",
            "use or save"
        }
    },
    weight = 1,
    cost = 4,
    name = "Mega Resource Pack",
    pos = {x = 3, y = 0},
    config = {extra = 4, choose = 4},
    create_card = function(self, card)
        return {set = "Resource", area = G.pack_cards, skip_materialize = true}
    end,
    in_pool = function(self)
        return true
    end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
    draw_hand = false
}


--Jokers--
-- Joker Bundle

SMODS.Joker { 
	name = "mc_bundle",
	key = "bundle",
	loc_txt = {
        name = "Bundle",
        text = {"gains 2 consumable slots",
            },
    },
	pos = { x = 0, y = 1 },
	config = { extra = { bundle = 2 } },
	rarity = 2,
	cost = 6,
	atlas = "jokeratlas",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.bundle } }
	end,
	add_to_deck = function(self, card, from_debuff) 
		G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.bundle
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.bundle
	end,
}

-- Joker Steve

if (SMODS.Mods.Cryptid or {}).can_load then -- checks if Cryptid is enabled
    local cry_config = SMODS.load_mod_config({id = "Cryptid", path = SMODS.Mods.Cryptid.path}) -- loads Cryptid configs

    if cry_config["Exotic Jokers"] then -- check if exotic jokers are enabled
        SMODS.Joker {
            key = "steve",
            loc_txt = {
                name = "Steve",
                text = {"Destroy a random Minecraft card at end of shop",
                    "gain {C:chips}+#2#{} Chips per dirt card",
                    "gain {C:mult}+#4#{} Mult per coal card",
                    "gain {C:money}$#10#{} per gold card",
                    "gain {X:chips,C:white} X#6# {} Chips per copper card",
                    "gain {X:mult,C:white} X#8# {} Mult per iron card",
                    "gain {X:dark_edition,C:white} ^#12# {} Chips per emerald card",
                    "gain {X:dark_edition,C:white} ^#14# {} Mult per diamond card",
                    "gain {X:dark_edition,C:white} ^^#16# {} Mult per netherite card",
                    "{C:inactive}(Currently {C:chips} +#1# {C:inactive} Chips)",
                    "{C:inactive}(Currently {C:mult} +#3# {C:inactive} Mult)",
                    "{C:inactive}(Currently {C:money} $#9#)",
                    "{C:inactive}(Currently {X:chips,C:white} X#5# {C:inactive} Chips)",
                    "{C:inactive}(Currently {X:mult,C:white} X#7# {C:inactive} Mult)",
                    "{C:inactive}(Currently {X:dark_edition,C:white} ^#11# {C:inactive} Chips)",
                    "{C:inactive}(Currently {X:dark_edition,C:white} ^#13# {C:inactive} Mult)",
                    "{C:inactive}(Currently {X:dark_edition,C:white} ^^#15# {C:inactive} Mult)",
					"{C:dark_edition,s:0.7}Art by : GudUsername{}",					
                },
            },
            config = {extra ={chips = 15, chips_mod = 15, mult = 15, mult_mod = 15, x_chips = 1, x_chips_mod = 1, Xmult = 1, Xmult_mod = 1, money = 5, money_mod = 5, Echips = 1, Echips_mod = 0.5, Emult = 1, Emult_mod = 0.5,  EEmult = 1, EEmult_mod = 0.5,  }},
            rarity = "cry_exotic",
            pos = { x = 0, y = 0 },
			soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 } },
            atlas = 'jokeratlas',
            cost = 50,
            blueprint_compat = true,
            calculate = function(self, card, context)
                --TODO: make it so it reselects if not one of the consumbales it can eat.
                if context.ending_shop and (not context.blueprint ) then
                    local destructable_resource = {}
                    local quota = 1
                    for i, currentConsuable in ipairs(G.consumeables.cards) do
                        if
                            currentConsuable.ability.set == "Resource" and not currentConsuable.getting_sliced and
                                not currentConsuable.ability.eternal
                         then
                            destructable_resource[#destructable_resource + 1] = i
                        end
                    end
                    local card_to_destroy = pseudorandom_element(destructable_resource, pseudoseed("steve"))
                    if card_to_destroy then
                        local quota = 1
                        if Incantation then
                        -- Do incantion stuff
                        end
                        local card_key = G.consumeables.cards[card_to_destroy].config.center.key:sub(3,-1)
                        --Scaling 
                        G.consumeables.cards[card_to_destroy].getting_sliced = true
                        if card_key == "mc_dirt" then
                            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+"..number_format(to_big(card.ability.extra.chips_mod)).." Chips"})
            
                        elseif card_key == "mc_coal" then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+"..number_format(to_big(card.ability.extra.mult_mod)).." Mult"})
                        elseif card_key == "mc_copper" then
                            card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.x_chips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+"..number_format(card.ability.extra.x_chips).." Chips"})
                        elseif card_key == "mc_iron" then 
                            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+ X"..number_format(card.ability.extra.Xmult).." Mult"})
                        elseif card_key == "mc_gold" then
                            card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+"..number_format(card.ability.extra.money).." Dollars"})
                        elseif card_key == "mc_diamond" then
                            card.ability.extra.Emult = card.ability.extra.Emult +  card.ability.extra.Emult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+^"..number_format(card.ability.extra.Emult).."Mult"})
                        elseif card_key == "mc_emerald" then
                            card.ability.extra.Echips = card.ability.extra.Echips + card.ability.extra.Echips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+^"..number_format(card.ability.extra.Echips).." Chips"})
                        elseif card_key == "mc_netherite" then
                            card.ability.extra.EEmult = card.ability.extra.EEmult +  card.ability.extra.EEmult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                             {message = "+^^"..number_format(card.ability.extra.EEmult).."Mult"})
            
                        -- else if card_key == "mc_lapis" then
                        -- else if card_key == "mc_redstone" then
                        -- else if card_key == "mc_quartz" then
                        else  -- Not recongized
                            G.consumeables.cards[card_to_destroy].getting_sliced = false
                            return {}
                         end
                        -- Destroy the consumable
                        G.E_MANAGER:add_event(
                         Event({
                            func = function()
                                (context.blueprint_card or card):juice_up(0.8, 0.8)
                                G.consumeables.cards[card_to_destroy]:start_dissolve({G.C.RED}, nil, 1.6)
                                return true
                            end})
                        )
                    end
                else
                    if context.cardarea == G.jokers and context.joker_main and not context.before and not context.after then
                        SMODS.eval_this(
                            card,
                            {
                                chip_mod = card.ability.extra.chips,
                                message = localize(
                                    {type = "variable", key = "a_chips", vars = {number_format(card.ability.extra.chips)}}
                                )
                            }
                        )
                        SMODS.eval_this(
                            card,
                            {
                                mult_mod = card.ability.extra.mult,
                                message = localize(
                                    {type = "variable", key = "a_mult", vars = {number_format(card.ability.extra.mult)}}
                                )
                            }
                        )
                        hand_chips = mod_chips(to_big(hand_chips) * card.ability.extra.x_chips)
						update_hand_text({delay = 0}, {chips = hand_chips})
						card_eval_status_text(card, 'jokers', nil, percent, nil, {message = localize{type='variable',key='a_xchips',vars={card.ability.extra.x_chips}}, Xchips_mod = card.ability.extra.x_chips})
                        SMODS.eval_this(
                            card,
                            {
                                Xmult_mod = card.ability.extra.Xmult,
                                message = localize(
                                    {type = "variable", key = "a_xmult", vars = {number_format(card.ability.extra.Xmult)}}
                                )
                            }
                        )	

                        mult = mod_mult(to_big(mult) ^ card.ability.extra.Emult)
						update_hand_text({delay = 0}, {mult = mult})
						card_eval_status_text(card, 'jokers', nil, percent, nil, {message = localize{type='variable',key='a_powmult',vars={card.ability.extra.Emult}}, powmult_mod = card.ability.extra.Emult})
                        hand_chips = mod_chips(to_big(hand_chips) ^ card.ability.extra.Echips)
						update_hand_text({delay = 0}, {chips = hand_chips})
						card_eval_status_text(card, 'jokers', nil, percent, nil, {message = localize{type='variable',key='a_powchips',vars={card.ability.extra.Echips}}, Echips_mod = card.ability.extra.Echips})
						mult = mod_mult(to_big(mult):arrow(2,card.ability.extra.EEmult))
						update_hand_text({delay = 0}, {mult = mult})
						card_eval_status_text(card, 'jokers', nil, percent, nil, {message = '^^' .. card.ability.extra.EEmult .. ' Mult',})
                        return {}
                    end
                    if context.cardarea == G.jokers and not context.before and not context.after then
                        ease_dollars(card.ability.extra.money)
                        return {
                            message = "+" .. number_format(card.ability.extra.money) .. " Dollars",
                            colour = G.C.MONEYD
                        }
                    end
                end
            end,
            loc_vars = function(self, info_queue, center)
                return {
                    vars = {
                    center.ability.extra.chips, center.ability.extra.chips_mod,
                    center.ability.extra.mult, center.ability.extra.mult_mod,
                    center.ability.extra.x_chips, center.ability.extra.x_chips_mod,
                        center.ability.extra.Xmult, center.ability.extra.Xmult_mod,
                        center.ability.extra.money, center.ability.extra.money_mod,
                        center.ability.extra.Echips, center.ability.extra.Echips_mod,
                        center.ability.extra.Emult, center.ability.extra.Emult_mod, 
                            center.ability.extra.EEmult, center.ability.extra.EEmult_mod,
                    }}
                end,
            }
    end
end

-- Joker Bucket

SMODS.Joker {
    key = "bucket",
    loc_txt = {
        name = "Bucket",
        text = {"Carry over {C:attention}5%{} of total ",
                "overscored {C:blue}chips{} to next {C:attention}blind{}",
                "{C:inactive}Ex: blind is 300 chips and you score 400{}",
                "{C:inactive}the overscored chips is 100 and 5% of that is 5{}",
                "{C:inactive}so you start the next blind with 5 chips{}",
                "{C:inactive}Can I haz bukket{}"
				}
			},
    config = {extra ={chips_gain = 0  }},
    rarity = 3,
    pos = { x = 0, y = 0 },
    atlas = 'crafted_jokers',
    cost = 5,
    blueprint_compat = true,
	in_pool = function(self)
		return false
	end,
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.chips_gain} }
	end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) then
            card.ability.extra.chips_gain = ( to_big(G.GAME.chips) - to_big(G.GAME.blind.chips) ) * 0.05
            return
        elseif context.setting_blind then
            G.GAME.chips = to_big(G.GAME.chips) + card.ability.extra.chips_gain
            card.ability.extra.chips_gain = 0
            G.E_MANAGER:add_event(Event({
                        func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Pour", colour = G.C.DARK_EDITION}); return true
                        end}))
				if to_big(G.GAME.chips) > to_big(G.GAME.chips) then
					stop_use()
					G.STATE = G.STATES.NEW_ROUND
					end_round()
				end
            return
        end
	end
}

-- Joker Oak Tree

SMODS.Joker {
	
	name = "mc_oak_tree",
	key = "oak_tree",
	loc_txt = {
        name = "Oak Tree",
        text = {"at end of Round give {C:attention}#1#{} logs",
				"Destroy after {C:attention}#2#{} Rounds",
            },
    },
	pos = { x = 1, y = 1 },
	config = { extra = { logs = 1, life = 5, } },
	rarity = 2,
	cost = 6,
	atlas = "jokeratlas",
	loc_vars = function(self, info_queue, center)
		return { vars = { center.ability.extra.logs, center.ability.extra.life } }
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
			add_craft_resource("logs",card.ability.extra.logs ,card,true)
			card.ability.extra.life = card.ability.extra.life - 1
			if card.ability.extra.life > 0 then
				return {
					message = { "-1 Round" },
					colour = G.C.FILTER,
				}
            elseif card.ability.extra.life < 1 then -- Could just be an else but eh
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
			end
		end
	end
}

-- Diamond Pickaxe

SMODS.Joker {
    key = "dia_pickaxe",
    loc_txt = {
        name = "Diamond Pickaxe",
        text = {
		"Destroy {C:attention}Stone cards{} in {C:attention}played hand{} ",
		"to gain {C:attention}#1#{} random {C:attention}resource{} and {C:attention}#3# Cobblestone{}",
                "Destroy {C:attention}Deepslate cards{} in {C:attention}played hand{} ",
                "to gain {C:attention}#2#{} random {C:attention}resources{}", 
		"{C:dark_edition,s:0.7}art by : lolxDdj{}",
        }
    },
    config = {extra = {amount1 = 1, amount2 = 2, amount = 1 }},
    rarity = 3,
    pos = { x = 1, y = 0 },
    atlas = 'crafted_jokers',
    cost = 5,
    blueprint_compat = true,
	in_pool = function(self)
		return false
	end,
	calculate = function(self, card, context)
		if context.destroying_card and context.destroying_card.ability.name == 'Stone Card'and not context.blueprint then 
			local givable_resource ={
			"coal",
			"copper",
			"iron",
			"gold",
			"lapis",
			}
			local give_resource = pseudorandom_element(givable_resource)
			add_craft_resource(give_resource,card.ability.extra.amount1,card,true)
			add_craft_resource("cobblestone",card.ability.extra.amount3,card,true)
			return true
		elseif context.destroying_card and context.destroying_card.ability.name == 'Deepslate Card'and not context.blueprint then 
			local givable_resource2 ={
			"redstone",
			"diamond",
			"emerald",
			"netherite",
			"quartz",
			}
			local give_resource2= pseudorandom_element(givable_resource2)
			local give_resource3= pseudorandom_element(givable_resource2)
			add_craft_resource(give_resource2,card.ability.extra.amount2/2,card,true)
			add_craft_resource(give_resource3,card.ability.extra.amount2/2,card,true)
			return true
		end			
	end	
}

-- Creeper Timer Func


local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
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
	return G_UIDEF_use_and_sell_buttons_ref(card)
end

--Code from Betmma's Vouchers

G.FUNCS.can_reserve_card = function(e)
	if #G.consumeables.cards < G.consumeables.config.card_limit then
		e.config.colour = G.C.GREEN
		e.config.button = "reserve_card"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

G.FUNCS.reserve_card = function(e)
	local c1 = e.config.ref_table
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.1,
		func = function()
			c1.area:remove_card(c1)
			c1:add_to_deck()
			if c1.children.price then
				c1.children.price:remove()
			end
			c1.children.price = nil
			if c1.children.buy_button then
				c1.children.buy_button:remove()
			end
			c1.children.buy_button = nil
			remove_nils(c1.children)
			G.consumeables:emplace(c1)
			G.GAME.pack_choices = G.GAME.pack_choices - 1
			if G.GAME.pack_choices <= 0 then
				G.FUNCS.end_consumeable(nil, delay_fac)
			end
			return true
		end,
	}))
end

local upd = Game.update
function Game:update(dt)
	upd(self, dt)
	if Incantation and not McIncanCompat then
		AllowBulkUse("Resource")
		McIncanCompat = true
	end
    if G.GAME and G.GAME.round_resets and G.GAME.blind and G.GAME.blind.name == "The Creeper" and G.GAME.blind.config and (G.GAME.blind.config.creepertiming ~= nil) and not G.GAME.blind.disabled then
        if Talisman then
            if to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
                G.GAME.blind.config.creepertiming = G.GAME.blind.config.creepertiming and math.max(0, (G.GAME.blind.config.creepertiming) - dt) or nil
                G.GAME.blind:set_text()
            end
        else
            if (G.GAME.chips) < (G.GAME.blind.chips) then
                G.GAME.blind.config.creepertiming = G.GAME.blind.config.creepertiming and math.max(0, (G.GAME.blind.config.creepertiming) - dt) or nil
                G.GAME.blind:set_text()
            end
        end
		if Talisman then
			if G.GAME.blind.config.creepertiming <= 0 and G.STATE == G.STATES.SELECTING_HAND and not to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
				end_round{}
			end
		else
			if G.GAME.blind.config.creepertiming <= 0 and G.STATE == G.STATES.SELECTING_HAND and not G.GAME.chips < G.GAME.blind.chips then
				end_round{}
			end
		end
    end
end
