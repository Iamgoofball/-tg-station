GLOBAL_LIST_INIT(allowed_skinnables, typecacheof(/obj/item/gun, /obj/item/melee, /obj/item/twohanded, /obj/mecha))

/obj/item/skin_pack
	name = "Skin Pack"
	var/datum/item_skin/contained_skin
	var/skin_type = /datum/item_skin/camo
	var/uses = 1

/obj/item/skin_pack/Initialize()
	..()
	var/skin_to_make = pick(subtypesof(skin_type))
	contained_skin = new skin_to_make
	name = "[initial(name)] ([contained_skin.name])"
	var/icon/new_icon = new('icons/obj/camo.dmi', "skin_display")
	icon = contained_skin.apply_skin(new_icon)


/obj/item/skin_pack/afterattack(atom/O, mob/user, proximity)
	. = ..()
	if(!proximity)
		return