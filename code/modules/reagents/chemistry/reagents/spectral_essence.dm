/**
 * # Spectral Essence Reagent
 *
 * A refined ectoplasmic liquid collected and distilled by the Paranormalist's
 * Ecto-Sucker. Unlike raw hauntium which hurts the living, spectral essence
 * is relatively safe and grants temporary ghost sight.
 *
 * Effects:
 * - On metabolize: Grants SEE_INVISIBLE_OBSERVER (can see ghosts), green skin tint
 * - During metabolism: Minor hallucinations, slight jitteriness
 * - On end metabolize: Removes ghost sight, reverts skin
 */

/datum/reagent/spectral_essence
	name = "Spectral Essence"
	description = "A refined ectoplasmic liquid that, when consumed, temporarily attunes the drinker's senses to the spectral plane. Side effects may include mild hallucinations and an unsettling green tint to the skin."
	color = "#44FF8877"
	taste_description = "an otherworldly chill"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 7.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/spectral_essence/on_mob_metabolize(mob/living/carbon/affected_mob, seconds_per_tick)
	. = ..()
	to_chat(affected_mob, span_green("A cold sensation washes over you. The veil between worlds grows thin..."))

	// Grant ghost sight
	affected_mob.set_invis_see(SEE_INVISIBLE_OBSERVER)

	// Apply a green skin tint
	affected_mob.add_atom_colour("#88FFAA44", TEMPORARY_COLOUR_PRIORITY)

	// Mood event
	affected_mob.add_mood_event("spectral_sight", /datum/mood_event/spectral_sight, name)

/datum/reagent/spectral_essence/on_mob_end_metabolize(mob/living/carbon/affected_mob)
	. = ..()
	to_chat(affected_mob, span_notice("The spectral visions fade. The world feels solid again."))

	// Remove ghost sight - reset to default
	affected_mob.set_invis_see(SEE_INVISIBLE_LIVING)

	// Remove green tint
	affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#88FFAA44")

	// Remove mood event
	affected_mob.clear_mood_event("spectral_sight")

/datum/reagent/spectral_essence/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	// Minor hallucinations while under the effect
	if(SPT_PROB(8, seconds_per_tick))
		affected_mob.emote(pick("shiver", "twitch"))
	// Occasional spooky messages
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_purple(pick(
			"You see something move in the corner of your eye...",
			"A faint whisper brushes past your ear...",
			"The air around you feels unnaturally cold...",
			"Shadows seem to shift and dance at the edge of your vision...",
			"You feel a presence nearby, watching...",
			"For a brief moment, you can see through the walls...",
		)))

/// Mood event for spectral sight
/datum/mood_event/spectral_sight
	description = "I can see the spirits of the dead... it's both beautiful and terrifying."
	mood_change = -2
	timeout = 8 MINUTES
