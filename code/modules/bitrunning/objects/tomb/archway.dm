GLOBAL_VAR_INIT(archway_puzzle_failure, null)
GLOBAL_VAR_INIT(archway_puzzle_success, null)
GLOBAL_VAR_INIT(archway2_puzzle_gear_location, null)
GLOBAL_VAR_INIT(archway2_puzzle_entrance, null)

/obj/structure/trap_archway
	name = "archway"
	desc = "Three large stones are embedded in the arch. Each has a different hue; yellow on the lower left, bluish at the top of the arch, and orange on the lower right."
	icon = 'icons/obj/bitrunning/tomb.dmi'
	icon_state = "archway"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	var/list/gemstones = list("Blue", "Yellow", "Orange")
	var/solved = FALSE
	var/solved_state = "archway_finished"
	opacity = TRUE

/obj/structure/trap_archway/Initialize(mapload)
	. = ..()
	var/turf/my_turf = get_turf(src)
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(crossed_archway))

/obj/structure/trap_archway/Destroy()
	. = ..()
	var/turf/my_turf = get_turf(src)
	UnregisterSignal(my_turf, COMSIG_ATOM_ENTERED)

/obj/structure/trap_archway/proc/crossed_archway(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(isitem(arrived))
		var/obj/item/I = arrived
		if(I.item_flags & ABSTRACT)
			return
	teleport(arrived)

/obj/structure/trap_archway/proc/teleport(atom/movable/target)
	var/turf/location = GLOB.archway_puzzle_failure
	if(solved)
		location = GLOB.archway_puzzle_success
	new /obj/effect/temp_visual/wizard(location, target.dir)
	target.forceMove(location)
	new /obj/effect/temp_visual/wizard/out(location, target.dir)

/obj/structure/trap_archway/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(solved)
		src.balloon_alert_to_viewers("gems don't react!")
		return
	var/choice_1 = tgui_input_list(user, "Which gem to touch?", "Archway", gemstones)
	if(isnull(choice_1))
		to_chat(user, span_warning("You decide to stop touching the stones."))
		return
	src.balloon_alert_to_viewers("*click*")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)
	var/choice_2 = tgui_input_list(user, "Which gem to touch?", "Archway", gemstones)
	if(isnull(choice_2))
		to_chat(user, span_warning("You decide to stop touching the stones."))
		return
	src.balloon_alert_to_viewers("*click*")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)
	var/choice_3 = tgui_input_list(user, "Which gem to touch?", "Archway", gemstones)
	if(isnull(choice_3))
		to_chat(user, span_warning("You decide to stop touching the stones."))
		return
	src.balloon_alert_to_viewers("*click*")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)
	if(choice_1 == "Yellow" && choice_2 == "Blue" && choice_3 == "Orange")
		src.balloon_alert_to_viewers("the mists clear")
		solved = TRUE
		opacity = FALSE
		icon_state = solved_state
		// todo: add sfx here
	else
		src.balloon_alert_to_viewers("the archway hums")

/obj/effect/mapping_helpers/archway_success
	name = "archway success teleport location"
	late = TRUE
	icon_state = "component"

/obj/effect/mapping_helpers/archway_success/LateInitialize()
	var/turf/target = get_turf(src)
	GLOB.archway_puzzle_success = target
	qdel(src)

/obj/effect/mapping_helpers/archway_failure
	name = "archway failure teleport location"
	late = TRUE
	icon_state = "component"

/obj/effect/mapping_helpers/archway_failure/LateInitialize()
	var/turf/target = get_turf(src)
	GLOB.archway_puzzle_failure = target
	qdel(src)

/obj/structure/trap_archway/clothing_thief
	icon_state = "archway_fake"
	gemstones = list("Olive", "Citron", "Russet") // yes, not being able to solve this is intentional

/obj/structure/trap_archway/clothing_thief/teleport(atom/movable/target)
	var/turf/location = GLOB.archway2_puzzle_entrance
	var/turf/gear_location = GLOB.archway2_puzzle_gear_location
	if(isliving(target))
		var/mob/living/sucker = target
		for(var/obj/item/equipped_item in sucker.get_equipped_items(include_pockets = TRUE))
			sucker.dropItemToGround(equipped_item)
			equipped_item.forceMove(gear_location)
		for(var/obj/item/held_item in sucker.held_items)
			sucker.dropItemToGround(held_item)
			held_item.forceMove(gear_location)
		new /obj/effect/temp_visual/wizard(location, target.dir)
		target.forceMove(location)
		new /obj/effect/temp_visual/wizard/out(location, target.dir)
	else
		target.forceMove(gear_location)

/obj/effect/mapping_helpers/archway2_gear
	name = "clothing thief archway gear teleport location"
	late = TRUE
	icon_state = "component"

/obj/effect/mapping_helpers/archway2_gear/LateInitialize()
	var/turf/target = get_turf(src)
	GLOB.archway2_puzzle_gear_location = target
	qdel(src)


/obj/effect/mapping_helpers/archway2_location
	name = "clothing thief archway teleport location"
	late = TRUE
	icon_state = "component"

/obj/effect/mapping_helpers/archway2_location/LateInitialize()
	var/turf/target = get_turf(src)
	GLOB.archway2_puzzle_entrance = target
	qdel(src)
