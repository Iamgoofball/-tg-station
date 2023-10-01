/datum/component/trap_trigger
	dupe_mode = COMPONENT_DUPE_ALLOWED
	// What trap ID should we trigger?
	var/trap_id_to_trigger

/datum/component/trap_trigger/Initialize(trap_id_to_trigger, triggers_on_crossed = TRUE, triggers_on_clicked = FALSE, triggers_on_attacked = FALSE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.trap_id_to_trigger = trap_id_to_trigger
	if(triggers_on_crossed)
		RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(crossed_trigger_trap))

	if(triggers_on_clicked)
		RegisterSignal(parent, COMSIG_CLICK, PROC_REF(click_trigger_trap))

	if(triggers_on_attacked)
		RegisterSignal(parent, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(attack_trigger_trap))

/datum/component/trap_trigger/proc/crossed_trigger_trap(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	var/turf/open/trapdoor_turf = parent
	if(isitem(arrived))
		var/obj/item/I = arrived
		if(I.item_flags & ABSTRACT)
			return
	if(arrived.movement_type & (FLYING|FLOATING) || !arrived.has_gravity())
		return
	trigger_trap()

/datum/component/trap_trigger/proc/attack_trigger_trap(datum/source, mob/attacker)
	SIGNAL_HANDLER
	trigger_trap()

/datum/component/trap_trigger/proc/click_trigger_trap(atom/source, location, control, params, user)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, LEFT_CLICK))
		trigger_trap()

/datum/component/trap_trigger/proc/trigger_trap()
	var/atom/atom_parent = parent
	atom_parent.balloon_alert_to_viewers("*click*")
	playsound(atom_parent, 'sound/machines/click.ogg', 100, TRUE)
	for(var/obj/effect/abstract/trap/trap_to_trigger in GLOB.traps_list)
		if(trap_to_trigger.trap_id == trap_id_to_trigger)
			trap_to_trigger.trigger_trap()
			continue
