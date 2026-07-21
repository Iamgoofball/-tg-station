// Add new Klingon recipes to the kitchen subsystem
#include "defines/recipe_defines.dm"

recipe/klingon_bloodwine
    name = "Klingon Bloodwine"
    desc = "A strong and bitter beverage made from fermented blood."
    icon_state = "klingon_bloodwine"
    result = item/klingon_bloodwine
    reqs = list()
    reqs += (recipe_ingredient("blood", 1))
    reqs += (recipe_ingredient("water", 1))
    reqs += (recipe_ingredient("yeast", 1))
    reqs += (recipe_ingredient("sugar", 1))
    reqs += (recipe_ingredient("spices", 1))
    time = 10

recipe/klingon_gagh
    name = "Klingon Gagh"
    desc = "A traditional Klingon dish made from raw meat and spices."
    icon_state = "klingon_gagh"
    result = item/klingon_gagh
    reqs = list()
    reqs += (recipe_ingredient("meat", 1))
    reqs += (recipe_ingredient("spices", 1))
    time = 5

recipe/klingon_ghurt
    name = "Klingon Ghurt"
    desc = "A sweet and sour dish made from fermented fruit."
    icon_state = "klingon_ghurt"
    result = item/klingon_ghurt
    reqs = list()
    reqs += (recipe_ingredient("fruit", 1))
    reqs += (recipe_ingredient("yeast", 1))
    reqs += (recipe_ingredient("sugar", 1))
    time = 8

recipe/klingon_grat
    name = "Klingon Grat"
    desc = "A hearty stew made from meat and vegetables."
    icon_state = "klingon_grat"
    result = item/klingon_grat
    reqs = list()
    reqs += (recipe_ingredient("meat", 1))
    reqs += (recipe_ingredient("vegetables", 1))
    reqs += (recipe_ingredient("spices", 1))
    time = 12

recipe/klingon_qapla
    name = "Klingon Qapla'"
    desc = "A traditional Klingon dish made from raw meat and spices."
    icon_state = "klingon_qapla"
    result = item/klingon_qapla
    reqs = list()
    reqs += (recipe_ingredient("meat", 1))
    reqs += (recipe_ingredient("spices", 1))
    time = 5