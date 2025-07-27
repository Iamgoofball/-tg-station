/obj/projectile/bullet/tgmc
	name = "tgmc bullet"
	icon_state = "tgmc_bullet"
	speed = 3
	accurate_range = 5
	maximum_range = 20

/obj/projectile/bullet/tgmc/smartmachinegun
	name = "10x25mm bullet"
	damage = 20
	armour_penetration = 15
	accurate_range = 12

/obj/projectile/bullet/tgmc/dot45acp
	name = ".45 ACP bullet"
	embed_type = /datum/embedding/bullet/dot45acp
	damage = 30
	armour_penetration = 5
	accurate_range = 5

/datum/embedding/bullet/dot45acp
	embed_chance = 25

/obj/projectile/bullet/tgmc/buckshot
	name = "buckshot"
	icon_state = "tgmc_buckshot"
	maximum_range = 10
	damage = 40
	damage_falloff_tile = 4
