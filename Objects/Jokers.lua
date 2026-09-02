--This file contains the jokers this mod adds.

--Bundle
SMODS.Joker {
    name = "mc_bundle",
    key = "bundle",
    loc_txt = {
        name = "Bundle",
        text = { "gains 2 consumable slots",
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

--Steve
if (SMODS.Mods.Cryptid or {}).can_load then                                                      -- checks if Cryptid is enabled
    local cry_config = SMODS.load_mod_config({ id = "Cryptid", path = SMODS.Mods.Cryptid.path }) -- loads Cryptid configs

    if cry_config["Exotic Jokers"] then                                                          -- check if exotic jokers are enabled
        SMODS.Joker {
            key = "steve",
            loc_txt = {
                name = "Steve",
                text = { "Destroy a random Minecraft card at end of shop",
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
            config = { extra = { chips = 15, chips_mod = 15, mult = 15, mult_mod = 15, x_chips = 1, x_chips_mod = 1, Xmult = 1, Xmult_mod = 1, money = 5, money_mod = 5, Echips = 1, Echips_mod = 0.5, Emult = 1, Emult_mod = 0.5, EEmult = 1, EEmult_mod = 0.5, } },
            rarity = "cry_exotic",
            pos = { x = 0, y = 0 },
            soul_pos = { x = 1, y = 0, extra = { x = 2, y = 0 } },
            atlas = 'jokeratlas',
            cost = 50,
            blueprint_compat = true,
            calculate = function(self, card, context)
                --TODO: make it so it reselects if not one of the consumbales it can eat.
                if context.ending_shop and (not context.blueprint) then
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
                        local card_key = G.consumeables.cards[card_to_destroy].config.center.key:sub(3, -1)
                        --Scaling
                        G.consumeables.cards[card_to_destroy].getting_sliced = true
                        if card_key == "mc_dirt" then
                            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+" .. number_format(to_big(card.ability.extra.chips_mod)) .. " Chips" })
                        elseif card_key == "mc_coal" then
                            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+" .. number_format(to_big(card.ability.extra.mult_mod)) .. " Mult" })
                        elseif card_key == "mc_copper" then
                            card.ability.extra.x_chips = card.ability.extra.x_chips +
                                card.ability.extra.x_chips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+" .. number_format(card.ability.extra.x_chips) .. " Chips" })
                        elseif card_key == "mc_iron" then
                            card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+ X" .. number_format(card.ability.extra.Xmult) .. " Mult" })
                        elseif card_key == "mc_gold" then
                            card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+" .. number_format(card.ability.extra.money) .. " Dollars" })
                        elseif card_key == "mc_diamond" then
                            card.ability.extra.Emult = card.ability.extra.Emult + card.ability.extra.Emult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+^" .. number_format(card.ability.extra.Emult) .. "Mult" })
                        elseif card_key == "mc_emerald" then
                            card.ability.extra.Echips = card.ability.extra.Echips + card.ability.extra.Echips_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+^" .. number_format(card.ability.extra.Echips) .. " Chips" })
                        elseif card_key == "mc_netherite" then
                            card.ability.extra.EEmult = card.ability.extra.EEmult + card.ability.extra.EEmult_mod * quota
                            card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil,
                                { message = "+^^" .. number_format(card.ability.extra.EEmult) .. "Mult" })

                            -- else if card_key == "mc_lapis" then
                            -- else if card_key == "mc_redstone" then
                            -- else if card_key == "mc_quartz" then
                        else -- Not recongized
                            G.consumeables.cards[card_to_destroy].getting_sliced = false
                            return {}
                        end
                        -- Destroy the consumable
                        G.E_MANAGER:add_event(
                            Event({
                                func = function()
                                    (context.blueprint_card or card):juice_up(0.8, 0.8)
                                    G.consumeables.cards[card_to_destroy]:start_dissolve({ G.C.RED }, nil, 1.6)
                                    return true
                                end
                            })
                        )
                    end
                else
                    if context.cardarea == G.jokers and context.joker_main and not context.before and not context.after then
                        SMODS.eval_this(
                            card,
                            {
                                chip_mod = card.ability.extra.chips,
                                message = localize(
                                    { type = "variable", key = "a_chips", vars = { number_format(card.ability.extra.chips) } }
                                )
                            }
                        )
                        SMODS.eval_this(
                            card,
                            {
                                mult_mod = card.ability.extra.mult,
                                message = localize(
                                    { type = "variable", key = "a_mult", vars = { number_format(card.ability.extra.mult) } }
                                )
                            }
                        )
                        hand_chips = mod_chips(to_big(hand_chips) * card.ability.extra.x_chips)
                        update_hand_text({ delay = 0 }, { chips = hand_chips })
                        card_eval_status_text(card, 'jokers', nil, percent, nil,
                            {
                                message = localize { type = 'variable', key = 'a_xchips', vars = { card.ability.extra.x_chips } },
                                Xchips_mod =
                                    card.ability.extra.x_chips
                            })
                        SMODS.eval_this(
                            card,
                            {
                                Xmult_mod = card.ability.extra.Xmult,
                                message = localize(
                                    { type = "variable", key = "a_xmult", vars = { number_format(card.ability.extra.Xmult) } }
                                )
                            }
                        )

                        mult = mod_mult(to_big(mult) ^ card.ability.extra.Emult)
                        update_hand_text({ delay = 0 }, { mult = mult })
                        card_eval_status_text(card, 'jokers', nil, percent, nil,
                            {
                                message = localize { type = 'variable', key = 'a_powmult', vars = { card.ability.extra.Emult } },
                                powmult_mod =
                                    card.ability.extra.Emult
                            })
                        hand_chips = mod_chips(to_big(hand_chips) ^ card.ability.extra.Echips)
                        update_hand_text({ delay = 0 }, { chips = hand_chips })
                        card_eval_status_text(card, 'jokers', nil, percent, nil,
                            {
                                message = localize { type = 'variable', key = 'a_powchips', vars = { card.ability.extra.Echips } },
                                Echips_mod =
                                    card.ability.extra.Echips
                            })
                        mult = mod_mult(to_big(mult):arrow(2, card.ability.extra.EEmult))
                        update_hand_text({ delay = 0 }, { mult = mult })
                        card_eval_status_text(card, 'jokers', nil, percent, nil,
                            { message = '^^' .. card.ability.extra.EEmult .. ' Mult', })
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
                    }
                }
            end,
        }
    end
end

--Bucket
SMODS.Joker {
    key = "bucket",
    loc_txt = {
        name = "Bucket",
        text = { "Carry over {C:attention}5%{} of total ",
            "overscored {C:blue}chips{} to next {C:attention}blind{}",
            "{C:inactive}Ex: blind is 300 chips and you score 400{}",
            "{C:inactive}the overscored chips is 100 and 5% of that is 5{}",
            "{C:inactive}so you start the next blind with 5 chips{}",
            "{C:inactive}Can I haz bukket{}"
        }
    },
    config = { extra = { chips_gain = 0 } },
    rarity = 3,
    pos = { x = 0, y = 0 },
    atlas = 'crafted_jokers',
    cost = 5,
    blueprint_compat = true,
    in_pool = function(self)
        return false
    end,
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.chips_gain } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not (context.individual or context.repetition) then
            card.ability.extra.chips_gain = (to_big(G.GAME.chips) - to_big(G.GAME.blind.chips)) * 0.05
            return
        elseif context.setting_blind then
            G.GAME.chips = to_big(G.GAME.chips) + card.ability.extra.chips_gain
            card.ability.extra.chips_gain = 0
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Pour", colour = G.C.DARK_EDITION }); return true
                end
            }))
            if to_big(G.GAME.chips) > to_big(G.GAME.chips) then
                stop_use()
                G.STATE = G.STATES.NEW_ROUND
                end_round()
            end
            return
        end
    end
}

--Diamond Pickaxe
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
    config = { extra = { amount1 = 1, amount2 = 2, amount = 1 } },
    rarity = 3,
    pos = { x = 1, y = 0 },
    atlas = 'crafted_jokers',
    cost = 5,
    blueprint_compat = true,
    in_pool = function(self)
        return false
    end,
    calculate = function(self, card, context)
        if context.destroying_card and context.destroying_card.ability.name == 'Stone Card' and not context.blueprint then
            local givable_resource = {
                "coal",
                "copper",
                "iron",
                "gold",
                "lapis",
            }
            local give_resource = pseudorandom_element(givable_resource)
            add_craft_resource(give_resource, card.ability.extra.amount1, card, true)
            add_craft_resource("cobblestone", card.ability.extra.amount3, card, true)
            return true
        elseif context.destroying_card and context.destroying_card.ability.name == 'Deepslate Card' and not context.blueprint then
            local givable_resource2 = {
                "redstone",
                "diamond",
                "emerald",
                "netherite",
                "quartz",
            }
            local give_resource2 = pseudorandom_element(givable_resource2)
            local give_resource3 = pseudorandom_element(givable_resource2)
            add_craft_resource(give_resource2, card.ability.extra.amount2 / 2, card, true)
            add_craft_resource(give_resource3, card.ability.extra.amount2 / 2, card, true)
            return true
        end
    end,
    loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.extra.amount1, center.ability.extra.amount2, center.ability.extra.amount } }
    end
}

--Gold Block
SMODS.Joker {
    name = "mc_gold_block",
    key = "gold_block",
    loc_txt = {
        name = "Gold Block",
        text = {
            "gold cards give more money equal to 1 + the square root of how much gold resource you have rounded up",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 2,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.individual and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, "m_gold") then
                return {
                    dollars = 1 + (math.ceil(math.sqrt(G.GAME.craftr.gold)))
                }
            end
        end
    end,
    in_pool = function(self)
        return false
    end,
}

--Orb of Dominance
SMODS.Joker {
    name = "mc_orb_dom",
    key = "orb_dom",
    loc_txt = {
        name = "Orb of Dominance",
        text = {
            "placeholder",
        },
    },
    pos = { x = 3, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
}

--Scraped--

--[[

SMODS.Joker {
    name = "mc_orb_dom_j",
    key = "orb_dom_j",
    loc_txt = {
        name = "Orb of Dominance Fragment (Jungle Awakens)",
        text = {
            "placeholder",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return false
    end,
}

SMODS.Joker {
    name = "mc_orb_dom_w",
    key = "orb_dom_w",
    loc_txt = {
        name = "Orb of Dominance Fragment (Windswept Hills)",
        text = {
            "placeholder",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return false
    end,
}

SMODS.Joker {
    name = "mc_orb_dom_c",
    key = "orb_dom_c",
    loc_txt = {
        name = "Orb of Dominance Fragment (Creeping Winter)",
        text = {
            "placeholder",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return false
    end,
}

SMODS.Joker {
    name = "mc_orb_dom_h",
    key = "orb_dom_h",
    loc_txt = {
        name = "Orb of Dominance Fragment (Hidden Depths)",
        text = {
            "placeholder",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return false
    end,
}
SMODS.Joker {
    name = "mc_orb_dom_e",
    key = "orb_dom_e",
    loc_txt = {
        name = "Orb of Dominance Fragment (Echoing Void)",
        text = {
            "placeholder",
        },
    },
    pos = { x = 2, y = 0 },
    config = { extra = {} },
    rarity = 4,
    cost = 6,
    atlas = "crafted_jokers",
    loc_vars = function(self, info_queue, center)
        return { vars = {} }
    end,
    calculate = function(self, card, context)
    end,
    in_pool = function(self)
        return false
    end,
}

--Oak Tree
SMODS.Joker {

    name = "mc_oak_tree",
    key = "oak_tree",
    loc_txt = {
        name = "Oak Tree",
        text = { "at end of Round give {C:attention}#1#{} logs",
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
            add_craft_resource("logs", card.ability.extra.logs, card, true)
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

--]]
