/datum/ai_behavior/slime_feed
	behavior_flags = AI_BEHAVIOR_MOVE_AND_PERFORM
	action_cooldown = 0.4 SECONDS

/datum/ai_behavior/slime_feed/setup(datum/ai_controller/controller, target_key)
	. = ..()
	controller.current_movement_target = controller.blackboard[target_key]

/datum/ai_behavior/slime_feed/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/carbon/human/target_food = controller.blackboard[target_key]
	var/mob/living/basic/slime/slime_pawn = controller.pawn
	if(slime_pawn.stat || target_food.stat == DEAD)
		finish_action(controller, TRUE, target_key)
		return
	if(get_dist(slime_pawn, target_food) >= 7)
		finish_action(controller, TRUE, target_key)
		return
	if(slime_pawn.amount_grown >= SLIME_EVOLUTION_THRESHOLD) // a little extra so they don't immediately have to re-attach
		finish_action(controller, TRUE, target_key)
		return
	slime_pawn.Feedon(target_food)
	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/slime_feed/finish_action(datum/ai_controller/controller, succeeded, target_key)
	var/mob/living/basic/slime/slime_pawn = controller.pawn
	controller.blackboard -= target_key
	controller.current_movement_target = null
	return ..()

/datum/ai_behavior/slime_feeding
	action_cooldown = 0.4 SECONDS

/datum/ai_behavior/slime_feeding/perform(delta_time, datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/basic/slime/slime_pawn = controller.pawn
	var/mob/living/carbon/human/target_food = slime_pawn.buckled
	if(slime_pawn.stat || target_food.stat == DEAD)
		finish_action(controller, TRUE, target_key)
		return
	if(get_dist(slime_pawn, target_food) >= 1)
		finish_action(controller, TRUE, target_key)
		return
	if(slime_pawn.amount_grown >= SLIME_EVOLUTION_THRESHOLD) // a little extra so they don't immediately have to re-attach
		finish_action(controller, TRUE, target_key)
		return
	slime_pawn.handle_feeding(delta_time)

/datum/ai_behavior/slime_feed/finish_action(datum/ai_controller/controller, succeeded, target_key)
	var/mob/living/basic/slime/slime_pawn = controller.pawn
	slime_pawn.Feedstop()
	return ..()

/datum/ai_behavior/slime_process_nutrients
	action_cooldown = 0.4 SECONDS

/datum/ai_behavior/slime_process_nutrients/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic/slime/slime_pawn = controller.pawn

	if(!slime_pawn.stat)
		slime_pawn.handle_nutrition(delta_time)
		finish_action(controller, TRUE)
		return
	finish_action(controller, FALSE)
