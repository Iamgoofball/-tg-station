/obj/item/storage/tgmc_pouch
	name = "generic pouch"
	desc = "If you can see this, something is wrong."
	icon = 'icons/obj/storage/pouches.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS | ITEM_SLOT_SUITSTORE

/obj/item/storage/tgmc_pouch/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/storage/tgmc_pouch/update_icon_state()
	var/suffix = ""
	if(!contents.len)
		suffix = "_e"
	else
		suffix = "_[contents.len]"
	icon_state = "[initial(icon_state)][suffix]"
	return ..()

/datum/storage/ammo_pouch
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_total_storage = 9
	max_slots = 3

/datum/storage/ammo_pouch/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_box/magazine,
	))

/obj/item/storage/tgmc_pouch/ammo
	name = "magazine pouch"
	desc = "This pouch can contain three ammo magazines."
	icon_state = "large_ammo_mag"
	storage_type = /datum/storage/ammo_pouch

/datum/storage/ammo_pouch/pistol
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = 6
	max_slots = 3

/obj/item/storage/tgmc_pouch/ammo_pistol
	name = "pistol magazine pouch"
	desc = "It can contain pistol and revolver ammo magazines."
	icon_state = "pistol_mag"
	storage_type = /datum/storage/ammo_pouch/pistol

/datum/storage/ammo_pouch/explosive_pouch
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = 6
	max_slots = 3

/datum/storage/ammo_pouch/explosive_pouch/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/grenade,
	))

/obj/item/storage/tgmc_pouch/explosive_pouch
	name = "explosive pouch"
	desc = "It can contain grenades, plastiques, mine boxes, and other explosives."
	icon_state = "large_explosive"
	storage_type = /datum/storage/ammo_pouch/explosive_pouch

/datum/storage/ammo_pouch/explosive_pouch/grenade
	max_total_storage = 12
	max_slots = 6

/obj/item/storage/tgmc_pouch/grenade_pouch
	name = "grenade pouch"
	desc = "It can contain grenades."
	icon_state = "grenade"
	storage_type = /datum/storage/ammo_pouch/explosive_pouch/grenade

/datum/storage/ammo_pouch/medipen_pouch
	max_specific_storage = WEIGHT_CLASS_SMALL
	max_total_storage = 10
	max_slots = 5

/datum/storage/ammo_pouch/medipen_pouch/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/hypospray/medipen,
	))

/obj/item/storage/tgmc_pouch/medipen_pouch
	name = "medical injector pouch"
	desc = "A specialized medical pouch that can only hold auto-injectors."
	icon_state = "firstaid_injector"
	storage_type = /datum/storage/ammo_pouch/medipen_pouch

// prefabs

/obj/item/storage/tgmc_pouch/explosive_pouch/prefilled/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/grenade/c4/x4(src)

/obj/item/storage/tgmc_pouch/medipen_pouch/prefilled/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/ekit(src)
	new /obj/item/reagent_containers/hypospray/medipen/ekit(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/reagent_containers/hypospray/medipen/stimulants(src)
	new /obj/item/reagent_containers/hypospray/medipen/atropine(src)

/obj/item/storage/tgmc_pouch/grenade_pouch/prefilled/PopulateContents()
	for(var/i in 1 to 2)
		new /obj/item/grenade/m40(src)
	new /obj/item/grenade/m40/lasburster(src)
	new /obj/item/grenade/m40/smoke(src)
	new /obj/item/grenade/m40/cloaking(src)
	new /obj/item/grenade/m40/phosphorus(src)

/obj/item/storage/tgmc_pouch/ammo/smartgun/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/ammo_box/magazine/smartmachinegun(src)

/obj/item/storage/tgmc_pouch/ammo/ar21/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/ammo_box/magazine/ar21(src)

/obj/item/storage/tgmc_pouch/ammo_pistol/filled/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/ammo_box/magazine/p23(src)

/obj/item/storage/shell_box
	name = "generic shell box"
	desc = "If you can see this, something is wrong."
	icon = 'icons/obj/storage/pouches.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS | ITEM_SLOT_SUITSTORE

/obj/item/storage/shell_box/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/storage/shell_box/update_icon_state()
	var/suffix = ""
	if(!contents.len)
		suffix = "_e"
	else
		suffix = ""
	icon_state = "[initial(icon_state)][suffix]"
	return ..()

/datum/storage/shell_box
	max_specific_storage = WEIGHT_CLASS_TINY
	max_total_storage = 14
	max_slots = 14
	numerical_stacking = TRUE

/datum/storage/shell_box/New(atom/parent, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/ammo_casing/shotgun,
	))

/obj/item/storage/shell_box/buckshot
	name = "buckshot shell box"
	desc = "A box of buckshot shells for the SH-35. Holds 14 shells."
	icon_state = "buckshot"
	storage_type = /datum/storage/shell_box

/obj/item/storage/shell_box/buckshot/prefilled/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/ammo_casing/shotgun/tgmc(src)
