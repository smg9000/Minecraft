--- STEAMODDED HEADER
--- MOD_NAME: Minecraft
--- MOD_ID: Minecraft
--- PREFIX: mc
--- MOD_AUTHOR: [SMG9000, Mathguy ]
--- MOD_DESCRIPTION: a mod that adds minecraft to balatro in a way that you would not expect
--- DEPENDENCIES: [Talisman]
--- VERSION: 0.0.2b

----------------------------------------------
------------MOD CODE -------------------------


function SMODS.SAVE_UNLOCKS()
    boot_print_stage("Saving Unlocks")
	G:save_progress()
    -------------------------------------
    local TESTHELPER_unlocks = false and not _RELEASE_MODE
    -------------------------------------
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '') then
        love.filesystem.createDirectory(G.SETTINGS.profile ..
            '')
    end
    if not love.filesystem.getInfo(G.SETTINGS.profile .. '/' .. 'meta.jkr') then
        love.filesystem.append(
            G.SETTINGS.profile .. '/' .. 'meta.jkr', 'return {}')
    end

    convert_save_to_meta()

    local meta = STR_UNPACK(get_compressed(G.SETTINGS.profile .. '/' .. 'meta.jkr') or 'return {}')
    meta.unlocked = meta.unlocked or {}
    meta.discovered = meta.discovered or {}
    meta.alerted = meta.alerted or {}

    G.P_LOCKED = {}
    for k, v in pairs(G.P_CENTERS) do
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.unlocked = true; v.discovered = true; v.alerted = true
            end --REMOVE THIS
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.unlocked and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^v_')) then
                G.P_LOCKED[#G.P_LOCKED + 1] = v
            end
            if not v.discovered and (string.find(k, '^j_') or string.find(k, '^b_') or string.find(k, '^e_') or string.find(k, '^c_') or string.find(k, '^p_') or string.find(k, '^v_')) and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] or v.set == 'Back' or v.start_alerted then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end

	table.sort(G.P_LOCKED, function (a, b) return a.order and b.order and a.order < b.order end)

	for k, v in pairs(G.P_BLINDS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
	for k, v in pairs(G.P_TAGS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then v.discovered = true; v.alerted = true  end --REMOVE THIS
            if not v.discovered and meta.discovered[k] then 
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then 
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
	for k, v in pairs(G.P_CRAFTS) do
        v.key = k
        if not v.wip and not v.demo then 
            if TESTHELPER_unlocks then
                v.unlocked = true; v.discovered = true; v.alerted = true
            end --REMOVE THIS
            if not v.unlocked and meta.unlocked[k] then
                v.unlocked = true
            end
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered then
                v.alerted = false
            end
        end
    end
    for k, v in pairs(G.P_SEALS) do
        v.key = k
        if not v.wip and not v.demo then
            if TESTHELPER_unlocks then
                v.discovered = true; v.alerted = true
            end                                                                   --REMOVE THIS
            if not v.discovered and meta.discovered[k] then
                v.discovered = true
            end
            if v.discovered and meta.alerted[k] then
                v.alerted = true
            elseif v.discovered then
                v.alerted = false
            end
        end
    end
    for _, t in ipairs{
        G.P_CENTERS,
        G.P_BLINDS,
        G.P_TAGS,
        G.P_SEALS,
        G.P_CRAFTS,
    } do
        for k, v in pairs(t) do
            v._discovered_unlocked_overwritten = true
        end
    end
end





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



function craft_joker(card)
    local obj = card.config.center
    local key = obj.key
    
   G.GAME.craft_dirt = G.GAME.craft_dirt - obj.dirt_req
   G.GAME.craft_coal = G.GAME.craft_coal - obj.coal_req
   G.GAME.craft_iron = G.GAME.craft_iron - obj.iron_req
   G.GAME.craft_gold = G.GAME.craft_gold - obj.gold_req
   G.GAME.craft_copper = G.GAME.craft_copper - obj.copper_req
   G.GAME.craft_diamond = G.GAME.craft_diamond - obj.diamond_req
   G.GAME.craft_emerald = G.GAME.craft_emerald - obj.emerald_req
   G.GAME.craft_netherite = G.GAME.craft_netherite - obj.netherite_req
    if key == "mc_bucket" then
        local bucket = SMODS.create_card{key = "j_mc_bucket" }
		G.jokers:emplace(bucket)
		card:add_to_deck()
    end
end

G.FUNCS.can_craft = function(e)
    if e.config.ref_table and e.config.ref_table.config and e.config.ref_table.config.center and e.config.ref_table.config.center.key  and
	((not e.config.ref_table.config.center.dirt_req or (G.GAME.craft_dirt < e.config.ref_table.config.center.dirt_req)))  and
	((not e.config.ref_table.config.center.coal_req or (G.GAME.craft_coal < e.config.ref_table.config.center.coal_req)))  and
	((not e.config.ref_table.config.center.iron_req or (G.GAME.craft_iron < e.config.ref_table.config.center.iron_req))) and
	((not e.config.ref_table.config.center.gold_req or (G.GAME.craft_gold < e.config.ref_table.config.center.gold_req))) and
	((not e.config.ref_table.config.center.copper_req or (G.GAME.craft_copper < e.config.ref_table.config.center.copper_req)))and
	((not e.config.ref_table.config.center.diamond_req or (G.GAME.craft_diamond < e.config.ref_table.config.center.diamond_req))) and
	((not e.config.ref_table.config.center.emerald_req or (G.GAME.craft_emerald < e.config.ref_table.config.center.emerald_req))) and
	((not e.config.ref_table.config.center.netherite_req or (G.GAME.craft_netherite < e.config.ref_table.config.center.netherite_req))) then
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
        local tab_but = G.OVERLAY_MENU:get_UIE_by_ID("tab_but_" .. localize('b_craft'))
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

  local text = "Crafts"

    local t = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes = {
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = text, colours = {G.C.UI.TEXT_LIGHT}, bump = true, scale = 0.6})}}
        }},
        {n=G.UIT.R, config={align = "cm", minw = 2.5, padding = 0.2, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes=area_table},
            {n=G.UIT.R, config={align = "cm"}, nodes={
                create_option_cycle({options = craft_options, w = 3.5, cycle_shoulders = true, opt_callback = 'your_game_crafting_page', focus_args = {snap_to = true, nav = 'wide'},current_option = (crafts_page or 1), colour = G.C.ORANGE, no_pips = true})
        }}
      }}
    return t
end



function SMODS.current_mod.process_loc_text()
 G.localization.misc.dictionary['b_crafting'] = "Crafting"
 G.localization.misc.dictionary["b_craft"] = "CRAFT"
 G.localization.misc.dictionary["k_craft"] = "Craft"
	G.localization.descriptions.Craft = {
        mc_bucket = {
            name = "Bucket",
            text = {
                "Carry over %5 of total overscored chips ",
                "to next blind",
                "{C:inactive}Ex: blind is 300 chips and you score 400{}",
                "{C:inactive}the overscored chips is 100 and 5% of that is 5{}",
                "{C:inactive}so you start the next blind with 5 chips{}",
            }}}
end


--Consumables--
SMODS.ConsumableType({
    key = "resource",
    primary_colour = HEX("6A5700"),
    secondary_colour = HEX("02BF0E"),
    collection_rows = {4,4}, 
    loc_txt = {
        collection = "Resource Cards",
        name = "Resource",
        label = "Resource",
        undiscovered = {
            name = 'Undiscovered Resource',
            text = { 'idk stuff ig' },
        },
        },
    shop_rate = 1,
    default = ' ',
    can_stack = true,
    can_divide = true,
})

SMODS.UndiscoveredSprite {
    key = 'resource',
    atlas = 'resource',
    pos = {x = 3, y = 3},
}
    
SMODS.Consumable({
    key = "dirt",
    set = "resource",
    pos = {x=0,y=0},
	config = {},
    loc_txt = {
        name = 'Dirt',
        text = {
			"common resource."
        },
    },
    cost = 4,
    atlas = "resource",
})

SMODS.Consumable({
    key = "coal",
    set = "resource",
    pos = {x=1,y=0},
	config = {},
    loc_txt = {
        name = 'Coal',
        text = {
			"common resource."
        },
    },
    cost = 4,
    atlas = "resource",
})

SMODS.Consumable({
    key = "copper",
    set = "resource",
    pos = {x=3,y=0},
	config = {},
    loc_txt = {
        name = 'Copper',
        text = {
			"uncommon resource."
        },
    },
    cost = 8,
    atlas = "resource",
})

SMODS.Consumable({
    key = "iron",
    set = "resource",
    pos = {x=2,y=0},
	config = {},
    loc_txt = {
        name = 'Iron',
        text = {
			"uncommon resource."
        },
    },
    cost = 8,
    atlas = "resource",
})
SMODS.Consumable({
    key = "gold",
    set = "resource",
    pos = {x=3,y=0},
	config = {},
    loc_txt = {
        name = 'Gold',
        text = {
			"uncommon resource."
        },
    },
    cost = 8,
    atlas = "resource",
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
--Jokers--





if (SMODS.Mods.Cryptid or {}).can_load then -- checks if Cryptid is enabled
    local cry_config = SMODS.load_mod_config({id = "Cryptid", path = SMODS.Mods.Cryptid.path}) -- loads Cryptid configs

    if cry_config["Exotic Jokers"] then -- check if exotic jokers are enabled
        SMODS.Joker({
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
            },
    },
    config = {extra ={chips = 15, chips_mod = 15, mult = 15, mult_mod = 15, Xchips = 1, Xchips_mod = 1, Xmult = 1, Xmult_mod = 1, money = 5, money_mod = 5, Echips = 1, Echips_mod = 0.5, Emult = 1, Emult_mod = 0.5,  Tmult = 1, Tmult_mod = 0.5,  }},
    rarity = "cry_exotic",
    pos = { x = 0, y = 0 },
    atlas = 'placeholder',
    cost = 3,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.ending_shop then
            local destructable_resource = {}
	    local quota = 1
            for i = 1, #G.consumeables.cards do
                if G.consumeables.cards[i].ability.set == 'resource' and not G.consumeables.cards[i].getting_sliced and not G.consumeables.cards[i].ability.eternal then 
				destructable_resource[#destructable_resource+1] = G.consumeables.cards[i] end
            end
            local resource_to_destroy = #destructable_resource > 0 and pseudorandom_element(destructable_resource, pseudoseed('steve')) or nil
			for i = 1, #G.consumeables.cards do
            if resource_to_destroy and G.consumeables.cards[i].config.center.key == "c_mc_dirt" then
				if Incantation then
					quota = resource_to_destroy:getEvalQty()
				end
                resource_to_destroy.getting_sliced = true
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod * quota
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    resource_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
                if not (context.blueprint_card or self).getting_sliced then
                    card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = "+"..number_format(to_big(card.ability.extra.chips_mod)).." Chips"})
                end
                return nil, true
            end
            if resource_to_destroy and G.consumeables.cards[i].config.center.key == "c_mc_coal" then
				if Incantation then
					quota = resource_to_destroy:getEvalQty()
			end
                resource_to_destroy.getting_sliced = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * quota
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    resource_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
                if not (context.blueprint_card or self).getting_sliced then
                    card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = "+"..number_format(to_big(card.ability.extra.mult_mod)).." Mult"})
                end
                return nil, true
            end
			if resource_to_destroy and G.consumeables.cards[i].config.center.key == "c_mc_gold" then
				if Incantation then
					quota = resource_to_destroy:getEvalQty()
				end
                resource_to_destroy.getting_sliced = true
                card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod * quota
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    resource_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
                if not (context.blueprint_card or self).getting_sliced then
						card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = "+"..number_format(card.ability.extra.money).." Dollars"})
                end
                return nil, true
            end
			if resource_to_destroy and G.consumeables.cards[i].config.center.key == "c_mc_copper" then
				if Incantation then
					quota = resource_to_destroy:getEvalQty()
				end
                resource_to_destroy.getting_sliced = true
                card.ability.extra.Xchips = card.ability.extra.Xchips + card.ability.extra.Xchips_mod * quota
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    resource_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
                if not (context.blueprint_card or self).getting_sliced then
						card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = "+"..number_format(card.ability.extra.Xchips).." Chips"})
                end
                return nil, true
            end
			if resource_to_destroy and G.consumeables.cards[i].config.center.key == "c_mc_iron" then
				if Incantation then
					quota = resource_to_destroy:getEvalQty()
				end
                resource_to_destroy.getting_sliced = true
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * quota
                G.E_MANAGER:add_event(Event({func = function()
                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                    resource_to_destroy:start_dissolve({G.C.RED}, nil, 1.6)
                return true end }))
                if not (context.blueprint_card or self).getting_sliced then
						card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = "+"..number_format(card.ability.extra.Xmult).." Dollars"})
                end
                return nil, true
            end
        end
            end
        if context.cardarea == G.jokers and context.joker_main and not context.before and not context.after then
            SMODS.eval_this(card, {
				chip_mod = card.ability.extra.chips,
				message = localize({ type = 'variable',  key = 'a_chips', vars = {number_format(card.ability.extra.chips)} })
				})
			SMODS.eval_this(card, {
				mult_mod = card.ability.extra.mult,
				message = localize({ type = 'variable',  key = 'a_mult', vars = {number_format(card.ability.extra.mult)} })
				})
			SMODS.eval_this(card, {
				Xchip_mod = card.ability.extra.Xchips,
				message = localize({ type = 'variable',  key = 'a_xchips', vars = {number_format(card.ability.extra.Xchips)} })
				})
			SMODS.eval_this(card, {
				Xmult_mod = card.ability.extra.Xmult,
				message = localize({ type = 'variable',  key = 'a_xmult', vars = {number_format(card.ability.extra.Xmult)} })
				})
			
			return{
			
			}
        end
		if context.cardarea == G.jokers and not context.before and not context.after then
            ease_dollars(card.ability.extra.money)
			return {
                message = "+"..number_format(card.ability.extra.money).." Dollars",
                colour = G.C.MONEY
            }
        end
	end,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips, center.ability.extra.chips_mod, center.ability.extra.mult, center.ability.extra.mult_mod, center.ability.extra.Xchips, center.ability.extra.Xchips_mod, center.ability.extra.Xmult, center.ability.extra.Xmult_mod, center.ability.extra.money, center.ability.extra.money_mod, center.ability.extra.Echips, center.ability.extra.Echips_mod, center.ability.extra.Emult, center.ability.extra.Emult_mod, center.ability.extra.Tmult, center.ability.extra.Tmult_mod, }}
    end,
})
    

    end
end

SMODS.Joker({
    key = "bucket",
    loc_txt = {
        name = "bucket",
        text = {"Carry over %5 of total overscored chips ",
                "to next blind",
                "{C:inactive}Ex: blind is 300 chips and you score 400{}",
                "{C:inactive}the overscored chips is 100 and 5% of that is 5{}",
                "{C:inactive}so you start the next blind with 5 chips{}",
				}
			},
    config = {extra ={chips_gain = 0  }},
    rarity = 3,
    pos = { x = 0, y = 0 },
    atlas = 'crafted_jokers',
    cost = 5,
    blueprint_compat = true,
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
                        func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_upgrade_ex"), colour = G.C.DARK_EDITION}); return true
                        end}))
            return
        end
	end
})

