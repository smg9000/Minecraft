SMODS.MC_Resources = {}
    SMODS.MC_Resources = SMODS.Center:extend {
        obj_table = SMODS.MC_Resources,
        obj_buffer = {},
        set = 'MC_Resources',
        required_params = {
            'key',
        },
        inject = function(self)
            G.P_MC_RESOURCES[self.key] = {}
			table.insert(G.P_CENTER_POOLS.MC_Resources, self)
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
                full_UI_table.name = self.set == 'Enhanced' and 'temp_value' or localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = res.name_vars or target.vars or {} }
            elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name and self.set ~= 'Enhanced' then
                desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
            end
            if specific_vars and specific_vars.debuffed and not res.replace_debuff then
                target = { type = 'other', key = 'debuffed_' ..
                (specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes, AUT = full_UI_table, }
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
SMODS.MC_Resources {
        order = 1,
		key = 'mc_iron',
		unlocked = true,
        sprite_args = {frame_durations = {[1] = 10} },
		discovered = true,
		atlas = 'mc_resources',
		cost = 8,
		name = "Iron Ingots",
        set = 'MC_Resources',
		pos = {x=0,y=0},
		config = {},
        loc_vars = function(self, info_queue, card)
		    return { vars = {} }
        end
    }
SMODS.MC_Resources {
        order = 2,
		key = 'mc_logs',
		unlocked = true,
		discovered = true,
		atlas = 'mc_resources',
		cost = 8,
		name = "Oak Logs",
        set = 'MC_Resources',
		pos = {x=0,y=1},
		config = {},
        loc_vars = function(self, info_queue, card)
		    return { vars = {} }
        end
    }
SMODS.MC_Resources {
        order = 1,
		key = 'mc_planks',
		unlocked = true,
		discovered = true,
		atlas = 'mc_resources',
		cost = 8,
		name = "Oak Planks",
        set = 'MC_Resources',
		pos = {x=0,y=2},
		config = {},
        loc_vars = function(self, info_queue, card)
		    return { vars = {} }
        end
    }
SMODS.MC_Resources {
        order = 1,
		key = 'mc_sticks',
		unlocked = true,
		discovered = true,
		atlas = 'mc_resources',
		cost = 8,
		name = "Sticks",
        set = 'MC_Resources',
		pos = {x=0,y=3},
		config = {},
        loc_vars = function(self, info_queue, card)
		    return { vars = {} }
        end
    }
