//Xathi Foods, straight from Xath Prime - gloriously bloody and aggressively seasoned
//Traditional fare of the Xathi Host, prepared the same way for a thousand generations.

//Meat Dishes

/obj/item/food/skorn
	name = "skorn"
	desc = "A bowl of live serpent worms, served fresh and wriggling. The most iconic of all Xathi dishes."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "skorn"
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

/obj/item/food/skorn/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/skorn_chopped, 2, 3 SECONDS, table_required = TRUE, screentip_verb = "Chop")

/obj/item/food/skorn_chopped
	name = "chopped skorn"
	desc = "Finely chopped serpent worms. No longer wriggling, but still a delicacy."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "skorn_chopped"
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 3,
		/datum/reagent/consumable/salt = 1,
	)
	tastes = list("serpent worms" = 1, "blood" = 1)
	foodtypes = MEAT | RAW | GORE
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/meat = MEATDISH_MATERIAL_AMOUNT)
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/vareth_blood_pie
	name = "vareth blood pie"
	desc = "A savory Xathi blood pie, filled with seasoned meat and blood in a thick pastry crust. Not for the faint of heart."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "vareth_blood_pie"
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

/obj/item/food/vareth_blood_pie/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/vareth_blood_pie_slice, 4, 3 SECONDS, table_required = TRUE, screentip_verb = "Slice")

/obj/item/food/vareth_blood_pie_slice
	name = "vareth blood pie slice"
	desc = "A slice of Xathi blood pie. The blood runs clear — no, wait, it runs red. Very red."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "vareth_blood_pie_slice"
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

/obj/item/food/heart_of_draeth
	name = "heart of draeth"
	desc = "The grilled heart of a draeth, a fierce beast native to Xath Prime. Heavily spiced and seared to perfection. A true warrior's meal."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "heart_of_draeth"
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

/obj/item/food/kethiv_claw
	name = "kethiv claw"
	desc = "A deep-fried claw of the kethiv, a Xathi bird-like creature. The outer shell is crunchy while the inside is tender and juicy."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "kethiv_claw"
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

/obj/item/food/zurn
	name = "zurn"
	desc = "Xathi roasted grubs, heavily seasoned with traditional Xath Prime spices. Crunchy on the outside, juicy on the inside."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "zurn"
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

/obj/item/food/threll_lung
	name = "threll lung stirfry"
	desc = "A traditional Xathi dish made from threll lung, sliced thin and stirfried with hot peppers and spices. Chewy and intense."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "threll_lung"
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

/obj/item/food/vosk_leg
	name = "roasted vosk leg"
	desc = "The roasted leg of a vosk, a reptilian creature from Xath Prime. Slow cooked with traditional Xathi herbs until falling off the bone."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "vosk_leg"
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

/obj/item/food/kaltho_pastry
	name = "kaltho pastry"
	desc = "Xathi warrior pastries, filled with spiced meat and baked until golden. The perfect snack before battle — or after."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "kaltho_pastry"
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

/obj/item/food/zeth_sauce
	name = "zeth berry sauce"
	desc = "A thick, pungent Xathi sauce made from fermented zeth berries. Pairs well with skorn and roasted meats."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "zeth_sauce"
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

/obj/item/food/spaghetti/zurn_noodles
	name = "zurn noodle bowl"
	desc = "Xathi-style noodles topped with roasted zurn grubs and zeth berry sauce. A popular dish among the Xathi Host."
	icon = 'icons/obj/food/xathi.dmi'
	icon_state = "zurn_noodles"
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
