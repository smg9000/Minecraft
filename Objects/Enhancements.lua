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
