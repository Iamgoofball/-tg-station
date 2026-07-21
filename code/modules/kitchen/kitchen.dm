// Update the kitchen code to include the new Klingon recipes
#include "defines/kitchen_defines.dm"

proc/kitchen_init()
    // Add Klingon recipes to the kitchen
    kitchen_recipes += recipe/klingon_bloodwine
    kitchen_recipes += recipe/klingon_gagh
    kitchen_recipes += recipe/klingon_ghurt
    kitchen_recipes += recipe/klingon_grat
    kitchen_recipes += recipe/klingon_qapla