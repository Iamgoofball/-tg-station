//Subtype of human - Shrimp-person
/datum/species/human/shrimp
	name = "Shrimp"
	id = SPECIES_SHRIMP
	examine_limb_id = SPECIES_HUMAN
	mutantbrain = /obj/item/organ/brain
	mutanttongue = /obj/item/organ/tongue
	mutantears = /obj/item/organ/ears
	mutanteyes = /obj/item/organ/eyes
	mutant_organs = list()
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
		TRAIT_WATER_BREATHING,      // 蝦人可以在水中呼吸
		TRAIT_CAN_STRIP,
		TRAIT_SWIMMING,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/human
	payday_modifier = 1.0
	family_heirlooms = list(/obj/item/food/shell)
	species_cookie = /obj/item/food/butter

/datum/species/human/shrimp/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons = TRUE, replace_missing = TRUE)
	. = ..()
	// 蝦人額外特性：增加游泳速度，降低陸上速度
	if(!pref_load)
		human_who_gained_species.add_movespeed_modifier(/datum/movespeed_modifier/shrimp_land)
		human_who_gained_species.add_movespeed_modifier(/datum/movespeed_modifier/shrimp_water)

/datum/species/human/shrimp/on_species_loss(mob/living/carbon/human/human_who_lost_species)
	. = ..()
	human_who_lost_species.remove_movespeed_modifier(/datum/movespeed_modifier/shrimp_land)
	human_who_lost_species.remove_movespeed_modifier(/datum/movespeed_modifier/shrimp_water)

/datum/movespeed_modifier/shrimp_land
	multiplicative_slowdown = 0.2  // 陸上稍慢

/datum/movespeed_modifier/shrimp_water
	multiplicative_slowdown = -0.2 // 水中稍快

/datum/species/human/shrimp/get_physical_attributes()
	return "Shrimp-people are crustacean-human hybrids, featuring tough exoskeletons and a natural affinity for water. \
		They are excellent swimmers and can breathe underwater, but they move a bit slower on land."

/datum/species/human/shrimp/get_species_description()
	return "Shrimp-people are a genetic modification that splices human DNA with that of deep-sea shrimp. \
		They are prized for their resilience and aquatic capabilities, often serving as deep-sea explorers and salvagers."

/datum/species/human/shrimp/get_species_lore()
	return list(
		"Shrimp-people originated from experimental deep-sea adaptation programs, designed to allow humans to work in high-pressure, underwater environments. \
			The resulting hybrids proved remarkably durable and quickly found roles in salvage, exploration, and underwater construction.",

		"Despite their usefulness, Shrimp-people often face prejudice for their appearance and perceived 'otherness'. \
			Many have formed tight-knit communities in coastal colonies and underwater habitats, where their skills are highly valued.",

		"Modern Shrimp-people possess a unique blend of traits: a tough chitinous exoskeleton, the ability to breathe water, \
			and a natural affinity for aquatic navigation. They are often employed in deep-sea mining, marine biology, and undersea salvage operations."
	)

/datum/species/human/shrimp/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "water",
			SPECIES_PERK_NAME = "Aquatic",
			SPECIES_PERK_DESC = "Shrimp-people can breathe underwater and swim faster.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield-alt",
			SPECIES_PERK_NAME = "Exoskeleton",
			SPECIES_PERK_DESC = "Shrimp-people have a tough outer shell that provides some damage resistance.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = "running",
			SPECIES_PERK_NAME = "Land Sluggishness",
			SPECIES_PERK_DESC = "Shrimp-people move slightly slower on land compared to humans.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "dry",
			SPECIES_PERK_NAME = "Dehydration",
			SPECIES_PERK_DESC = "Shrimp-people need to stay moist; they suffer damage if out of water for too long.",
		),
	)
	return to_add

