// 𓂀 𓆣 𓅓 𓊪 𓏏 𓂧 𓎼 𓄿 𓃀 𓅱 𓏏 𓏏 — The Butt Organ
// 𓋹 May the butt guide you through the Duat of space. 𓋹
//
// 📜 Egyptian Documentation (as required by Bounty #233):
//
// 𓇳 The Butt Organ (𓂝𓏏𓂝𓏏) is a sacred vessel of flatulence.
// 𓇳 It resides in the groin (𓊪𓏏𓂋𓏏) and channels the winds of Nut.
// 𓇳 When destroyed by Super Fart (𓊪𓏏𓂋𓏏𓅱𓂋), it must be replaced
//    through the sacred rites of Surgery (𓋴𓅱𓂋𓎼𓂋𓇌).
// 𓇳 Without the butt, one cannot release the Breath of Set. 𓇳

/obj/item/organ/butt
	name = "butt"
	icon_state = "butt"
	base_icon_state = "butt"

	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_BUTT
	food_reagents = list(/datum/reagent/consumable/nutriment/organ_tissue = 5)
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	/// 𓊪𓏏𓂋𓏏𓅱𓂋 — Has this butt been destroyed by a super fart?
	var/super_farted = FALSE

	now_failing = span_warning("You feel a disturbing emptiness where your butt should be. Farting is impossible.")
	now_fixed = span_info("Your butt has been restored. The winds may flow once more.")

// 𓅓𓅱𓏏 — Can this creature fart?
// 𓋴𓅱𓂋: TRUE if butt is functional and not super-farted
/obj/item/organ/butt/proc/can_fart()
	if(organ_flags & ORGAN_FAILING)
		return FALSE
	if(super_farted)
		return FALSE
	if(damage >= maxHealth * 0.5)
		return FALSE
	return TRUE

// 𓊪𓏏𓂋𓏏𓅱𓂋 — Execute the Super Fart
// Destroys this butt organ, causing an explosion and gas release.
// Returns TRUE if successful.
/obj/item/organ/butt/proc/perform_super_fart()
	if(!can_fart())
		return FALSE
	if(super_farted)
		return FALSE

	super_farted = TRUE
	apply_organ_damage(maxHealth) // 💥 instantly destroyed

	// 𓂝𓏏𓅱𓂋 — Notify the owner
	if(owner)
		owner.visible_message(
			span_danger("[owner] lets out an earth-shattering SUPER FART! Their butt is completely destroyed!"),
			span_userdanger("You unleash a SUPER FART of legendary proportions! Your butt is GONE!"),
		)

	return TRUE

// 𓅓𓅱𓏏𓅱𓂋 — Regular fart
// Releases a small toot. Does not damage the butt.
/obj/item/organ/butt/proc/perform_fart()
	if(!can_fart())
		return FALSE

	if(owner)
		owner.visible_message(
			span_notice("[owner] lets out a small toot."),
			span_notice("You fart. A small, satisfying toot."),
		)
	// TODO: Play SFX from sound/vox_farts/
	return TRUE

/obj/item/organ/butt/on_life(seconds_per_tick)
	. = ..()
	if(!owner)
		return

	// 𓇳 Random inflammation check — similar to appendix logic
	if(super_farted)
		return // destroyed butts don't inflame

	// 𓇳 Inflamed butts cause involuntary toots
	if(inflamation_stage && SPT_PROB(5, seconds_per_tick))
		perform_fart()

/obj/item/organ/butt/grind_results()
	return list(/datum/reagent/toxin/bad_food = 5)
