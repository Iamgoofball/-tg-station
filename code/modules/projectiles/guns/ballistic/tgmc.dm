/obj/item/gun/ballistic/automatic/smartmachinegun
	name = "\improper SG-29 Raummetall-KT smart machine gun"
	desc = "The Raummetall-KT SG-29 is the TGMC's current standard medium machine gun. It's known for its ability to lay down heavy \
	fire support very well. It is generally used when someone wants to hold a position or provide fire support. Requires special training and \
	uses 10x26mm ammunition."
	icon = 'icons/obj/weapons/guns/tgmc_64.dmi'
	//SET_BASE_VISUAL_PIXEL(-32, 0) UNCOMMENT ONCE FUCKING INVENTORY IS FIXED
	icon_state = "sg29"
	inhand_icon_state = "sg29"
	worn_icon_state = "sg29"
	burst_size = 1
	actions_types = list()
	mag_display = TRUE
	empty_indicator = FALSE
	w_class = WEIGHT_CLASS_BULKY // cannot go in backpacks, its a massive machine gun
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/smartmachinegun
	pin = /obj/item/firing_pin
	show_bolt_icon = FALSE
	muzzle_type = /obj/effect/temp_visual/muzzle/bullet
	fire_sound = SFX_SMARTGUN_FIRING
	dry_fire_sound = 'sound/items/weapons/gun/tgmc/smartgun_empty.ogg'
	load_sound = 'sound/items/weapons/gun/tgmc/smartgun_reload.ogg'
	load_empty_sound = 'sound/items/weapons/gun/tgmc/smartgun_reload.ogg'
	eject_sound = 'sound/items/weapons/gun/tgmc/smartgun_unload.ogg'
	eject_empty_sound = 'sound/items/weapons/gun/tgmc/smartgun_unload.ogg'
	recoil = 4
	spread = 13
	wielded_icon = "sg29-wielded"
	wielded_recoil = 0.5
	unwielded_recoil = 4
	wielded_spread = 0
	unwielded_spread = 13
	wieldable = TRUE

/obj/item/gun/ballistic/automatic/smartmachinegun/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.2 SECONDS)

/obj/item/gun/ballistic/p23
	name = "\improper P-23 service pistol"
	desc = "A standard P-23 chambered in .45 ACP. Has a smaller magazine capacity, but packs a better punch. Has an irremovable laser sight. \
	Uses .45 magazines."
	icon = 'icons/obj/weapons/guns/tgmc.dmi'
	icon_state = "tp23"
	inhand_icon_state = "tp23"
	w_class = WEIGHT_CLASS_SMALL
	mag_display = FALSE
	empty_indicator = FALSE
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT
	accepted_magazine_type = /obj/item/ammo_box/magazine/p23
	pin = /obj/item/firing_pin
	show_bolt_icon = TRUE
	bolt_type = BOLT_TYPE_LOCKING
	muzzle_type = /obj/effect/temp_visual/muzzle/bullet
	fire_sound = 'sound/items/weapons/gun/tgmc/p23_fire.ogg'
	load_sound = 'sound/items/weapons/gun/tgmc/p23_reload.ogg'
	load_empty_sound = 'sound/items/weapons/gun/tgmc/p23_reload.ogg'
	eject_sound = 'sound/items/weapons/gun/tgmc/p23_unload.ogg'
	eject_empty_sound = 'sound/items/weapons/gun/tgmc/p23_unload.ogg'
	rack_sound = 'sound/items/weapons/gun/tgmc/p23_cocked.ogg'
	bolt_drop_sound = 'sound/items/weapons/gun/tgmc/p23_cocked.ogg'
	lock_back_sound = 'sound/items/weapons/gun/tgmc/p23_cocked.ogg'
	fire_delay = 0.2 SECONDS
	recoil = 0
	spread = 4
	wielded_icon = "tp23-wielded"
	wielded_recoil = 0
	unwielded_recoil = 0
	wielded_spread = 0
	unwielded_spread = 4
	wieldable = TRUE

/obj/item/gun/ballistic/shotgun/sh35
	name = "\improper SH-35 pump shotgun"
	desc = "The Terran Armories SH-35 is the shotgun used by the TerraGov Marine Corps. It's used as a close quarters tool when someone wants \
	something more suited for close range than most people, or as an odd sidearm on your back for emergencies. Uses 12 gauge shells."
	icon = 'icons/obj/weapons/guns/tgmc_64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	//SET_BASE_VISUAL_PIXEL(-32, 0) UNCOMMENT ONCE FUCKING INVENTORY IS FIXED
	icon_state = "sh35"
	inhand_icon_state = "sh35"
	worn_icon_state = "sh35"
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	mag_display = FALSE
	empty_indicator = FALSE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/sh35
	pin = /obj/item/firing_pin
	show_bolt_icon = FALSE
	muzzle_type = /obj/effect/temp_visual/muzzle/bullet
	fire_sound = 'sound/items/weapons/gun/tgmc/sh35_fire.ogg'
	load_sound = 'sound/items/weapons/gun/tgmc/sh35_reload.ogg'
	rack_sound = 'sound/items/weapons/gun/tgmc/sh35_pump.ogg'
	dry_fire_sound = 'sound/items/weapons/gun/tgmc/sh35_empty.ogg'
	recoil = 4
	spread = 10
	wielded_icon = "sh35-wielded"
	wielded_recoil = 2
	unwielded_recoil = 4
	wielded_spread = 4
	unwielded_spread = 10
	wieldable = TRUE
	rack_on_dryfire_if_not_semi_auto = TRUE

/obj/item/gun/ballistic/automatic/ar21
	name = "\improper AR-21 Kauser skirmish rifle"
	desc = "The Kauser AR-21 is a versatile rifle is developed to bridge a gap between higher caliber weaponry and a normal rifle. \
	It fires a strong 10x25mm round, which has decent stopping power. It however suffers in magazine size and movement capablity compared \
	to smaller peers."
	icon = 'icons/obj/weapons/guns/tgmc_64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	icon_state = "ar21"
	inhand_icon_state = "ar21"
	worn_icon_state = "ar21"
	inhand_x_dimension = 64
	inhand_y_dimension = 32
	burst_size = 1
	actions_types = list()
	mag_display = TRUE
	empty_indicator = TRUE
	w_class = WEIGHT_CLASS_BULKY // It's a rifle
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK
	accepted_magazine_type = /obj/item/ammo_box/magazine/ar21
	pin = /obj/item/firing_pin
	show_bolt_icon = FALSE
	muzzle_type = /obj/effect/temp_visual/muzzle/bullet
	fire_sound = 'sound/items/weapons/gun/tgmc/ar21_fire.ogg'
	dry_fire_sound = 'sound/items/weapons/gun/tgmc/ar21_empty.ogg'
	load_sound = 'sound/items/weapons/gun/tgmc/ar21_reload.ogg'
	load_empty_sound = 'sound/items/weapons/gun/tgmc/ar21_reload.ogg'
	eject_sound = 'sound/items/weapons/gun/tgmc/ar21_unload.ogg'
	eject_empty_sound = 'sound/items/weapons/gun/tgmc/ar21_unload.ogg'
	recoil = 4
	spread = 13
	wielded_icon = "ar21_wielded"
	wielded_recoil = 0.5
	unwielded_recoil = 4
	wielded_spread = 0
	unwielded_spread = 13
	wieldable = TRUE

/obj/item/gun/ballistic/automatic/ar21/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.25 SECONDS)
