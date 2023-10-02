/obj/structure/trap_gargoyle_head
	name = "face of the great green devil"
	desc = "The devil's mouth gapes wide and empty; in fact it is dead black, emitting no hint of light and allowing none entry."
	icon = 'icons/obj/bitrunning/tomb.dmi'
	icon_state = "gargoyle_mouth"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE

/obj/structure/trap_gargoyle_head/Initialize(mapload)
	. = ..()
	var/turf/my_turf = get_turf(src)
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, PROC_REF(crossed_gargoyle))

/obj/structure/trap_gargoyle_head/Destroy()
	. = ..()
	var/turf/my_turf = get_turf(src)
	UnregisterSignal(my_turf, COMSIG_ATOM_ENTERED)

/obj/structure/trap_gargoyle_head/proc/crossed_gargoyle(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(isitem(arrived))
		var/obj/item/I = arrived
		if(I.item_flags & ABSTRACT)
			return
	skill_issue(arrived)

/obj/structure/trap_gargoyle_head/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	skill_issue(user)

/obj/structure/trap_gargoyle_head/proc/skill_issue(atom/movable/skill_issuer)
	if(isliving(skill_issuer))
		var/mob/living/annihilation_enjoyer = skill_issuer
		INVOKE_ASYNC(annihilation_enjoyer, TYPE_PROC_REF(/mob, emote), "scream")
		annihilation_enjoyer.balloon_alert_to_viewers("sucked into gargoyle head!")
		annihilation_enjoyer.dust(force = TRUE)
		return
	qdel(skill_issuer)
