/obj/structure/keyhole
	name = "keyhole"
	desc = "A keyhole. I wonder what the key is?"
	icon = 'icons/obj/bitrunning/tomb.dmi'
	icon_state = "keyhole"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	var/trap_id_to_trigger = "CHANGEME"
	var/correct_key = /obj/singularity
	var/consumes_key = TRUE

/obj/structure/keyhole/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(istype(attacking_item, correct_key))
		src.balloon_alert_to_viewers("*click*")
		playsound(src, 'sound/machines/click.ogg', 100, TRUE)
		for(var/obj/effect/abstract/trap/trap_to_trigger in GLOB.traps_list)
			if(trap_to_trigger.trap_id == trap_id_to_trigger)
				trap_to_trigger.trigger_trap()
				continue
		if(consumes_key)
			qdel(attacking_item)
		qdel(src)
	else
		src.balloon_alert(user, "doesn't fit!")
