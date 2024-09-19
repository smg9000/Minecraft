--- STEAMODDED HEADER
--- MOD_NAME: Minecraft
--- MOD_ID: Minecraft
--- PREFIX: mc
--- MOD_AUTHOR: [SMG9000, ]
--- MOD_DESCRIPTION: a mod that adds minecraft to balatro in a way that you would not expect
--- DEPENDENCIES: [Cryptid, Talisman]
--- VERSION: 0.0.1

----------------------------------------------
------------MOD CODE -------------------------




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
--Jokers--
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    

