/datum/crafting_recipe/food/skorn
	name = "Skorn"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 2,
		/datum/reagent/blood = 5,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/skorn
	added_foodtypes = GORE
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/vareth_blood_pie
	name = "Vareth blood pie"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 2,
		/obj/item/food/doughslice = 2,
		/datum/reagent/blood = 10,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2,
	)
	result = /obj/item/food/vareth_blood_pie
	removed_foodtypes = RAW
	added_foodtypes = GORE
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_PIE

/datum/crafting_recipe/food/heart_of_draeth
	name = "Heart of draeth"
	reqs = list(
		/obj/item/organ/heart = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/blackpepper = 2,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/heart_of_draeth
	added_foodtypes = MEAT|GORE
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/kethiv_claw
	name = "Kethiv claw"
	reqs = list(
		/obj/item/food/meat/cutlet = 1,
		/datum/reagent/consumable/nutriment/fat/oil = 5,
		/datum/reagent/consumable/salt = 1,
	)
	result = /obj/item/food/kethiv_claw
	added_foodtypes = FRIED
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/zurn
	name = "Zurn"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/zurn
	removed_foodtypes = RAW
	added_foodtypes = GORE
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT
	meal_category = MEAL_APPETIZER

/datum/crafting_recipe/food/threll_lung
	name = "Threll lung stirfry"
	reqs = list(
		/obj/item/organ/lungs = 1,
		/obj/item/food/grown/chili = 1,
		/obj/item/food/onion_slice = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	blacklist = list(
		/obj/item/organ/lungs/cybernetic,
	)
	result = /obj/item/food/threll_lung
	added_foodtypes = MEAT|GORE
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/vosk_leg
	name = "Roasted vosk leg"
	reqs = list(
		/obj/item/food/meat/slab = 1,
		/obj/item/food/grown/garlic = 1,
		/datum/reagent/consumable/salt = 2,
		/datum/reagent/consumable/blackpepper = 2,
	)
	result = /obj/item/food/vosk_leg
	removed_foodtypes = RAW
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_MEAT

/datum/crafting_recipe/food/kaltho_pastry
	name = "Kaltho pastry"
	reqs = list(
		/obj/item/food/doughslice = 1,
		/obj/item/food/meat/rawcutlet = 1,
		/datum/reagent/consumable/salt = 1,
		/datum/reagent/consumable/blackpepper = 1,
	)
	result = /obj/item/food/kaltho_pastry
	removed_foodtypes = RAW
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_PASTRY
	meal_category = MEAL_SNACK

/datum/crafting_recipe/food/zeth_sauce
	name = "Zeth berry sauce"
	reqs = list(
		/obj/item/food/grown/berries = 1,
		/obj/item/food/grown/chili = 1,
		/datum/reagent/consumable/salt = 2,
	)
	result = /obj/item/food/zeth_sauce
	cuisine_category = CUISINE_XATHI
	meal_category = MEAL_COMPONENT

/datum/crafting_recipe/food/zurn_noodles
	name = "Zurn noodle bowl"
	reqs = list(
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/obj/item/food/zurn = 1,
		/obj/item/food/zeth_sauce = 1,
		/obj/item/reagent_containers/cup/bowl = 1,
	)
	result = /obj/item/food/spaghetti/zurn_noodles
	cuisine_category = CUISINE_XATHI
	dish_category = DISH_NOODLES
