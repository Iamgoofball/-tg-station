/mob/living/basic/gargoyle
	name = "gargoyle"
	desc = "A vicious monster pretending to be a statue. If you're reading this and it's still alive, you might be dead."
	icon = 'icons/mob/simple/tomb.dmi'
	icon_state = "gargoyle"
	icon_living = "gargoyle"
	icon_dead = "gargoyle_dead"
	gold_core_spawnable = HOSTILE_SPAWN
	pass_flags = PASSTABLE | PASSGRILLE
	gender = NEUTER
	speak_emote = list("statues")
	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 0.5, BURN = 1.25, TOX = 1, CLONE = 1, STAMINA = 1, OXY = 1)
	health = 200
	maxHealth = 200
	combat_mode = TRUE
	melee_damage_lower = 12
	melee_damage_upper = 26
	attack_vis_effect = ATTACK_EFFECT_SLASH
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slashes"
	attack_sound = 'sound/weapons/slash.ogg'
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	death_message = "crumbles into rocks"
	armour_penetration = 15
	obj_damage = 5
	faction = list(FACTION_HOSTILE)
	ai_controller = /datum/ai_controller/basic_controller/gargoyle
	minimum_survivable_temperature = 250
	maximum_survivable_temperature = INFINITY
	speed = 1.5 // gargoyles are fast

/mob/living/basic/gargoyle/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)

/mob/living/basic/gargoyle/death(gibbed)
	. = ..()
	new /obj/structure/flora/rock/pile/style_random(get_turf(src))
	qdel(src)

/datum/ai_controller/basic_controller/gargoyle
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/attack_until_dead(),
	)

	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)
