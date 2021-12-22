///used by slimes
/datum/ai_planning_subtree/slime_feed

/datum/ai_planning_subtree/slime_feed/SelectBehaviors(datum/ai_controller/controller, delta_time)
	. = ..()
	var/mob/living/basic/slime/slime_pawn = controller.pawn
	controller.queue_behavior(/datum/ai_behavior/slime_process_nutrients)

	if(slime_pawn.amount_grown >= SLIME_EVOLUTION_THRESHOLD)
		return SUBTREE_RETURN_FINISH_PLANNING
	if(!slime_pawn.buckled)
		if(!controller.blackboard[BB_SLIME_FEED_TARGET])
			if(slime_pawn.nutrition < slime_pawn.get_starve_nutrition()) // Feed on anything if we're starving.
				controller.queue_behavior(/datum/ai_behavior/find_and_set, BB_SLIME_FEED_TARGET, list(/mob/living/carbon/human), 7)
				return SUBTREE_RETURN_FINISH_PLANNING
			else // Otherwise, feed on monke only.
				controller.queue_behavior(/datum/ai_behavior/find_and_set/racism, BB_SLIME_FEED_TARGET, list(/datum/species/monkey), 7)
				return SUBTREE_RETURN_FINISH_PLANNING

		controller.queue_behavior(/datum/ai_behavior/slime_feed, BB_SLIME_FEED_TARGET)
	controller.queue_behavior(/datum/ai_behavior/slime_feeding)
	return SUBTREE_RETURN_FINISH_PLANNING

