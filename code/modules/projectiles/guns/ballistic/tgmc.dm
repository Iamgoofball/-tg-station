/obj/item/gun/ballistic/automatic/smartmachinegun
	name = "\improper SG-29 Raummetall-KT smart machine gun"
	desc = "The Raummetall-KT SG-29 is the TGMC's current standard medium machine gun. It's known for its ability to lay down heavy \
	fire support very well. It is generally used when someone wants to hold a position or provide fire support. Requires special training and \
	uses 10x26mm ammunition."
	icon = 'icons/obj/weapons/guns/tgmc_64.dmi'
	SET_BASE_VISUAL_PIXEL(-32, 0)
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
