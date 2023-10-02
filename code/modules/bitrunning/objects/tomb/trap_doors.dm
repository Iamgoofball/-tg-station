/obj/structure/mineral_door/iron/trap
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	var/list/choices = list(
		"Pull down",
		"Pivot centrally",
		"Pull inward and up at bottom",
		"Slide up",
		"Pull double panels inward",
		"Slide left",
		"Press all studs"
	)
	var/correct_choice = "Pull down"
	var/trap_to_trigger_id

/obj/structure/mineral_door/iron/trap/TryToSwitchState(atom/user)
	if(door_opened)
		src.balloon_alert(user, "door already open!")
		return
	var/choice = tgui_input_list(user, "How do you open this door?", name, shuffle(choices))
	if(!choice)
		to_chat(user, "You decide not to try the door.")
		return
	if(choice != correct_choice)
		src.balloon_alert_to_viewers("*click*")
		playsound(src, 'sound/machines/click.ogg', 100, TRUE)
		for(var/obj/effect/abstract/trap/trap_to_trigger in GLOB.traps_list)
			if(trap_to_trigger.trap_id == trap_to_trigger_id)
				trap_to_trigger.trigger_trap()
				continue
		return
	..()

/obj/structure/mineral_door/iron/trap/a
	correct_choice = "Pull down"
	trap_to_trigger_id = "room10_1"

/obj/structure/mineral_door/iron/trap/b
	correct_choice = "Pivot centrally"
	trap_to_trigger_id = "room10_1"

/obj/structure/mineral_door/iron/trap/c
	correct_choice = "Pull inward and up at bottom"
	trap_to_trigger_id = "room10_1"

/obj/structure/mineral_door/iron/trap/d
	correct_choice = "Slide up"
	trap_to_trigger_id = "room10_2"

/obj/structure/mineral_door/iron/trap/e
	correct_choice = "Pull double panels inward"
	trap_to_trigger_id = "room10_2"

/obj/structure/mineral_door/iron/trap/f
	correct_choice = "Slide left"
	trap_to_trigger_id = "room10_3"

/obj/structure/mineral_door/iron/trap/g
	correct_choice = "Press all studs"
	trap_to_trigger_id = "room10_4"

