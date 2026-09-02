--This file contains the mobs that can appear in the mob arena.

--TODO: ???
SMODS.Mobs = {}

SMODS.Mob = SMODS.Center:extend {
    obj_table = SMODS.Mobs,
    obj_buffer = {},
    set = 'Mob',
    required_params = {
        'key',
        'hp',
        'drops',
        'area',
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
    end,
    set_badges = function(self, card, badges)
        local rarity_badge_colors = {
            mc_Mob_Common = HEX("FFFFFF"),
            mc_Mob_Rare = HEX("55FFFF"),
            mc_Mob_Boss = HEX("FF55FF"),
        }
        badges[#badges + 1] = create_badge(localize('k_' .. self.rarity), rarity_badge_colors[self.rarity], G.C.BLACK,
            1.2)
    end,
}

--Mobpool Configuration
SMODS.ObjectType {
    key = "Mob_pool",
    cards = {
        ["mc_zombie"] = true,
        ["mc_skeleton"] = true,
        ["mc_creeper"] = true,
        ["mc_enderman"] = true,
        ["mc_warden"] = true,
    },
    rarities = {
        {
            key = "mc_Mob_Common",
            rate = 0.75,
        },
        {
            key = "mc_Mob_Rare",
            rate = 0.2,
        },
        {
            key = "mc_Mob_Boss",
            rate = 0.05,
        },
    },
}

--Mob Rarities--

--Common
SMODS.Rarity {
    key = "Mob_Common",
    loc_txt = {},
    default_weight = 0.75,
    badge_colour = HEX('009dff'),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

--Rare
SMODS.Rarity {
    key = "Mob_Rare",
    loc_txt = {},
    default_weight = 0.2,
    badge_colour = HEX('009dff'),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

--Boss
SMODS.Rarity {
    key = "Mob_Boss",
    loc_txt = {},
    default_weight = 0.05,
    badge_colour = HEX('009dff'),
    get_weight = function(self, weight, object_type)
        return weight
    end,
}

--Mobs--

--Zombie
SMODS.Mob {
    order = 1,
    key = 'mc_zombie',
    unlocked = true,
    discovered = true,
    atlas = 'mc_mobs',
    name = "Zombie",
    drops = {
        rotten_flesh = 1.5,
        iron = 120
    },
    rarity = "mc_Mob_Common",
    area = "overworld",
    hp = 20,
    pos = { x = 1, y = 0 },
    set = "Mob",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

--Creeper
SMODS.Mob {
    order = 1,
    key = 'mc_creeper',
    unlocked = true,
    discovered = true,
    atlas = 'mc_mobs',
    name = "Creeper",
    drops = {
        gunpowder = 1.5
    },
    rarity = "mc_Mob_Common",
    area = "overworld",
    hp = 20,
    pos = { x = 0, y = 0 },
    set = "Mob",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

--Skeleton
SMODS.Mob {
    order = 1,
    key = 'mc_skeleton',
    unlocked = true,
    discovered = true,
    atlas = 'mc_mobs',
    name = "Skeleton",
    drops = {
        bone = 1.5
    },
    rarity = "mc_Mob_Common",
    area = "overworld",
    hp = 20,
    pos = { x = 0, y = 0 },
    set = "Mob",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

--Enderman
SMODS.Mob {
    order = 2,
    key = 'mc_enderman',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    cost = 8,
    name = "Enderman",
    drops = {
        ender_pearl = 2,
    },
    rarity = "mc_Mob_Rare",
    area = "overworld",
    hp = 40,
    pos = { x = 1, y = 0 },
    set = "Mob",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

--Warden
SMODS.Mob {
    order = 2,
    key = 'mc_warden',
    unlocked = true,
    discovered = true,
    atlas = 'mc_crafted_jokers',
    cost = 8,
    name = "Warden",
    drops = {
    },
    rarity = "mc_Mob_Boss",
    area = "overworld",
    hp = 500,
    pos = { x = 1, y = 0 },
    set = "Mob",
    config = {},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
}

