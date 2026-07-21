//Klingon Foods, straight from Qo'noS - gloriously bloody and aggressively seasoned
//Heghlu'meH QaQ jajvam! (Today is a good day to die — but first, let's eat!)

//Meat Dishes

/obj/item/food/gagh
	name = "gagh"
	desc = "A bowl of live serpent worms, served fresh and wriggling. The most iconic of all Klingon dishes. Qapla'!"
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "gagh"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("serpent worms" = 1, "earth" = 1, "blood" = 1)
	foodtypes = MEAT | RAW | GORE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 2)
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/gagh/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/gagh_chopped, 2, 3 SECONDS, table_required = TRUE, screentip_verb = "Chop")

/obj/item/food/gagh_chopped
	name = "chopped gagh"
	desc = "Finely chopped serpent worms. No longer wriggling, but still a delicacy."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "gagh_chopped"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("serpent worms" = 1, "blood" = 1)
	foodtypes = MEAT | RAW | GORE
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/rokeg_blood_pie
	name = "rokeg blood pie"
	desc = "A savory Klingon blood pie, filled with seasoned meat and blood in a thick pastry crust. Not for the faint of heart."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "rokeg_blood_pie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/blood = 5,
	)
	tastes = list("meat" = 1, "pastry" = 1, "iron" = 1, "blood" = 1)
	foodtypes = MEAT | GRAIN | GORE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT * 2)
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/rokeg_blood_pie/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/rokeg_blood_pie_slice, 4, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/rokeg_blood_pie_slice
	name = "rokeg blood pie slice"
	desc = "A slice of Klingon blood pie. The blood runs clear — no, wait, it runs red. Very red."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "rokeg_blood_pie_slice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 2,
		/datum/reagent/consumable/nutriment/protein = 2,
		/datum/reagent/consumable/nutriment/vitamin = 1,
		/datum/reagent/blood = 1,
	)
	tastes = list("meat" = 1, "pastry" = 1, "iron" = 1, "blood" = 1)
	foodtypes = MEAT | GRAIN | GORE
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT / 2)
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/heart_of_targ
	name = "heart of targ"
	desc = "The grilled heart of a targ, a fierce Klingon beast. Heavily spiced and seared to perfection. A true warrior's meal."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "heart_of_targ"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/capsaicin = 3,
		/datum/reagent/consumable/blackpepper = 1,
	)
	tastes = list("gamey meat" = 1, "fire" = 1, "spice" = 1, "courage" = 1)
	foodtypes = MEAT | VEGETABLES | GORE
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pipius_claw
	name = "pipius claw"
	desc = "A deep-fried claw of the pipius, a Klingon bird-like creature. The outer shell is crunchy while the inside is tender and juicy."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "pipius_claw"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/nutriment/fat/oil = 2,
	)
	tastes = list("fried meat" = 1, "crunch" = 1, "wild game" = 1)
	foodtypes = MEAT | FRIED
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/racht
	name = "racht"
	desc = "Klingon roasted grubs, heavily seasoned with traditional Qo'noS spices. Crunchy on the outside, juicy on the inside."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "racht"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 5,
		/datum/reagent/consumable/nutriment/vitamin = 3,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("roasted grubs" = 1, "smoke" = 1, "spice" = 1)
	foodtypes = MEAT | GORE
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_1

/obj/item/food/bregit_lung
	name = "bregit lung stirfry"
	desc = "A traditional Klingon dish made from bregit lung, sliced thin and stirfried with hot peppers and spices. Chewy and intense."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "bregit_lung"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/capsaicin = 4,
	)
	tastes = list("gamey offal" = 1, "fire" = 1, "chewy meat" = 1)
	foodtypes = MEAT | GORE | VEGETABLES
	trash_type = /obj/item/reagent_containers/cup/bowl
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/krada_leg
	name = "roasted krada leg"
	desc = "The roasted leg of a krada, a reptilian creature from Qo'noS. Slow cooked with traditional Klingon herbs until falling off the bone."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "krada_leg"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
		/datum/reagent/consumable/salt = 2,
	)
	tastes = list("roasted meat" = 1, "herbs" = 1, "smoke" = 1)
	foodtypes = MEAT | VEGETABLES
	w_class = WEIGHT_CLASS_NORMAL
	crafting_complexity = FOOD_COMPLEXITY_3
	custom_materials = list(/datum/material/meat = MEATSLAB_MATERIAL_AMOUNT)

/obj/item/food/zilm_kach
	name = "zilm'kach"
	desc = "Klingon warrior pastries, filled with spiced meat and baked until golden. The perfect snack before battle — or after."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "zilm_kach"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 4,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("spiced meat" = 1, "flaky pastry" = 1, "warmth" = 1)
	foodtypes = MEAT | GRAIN
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_3

//Condiments

/obj/item/food/grapok_sauce
	name = "grapok sauce"
	desc = "A thick, pungent Klingon sauce made from fermented grapok berries. Pairs well with gagh and roasted meats."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "grapok_sauce"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 2,
		/datum/reagent/consumable/capsaicin = 1,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("fermented berries" = 1, "fire" = 1, "umami" = 1)
	foodtypes = FRUIT | VEGETABLES
	w_class = WEIGHT_CLASS_TINY
	crafting_complexity = FOOD_COMPLEXITY_1

//Beverages (food-adjacent)

/obj/item/food/spaghetti/racht_noodles
	name = "racht noodle bowl"
	desc = "Klingon-style noodles topped with roasted racht grubs and grapok sauce. A popular dish in the mess halls of the Klingon Defense Force."
	icon = 'icons/obj/food/klingon.dmi'
	icon_state = "racht_noodles"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/protein = 6,
		/datum/reagent/consumable/nutriment/vitamin = 4,
		/datum/reagent/consumable/capsaicin = 2,
	)
	tastes = list("noodles" = 1, "roasted grubs" = 1, "spice" = 1, "umami" = 1)
	foodtypes = MEAT | GRAIN | GORE | FRUIT | VEGETABLES
	w_class = WEIGHT_CLASS_SMALL
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_3
