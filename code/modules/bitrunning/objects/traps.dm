GLOBAL_LIST_EMPTY(traps_list)

/obj/effect/abstract/trap // rocks fall, spacemen die
	name = "generic trap"
	desc = "You shouldn't be able to see this, tell the dungeon master to use a dice shield."
	mouse_opacity = 0
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "trap"
	var/trap_id = "CHANGE ME OR SUFFER THE WRATH OF NON-FUNCTIONAL TRAPS"
	var/repeatable = FALSE
	var/triggered = FALSE

/obj/effect/abstract/trap/Initialize(mapload)
	. = ..()
	alpha = 0
	GLOB.traps_list += src

/obj/effect/abstract/trap/Destroy(force)
	GLOB.traps_list -= src
	. = ..()

/obj/effect/abstract/trap/proc/trigger_trap()
	SHOULD_CALL_PARENT(TRUE)
	if(triggered && !repeatable)
		return FALSE
	triggered = TRUE
	return TRUE

/obj/effect/abstract/trap/rocks_fall_everyone_dies
	name = "collapsing ceiling trap"

/obj/effect/abstract/trap/rocks_fall_everyone_dies/trigger_trap()
	if(!..())
		return
	var/turf/T = get_turf(src)
	new /obj/structure/flora/rock/style_random(T)
	for(var/mob/living/trapped_individual in T.contents)
		trapped_individual.balloon_alert(trapped_individual, "rocks fall!")
		trapped_individual.emote("scream")
		trapped_individual.gib(TRUE)

/obj/effect/abstract/trap/ceiling_lower
	name = "crushing ceiling trap"
	var/path_for_ceiling = /turf/closed/indestructible/iron

/obj/effect/abstract/trap/ceiling_lower/trigger_trap()
	if(!..())
		return
	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50)
	addtimer(CALLBACK(src, PROC_REF(lower_ceiling)), 4 SECONDS)

/obj/effect/abstract/trap/ceiling_lower/proc/lower_ceiling()
	var/turf/T = get_turf(src)
	playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50)
	T.ChangeTurf(path_for_ceiling)
	for(var/mob/living/trapped_individual in T.contents)
		trapped_individual.balloon_alert(trapped_individual, "rocks fall!")
		trapped_individual.emote("scream")
		trapped_individual.gib(TRUE)

/obj/effect/abstract/trap/create_turf
	name = "create turf trap"
	var/path_for_turf = /turf/closed/indestructible/iron

/obj/effect/abstract/trap/create_turf/trigger_trap()
	if(!..())
		return
	var/turf/T = get_turf(src)
	T.ChangeTurf(path_for_turf)

/obj/effect/abstract/trap/create_atom
	name = "create atom trap"
	var/path_for_atom = /mob/living/basic/snake
	var/amount_to_spawn = 1

/obj/effect/abstract/trap/create_atom/trigger_trap()
	if(!..())
		return
	var/turf/T = get_turf(src)
	for(var/i in 1 to amount_to_spawn)
		new path_for_atom(T, dir)

/obj/effect/abstract/trap/display_message
	name = "display message trap"
	var/text_to_display = "short msg here"

/obj/effect/abstract/trap/display_message/trigger_trap()
	if(!..())
		return
	var/turf/T = get_turf(src)
	T.balloon_alert_to_viewers(text_to_display)

/obj/effect/abstract/trap/fire_projectile
	name = "fire projectile trap"
	var/path_for_projectile = /obj/projectile/bullet/arrow

/obj/effect/abstract/trap/fire_projectile/trigger_trap()
	if(!..())
		return
	var/turf/starting_turf = get_turf(src)
	var/turf/target_turf = get_step(starting_turf, dir)
	var/obj/projectile/to_fire = new path_for_projectile()
	to_fire.preparePixelProjectile(target_turf, starting_turf)
	to_fire.fire()

/obj/effect/abstract/trap/chem_smoke
	name = "chemical smoke trap"
	var/smoke_radius = 3
	var/chem_volume = 50
	var/reagent_to_use = /datum/reagent/toxin/amatoxin

/obj/effect/abstract/trap/chem_smoke/trigger_trap()
	if(!..())
		return
	var/turf/starting_turf = get_turf(src)
	do_chem_smoke(smoke_radius, holder = src, location = starting_turf, reagent_type = reagent_to_use, reagent_volume = chem_volume)
