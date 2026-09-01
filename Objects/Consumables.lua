
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
			"{C:inactive,E:1,s:0.8}I've Got a jar o' Dirrrt.{}"
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
    key = "mc_mob",
    steveEat = true,
    pos = {x=1,y=0},
    loc_txt = {
        name = 'Overworld Mob Arena',
        text = {
			"Starts an Overworld mob arena",
        },
    },
    cost = 4,
    atlas = "resource",
	rarity = "Common",
	use = function(self, card, area, copier)
        for k, v in pairs(G.GAME.mob_arena_values) do 
            if k == "mob_area" then
                G.GAME.mob_arena_values[k] = "overworld"
            end
        end
        G.FUNCS.mob_fight()


        
		return add_craft_resource("coal",card.ability.extra.amount,card,true)
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


local upd = Game.update
function Game:update(dt)
	upd(self, dt)
	if Incantation and not McIncanCompat then
		AllowBulkUse("Resource")
		McIncanCompat = true
	end
end
