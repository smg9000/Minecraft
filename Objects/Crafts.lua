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
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local target = {
            type = 'descriptions',
            key = self.key,
            set = self.set,
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end

        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or
                localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
            desc_nodes.name = localize { type = 'name_text', key = res.name_key or target.key, set = target.set }
        end
        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = {
                type = 'other',
                key = 'debuffed_' ..
                    (specific_vars.playing_card and 'playing_card' or 'default'),
                nodes = desc_nodes,
                AUT = full_UI_table,
            }
        end
        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end

        localize(target)
        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end
        desc_nodes.background_colour = res.background_colour
    end
}

--Bucket
SMODS.Craft {
    order = 1,
    key = 'mc_bucket',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    cost = 8,
    name = "Bucket",
    req = { iron = 3 },
    craft_type = "joker",
    pos = { x = 0, y = 0 },
    set = "Craft",
    config = {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'bucket_cost', set = 'Other' }
        return { vars = {} }
    end
}

--Diamond Pickaxe
SMODS.Craft {
    order = 1,
    key = 'mc_dia_pickaxe',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    craft_type = "joker",
    cost = 8,
    name = "Diamond Pickaxe",
    req = { diamond = 3, sticks = 2 },
    pos = { x = 1, y = 0 },
    set = "Craft",
    config = {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'dia_pickaxe_cost', set = 'Other' }
        return { vars = {} }
    end
}

--Gold Block
SMODS.Craft {
    order = 1,
    key = 'mc_gold_block',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    craft_type = "joker",
    cost = 8,
    name = "Gold Block",
    req = { gold = 9 },
    pos = { x = 2, y = 0 },
    set = "Craft",
    config = {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'gold_block_cost', set = 'Other' }
        return { vars = {} }
    end
}

--Wooden Sword
SMODS.Craft {
    order = 1,
    key = 'mc_wooden_sword_craft',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    craft_type = "weapon",
    cost = 8,
    name = "Wooden_sword",
    req = {
        sticks = 1,
        planks = 2,
    },
    pos = { x = 2, y = 0 },
    set = "Craft",
    config = {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'wooden_sword_craft_cost', set = 'Other' }
        return { vars = {} }
    end
}

--[[
--Scrapped???--

SMODS.Craft {
    order = 1,
    key = 'mc_orb_dom',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    cost = 8,
    name = "Orb of Dominance",
    craft_type = "joker",
    req = {
        jokers = {
            j_mc_orb_dom_j = 1,
            j_mc_orb_dom_w = 1,
            j_mc_orb_dom_c = 1,
            j_mc_orb_dom_h = 1,
            j_mc_orb_dom_e = 1
        }
    },
    pos = { x = 3, y = 0 },
    set = "Craft",
    config = {},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'orb_dom_cost', set = 'Other' }
        return { vars = {} }
    end
}
--]]