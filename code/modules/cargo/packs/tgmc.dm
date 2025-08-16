/datum/supply_pack/tgmc
	group = "TGMC Imports"
	access = ACCESS_SECURITY
	crate_type = /obj/structure/closet/crate/secure/syndicrate_fake
	special = TRUE
	special_enabled = FALSE

/datum/supply_pack/tgmc/ar21
	name = "AR-21 Skirmish Rifle"
	desc = "An AR-21 Skirmish Rifle; we give these to our boys in the field and they're damn good at shooting bugs."
	contains = list(
		/obj/item/gun/ballistic/automatic/ar21,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/ar21_mags
	name = "AR-21 Skirmish Rifle Magazines"
	desc = "A three-pack of AR-21 magazines. Comes with a magazine pouch included!"
	contains = list(
		/obj/item/storage/tgmc_pouch/ammo/ar21,
	)
	cost = CARGO_CRATE_VALUE*2

/datum/supply_pack/tgmc/smartgun
	name = "SG-29 Raummetall-KT Smart Machine Gun"
	desc = "The pride and joy of our smartgunners, the SG-29 Raummetall-KT smart machine gun. Two hundred and fifty rounds of pure, bug-melting goodness."
	contains = list(
		/obj/item/gun/ballistic/automatic/smartmachinegun,
	)
	cost = CARGO_CRATE_VALUE*10

/datum/supply_pack/tgmc/smartgun_mags
	name = "SG-29 Smartgun Magazines"
	desc = "A three-pack of SG-29 box magazines. Comes with a magazine pouch included!"
	contains = list(
		/obj/item/storage/tgmc_pouch/ammo/smartgun,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/sh35
	name = "SH-35 Pump Shotgun"
	desc = "The SH-35 pump shotgun. Our men like to keep them handy, for close encounters."
	contains = list(
		/obj/item/gun/ballistic/shotgun/sh35,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/buckshot_boxes
	name = "12-Gauge Buckshot Boxes"
	desc = "Three boxes of marine-grade 12-gauge buckshot. These'll fit in anything you've got chambered in 12 gauge."
	contains = list(
		/obj/item/storage/shell_box/buckshot/prefilled = 3,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/buckshot_boxes
	name = "12-Gauge Buckshot Boxes"
	desc = "Three boxes of marine-grade 12-gauge buckshot. These'll fit in anything you've got chambered in 12 gauge."
	contains = list(
		/obj/item/storage/shell_box/buckshot/prefilled = 3,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/p23
	name = "P-23 Service Pistol"
	desc = "A P-23 service pistol; the trusted sidearm of the marine forces. Might not be the flashiest, but it packs a punch."
	contains = list(
		/obj/item/gun/ballistic/p23,
	)
	cost = CARGO_CRATE_VALUE*2

/datum/supply_pack/tgmc/p23_mags
	name = "P-23 Service Pistol Magazines"
	desc = "A three-pack of P-23 magazines. Comes with a magazine pouch included!"
	contains = list(
		/obj/item/storage/tgmc_pouch/ammo_pistol/filled,
	)
	cost = CARGO_CRATE_VALUE*1

/datum/supply_pack/tgmc/injector_pouch
	name = "Medical Injector Pouch (Filled)"
	desc = "A filled pouch of five medical injectors. The boys call it \"the juice\"."
	contains = list(
		/obj/item/storage/tgmc_pouch/medipen_pouch/prefilled,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/injector_pouch
	name = "Medical Injector Pouch (Empty)"
	desc = "An empty medical injector pouch."
	contains = list(
		/obj/item/storage/tgmc_pouch/medipen_pouch,
	)
	cost = CARGO_CRATE_VALUE*1

/datum/supply_pack/tgmc/explosive_pouch
	name = "Explosive X-4 Pouch"
	desc = "A filled pouch of three bricks of X-4. Perfect for tactical entrances."
	contains = list(
		/obj/item/storage/tgmc_pouch/explosive_pouch/prefilled,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/grenade_pouch
	name = "Grenade Pouch (Filled)"
	desc = "A filled grenade pouch with the standard assortment of grenades."
	contains = list(
		/obj/item/storage/tgmc_pouch/grenade_pouch/prefilled,
	)
	cost = CARGO_CRATE_VALUE*4

/datum/supply_pack/tgmc/m40
	name = "M40 HEDP Grenade (5-Pack)"
	desc = "Five of our finest M40 HEDP grenades, at a discount price!"
	contains = list(
		/obj/item/grenade/m40 = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/incendiary
	name = "M40 HIDP Grenade (5-Pack)"
	desc = "Five of our finest M40 HIDP grenades, perfect for lighting the bugs on fire!"
	contains = list(
		/obj/item/grenade/m40/incendiary = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/phosphorus
	name = "M40 HPDP Grenade (5-Pack)"
	desc = "Five of our finest M40 HPDP grenades, outlawed in the Spinward as a war-crime, and requires a permit to own in TerraGov."
	contains = list(
		/obj/item/grenade/m40/phosphorus = 5,
	)
	cost = CARGO_CRATE_VALUE*10

/datum/supply_pack/tgmc/smoke
	name = "M40 HSDP Grenade (5-Pack)"
	desc = "Five of our finest M40 HSDP grenades, great for quick getaways and providing cover for movements."
	contains = list(
		/obj/item/grenade/m40/smoke = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/cloaking
	name = "M40-2 SCDP Grenade (5-Pack)"
	desc = "Five of our finest M40-2 SCDP grenades, improved with nanobots to provide a cloaking effect while in the smoke."
	contains = list(
		/obj/item/grenade/m40/cloaking = 5,
	)
	cost = CARGO_CRATE_VALUE*10

/datum/supply_pack/tgmc/m15
	name = "M15 Frag Grenade (5-Pack)"
	desc = "Our old surplus M15 Frag grenades, tried and true despite their age."
	contains = list(
		/obj/item/grenade/m40/m15 = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/hefa
	name = "M25 HEFA Grenade (5-Pack)"
	desc = "Five of our finest M25 HEFA grenades, shooting out buckshot shrapnel."
	contains = list(
		/obj/item/grenade/m40/hefa = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/lasburster
	name = "M80 Lasburster Grenade (5-Pack)"
	desc = "Five of our finest M80 Lasburster grenades, delivers a burst of laser beams around it when it explodes."
	contains = list(
		/obj/item/grenade/m40/lasburster = 5,
	)
	cost = CARGO_CRATE_VALUE*5

/datum/supply_pack/tgmc/emp
	name = "EMP Grenade (5-Pack)"
	desc = "Five of our finest EMP grenades, great for shorting out any kind of mechanical menace."
	contains = list(
		/obj/item/grenade/m40/emp = 5,
	)
	cost = CARGO_CRATE_VALUE*5
