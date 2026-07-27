#define RUNNING_TRIP_CHANCE 0.2
#define RUNNING_TRIP_DURATION (2 SECONDS)

/mob/living/carbon/slip(knockdown_amount, obj/slipped_on, lube_flags, paralyze, daze, force_drop = FALSE)
	if(movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
		return FALSE
	if(!(loc.handle_slip(src, knockdown_amount, slipped_on, lube_flags, paralyze, daze, force_drop)))
		return FALSE
	if(!(lube_flags & SLIDE_ICE))
		log_combat(src, (slipped_on || get_turf(src)), "slipped on the", null, ((lube_flags & SLIDE) ? "(SLIDING)" : null))
	..()
	return TRUE

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(!. || (movement_type & FLOATING)) //floating is easy
		return
	if(nutrition <= 0 || stat == DEAD)
		return
	var/hunger_loss = HUNGER_FACTOR / 10
	if(move_intent == MOVE_INTENT_RUN)
		hunger_loss *= 2
	adjust_nutrition(-1 * hunger_loss)
	try_running_trip()

/// Gives running a small chance to end in an embarrassing fall.
/mob/living/carbon/proc/try_running_trip(chance = RUNNING_TRIP_CHANCE)
	if(move_intent != MOVE_INTENT_RUN || !has_gravity() || buckled)
		return FALSE
	if(movement_type & MOVETYPES_NOT_TOUCHING_GROUND)
		return FALSE
	if(IsKnockdown() || IsParalyzed() || !prob(chance))
		return FALSE

	visible_message(
		span_warning("[src] trips over [src.p_their()] own feet!"),
		span_userdanger("You trip over your own feet!"),
	)
	playsound(src, 'sound/misc/slip.ogg', 30, TRUE)
	Knockdown(RUNNING_TRIP_DURATION)
	return TRUE

/mob/living/carbon/set_usable_legs(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		if(usable_legs != 0) //From having no usable legs to having some.
			REMOVE_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_legs == 0 && !(movement_type & (FLYING | FLOATING))) //From having usable legs to no longer having them.
		ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(!usable_hands)
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)


/mob/living/carbon/set_usable_hands(new_value)
	. = ..()
	if(isnull(.))
		return
	if(. == 0)
		REMOVE_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(usable_hands != 0) //From having no usable hands to having some.
			REMOVE_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
	else if(usable_hands == 0 && default_num_hands > 0) //From having usable hands to no longer having them.
		ADD_TRAIT(src, TRAIT_HANDS_BLOCKED, LACKING_MANIPULATION_APPENDAGES_TRAIT)
		if(!usable_legs && !(movement_type & (FLYING | FLOATING)))
			ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/mob/living/carbon/on_movement_type_flag_enabled(datum/source, flag, old_movement_type)
	. = ..()
	if(movement_type & (FLYING | FLOATING) && !(old_movement_type & (FLYING | FLOATING)))
		remove_movespeed_modifier(/datum/movespeed_modifier/limbless)
		remove_traits(list(TRAIT_FLOORED, TRAIT_IMMOBILIZED), LACKING_LOCOMOTION_APPENDAGES_TRAIT)

/mob/living/carbon/on_movement_type_flag_disabled(datum/source, flag, old_movement_type)
	. = ..()
	if(old_movement_type & (FLYING | FLOATING) && !(movement_type & (FLYING | FLOATING)))
		var/limbless_slowdown = 0
		if(usable_legs < default_num_legs)
			limbless_slowdown += (default_num_legs - usable_legs) * 3
			if(!usable_legs)
				ADD_TRAIT(src, TRAIT_FLOORED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
				if(usable_hands < default_num_hands)
					limbless_slowdown += (default_num_hands - usable_hands) * 3
					if(!usable_hands)
						ADD_TRAIT(src, TRAIT_IMMOBILIZED, LACKING_LOCOMOTION_APPENDAGES_TRAIT)
		if(limbless_slowdown)
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/limbless, multiplicative_slowdown = limbless_slowdown)
		else
			remove_movespeed_modifier(/datum/movespeed_modifier/limbless)

#undef RUNNING_TRIP_CHANCE
#undef RUNNING_TRIP_DURATION
