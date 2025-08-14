GLOBAL_LIST_INIT(minimap_headsets, list())

/atom/movable/screen/SL_locator
	name = "sl locator"
	icon = 'icons/ui_icons/antags/pirates/tgmc_arrows.dmi'
	icon_state = "Blue_arrow"
	alpha = 128
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER,CENTER"

/datum/component/locator_and_minimap
	var/mob/living/carbon/human/wearer = null
	var/obj/item/radio/headset/our_headset
	var/marker_flags = MINIMAP_FLAG_TGMC
	var/atom/movable/screen/SL_locator/SL_locator
	var/icon_state_for_map = null
	var/map_type

/datum/component/locator_and_minimap/Initialize(map_type, marker_flags, icon_state_for_map)
	if(!istype(parent, /obj/item/radio/headset))
		return COMPONENT_INCOMPATIBLE
	src.marker_flags = marker_flags
	src.icon_state_for_map = icon_state_for_map
	src.map_type = map_type
	our_headset = parent
	GLOB.minimap_headsets += src
	our_headset.add_item_action(map_type)
	if(istype(our_headset.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/temp = our_headset.loc
		if(temp.ears == our_headset)
			wearer = temp
			RegisterSignals(wearer, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE), PROC_REF(update_minimap_icon))
			RegisterSignal(wearer, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
			update_minimap_icon()
			//squad leader locator
			SL_locator = new /atom/movable/screen/SL_locator(null, wearer?.hud_used)
			wearer?.hud_used?.infodisplay += SL_locator
			update_tracking()
			wearer?.hud_used?.show_hud(wearer?.hud_used?.hud_version)

/datum/component/locator_and_minimap/Destroy(force)
	GLOB.minimap_headsets -= src
	if(our_headset)
		our_headset.remove_item_action(map_type)
	our_headset = null
	. = ..()

/datum/component/locator_and_minimap/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_attached))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_detached))

/datum/component/locator_and_minimap/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	. = ..()

/datum/component/locator_and_minimap/proc/on_attached(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(slot == ITEM_SLOT_EARS)
		wearer = equipper
		RegisterSignals(wearer, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE), PROC_REF(update_minimap_icon))
		RegisterSignal(wearer, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
		RegisterSignal(wearer, COMSIG_MOB_LOGIN, PROC_REF(on_login))
		update_minimap_icon()
		//squad leader locator
		SL_locator = new /atom/movable/screen/SL_locator(null, wearer?.hud_used)
		wearer?.hud_used?.infodisplay += SL_locator
		update_tracking()
		wearer?.hud_used?.show_hud(wearer?.hud_used?.hud_version)

/datum/component/locator_and_minimap/proc/on_login(mob/source)
	SIGNAL_HANDLER
	if(!source.client)
		return
	SL_locator = new /atom/movable/screen/SL_locator(null, wearer?.hud_used)
	wearer?.hud_used?.infodisplay += SL_locator
	update_tracking()
	wearer?.hud_used?.show_hud(wearer?.hud_used?.hud_version)

/datum/component/locator_and_minimap/proc/on_detached(datum/source, mob/user)
	SIGNAL_HANDLER
	if(!QDELETED(user))
		SSminimaps.remove_marker(user)
		UnregisterSignal(user, list(COMSIG_LIVING_DEATH, COMSIG_LIVING_REVIVE, COMSIG_MOVABLE_MOVED, COMSIG_MOB_LOGIN))
		user?.hud_used?.infodisplay -= SL_locator
	qdel(SL_locator)
	wearer = null

/datum/component/locator_and_minimap/proc/on_moved(atom/movable/mover, turf/old_loc)
	SIGNAL_HANDLER
	if(our_headset.command)
		for(var/headset in GLOB.minimap_headsets)
			var/datum/component/locator_and_minimap/possible_tracker = headset
			if(possible_tracker.marker_flags & marker_flags)
				possible_tracker.update_tracking()
	else
		update_tracking()

///Updates the wearer's minimap icon
/datum/component/locator_and_minimap/proc/update_minimap_icon()
	SIGNAL_HANDLER
	SSminimaps.remove_marker(wearer)
	if(wearer.stat == DEAD)
		if(!wearer.mind)
			var/mob/dead/observer/ghost = wearer.get_ghost(TRUE)
			if(!ghost?.can_reenter_corpse)
				SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "unrevivable", MINIMAP_BLIPS_LAYER))
				return
		SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "revivable", MINIMAP_BLIPS_LAYER))
		return
	determine_icon()

/datum/component/locator_and_minimap/proc/determine_icon()
	if(icon_state_for_map)
		SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, icon_state_for_map, MINIMAP_BLIPS_LAYER))
		return
	var/obj/item/card/id/id_card = wearer.get_idcard(hand_first = FALSE)
	if(!id_card || !id_card.get_trim_assignment())
		SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "unknown", MINIMAP_BLIPS_LAYER))
		return
	switch(id_card.get_trim_assignment())
		if(JOB_HEAD_OF_SECURITY)
			SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "hos", MINIMAP_BLIPS_LAYER))
		if(JOB_SECURITY_OFFICER)
			SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "officer", MINIMAP_BLIPS_LAYER))
		if(JOB_DETECTIVE)
			SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "detective", MINIMAP_BLIPS_LAYER))
		if(JOB_WARDEN)
			SSminimaps.add_marker(wearer, marker_flags, image('icons/ui_icons/antags/pirates/tgmc_minimap_blips.dmi', null, "warden", MINIMAP_BLIPS_LAYER))

/datum/component/locator_and_minimap/proc/update_tracking()
	if(!wearer && !wearer.hud_used)
		SL_locator.icon_state = ""
		SL_locator.alpha = 0
		return
	if(our_headset.command)
		SL_locator.icon_state = ""
		SL_locator.alpha = 0
		return
	var/obj/item/radio/headset/found_commander
	for(var/headset in GLOB.minimap_headsets)
		var/datum/component/locator_and_minimap/possible_commander = headset
		if(possible_commander.our_headset.command && (possible_commander.marker_flags & marker_flags))
			found_commander = possible_commander.our_headset
			break
	if(!found_commander || QDELETED(found_commander))
		SL_locator.icon_state = ""
		SL_locator.alpha = 0
		return
	SL_locator.icon_state = "Blue_arrow"
	SL_locator.alpha = 128
	SL_locator.transform = 0 //Reset and 0 out
	SL_locator.transform = turn(SL_locator.transform, get_angle(wearer, get_turf(found_commander)))
