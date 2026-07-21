/datum/crafting_recipe/food/gagh
	name = "Gagh"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 2,
		/datum/reagent/blood = 5,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/gagh
	added_foodtypes = GORE
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/rokeg_blood_pie
	name = "Rokeg blood pie"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 2,
		/obj/item/food/doughslice = 2,
		/datum/reagent/blood = 10,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2,
	)
	result = /obj/item/food/rokeg_blood_pie
	removed_foodtypes = RAW
	added_foodtypes = GORE
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_PIE

/datum/crafting_recipe/food/heart_of_targ
	name = "Heart of targ"
	reqs = list(
		/obj/item/organ/heart = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/blackpepper = 2,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/heart_of_targ
	added_foodtypes = GORE
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/pipius_claw
	name = "Pipius claw"
	reqs = list(
		/obj/item/food/meat/cutlet = 1,
		/datum/reagent/consumable/nutriment/fat/oil = 5,
		/datum/reagent/consumable/salt = 1,
	)
	result = /obj/item/food/pipius_claw
	added_foodtypes = FRIED
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/racht
	name = "Racht"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/racht
	added_foodtypes = GORE
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/bregit_lung
	name = "Bregit lung stirfry"
	reqs = list(
		/obj/item/organ/lungs = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	blacklist = list(
		/obj/item/organ/lungs/cybernetic,
	)
	result = /obj/item/food/bregit_lung
	added_foodtypes = MEAT|GORE
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/krada_leg
	name = "Roasted krada leg"
	reqs = list(
		/obj/item/food/meat/slab = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2,
	)
	result = /obj/item/food/krada_leg
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/zilm_kach
	name = "Zilm'kach"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meat/rawcutlet = 1,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
	)
	result = /obj/item/food/zilm_kach
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_PASTRY
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/grapok_sauce
	name = "Grapok sauce"
	reqs = list(
		/obj/item/food/grown/berries = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/grapok_sauce
	cuisine_category = CUISINE_KLINGON
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/racht_noodles
	name = "Racht noodle bowl"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/racht = 1,
		/obj/item/food/grapok_sauce = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/spaghetti/racht_noodles
	cuisine_category = CUISINE_KLINGON
	dish_category = DISH_NOODLES
