--This file contains the weapons used in the mob arena.

--Weapon Inventory(?)
SMODS.Weapons = {}

SMODS.Weapon = SMODS.Center:extend {
    obj_table = SMODS.Weapons,
    obj_buffer = {},
    set = 'Weapon',
    required_params = {
        'key',
        "damage",
        "cooldown",
    },

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

--Fist (Default Weapon)
SMODS.Weapon {
    order = 1,
    key = 'mc_fist',
    unlocked = true,
    discovered = true,
    atlas = 'mc_weapons',
    cost = 8,
    name = "Fist",
    damage = 1,
    cooldown = 0.25,
    pos = { x = 0, y = 0 },
    set = "Weapon",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = { self.damage, self.cooldown } }
    end,
}

--Wood Sword
SMODS.Weapon {
    order = 2,
    key = 'mc_wooden_sword',
    unlocked = true,
    discovered = true,
    atlas = 'mc_weapons',
    cost = 8,
    name = "Wooden Sword",
    damage = 4,
    cooldown = 0.625,
    pos = { x = 1, y = 0 },
    set = "Weapon",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = { self.damage, self.cooldown } }
    end,
}
