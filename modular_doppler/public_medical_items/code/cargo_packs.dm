/datum/supply_pack/medical/civil_defense
	name = "Civil Defense Medical Kit Crate"
	crate_name = "civil defense medical kit crate"
	desc = "Contains ten civil defense medical kits, small packs of injectors meant to be passed out to the public in case of emergency."
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 10 // 2000
	contains = list(
		/obj/item/storage/medkit/civil_defense/stocked = 10,
	)

/datum/supply_pack/medical/frontier_first_aid
	name = "Frontier First Aid Crate"
	crate_name = "frontier first aid crate"
	desc = "Contains two of each of frontier medical kits, and combat surgeon medical kits."
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/storage/medkit/frontier/stocked = 3,
		/obj/item/storage/medkit/combat_surgeon/stocked = 3,
	)

/datum/supply_pack/medical/kit_medical
	name = "Heavy Duty Medical Kit Crate"
	crate_name = "medical kit crate"
	desc = "Contains two heavy-duty medical kits for emergencies."
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 11
	contains = list(
		/obj/item/storage/backpack/duffelbag/deforest_medkit/stocked,
		/obj/item/storage/backpack/duffelbag/deforest_surgical/stocked,
	)

/datum/supply_pack/medical/eac_first_aid_vendor_refill
	name = "EaC First Aid Station Resupply Crate"
	crate_name = "\improper EaC First Aid Station resupply crate"
	desc = "Contains a restocking canister for EaC first aid stations."
	access = ACCESS_MEDICAL
	cost = CARGO_CRATE_VALUE * 3
	contains = list(
		/obj/item/vending_refill/medical_everywhere,
	)
