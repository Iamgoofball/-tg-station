/// 🦐 SHRIMP PEOPLE 🦐
/// A species of aquatic shrimp-like humanoids that must wear fishbowls on their heads
/// and have silly antennae that grant permanent T-ray vision.
/// Their big shrimplike tails do damage to nearby mobs and structures when they *spin.
/// When they die with high burn damage, they turn into fried shrimp! 🍤

/datum/species/shrimp
	/// 🦐 Shrimplike humanoids with antennae and big tails
	name = "\improper Shrimpperson" // 🦐
	plural_form = "Shrimpfolk" // 🦐
	id = SPECIES_SHRIMP // 🦐
	sexes = TRUE // 🦐
	meat = /obj/item/food/meat/slab/human/mutant/shrimp // 🦐
	skinned_type = /obj/item/stack/sheet/animalhide/shrimp // 🦐

	// 🦐 Shrimps have exoskeleton-like skin that grants them natural armor
	inherent_traits = list(
		TRAIT_MUTANT_COLORS, // 🦐 Shrimplike skin colors
		TRAIT_XRAY_VISION, // 🦐 Permanent T-ray view from their silly antennae!
		// TRAIT_NOBREATH, // handled by fishbowl equipment
		// TRAIT_NO_UNDERWEAR, // They have natural shrimp plating 🦐
	)

	inherent_biotypes = MOB_HUMANOID|MOB_CRUSTACEAN // 🦐 Shrimp are crustaceans!

	// 🦐 Shrimp organs - adapted for aquatic life
	mutanteyes = /obj/item/organ/eyes/shrimp // 🦐 Antennae eyes (T-ray)
	mutanttongue = /obj/item/organ/tongue/shrimp // 🦐 Shrimpy tongue
	mutantliver = /obj/item/organ/liver/shrimp // 🦐 Adapted shrimp liver
	mutantlungs = /obj/item/organ/lungs/shrimp // 🦐 Aquatic-adapted lungs
	mutantheart = /obj/item/organ/heart/shrimp // 🦐 Tiny shrimp heart 🦐

	// 🦐 Shrimp temperature tolerances - like cold water creatures
	coldmod = 0.5 // 🦐 Love the cold
	heatmod = 2.0 // 🦐 Hate the heat (that's how you get cooked!)
	siemens_coeff = 1.5 // 🦐 More conductive than humans (salty water)
	payday_modifier = 1.0 // 🦐
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN // 🦐

	// 🦐 Species-specific equipment
	species_cookie = /obj/item/food/meat/slab/shrimp // 🦐 They love shrimp too! 🦐
	exotic_bloodtype = BLOOD_TYPE_SHRIMP // 🦐 Shrimp hemolymph
	species_language_holder = /datum/language_holder/shrimp // 🦐

	// 🦐 Body temperature same as humans but they're cold-blooded
	bodytemp_heat_damage_limit = (BODYTEMP_HEAT_DAMAGE_LIMIT - 15) // 🦐 Start cooking at lower temps 🍤
	bodytemp_cold_damage_limit = (BODYTEMP_COLD_DAMAGE_LIMIT - 30) // 🦐 Can handle colder waters

	// 🦐 The fishbowl head is required for life (like plasmaman suits)
	outfit_important_for_life = /datum/outfit/shrimp // 🦐 Fishbowl head!

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/shrimp,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/shrimp,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/shrimp,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/shrimp,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/shrimp,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/shrimp,
	)

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 SPECIES BEHAVIORS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/on_species_gain(mob/living/carbon/human/human, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	// 🦐 Register spin emote for tail attacks!
	RegisterSignal(human, COMSIG_MOB_EMOTED("spin"), PROC_REF(on_shrimp_spin))
	// 🦐 Register death for fried shrimp transformation
	RegisterSignal(human, COMSIG_LIVING_DEATH, PROC_REF(on_shrimp_death))
	// 🦐 Give them their fishbowl head
	if(!pref_load)
		human.equip_to_slot_or_del(new /obj/item/clothing/head/fishbowl(human), ITEM_SLOT_HEAD)

/datum/species/shrimp/on_species_loss(mob/living/carbon/human/human, datum/species/new_species, pref_load, regenerate_icons)
	// 🦐 Clean up signals
	UnregisterSignal(human, COMSIG_MOB_EMOTED("spin"))
	UnregisterSignal(human, COMSIG_LIVING_DEATH)
	. = ..()

/// 🦐 When a shrimp person *spins, their big tail damages nearby mobs and structures!
/datum/species/shrimp/proc/on_shrimp_spin(mob/living/carbon/human/shrimpy)
	SIGNAL_HANDLER // 🦐

	// 🦐 Tail whip damage!
	var/range = 1 // 🦐 Their big tail can hit adjacent tiles
	var/damage = 15 // 🦐 BRUTE damage from the powerful tail

	// 🦐 Damage everything nearby
	for(var/mob/living/victim in oview(range, shrimpy))
		if(victim == shrimpy)
			continue
		// 🦐 If they're facing away from the shrimp, more damage!
		var/dir_to_target = get_dir(shrimpy, victim)
		var/target_dir = victim.dir
		var/is_facing_away = (dir_to_target == target_dir) // facing same direction = away
		var/actual_damage = is_facing_away ? damage : (damage * 0.5)

		victim.apply_damage(actual_damage, BRUTE, BODY_ZONE_CHEST)
		victim.apply_damage(actual_damage * 0.5, STAMINA) // 🦐 Staggers them
		victim.Knockdown(1 SECONDS) // 🦐 Knocks them down!
		shrimpy.visible_message(
			span_danger("[shrimpy]'s big shrimplike tail WHAPS [victim] for [actual_damage] damage! 🦐"),
			span_userdanger("Your big shrimp tail smacks [victim]! 🦐"),
		)
		playsound(shrimpy, 'sound/weapons/sonic_jackhammer.ogg', 50, TRUE) // 🦐 CRACK

	// 🦐 Also damage nearby structures!
	for(var/obj/structure/structure in oview(range, shrimpy))
		if(is_type_in_list(structure, list(/obj/structure/window, /obj/structure/grille, /obj/structure/table)))
			structure.take_damage(30, BRUTE, MELEE) // 🦐 Smashes through fragile stuff!
			shrimpy.visible_message(
				span_danger("[shrimpy]'s tail SMASHES through [structure]! 🦐"),
				span_userdanger("Your tail crushes [structure]! 🦐"),
			)

/// 🦐 When a shrimp person dies with high burn damage, they turn into FRIED SHRIMP! 🍤
/datum/species/shrimp/proc/on_shrimp_death(mob/living/carbon/human/shrimpy, gibbed)
	SIGNAL_HANDLER // 🦐

	// 🦐 Check if they died from burn damage (being cooked!)
	var/burn_damage = shrimpy.getFireLoss()
	var/total_damage = shrimpy.getToxLoss() + shrimpy.getFireLoss() + shrimpy.getBruteLoss() + shrimpy.getOxyLoss()

	if(burn_damage > 50 || (total_damage > 0 && (burn_damage / total_damage) > 0.4))
		// 🦐 FRIED SHRIMP! 🍤
		shrimpy.visible_message(
			span_danger("[shrimpy]'s body sizzles and curls up into a delicious fried shrimp! 🍤"),
			span_userdanger("You have been COOKED! 🍤"),
		)
		playsound(shrimpy, 'sound/items/food/fryer/deep_fryer_emerge.ogg', 80, TRUE) // 🦐 SIZZLE

		// 🍤 Drop delicious fried shrimp for everyone
		var/obj/item/food/fried_shrimp/fried = new(shrimpy.drop_location())
		fried.name = "[shrimpy.real_name] fried shrimp" // 🍤 Named after them!
		fried.desc = "A perfectly cooked [shrimpy.real_name] shrimp. Looks delicious! 🍤"

		// 🦐 Drop their tail as a trophy too
		new /obj/item/stack/sheet/animalhide/shrimp_tail(shrimpy.drop_location())

		// 🦐 Also some regular shrimp meat
		for(var/i in 1 to 3)
			new /obj/item/food/meat/slab/human/mutant/shrimp(shrimpy.drop_location())

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 DESCRIPTIONS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/get_physical_attributes()
	return "Shrimp People are aquatic crustacean-humanoids with shrimplike exoskeleton skin. \
		They must wear a fishbowl on their head filled with water to survive outside of aquatic environments. \
		Their silly antennae grant them permanent T-ray vision, allowing them to see through walls! \
		Their big shrimp tails can deal devastating damage to nearby foes when they spin. \
		And if they're cooked to death... well, they turn into a tasty snack. 🦐🍤"

/datum/species/shrimp/get_species_description()
	return "Discovered in the deep oceanic trenches of a distant water world, \
		Shrimp People are a proud crustacean species that joined the crew \
		after a particularly lucrative seafood contract was negotiated. \
		They're known for being excellent chefs (of non-shrimp dishes), \
		enthusiastic dancers (the tail *spin is legendary), \
		and for having an absolutely insatiable love of shrimp emoji. 🦐"

/datum/species/shrimp/get_species_lore()
	return list(
		"🦐 The Shrimp People (Shrimpfolk) originated on the ocean world of Aquarius IV, \
		a planet covered entirely in warm, shallow seas perfect for crustacean evolution. \
		Their civilization developed in the coral cities of the deep, where they cultivated \
		sentience through generations of complex social molting rituals. 🦐",

		"🦐 First contact with humanity occurred when a Nanotrasen deep-sea drilling platform \
		accidentally punched through the roof of the Shrimpfolk's capital city. \
		Instead of war, the Shrimpfolk offered the stunned drill operators a platter of \
		delicious garlic butter sauce, and a lasting peace was forged over shared meals. 🦐",

		"🦐 Shrimp People have since integrated into galactic society, though they require \
		special accommodations. Their fishbowl helmets contain a carefully balanced saline \
		solution that keeps their gill-slits moist. Without it, they begin to desiccate rapidly. \
		Their antennae, besides being adorable, have naturally evolved T-ray perception \
		from millennia of navigating murky waters. 🦐",

		"🦐 A Shrimp Person's tail is not just for show - it's a powerful weapon evolved \
		for fending off deep-sea predators. When they *spin, the centrifugal force turns \
		their tail into a devastating bludgeon. Shrimpfolk dance competitions (\"Tail-Offs\") \
		are a popular galactic sport that the Shrimpfolk invariably win. 🦐",
	)

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 PERKS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "eye", // 🦐 T-ray vision
		SPECIES_PERK_NAME = "T-Ray Vision 👀",
		SPECIES_PERK_DESC = "Shrimp People's silly antennae grant them permanent T-ray vision, \
			allowing them to see through walls and detect hidden threats! 🦐",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "fighter-jet", // 🦐 Tail spin attack
		SPECIES_PERK_NAME = "Tail *Spin Attack 🌀",
		SPECIES_PERK_DESC = "Shrimp People have big powerful tails. When they *spin, \
			their tail whips around dealing heavy damage to nearby mobs and structures! 🦐",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "fish", // 🦐 Fishbowl head
		SPECIES_PERK_NAME = "Fishbowl Head 🐟",
		SPECIES_PERK_DESC = "Shrimp People require a fishbowl filled with saline water \
			to survive outside of aquatic environments. It's fashionable though! 🦐",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "fire", // 🦐 Heat weakness
		SPECIES_PERK_NAME = "Cooked Alive 🍤",
		SPECIES_PERK_DESC = "Shrimp People take extra damage from heat and \
			if they die with high burn damage, they turn into delicious fried shrimp! \
			Don't be the main course! 🦐",
	))
	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "tint", // 🦐 Conductive body
		SPECIES_PERK_NAME = "Salty Conductivity ⚡",
		SPECIES_PERK_DESC = "The saline content of Shrimp People's bodies makes them \
			more conductive to electricity than baseline humans. Watch out for stun batons! 🦐",
	))

	return to_add

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 SOUNDS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/get_scream_sound(mob/living/carbon/human/shrimp)
	return pick(
		'sound/mobs/humanoids/shrimp/shrimp_scream_1.ogg',
		'sound/mobs/humanoids/shrimp/shrimp_scream_2.ogg',
	)

/datum/species/shrimp/get_cough_sound(mob/living/carbon/human/shrimp)
	return 'sound/mobs/humanoids/shrimp/shrimp_cough.ogg'

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 COLOR / PREVIEW
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/prepare_human_for_preview(mob/living/carbon/human/human)
	// 🦐 Give them a nice shrimp color!
	var/pink_orange_or_red = pick("#FF69B4", "#FF8C00", "#DC143C", "#FF6347", "#E34234") // 🦐 Shrimp colors!
	human.dna.features[FEATURE_MUTANT_COLOR] = pink_orange_or_red
	human.update_body(is_creating = TRUE)
	// 🦐 Put a fishbowl on them for the preview
	human.equip_to_slot_or_del(new /obj/item/clothing/head/fishbowl(human), ITEM_SLOT_HEAD)

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 ROUNDSTART ELIGIBILITY
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/datum/species/shrimp/check_roundstart_eligible()
	return TRUE // 🦐 Shrimpfolk are ready to play! 🦐

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 FISHBOWL HEAD
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/obj/item/clothing/head/fishbowl
	name = "fishbowl helmet"
	desc = "A glass fishbowl filled with saline water, worn by Shrimp People to keep their gills moist. 🦐"
	icon_state = "fishbowl"
	inhand_icon_state = "fishbowl"
	icon = 'icons/obj/clothing/hats.dmi'
	worn_icon = 'icons/mob/clothing/head/head.dmi'
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEEARS|HIDEEYES|HIDEFACE|HIDESNOUT
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH|PEPPERPROOF
	armor_type = /datum/armor/none
	body_parts_covered = HEAD|FACE|EYES
	slot_flags = ITEM_SLOT_HEAD
	resistance_flags = FIRE_PROOF|UNACID|ACID_PROOF // 🦐 Glass doesn't melt
	clothing_flags = STACKABLE_HELMET_EXEMPT
	/// 🦐 If the fishbowl is broken, the shrimp needs a new one
	var/broken = FALSE

/obj/item/clothing/head/fishbowl/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_HEAD && ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.dna?.species?.id == SPECIES_SHRIMP)
			// 🦐 Shrimp are happy with their fishbowl!
			human_user.add_mood_event("fishbowl_happy", /datum/mood_event/fishbowl_comfort)

/obj/item/clothing/head/fishbowl/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		human_user.clear_mood_event("fishbowl_happy")

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 FRIED SHRIMP FOOD ITEM
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/obj/item/food/fried_shrimp
	name = "fried shrimp 🍤"
	desc = "A delicious golden-fried shrimp. Crunchy! 🍤"
	icon_state = "fried_shrimp"
	foodtypes = MEAT | SEAFOOD
	junkiness = 15
	tastes = list("shrimp" = 3, "crunchy batter" = 1, "regret" = 1)
	food_flags = NONE
	w_class = WEIGHT_CLASS_SMALL
	venue_value = 5

// 🦐 Mood event for having a fishbowl
/datum/mood_event/fishbowl_comfort
	description = "My fishbowl keeps my gills nice and moist! 🦐"
	mood_change = 3
	timeout = 30 SECONDS

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 SHRIMP BODYPARTS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/obj/item/bodypart/head/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "shrimp_head"
	limb_id = SPECIES_SHRIMP
	is_dimorphic = TRUE
	biological_state = BIO_FLESH_BONE // 🦐 Exoskeleton-ish
	dismemberable = TRUE
	max_damage = 100
	body_zone = BODY_ZONE_HEAD

/obj/item/bodypart/chest/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "shrimp_chest"
	limb_id = SPECIES_SHRIMP
	is_dimorphic = TRUE
	biological_state = BIO_FLESH_BONE
	dismemberable = TRUE
	max_damage = 200
	body_zone = BODY_ZONE_CHEST

/obj/item/bodypart/arm/left/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "l_arm"
	limb_id = SPECIES_SHRIMP
	biological_state = BIO_FLESH_BONE
	dismemberable = TRUE
	max_damage = 75
	body_zone = BODY_ZONE_L_ARM

/obj/item/bodypart/arm/right/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "r_arm"
	limb_id = SPECIES_SHRIMP
	biological_state = BIO_FLESH_BONE
	dismemberable = TRUE
	max_damage = 75
	body_zone = BODY_ZONE_R_ARM

/obj/item/bodypart/leg/left/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "l_leg"
	limb_id = SPECIES_SHRIMP
	biological_state = BIO_FLESH_BONE
	dismemberable = TRUE
	max_damage = 75
	body_zone = BODY_ZONE_L_LEG

/obj/item/bodypart/leg/right/shrimp
	icon_static = 'icons/mob/human/species/shrimp/bodyparts.dmi'
	icon_state = "r_leg"
	limb_id = SPECIES_SHRIMP
	biological_state = BIO_FLESH_BONE
	dismemberable = TRUE
	max_damage = 75
	body_zone = BODY_ZONE_R_LEG

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 SHRIMP ORGANS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/obj/item/organ/eyes/shrimp
	name = "shrimp antennae eyes"
	desc = "A pair of silly-looking shrimp antennae with visual receptors at the tips. 🦐"
	icon_state = "shrimp_eyes"
	eye_color_left = "FFF"
	eye_color_right = "FFF"
	// 🦐 T-ray vision built in!
	_flash_protection = FLASH_PROTECTION_SENSITIVE // 🦐 Sensitive eyes
	tint = 0
	see_in_dark = 8 // 🦐 Excellent night vision from deep sea
	organ_traits = list(TRAIT_XRAY_VISION) // 🦐 PERMANENT T-RAY VIEW!

/obj/item/organ/tongue/shrimp
	name = "shrimp tongue"
	desc = "A small, wriggly shrimp tongue. It tastes everything with extra salty flavor. 🦐"
	icon_state = "shrimp_tongue"
	tastes_like = "shrimp"
	modifier_speech = TRAIT_MUTANT_COLORS // 🦐

/obj/item/organ/liver/shrimp
	name = "shrimp liver"
	desc = "A small, shrimp-shaped liver adapted for filtering saline water. 🦐"
	icon_state = "shrimp_liver"
	alcohol_tolerance = -0.1 // 🦐 Shrimp don't handle alcohol well
	toxin_filter_rate = 0.5 // 🦐 Less effective at filtering toxins
	organ_traits = list(TRAIT_STABLELIVER) // 🦐 But they're stable!

/obj/item/organ/lungs/shrimp
	name = "shrimp gill-lungs"
	desc = "A set of lung-gill hybrids that can extract oxygen from both air and water. 🦐"
	icon_state = "shrimp_lungs"
	organ_traits = list(TRAIT_NOBREATH) // 🦐 Can breathe underwater (via fishbowl)

/obj/item/organ/heart/shrimp
	name = "tiny shrimp heart"
	desc = "A surprisingly complex tiny heart from a Shrimp Person. It beats very fast! 🦐"
	icon_state = "shrimp_heart"
	organ_efficiency = 0.8 // 🦐 Small heart works harder

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 SHRIMP MATERIALS & ITEMS
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

/obj/item/stack/sheet/animalhide/shrimp
	name = "shrimp chitin"
	desc = "Tough chitinous plates from a Shrimp Person's exoskeleton. 🦐"
	icon_state = "sheet-chitin"
	inhand_icon_state = "sheet-chitin"
	singular_name = "shrimp chitin sheet"
	novariants = FALSE

/obj/item/stack/sheet/animalhide/shrimp_tail
	name = "shrimp tail"
	desc = "A big, powerful shrimp tail. It still twitches occasionally. 🦐"
	icon_state = "shrimp_tail"
	singular_name = "shrimp tail"
	novariants = FALSE

/obj/item/food/meat/slab/human/mutant/shrimp
	name = "shrimp meat"
	desc = "A slab of pinkish shrimp meat. Looks tasty! 🦐"
	icon_state = "meat_shrimp"
	foodtypes = MEAT | SEAFOOD
	tastes = list("shrimp" = 3, "salt water" = 1)
	cooked_type = /obj/item/food/fried_shrimp

// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐
// 🦐 BLOOD TYPE
// 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐 🦐

#define BLOOD_TYPE_SHRIMP "SHRIMP" // 🦐 Shrimp hemolymph
