#define SIGNAL_PIRATE_REQUIRED_AREAS 4
#define SIGNAL_PIRATE_SECONDS_PER_AREA 75
#define SIGNAL_PIRATE_INTERFERENCE_INTERVAL 20 SECONDS
#define SIGNAL_PIRATE_NOISE_DELAY 5 SECONDS
#define SIGNAL_PIRATE_NOISE_INTERVAL 10 SECONDS
#define SIGNAL_PIRATE_RETUNE_TIME 5 SECONDS
#define SIGNAL_PIRATE_RETUNE_REDUCTION 20
#define SIGNAL_PIRATE_EMP_RANGE 2
#define SIGNAL_PIRATE_HIJACK_RANGE 7
#define SIGNAL_PIRATE_DISPLAY_RESET_DELAY 5 SECONDS
#define SIGNAL_PIRATE_RELAY_OVERLOAD 25

GLOBAL_LIST_EMPTY(signal_pirate_start)

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
	/// Weak reference to the player-controlled transmitter recruited on gain.
	var/datum/weakref/transmitter_ref
	/// Weak reference to the handheld jammer charged by successful broadcasts.
	var/datum/weakref/jammer_ref
	/// Kept configurable for admins and focused unit tests.
	var/required_areas = SIGNAL_PIRATE_REQUIRED_AREAS
	var/seconds_per_area = SIGNAL_PIRATE_SECONDS_PER_AREA
	/// Disabled only by focused tests which do not need to exercise a live lazy-template load.
	var/should_move_to_shuttle = TRUE
	/// Disabled by focused tests so that they need not open a live ghost poll.
	var/should_recruit_transmitter = TRUE

/// Sets up the pirate's objectives, equipment, shuttle placement, and transmitter operator.
/datum/antagonist/signal_pirate/on_gain()
	forge_objectives()
	issue_equipment()
	. = ..()
	if(should_move_to_shuttle)
		INVOKE_ASYNC(src, PROC_REF(move_to_shuttle))
	if(should_recruit_transmitter)
		INVOKE_ASYNC(src, PROC_REF(recruit_transmitter_operator))
	return .

/// Marks the pirate as friendly to the shuttle's defensive turrets for exactly as long as the role is held.
/datum/antagonist/signal_pirate/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/pirate = mob_override || owner.current
	pirate?.add_faction(FACTION_PIRATE)

/// Removes the shuttle-turret faction when the Signal Pirate role is lost, mirroring the effect applied on gain.
/datum/antagonist/signal_pirate/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/pirate = mob_override || owner.current
	pirate?.remove_faction(FACTION_PIRATE)

/// Loads the Freewave shuttle if necessary and moves the pirate to its spawn landmark.
/datum/antagonist/signal_pirate/proc/move_to_shuttle()
	var/mob/living/pirate = owner?.current
	if(!pirate)
		return
	if(!length(GLOB.signal_pirate_start))
		SSmapping.lazy_load_template(LAZY_TEMPLATE_KEY_SIGNAL_PIRATE)
	if(length(GLOB.signal_pirate_start) && !QDELETED(pirate))
		pirate.forceMove(pick(GLOB.signal_pirate_start))

/// Unlinks role equipment when the antagonist datum is removed.
/datum/antagonist/signal_pirate/on_removal()
	var/mob/living/basic/signal_pirate_transmitter/transmitter = transmitter_ref?.resolve()
	transmitter?.unlink_pirate()
	var/obj/item/signal_pirate_jammer/jammer = jammer_ref?.resolve()
	jammer?.pirate_ref = null
	return ..()

/// Displays the role introduction and objectives.
/datum/antagonist/signal_pirate/greet()
	play_stinger()
	to_chat(owner, span_boldwarning("You are a Signal Pirate! Your sponsor wants its forbidden program carried over Nanotrasen's airwaves."))
	to_chat(owner, span_notice("Hijack four station areas. Your transmitter emits disruptive EMP static, and each completed hijack charges your feedback spike."))
	owner.announce_objectives()

/// Creates the broadcast and escape objectives.
/datum/antagonist/signal_pirate/forge_objectives()
	var/datum/objective/signal_pirate/broadcast_objective = new
	broadcast_objective.owner = owner
	objectives += broadcast_objective

	var/datum/objective/escape/escape_objective = new
	escape_objective.owner = owner
	objectives += escape_objective

/// Gives the pirate their jammer and broadcast coat.
/datum/antagonist/signal_pirate/proc/issue_equipment()
	if(!isliving(owner.current))
		return
	var/mob/living/pirate = owner.current
	var/obj/item/signal_pirate_jammer/jammer = new(pirate.drop_location())
	jammer.pirate_ref = WEAKREF(src)
	jammer_ref = WEAKREF(jammer)
	pirate.put_in_hands(jammer)
	var/obj/item/clothing/suit/armor/signal_pirate/coat = new(pirate.drop_location())
	pirate.equip_to_slot_if_possible(coat, ITEM_SLOT_OCLOTHING, disable_warning = TRUE)

/// Polls ghosts for a transmitter operator and creates the mobile transmitter.
/datum/antagonist/signal_pirate/proc/recruit_transmitter_operator()
	var/mob/living/pirate = owner?.current
	if(!pirate || QDELETED(src))
		return
	var/mob/dead/observer/candidate = SSpolling.poll_ghost_candidates(
		"Would you like to control a Signal Pirate's mobile transmitter?",
		check_jobban = ROLE_SIGNAL_PIRATE,
		poll_time = 20 SECONDS,
		alert_pic = /mob/living/basic/signal_pirate_transmitter,
		jump_target = pirate,
		role_name_text = "Signal Pirate transmitter",
		amount_to_pick = 1,
	)
	if(!candidate || !owner?.current)
		to_chat(owner, span_warning("No operator answered the transmitter poll. Your Signal Pirate role has been removed."))
		owner?.remove_antag_datum(type)
		return
	var/mob/living/basic/signal_pirate_transmitter/transmitter = new(get_turf(owner.current))
	transmitter.link_pirate(src)
	transmitter_ref = WEAKREF(transmitter)
	transmitter.PossessByPlayer(candidate.key)
	to_chat(transmitter, span_boldnotice("You control the Signal Pirate's mobile transmitter. Travel to distinct station areas and use your Broadcast action to hijack each feed."))
	to_chat(owner, span_boldnotice("A volunteer now controls your mobile transmitter."))

/// Records elapsed broadcast time and charges the jammer when an area is completed.
/datum/antagonist/signal_pirate/proc/record_broadcast(area_type, elapsed_seconds)
	if(!ispath(area_type, /area) || elapsed_seconds <= 0)
		return
	var/old_elapsed_seconds = broadcast_time_by_area[area_type] || 0
	broadcast_time_by_area[area_type] = min(seconds_per_area, old_elapsed_seconds + elapsed_seconds)
	if(old_elapsed_seconds < seconds_per_area && broadcast_time_by_area[area_type] >= seconds_per_area)
		var/obj/item/signal_pirate_jammer/jammer = jammer_ref?.resolve()
		jammer?.add_charge()
		to_chat(owner, span_boldnotice("Area feed hijacked! Your scrambler gained one disruption charge."))

/// Returns the number of distinct areas with completed broadcasts.
/datum/antagonist/signal_pirate/proc/completed_broadcasts()
	. = 0
	for(var/area_type in broadcast_time_by_area)
		if(broadcast_time_by_area[area_type] >= seconds_per_area)
			.++

/// Returns broadcast progress for the antagonist panel.
/datum/antagonist/signal_pirate/antag_panel_data()
	return "Completed broadcasts: [completed_broadcasts()]/[required_areas]"

/datum/objective/signal_pirate
	name = "broadcast pirate radio"

/// Updates the objective text with the role's configured requirements.
/datum/objective/signal_pirate/update_explanation_text()
	var/datum/antagonist/signal_pirate/pirate = owner?.has_antag_datum(/datum/antagonist/signal_pirate)
	if(!pirate)
		explanation_text = "Broadcast pirate radio from several distinct station areas."
		return
	explanation_text = "Hijack [pirate.required_areas] distinct station areas by broadcasting for [DisplayTimeText(pirate.seconds_per_area SECONDS)] in each. Your broadcasts disrupt nearby electronics and charge your handheld scrambler."

/// Returns whether the pirate has completed enough distinct broadcasts.
/datum/objective/signal_pirate/check_completion()
	var/datum/antagonist/signal_pirate/pirate = owner?.has_antag_datum(/datum/antagonist/signal_pirate)
	return pirate && pirate.completed_broadcasts() >= pirate.required_areas

/datum/outfit/signal_pirate
	name = "Signal Pirate (Preview only)"
	uniform = /obj/item/clothing/under/misc/overalls
	suit = /obj/item/clothing/suit/armor/signal_pirate
	head = /obj/item/clothing/head/soft/black
	ears = /obj/item/radio/headset
	gloves = /obj/item/clothing/gloves/color/black
	shoes = /obj/item/clothing/shoes/jackboots

/// Custom, lightly armored broadcast coat that is conspicuous rather than syndicate-grade.
/obj/item/clothing/suit/armor/signal_pirate
	name = "freewave broadcast coat"
	desc = "A customizable armored broadcast coat threaded with copper aerials. The patch reads FREEWAVE: NO MASTERS, NO DEAD AIR."
	icon = 'icons/obj/clothing/suits/signal_pirate.dmi'
	worn_icon = 'icons/mob/clothing/suits/signal_pirate.dmi'
	icon_state = "signal_pirate_coat"
	inhand_icon_state = "armor"
	armor_type = /datum/armor/signal_pirate
	/// Player-facing names and their matching item/worn sprite states.
	var/static/list/style_choices

/// Lets the wearer select one of the coat's cosmetic styles.
/obj/item/clothing/suit/armor/signal_pirate/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE
	var/list/available_styles = get_style_choices()
	var/list/radial_choices = list()
	for(var/style_name in available_styles)
		radial_choices[style_name] = image(icon = icon, icon_state = available_styles[style_name])
	var/chosen_style = show_radial_menu(user, src, radial_choices, require_near = TRUE, tooltips = TRUE)
	if(!chosen_style)
		return TRUE
	apply_style(chosen_style, user)
	return TRUE

/// Lazily initializes and returns the supported cosmetic styles.
/obj/item/clothing/suit/armor/signal_pirate/proc/get_style_choices()
	if(!style_choices)
		style_choices = list(
			"Violet Freewave" = "signal_pirate_coat",
			"Copper Relay" = "signal_pirate_coat_copper",
			"Midnight Static" = "signal_pirate_coat_midnight",
		)
	return style_choices

/// Applies a supported cosmetic style and refreshes the actual wearer's appearance.
/obj/item/clothing/suit/armor/signal_pirate/proc/apply_style(style_name, mob/user)
	var/list/available_styles = get_style_choices()
	var/new_icon_state = available_styles[style_name]
	if(!new_icon_state)
		return FALSE
	icon_state = new_icon_state
	worn_icon_state = new_icon_state
	if(isliving(loc))
		var/mob/living/wearer = loc
		wearer.update_worn_oversuit()
	user?.balloon_alert(user, "[style_name] colours chosen")
	return TRUE

/datum/armor/signal_pirate
	melee = 20
	bullet = 15
	laser = 20
	energy = 30
	bomb = 10
	fire = 20
	acid = 20
	wound = 5

/// Feedback weapon that converts completed broadcasts into limited EMP charges.
/obj/item/signal_pirate_jammer
	name = "Freewave feedback spike"
	desc = "A copper-shod boarding spike and burst transmitter. Its insulated grip was made to answer Security's stunning arms; hijacked feeds charge its electromagnetic blast."
	icon = 'icons/obj/devices/signal_pirate.dmi'
	icon_state = "jammer"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 14
	var/charges = 0
	var/datum/weakref/pirate_ref

/// Displays the jammer's remaining charges.
/obj/item/signal_pirate_jammer/examine(mob/user)
	. = ..()
	. += span_notice("The charge display reads [charges].")

/// Adds one disruption charge to the jammer.
/obj/item/signal_pirate_jammer/proc/add_charge()
	charges++
	desc = "A copper-shod boarding spike and burst transmitter. Its display shows [charges] disruption charge(s)."

/// Spends one charge to emit an electromagnetic pulse.
/obj/item/signal_pirate_jammer/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE
	if(!pirate_ref?.resolve())
		user.balloon_alert(user, "subscriber lockout!")
		return TRUE
	if(charges <= 0)
		user.balloon_alert(user, "no hijacked feeds!")
		return TRUE
	charges--
	playsound(src, 'sound/effects/magic/lightningbolt.ogg', 50, TRUE)
	user.visible_message(span_boldwarning("[user]'s [src] screams with electromagnetic static!"), span_notice("You burn a hijacked feed to scramble nearby electronics."))
	empulse(user, 0, SIGNAL_PIRATE_EMP_RANGE, emp_source = src)
	return TRUE

/// The Signal Pirate's loud, player-controlled mobile objective.
/mob/living/basic/signal_pirate_transmitter
	name = "bootleg subspace transmitter"
	desc = "A self-propelled transmitter assembled from mismatched radio parts. Its display reads OFF AIR."
	icon = 'icons/obj/devices/signal_pirate.dmi'
	icon_state = "transmitter_off"
	icon_living = "transmitter_off"
	icon_dead = "transmitter_off"
	density = TRUE
	mob_biotypes = MOB_ROBOTIC
	mob_size = MOB_SIZE_SMALL
	maxHealth = 80
	health = 80
	melee_damage_lower = 3
	melee_damage_upper = 3
	unsuitable_atmos_damage = 0
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = 1500
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, STAMINA = 0.5, OXY = 0)
	/// The role receiving credit for this transmitter's broadcasts.
	var/datum/weakref/pirate_ref
	var/broadcasting = FALSE
	var/next_noise_time_ds = 0
	var/next_interference_time_ds = 0

/// Grants the transmitter's action, environmental traits, and faction.
/mob/living/basic/signal_pirate_transmitter/Initialize(mapload)
	. = ..()
	var/static/list/innate_actions = list(/datum/action/innate/signal_pirate_broadcast)
	grant_actions_by_list(innate_actions)
	add_traits(list(TRAIT_SPACEWALK, TRAIT_SHOCKIMMUNE), INNATE_TRAIT)
	add_faction(FACTION_PIRATE)

/// Stops broadcasting and clears role linkage before deletion.
/mob/living/basic/signal_pirate_transmitter/Destroy()
	stop_broadcasting()
	pirate_ref = null
	return ..()

/// Stops broadcasting when the transmitter dies.
/mob/living/basic/signal_pirate_transmitter/death(gibbed)
	stop_broadcasting()
	return ..()

/// Links the transmitter to its Signal Pirate using a weak reference.
/mob/living/basic/signal_pirate_transmitter/proc/link_pirate(datum/antagonist/signal_pirate/pirate)
	pirate_ref = WEAKREF(pirate)

/// Stops broadcasting and removes the pirate link.
/mob/living/basic/signal_pirate_transmitter/proc/unlink_pirate()
	stop_broadcasting()
	pirate_ref = null

/// Synchronizes the transmitter sprite with its broadcast state.
/mob/living/basic/signal_pirate_transmitter/update_icon_state()
	icon_state = broadcasting ? "transmitter_on" : "transmitter_off"
	icon_living = icon_state
	return ..()

/// Displays completed broadcasts and trained diagnostic telemetry.
/mob/living/basic/signal_pirate_transmitter/examine(mob/user)
	. = ..()
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	if(!pirate)
		return
	. += span_notice("The counter reads [pirate.completed_broadcasts()]/[pirate.required_areas] complete area broadcasts.")
	if(HAS_TRAIT(user, TRAIT_NETWORK_DIAGNOSTICS))
		var/area/current_area = get_area(src)
		if(!current_area)
			return
		var/current_progress_seconds = pirate.broadcast_time_by_area[current_area.type] || 0
		. += span_notice("Your diagnostic overlay reports [current_progress_seconds]/[pirate.seconds_per_area] seconds accrued on [current_area.name]'s carrier.")

/// Lets a trained Network Engineer suppress a bounded amount of local progress.
/mob/living/basic/signal_pirate_transmitter/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!HAS_TRAIT(user, TRAIT_NETWORK_DIAGNOSTICS))
		user.balloon_alert(user, "carrier cipher unknown")
		return ITEM_INTERACT_BLOCKING
	if(!broadcasting)
		user.balloon_alert(user, "no active carrier")
		return ITEM_INTERACT_SUCCESS
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	var/area/current_area = get_area(src)
	if(!pirate || !current_area)
		return ITEM_INTERACT_SUCCESS
	user.visible_message(span_notice("[user] begins retuning [src]'s hostile carrier."), span_notice("You begin a diagnostic retune. Hold your multitool steady."))
	if(!do_after(user, SIGNAL_PIRATE_RETUNE_TIME, target = src) || !broadcasting || get_area(src) != current_area)
		return ITEM_INTERACT_SUCCESS
	var/old_progress = pirate.broadcast_time_by_area[current_area.type] || 0
	pirate.broadcast_time_by_area[current_area.type] = max(0, old_progress - SIGNAL_PIRATE_RETUNE_REDUCTION)
	playsound(src, 'sound/machines/beep/twobeep.ogg', 40, TRUE)
	user.visible_message(span_boldnotice("[user] suppresses [src]'s carrier wave!"), span_boldnotice("You suppress twenty seconds of hijack progress in [current_area.name]."))
	return ITEM_INTERACT_SUCCESS

/// Starts broadcasting when the transmitter is in valid station territory.
/mob/living/basic/signal_pirate_transmitter/proc/start_broadcasting()
	if(broadcasting)
		return
	var/turf/current_turf = get_turf(src)
	var/area/current_area = get_area(src)
	if(!pirate_ref?.resolve() || !current_turf || !current_area || !is_station_level(current_turf.z) || !(current_area.area_flags & VALID_TERRITORY))
		balloon_alert(src, "no station signal here!")
		return
	broadcasting = TRUE
	start_broadcasting_network("signal_pirate", "An unauthorized Freewave carrier has seized the entertainment network!")
	next_noise_time_ds = world.time + SIGNAL_PIRATE_NOISE_DELAY
	next_interference_time_ds = world.time + SIGNAL_PIRATE_INTERFERENCE_INTERVAL
	START_PROCESSING(SSobj, src)
	update_appearance()

/// Stops the network broadcast and object processing.
/mob/living/basic/signal_pirate_transmitter/proc/stop_broadcasting()
	if(!broadcasting)
		return
	broadcasting = FALSE
	stop_broadcasting_network("signal_pirate", "The unauthorized Freewave carrier has left the entertainment network.")
	STOP_PROCESSING(SSobj, src)
	update_appearance()

/// Advances broadcast progress and periodically emits noise and interference.
/mob/living/basic/signal_pirate_transmitter/process(seconds_per_tick)
	var/turf/transmitter_turf = get_turf(src)
	var/area/transmitter_area = get_area(src)
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	if(stat == DEAD || !transmitter_turf || !transmitter_area || !pirate || !is_station_level(transmitter_turf.z) || !(transmitter_area.area_flags & VALID_TERRITORY))
		stop_broadcasting()
		return PROCESS_KILL

	pirate.record_broadcast(transmitter_area.type, seconds_per_tick)
	if(world.time >= next_noise_time_ds)
		next_noise_time_ds = world.time + SIGNAL_PIRATE_NOISE_INTERVAL
		playsound(src, 'sound/machines/beep/twobeep_high.ogg', 45, TRUE)
		visible_message(span_warning("[src] crackles, \"You're listening to FREE SPACE RADIO!\""))
	if(world.time >= next_interference_time_ds)
		next_interference_time_ds = world.time + SIGNAL_PIRATE_INTERFERENCE_INTERVAL
		visible_message(span_boldwarning("[src]'s illegal carrier wave makes nearby electronics spit sparks!"))
		hijack_station_networks(transmitter_area)
		empulse(src, 0, SIGNAL_PIRATE_EMP_RANGE, emp_source = src)

/// Injects the broadcast into Circuits/NTNet and visibly seizes nearby station display and telecomms hardware.
/mob/living/basic/signal_pirate_transmitter/proc/hijack_station_networks(area/current_area)
	if(!current_area)
		return
	var/datum/antagonist/signal_pirate/pirate = pirate_ref?.resolve()
	send_ntnet_data_package(list(
		"event" = "signal_pirate_broadcast",
		"area" = current_area.name,
		"progress" = pirate?.completed_broadcasts() || 0,
		"transmitter" = REF(src),
	))

	for(var/obj/machinery/networked_machine in view(SIGNAL_PIRATE_HIJACK_RANGE, src))
		networked_machine.receive_ntnet_interference(src)

	for(var/obj/machinery/status_display/display in view(SIGNAL_PIRATE_HIJACK_RANGE, src))
		display.set_messages("FREE SPACE", "RADIO")
		addtimer(CALLBACK(display, TYPE_PROC_REF(/obj/machinery/status_display, update)), SIGNAL_PIRATE_DISPLAY_RESET_DELAY)

	for(var/obj/machinery/ntnet_relay/relay in view(SIGNAL_PIRATE_HIJACK_RANGE, src))
		relay.dos_overload = min(relay.dos_capacity, relay.dos_overload + SIGNAL_PIRATE_RELAY_OVERLOAD)
		relay.update_appearance()

/datum/action/innate/signal_pirate_broadcast
	name = "Toggle Broadcast"
	desc = "Begin or end an illegal Freewave broadcast in the present station area."
	button_icon = 'icons/obj/devices/signal_pirate.dmi'
	button_icon_state = "transmitter_on"

/// Toggles the transmitter's broadcast state.
/datum/action/innate/signal_pirate_broadcast/Activate()
	var/mob/living/basic/signal_pirate_transmitter/transmitter = owner
	if(!istype(transmitter))
		return
	if(transmitter.broadcasting)
		transmitter.stop_broadcasting()
		to_chat(transmitter, span_notice("You stop broadcasting."))
	else
		transmitter.start_broadcasting()
		if(transmitter.broadcasting)
			to_chat(transmitter, span_boldnotice("You take to the airwaves. Keep moving between distinct station areas."))

/// Marks a valid Signal Pirate shuttle spawn location.
/obj/effect/landmark/signal_pirate_start
	name = "signal pirate start"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "snukeop_spawn"

/// Registers the mapped spawn location and removes the landmark.
/obj/effect/landmark/signal_pirate_start/Initialize(mapload)
	. = ..()
	GLOB.signal_pirate_start += loc
	return INITIALIZE_HINT_QDEL

/area/shuttle/signal_pirate
	name = "Freewave Signal Pirate Shuttle"
	requires_power = TRUE

/turf/closed/wall/mineral/plastitanium/signal_pirate
	name = "Freewave transmitter wall"
	desc = "A violet plastitanium wall embossed with branching copper aerials."
	icon = 'icons/turf/walls/signal_pirate_wall.dmi'

/turf/open/indestructible/signal_pirate
	name = "Freewave transmitter deck"
	desc = "A dark violet deck plate scored into the likeness of a carrier wave."
	icon = 'icons/turf/floors/signal_pirate_floor.dmi'
	icon_state = "signal_pirate_floor"
	base_icon_state = "signal_pirate_floor"
	layer = LOW_FLOOR_LAYER
	plane = FLOOR_PLANE

/obj/machinery/computer/shuttle/signal_pirate
	name = "Freewave shuttle console"
	shuttleId = "signal_pirate"
	possible_destinations = "signal_pirate_home;signal_pirate_custom"

/obj/machinery/computer/camera_advanced/shuttle_docker/syndicate/signal_pirate
	name = "Freewave shuttle navigation computer"
	desc = "It selects a landing site for the pirate radio broadcast."
	shuttleId = "signal_pirate"
	shuttlePortId = "signal_pirate_custom"
	lock_override = CAMERA_LOCK_STATION
	jump_to_ports = list("signal_pirate_home" = 1)
	view_range = 5.5
	x_offset = 9
	y_offset = 0
	see_hidden = FALSE

/obj/docking_port/mobile/signal_pirate
	name = "Freewave signal pirate shuttle"
	shuttle_id = "signal_pirate"
	rechargeTime = 3 MINUTES

#undef SIGNAL_PIRATE_REQUIRED_AREAS
#undef SIGNAL_PIRATE_SECONDS_PER_AREA
#undef SIGNAL_PIRATE_INTERFERENCE_INTERVAL
#undef SIGNAL_PIRATE_NOISE_DELAY
#undef SIGNAL_PIRATE_NOISE_INTERVAL
#undef SIGNAL_PIRATE_RETUNE_TIME
#undef SIGNAL_PIRATE_RETUNE_REDUCTION
#undef SIGNAL_PIRATE_EMP_RANGE
#undef SIGNAL_PIRATE_HIJACK_RANGE
#undef SIGNAL_PIRATE_DISPLAY_RESET_DELAY
#undef SIGNAL_PIRATE_RELAY_OVERLOAD
