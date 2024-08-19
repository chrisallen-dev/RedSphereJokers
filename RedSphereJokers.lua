--- STEAMODDED HEADER
--- MOD_NAME: Red Sphere Jokers
--- MOD_ID: redspherejokers
--- MOD_AUTHOR: [Chris Allen]
--- MOD_DESCRIPTION: Testing out mod development
--- BADGE_COLOR: 8cb243
--- PREFIX: red
--- VERSION: 0.1.1c

----------------------------------------------
------------MOD CODE -------------------------

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
    key = "hubble",
    loc_txt = {
        name = 'Hubble',
        text = {
			"{C:planet}Planet{} cards in your",
            "{C:attention}consumable{} area give",
            "{C:mult}x3{} Mult for their",
            "Specified {C:attention}poker hand{}"
		}
    },
    requires = {'v_observatory'},
    unlocked = true,
    discovered = true,
    pos = {x = 1, y = 0},
    config = {extra = 3},
    atlas = 'RedSphereAtlas'

}


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
    requires = {'v_red_hubble'},
    unlocked = true,
    discovered = true,
    pos = {x = 2, y = 0},
    config = {extra = 5},
    atlas = 'RedSphereAtlas'

}



local Card_calculate_joker_ref=Card.calculate_joker
function Card:calculate_joker(context)
    
    if self.ability.set == "Planet" and not self.debuff then
        if context.joker_main then
            -- important to order the latest in the sequence first else it will only use  hubbles xmult value
            if G.GAME.used_vouchers.v_red_jameswebb and self.ability.consumeable.hand_type == context.scoring_name then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {G.P_CENTERS.v_red_jameswebb.config.extra}},
                    Xmult_mod = G.P_CENTERS.v_red_jameswebb.config.extra
                }
            end
            if G.GAME.used_vouchers.v_red_hubble and self.ability.consumeable.hand_type == context.scoring_name then
                return {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {G.P_CENTERS.v_red_hubble.config.extra}},
                    Xmult_mod = G.P_CENTERS.v_red_hubble.config.extra
                }
            end
            
        end
    end
    return Card_calculate_joker_ref(self,context)
end



SMODS.PokerHand {
    key = 'Countdown',
    name = 'CountDown',
    chips = 80,
    mult = 7,
    l_chips = 35,
    l_mult = 3,
    example = {
        { 'S_5', true },
        { 'H_4', true },
        { 'C_3', true },
        { 'D_2', true },
        { 'S_A', true },
    },
    loc_txt = {
        name = "Countdown",
        description = {
            "All systems go! we're ready for launch",
            "5, 4, 3, 2 and Ace",
            "of any suit"
        }
    },
    evaluate = function(parts, hand)
        if next(parts._straight) then
            local _strush = SMODS.merge_lists(parts._straight)
            local countdown = true
            for j = 1, #_strush do
                local rank = SMODS.Ranks[_strush[j].base.value]
                countdown = countdown and (rank.key == '5' or rank.key == '4' or rank.key == '3' or rank.key== '2' or rank.key == 'Ace')
            end
            if countdown then return {_strush} end
        end
    end
}



SMODS.Consumable {
    set = "Planet",
    key = "Moon",
    pos = {x=3,y=0},
    config = {hand_type = 'red_Countdown'},
    loc_txt = {
        name = "Moon",
        text = {
            "Level up",
            "{C:attention}Countdown",
            "{C:mult}+3{} Mult and",
            "{C:chips}+35{} chips"
        }
    },
    cost = 3,    
    unlocked = true,
    discovered = true,
    atlas = "RedSphereAtlas",
    can_use = true,
    can_use = function(self, card)
        return true
    end
}


   
    




----------------------------------------------
------------MOD CODE END----------------------