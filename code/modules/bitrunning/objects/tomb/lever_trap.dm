GLOBAL_LIST_EMPTY(trap_levers)

#define LEVER_POSITION_STARTING 0
#define LEVER_POSITION_UP 1
#define LEVER_POSITION_DOWN 2

/obj/structure/trap_levers
	name = "lever"
	desc = "Which way should it be flipped? Upwards or downwards?"
	icon = 'icons/obj/machines/recycling.dmi'
	icon_state = "switch-off"
	base_icon_state = "switch"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	var/position = LEVER_POSITION_STARTING
	var/up_trap_to_trigger
	var/down_trap_to_trigger
	var/puzzle_id

/obj/structure/trap_levers/Initialize(mapload)
	. = ..()
	GLOB.trap_levers += src

/obj/structure/trap_levers/Destroy(force)
	GLOB.trap_levers -= src
	. = ..()

/obj/structure/trap_levers/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	switch(position)
		if(LEVER_POSITION_STARTING)
			position = LEVER_POSITION_DOWN
			balloon_alert(user, "down")
		if(LEVER_POSITION_UP)
			position = LEVER_POSITION_DOWN
			balloon_alert(user, "down")
		if(LEVER_POSITION_DOWN)
			position = LEVER_POSITION_UP
			balloon_alert(user, "up")
	update_icon_state()
	var/levers_synchronized = position
	for(var/obj/structure/trap_levers/lever in GLOB.trap_levers)
		if(lever.puzzle_id != puzzle_id)
			continue
		if(lever.position != position)
			levers_synchronized = LEVER_POSITION_STARTING
			break
	var/trap_to_trigger_id
	switch(levers_synchronized)
		if(LEVER_POSITION_UP)
			trap_to_trigger_id = up_trap_to_trigger
		if(LEVER_POSITION_DOWN)
			trap_to_trigger_id = down_trap_to_trigger
	if(levers_synchronized)
		src.balloon_alert_to_viewers("*click*")
		playsound(src, 'sound/machines/click.ogg', 100, TRUE)
		for(var/obj/effect/abstract/trap/trap_to_trigger in GLOB.traps_list)
			if(trap_to_trigger.trap_id == trap_to_trigger_id)
				trap_to_trigger.trigger_trap()
				continue

// update the icon depending on the position
/obj/structure/trap_levers/update_icon_state()
	icon_state = "[base_icon_state]-off"
	switch(position)
		if(LEVER_POSITION_STARTING)
			icon_state = "[base_icon_state]-off"
		if(LEVER_POSITION_UP)
			icon_state = "[base_icon_state]-rev"
		if(LEVER_POSITION_DOWN)
			icon_state = "[base_icon_state]-fwd"
	return ..()
