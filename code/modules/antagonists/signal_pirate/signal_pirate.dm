#define SIGNAL_PIRATE_REQUIRED_AREAS 3
#define SIGNAL_PIRATE_SECONDS_PER_AREA 60

/**
 * A low-impact, location-control antagonist built around a deployable transmitter.
 *
 * Signal pirates must expose their transmitter in several station areas long enough
 * to finish a broadcast. The loud transmitter gives the crew useful counterplay,
 * while accepting an area only once keeps the pirate moving around the station.
 */
/datum/antagonist/signal_pirate
	name = "Signal Pirate"
	roundend_category = "signal pirates"
	antagpanel_category = "Signal Pirate"
	show_name_in_check_antagonists = TRUE
	show_to_ghosts = TRUE
	hardcore_random_bonus = TRUE
	suicide_cry = "THE AIRWAVES WANT TO BE FREE!!"
	preview_outfit = /datum/outfit/signal_pirate
	/// Mapping of area type to the number of seconds broadcast there.
	var/list/broadcast_time_by_area = list()
	/// Weak reference to the transmitter supplied on gain.
	var/datum/weakref/transmitter_ref
	/// Kept configurable for admins and focused unit tests.
	var/required_areas = SIGNAL_PIRATE_REQUIRED_AREAS
	var/seconds_per_area = SIGNAL_PIRATE_SECONDS_PER_AREA

/datum/antagonist/signal_pirate/on_gain()
	forge_objectives()
	issue_transmitter()
	return ..()

/datum/antagonist/signal_pirate/on_removal()
	var/obj/item/signal_pirate_transmitter/transmitter = transmitter_ref?.resolve()
	transmitter?.unlink_pirate()
	return ..()

/datum/antagonist/signal_pirate/greet()
	play_stinger()
	to_chat(owner, span_boldwarning("You are a signal pirate! Your sponsor wants its forbidden programme carried over Nanotrasen's airwaves."))
	to_chat(owner, span_notice("Deploy your transmitter in several station areas. It is noisy and must remain exposed, so move before Security triangulates you."))
	owner.announce_objectives()

/datum/antagonist/signal_pirate/forge_objectives()
	var/datum/objective/signal_pirate/broadcast_objective = new
	broadcast_objective.owner = owner
	objectives += broadcast_objective

	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = owner
	objectives += escape_objective

/// Supplies the role's core equipment, falling back to the owner's feet if both hands are full.
/datum/antagonist/signal_pirate/proc/issue_transmitter()
	if(!isliving(owner.current))
		return
	var/mob/living/pirate = owner.current
	var/obj/item/signal_pirate_transmitter/transmitter = new(pirate.drop_location())
	transmitter.link_pirate(src)
	transmitter_ref = WEAKREF(transmitter)
	pirate.put_in_hands(transmitter)

/// Credits elapsed broadcast time. Each physical area type may satisfy the objective only once.
/datum/antagonist/signal_pirate/proc/record_broadcast(area_type, elapsed_seconds)
	if(!ispath(area_type, /area) || elapsed_seconds <= 0)
		return
	broadcast_time_by_area[area_type] = min(seconds_per_area, (broadcast_time_by_area[area_type] || 0) + elapsed_seconds)

/// Returns how many distinct areas have carried a complete broadcast.
/datum/antagonist/signal_pirate/proc/completed_broadcasts()
	. = 0
	for(var/area_type in broadcast_time_by_area)
		if(broadcast_time_by_area[area_type] >= seconds_per_area)
			.++

/datum/antagonist/signal_pirate/antag_panel_data()
	return "Completed broadcasts: [completed_broadcasts()]/[required_areas]"

/datum/objective/signal_pirate
	name = "broadcast pirate radio"

/datum/objective/signal_pirate/update_explanation_text()
	var/datum/antagonist/signal_pirate/pirate = owner?.has_antag_datum(/datum/antagonist/signal_pirate)
	if(!pirate)
		explanation_text = "Broadcast pirate radio from several distinct station areas."
		return
	explanation_text = "Complete a [DisplayTimeText(pirate.seconds_per_area SECONDS)] transmission in each of [pirate.required_areas] distinct station areas."

/datum/objective/signal_pirate/check_completion()
	var/datum/antagonist/signal_pirate/pirate = owner?.has_antag_datum(/datum/antagonist/signal_pirate)
	return pirate && pirate.completed_broadcasts() >= pirate.required_areas

/datum/outfit/signal_pirate
	name = "Signal Pirate (Preview only)"
	uniform = /obj/item/clothing/under/misc/overalls
	suit = /obj/item/clothing/suit/jacket/leather
	head = /obj/item/clothing/head/soft/black
	ears = /obj/item/radio/headset
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots

/** The signal pirate's loud, deployable objective item. */
/obj/item/signal_pirate_transmitter
	name = "bootleg subspace transmitter"
	desc = "A compact transmitter assembled from mismatched radio parts. Its display reads OFF AIR."
	icon = 'icons/obj/devices/signal_pirate.dmi'
	icon_state = "transmitter_off"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 5
	item_flags = NO_PIXEL_RANDOM_DROP
	/// The role receiving credit for this transmitter's broadcasts.
	var/datum/weakref/pirate_ref
	var/broadcasting = FALSE
	var/next_noise = 0

/obj/item/signal_pirate_transmitter/Destroy()
	stop_broadcasting()
	pirate_ref = null
	return ..()

/obj/item/signal_pirate_transmitter/proc/link_pirate(datum/antagonist/signal_pirate/pirate)
	pirate_ref = WEAKREF(pirate)

/obj/item/signal_pirate_transmitter/proc/unlink_pirate()
	stop_broadcasting()
	pirate_ref = null

/obj/item/signal_pirate_transmitter/update_icon_state()
	icon_state = broadcasting ? "transmitter_on" : "transmitter_off"
	return ..()

/obj/item/signal_pirate_transmitter/examine(mob/user)
	. = ..()
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	if(pirate)
		. += span_notice("The counter reads [pirate.completed_broadcasts()]/[pirate.required_areas] complete area broadcasts.")

/// Deploy and immediately activate the transmitter from the user's hand.
/obj/item/signal_pirate_transmitter/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE
	if(!pirate_ref?.resolve())
		user.balloon_alert(user, "no subscriber linked!")
		return TRUE
	var/turf/deployment_turf = get_turf(user)
	var/area/deployment_area = get_area(deployment_turf)
	if(!deployment_turf || !is_station_level(deployment_turf.z) || !(deployment_area.area_flags & VALID_TERRITORY))
		user.balloon_alert(user, "no station signal here!")
		return TRUE
	user.temporarilyRemoveItemFromInventory(src)
	forceMove(deployment_turf)
	set_anchored(TRUE)
	start_broadcasting()
	user.visible_message(
		span_warning("[user] unfolds and activates [src]!"),
		span_notice("You deploy [src]. Its carrier wave is already traceable."),
	)
	return TRUE

/// Clicking an anchored unit turns it off; a wrench is still needed to retrieve it.
/obj/item/signal_pirate_transmitter/attack_hand(mob/user, list/modifiers)
	if(anchored)
		if(broadcasting)
			stop_broadcasting()
			user.visible_message(span_notice("[user] switches [src] off."))
		else
			user.balloon_alert(user, "wrench it loose!")
		return
	return ..()

/obj/item/signal_pirate_transmitter/wrench_act(mob/living/user, obj/item/tool)
	if(!anchored)
		return FALSE
	tool.play_tool_sound(src)
	stop_broadcasting()
	set_anchored(FALSE)
	user.visible_message(span_notice("[user] wrenches [src] free."))
	return TRUE

/obj/item/signal_pirate_transmitter/proc/start_broadcasting()
	if(broadcasting)
		return
	broadcasting = TRUE
	next_noise = world.time + 5 SECONDS
	START_PROCESSING(SSobj, src)
	update_appearance()

/obj/item/signal_pirate_transmitter/proc/stop_broadcasting()
	if(!broadcasting)
		return
	broadcasting = FALSE
	STOP_PROCESSING(SSobj, src)
	update_appearance()

/obj/item/signal_pirate_transmitter/process(seconds_per_tick)
	var/turf/transmitter_turf = get_turf(src)
	var/area/transmitter_area = get_area(src)
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	if(!anchored || !transmitter_turf || !pirate || !is_station_level(transmitter_turf.z) || !(transmitter_area.area_flags & VALID_TERRITORY))
		stop_broadcasting()
		return PROCESS_KILL

	pirate.record_broadcast(transmitter_area.type, seconds_per_tick)
	if(world.time >= next_noise)
		next_noise = world.time + 10 SECONDS
		playsound(src, 'sound/machines/beep/twobeep_high.ogg', 45, TRUE)
		visible_message(span_warning("[src] crackles, \"You're listening to FREE SPACE RADIO!\""))

#undef SIGNAL_PIRATE_REQUIRED_AREAS
#undef SIGNAL_PIRATE_SECONDS_PER_AREA
