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
