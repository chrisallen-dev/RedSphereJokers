--- STEAMODDED HEADER
--- MOD_NAME: Red Sphere Jokers
--- MOD_ID: redspherejokers
--- MOD_AUTHOR: [Chris Allen]
--- MOD_DESCRIPTION: Testing out mod development
--- BADGE_COLOR: FF0000
--- PREFIX: red

----------------------------------------------
------------MOD CODE -------------------------

-- just chcking the commits are working thourhg Visual Studio Code

local config = {
    red_moon_landing = true,
}

SMODS.Atlas({
    key = "RedSphereAtlas",
    path = "RedSphereAtlas.png",
    px = 71,
    py = 95
})

local function init_joker(joker, no_sprite)
    no_sprite = no_sprite or false
    joker.atlas = "RedSphereAtlas"
    local joker = SMODS.Joker(joker)
end

-- Moon Landing
if config.red_moon_landing then
    local moonlanding = {
        key = "moonlanding",
        loc_txt = {
            name = "Moon Landing",
            text = {
                "\"It's one small step for man\"",
                "Neil Armstrong, 1969",
                "{C:chips}+1969{} Chips"}
        },
        config = {
            extra = {
                chips = 1969,
            },
        },
        rarity = 3,
        cost = 8,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        pos = { x = 0, y = 0 }
    }

    function moonlanding.loc_vars(self, info, card)
        return { vars = { card.ability.extra.chips} }
    end

    moonlanding.calculate = function(self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = "localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}"
            }
        end
    end

    init_joker(moonlanding)
end






SMODS.Voucher{
    key = "jameswebb",
    loc_txt = {
        name = 'James Webb',
        text = {
			"{C:planet}Planet{} cards in your",
            "{C:attention}consumable{} area give",
            "{C:mult}x5{} Mult for their",
            "Specified {C:attention}poker hand{}"
		}
    },
    requires = {'v_observatory'},
    unlocked = true,
    discovered = true,
    pos = {x = 1, y = 0},
    config = {extra = 5},
    atlas = 'RedSphereAtlas'

}



    local Card_calculate_joker_ref=Card.calculate_joker
    function Card:calculate_joker(context)
        
        if self.ability.set == "Planet" and not self.debuff then
            if context.joker_main then
                if G.GAME.used_vouchers.v_red_jameswebb and self.ability.consumeable.hand_type == context.scoring_name then
                    return {
                        message = localize{type = 'variable', key = 'a_xmult', vars = {G.P_CENTERS.v_red_jameswebb.config.extra}},
                        Xmult_mod = G.P_CENTERS.v_red_jameswebb.config.extra
                    }
                end
            end
        end
        return Card_calculate_joker_ref(self,context)
    end







    


   
    




----------------------------------------------
------------MOD CODE END----------------------