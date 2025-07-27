/obj/item/ammo_casing/smartmachinegun
	name = "10x26mm caseless bullet"
	desc = "A 10x26mm caseless bullet."
	icon_state = "762-casing"
	caliber = CALIBER_10X26_CASELESS
	projectile_type = /obj/projectile/bullet/tgmc/smartmachinegun

/obj/item/ammo_casing/smartmachinegun/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/caseless)

/obj/item/ammo_casing/p23
	name = ".45 ACP bullet"
	desc = "A .45 ACP bullet."
	caliber = CALIBER_45
	projectile_type = /obj/projectile/bullet/tgmc/dot45acp

/obj/item/ammo_casing/shotgun/tgmc
	name = "TGMC 12 gauge buckshot shell"
	desc = "A TGMC-issue 12 gauge buckshot shell."
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/projectile/bullet/tgmc/buckshot
	pellets = 6
	variance = 30
	randomspread = FALSE
