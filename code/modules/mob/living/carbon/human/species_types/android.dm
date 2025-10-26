/datum/species/android
	name = "Android"
	id = SPECIES_ANDROID
	examine_limb_id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_NOHUNGER // Has to be here for the UI to render right, species traits are handled by the brain organ
	)
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	exotic_bloodtype = BLOOD_TYPE_OIL
	meat = null
	mutantbrain = /obj/item/organ/brain/cybernetic
	mutanttongue = /obj/item/organ/tongue/speaker
	mutantstomach = /obj/item/organ/stomach/fuel_generator
	mutantappendix = /obj/item/organ/appendix/random_number_database
	mutantheart = /obj/item/organ/heart/oil_pump
	mutantliver = /obj/item/organ/liver/cleaning_filter
	mutantlungs = /obj/item/organ/lungs/cooling_fans
	mutanteyes = /obj/item/organ/eyes/camera
	mutantears = /obj/item/organ/ears/microphone
	species_language_holder = /datum/language_holder/synthetic
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/robot/android,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/robot/android,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/android,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/android,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/android,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/robot/android,
	)

/datum/species/android/get_physical_attributes()
	return "Androids are a fully robotic species that doesn't feel pity, or remorse, or fear. It can't go into crit, and has a reworked health \
	system involving power and oil instead of caring about limb damage. They are radically different from the other species; be warned when using this \
	as a Wizard." // We only use this for the wizard mirror species changer, so we can be wizard-specific here.

/datum/species/android/get_species_description()
	return "Recent advances in the fields of medicine, robotics, and psychology have made a kind of \"clean\" immortality plausible for humanity: \
	androidism, an evolution on the full-body prosthetic (FBP) movement. Androidists (or simply \"androids\") are people who — for whatever reason \
	(medical necessity, an ideological commitment to transhumanism, etc) — have replaced their entire body with cutting edge advanced cybernetics \
	that aim to improve and iterate upon, not merely replace, human body parts."

/datum/species/android/get_species_lore()
	return list(
		"Androids are the bleeding edge of transhumanism — or a horror of modern medicine that will be regarded as a crime against sophoncy in retrospect.",

		"Androids are a mature product of the full-body prosthetic (FBP) movement, emerging from many decades of prosthetic research and development. \
		They are humans (or other sophonts) which have elected to replace their entire body with advanced, mechanized systems. \
		These systems are designed to maximize performance at work and in life, and lack the sophisticated hardware to emulate organic processes. \
		They do not feel pain, they do not need to eat or pass waste, they don't even breathe like a person would.",

		"Life as an android is both empowering and alienating. They live with fewer limitations, especially for those who were seriously disabled before \
		becoming androids, and can move faster, hit harder, and work longer than their organic counterparts, but lack the little things in life. \
		Their senses have been collapsed down to sight and hearing, and while both have greater fidelity, the loss of all the others takes it toll. \
		Disassociation, hallucinations, and depression are significantly more common in androids than their organic counterparts.",

		"After all, there's always a price to pay for immortality.",

		"While androidism is usually discussed in the media as an ideological commitment to transhumanism, androids are much more often the product of \
		traumatic events that require the near-complete replacement of the body. It is especially preferred in the rougher regions of space \
		because androids require significantly less infrastructure to support than ICU patients (and also the older generation full-body prosthetists). ",

		"Much controversy surrounds androidism even in that. The technology to make this possible has existed for less than a decade, and case studies \
		are still on-going, yet NanoTrasen continues to sell the treatment. Employment law in both TerraGov and the Spinward require that androids — \
		regardless of their origin — retain some resemblance to biological life if performing duties for non-state entities. This is why most androids \
		still require air and intake fuel through their mouths, even though there is no real design pressure for these conceits.",

		"Androids come from all walks of life, but usually hail from (or at least died in) relatively wealthy and technologically advanded places. \
		They can perform any job that a human might, though their nature makes them uniquely apt as manual labor and combat crews.  \
		Many may have significant medical debt that they are working off."
	)

/datum/species/android/create_pref_traits_perks()
	var/list/perks = list()
	return perks

/datum/species/android/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_ROBOT,
		SPECIES_PERK_NAME = "Snap-on Limbs",
		SPECIES_PERK_DESC = "If you've lost a limb, it's no problem at all; you can simply snap on the limb to the body.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SCREWDRIVER,
		SPECIES_PERK_NAME = "Easy Organ Repairs",
		SPECIES_PERK_DESC = "Your limbs can be opened up with a screwdriver and crowbar to easily access the contained organs, making \
		organ replacement a breeze if a part gets damaged!",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BEER_MUG_EMPTY,
		SPECIES_PERK_NAME = "Drink Beer to Recharge",
		SPECIES_PERK_DESC = "Ingesting any alcohol will immediately start burning it in your engine for power. This is able to revive you from being \
		completely powered off! The stronger the booze, the better the power burn. Other flammable liquids are usable too. Alternative engines may \
		change how you get power, so choose an engine carefully.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SATELLITE_DISH,
		SPECIES_PERK_NAME = "Distress Beacon",
		SPECIES_PERK_DESC = "If you run out of power or run out of oil, a distress beacon will automatically activate, flagging you up on the \
		Distress Beacon console in Robotics. You'll show up even if your sensors were off when you ran out of power or oil! An EMP will shut off the \
		beacon, however.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_OIL_CAN,
		SPECIES_PERK_NAME = "High-Speed Lubricants",
		SPECIES_PERK_DESC = "When you're topped off on oil, you'll be able to interact with everything around you much faster!",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_BATTERY_FULL,
		SPECIES_PERK_NAME = "Power is Health",
		SPECIES_PERK_DESC = "Androids do not operate off of limb damage like normal spacemen. Damage goes directly to your power, and if you \
		start running out of power, your organs start shutting off and you will eventually power down, activating your distress beacon.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_OIL_CAN,
		SPECIES_PERK_NAME = "Oil for Blood",
		SPECIES_PERK_DESC = "Androids keep themselves moving smoothly via oil as a lubricant, and will bleed it like blood. Replace it by splashing \
		yourself with oil or another type of lubricant, or by getting it injected via IV drip.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_OIL_CAN,
		SPECIES_PERK_NAME = "Oil Consumption",
		SPECIES_PERK_DESC = "All item interactions and all movement will burn through your oil; if it runs low, you'll interact slower, \
		and if it runs out, you'll be locked in place!",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BOLT_LIGHTNING,
		SPECIES_PERK_NAME = "Stamina Damages Power",
		SPECIES_PERK_DESC = "Stamina damage(ie. tasers, disablers, stun batons) directly sap your power, and as a result, while you can't go into \
		stamina crit, you will power down from enough stamina damage same as if you're attacked with conventional weapons.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_THERMOMETER_HALF,
		SPECIES_PERK_NAME = "Temperature Sensitive",
		SPECIES_PERK_DESC = "Your brain will overheat if not kept adequately cold, and if you're experiencing temperature extremes, you'll \
		burn power significantly faster!",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_WINDOW_RESTORE,
		SPECIES_PERK_NAME = "EMP-Vulnerable",
		SPECIES_PERK_DESC = "Getting hit with an EMP will deactivate your anti-virus and firewall on your email server briefly. \
		Don't click the ads!",
	))
	return perks
