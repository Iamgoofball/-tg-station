/datum/ai_controller/basic_controller/slime
	blackboard = list(
		BB_SLIME_FEED_TARGET = null
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/slime_feed
	)
