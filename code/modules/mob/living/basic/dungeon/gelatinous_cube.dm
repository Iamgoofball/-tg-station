/mob/living/basic/gelatinous_cube
	name = "gelatinous cube"
	desc = "Found underground or in dungeons, these quivering cubes of slime continuously scour their domain for food. The acid in their bodies is weak enough that many gelatinous cubes still contain the gear of their victims, as they're unable to break them down."
	icon = 'icons/mob/vatgrowing.dmi'
	icon_state = "gelatinous"
	icon_living = "gelatinous"
	icon_dead = "gelatinous_dead"
	gold_core_spawnable = HOSTILE_SPAWN
	pass_flags = PASSTABLE | PASSGRILLE
	gender = NEUTER
	speak_emote = list("blorbles")
	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	health = 200
	maxHealth = 200
	combat_mode = TRUE
	melee_damage_lower = 1
	melee_damage_upper = 6
	attack_vis_effect = ATTACK_EFFECT_SMASH
	attack_verb_continuous = "slimes"
	attack_verb_simple = "slime"
	attack_sound = 'sound/effects/blobattack.ogg'
	melee_attack_cooldown = 1.5 SECONDS
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	death_message = "collapses into a pile of goo!"
	armour_penetration = 15
	obj_damage = 20
	faction = list(FACTION_SLIME)
	ai_controller = /datum/ai_controller/basic_controller/gelatinous_cube
	minimum_survivable_temperature = 250
	maximum_survivable_temperature = INFINITY
	alpha = 50 // Cubes are hard to spot at first, they're so transparent.
	max_buckled_mobs = 4 // able to eat an entire adventuring party at once
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	base_pixel_x = 16
	base_pixel_y = 16
	speed = 0.8

/mob/living/basic/gelatinous_cube/Initialize(mapload)
	. = ..()
	transform *= 2
	RegisterSignal(src, COMSIG_LIVING_MOB_BUMP, PROC_REF(check_bump))
	RegisterSignal(src, COMSIG_ATOM_BUMPED, PROC_REF(bumped_hit))

/mob/living/basic/gelatinous_cube/Destroy()
	. = ..()
	UnregisterSignal(src, COMSIG_LIVING_MOB_BUMP)

/mob/living/basic/gelatinous_cube/death(gibbed)
	if(src.has_buckled_mobs())
		src.unbuckle_all_mobs()
	. = ..()

/mob/living/basic/gelatinous_cube/Life(seconds_per_tick, times_fired)
	. = ..()
	if(!src.stat)
		if(src.has_buckled_mobs())
			for(var/mob/living/victim in src.buckled_mobs)
				if(prob(15))
					victim.emote("scream")
				victim.take_overall_damage(burn = roll("2d6"))
				victim.acid_act(2, 15)
				victim.Stun(3 SECONDS)
				victim.Paralyze(3 SECONDS)
				if(victim.stat == DEAD)
					unbuckle_mob(victim, force = TRUE)

/mob/living/basic/gelatinous_cube/proc/check_bump(mob/living/bumper, mob/living/victim)
	SIGNAL_HANDLER
	if(stat)
		return
	engulf_victim(victim)

/mob/living/basic/gelatinous_cube/proc/bumped_hit(datum/source, atom/movable/hit_object)
	SIGNAL_HANDLER
	if(stat)
		return
	if(isliving(hit_object))
		engulf_victim(hit_object)

/mob/living/basic/gelatinous_cube/proc/engulf_victim(mob/living/victim)
	if(victim.stat)
		return
	victim.balloon_alert_to_viewers("engulfed!")
	src.buckle_mob(victim, force = TRUE)
	victim.Stun(3 SECONDS)
	victim.Paralyze(3 SECONDS)
	alpha = 200 // the jig is up

/mob/living/basic/gelatinous_cube/melee_attack(atom/target, list/modifiers, ignore_cooldown)
	. = ..()
	if(!.)
		return
	alpha = 200 // the jig is up
	target.acid_act(2, 15)

/datum/ai_controller/basic_controller/gelatinous_cube
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/attack_until_dead(),
	)

	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior // we want them to hold still as their initial advantage is the fact they're hard to spot for the engulf
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target/ignore_buckled,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/gelatinous_cube_engulf_subtree,
	)

/datum/ai_planning_subtree/gelatinous_cube_engulf_subtree
	/// What do we do in order to engulf someone?
	var/datum/ai_behavior/gelatinous_cube_engulf/engulf_behavior = /datum/ai_behavior/gelatinous_cube_engulf
	/// Is this the last thing we do? (if we set a movement target, this will usually be yes)
	var/end_planning = TRUE

/datum/ai_planning_subtree/gelatinous_cube_engulf_subtree/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(!controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
		return
	controller.queue_behavior(engulf_behavior, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETTING_DATUM)
	if (end_planning)
		return SUBTREE_RETURN_FINISH_PLANNING

/datum/ai_behavior/gelatinous_cube_engulf
	action_cooldown = 2 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/gelatinous_cube_engulf/setup(datum/ai_controller/controller, target_key, targetting_datum_key)
	. = ..()
	if(!controller.blackboard_key_exists(targetting_datum_key))
		CRASH("No target datum was supplied in the blackboard for [controller.pawn]")

	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/gelatinous_cube_engulf/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targetting_datum_key)
	if (isliving(controller.pawn))
		var/mob/living/pawn = controller.pawn
		if (world.time < pawn.next_move)
			return

	. = ..()
	var/mob/living/basic/basic_mob = controller.pawn

	var/atom/target = controller.blackboard[target_key]
	var/datum/targetting_datum/targetting_datum = controller.blackboard[targetting_datum_key]

	if(!targetting_datum.can_attack(basic_mob, target))
		finish_action(controller, FALSE, target_key)
		return
	basic_mob.Move(get_turf(target))
	if(length(basic_mob.buckled_mobs) && basic_mob.buckled_mobs.Find(target))
		finish_action(controller, TRUE, target_key)
		return
	finish_action(controller, FALSE, target_key)


/datum/ai_behavior/gelatinous_cube_engulf/finish_action(datum/ai_controller/controller, succeeded, target_key, targetting_datum_key)
	. = ..()
	controller.clear_blackboard_key(target_key)

/datum/ai_planning_subtree/simple_find_target/ignore_buckled
	behavior = /datum/ai_behavior/find_potential_targets/no_buckle

/datum/ai_behavior/find_potential_targets/no_buckle/pick_final_target(datum/ai_controller/controller, list/filtered_targets)
	var/mob/living/basic/basic_mob = controller.pawn
	if(!length(basic_mob.buckled_mobs))
		return pick(filtered_targets)
	for(var/mob/living/potential_buckled in filtered_targets)
		if(basic_mob.buckled_mobs.Find(potential_buckled))
			filtered_targets -= potential_buckled
			continue
	return pick(filtered_targets)
