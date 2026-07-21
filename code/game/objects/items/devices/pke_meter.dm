/**
 * # P.K.E. Meter (Psychokinetic Energy Meter)
 *
 * A handheld device used by the Paranormalist to detect ghosts,
 * dead bodies, and ectoplasmic anomalies. Scans a 7-tile radius
 * and provides intensity feedback based on proximity.
 *
 * Ghosts detected by the meter receive a prompt to "manifest,"
 * triggering visual and audio feedback for the wielder.
 */

#define PKE_SCAN_RANGE 7
#define PKE_SCAN_COOLDOWN 3 SECONDS

/obj/item/pke_meter
	name = "\improper P.K.E. Meter"
	desc = "A Psychokinetic Energy Meter. It detects nearby spiritual entities, ectoplasmic residues, and the recently deceased. Standard issue for Paranormalist field operatives."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "multitool"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	item_flags = NOBLUDGEON

	/// Whether the meter is currently actively scanning
	var/scanning = FALSE
	/// Cooldown for manual scans
	COOLDOWN_DECLARE(scan_cooldown)
	/// The last reading intensity (0-100)
	var/last_reading = 0

/obj/item/pke_meter/attack_self(mob/user)
	. = ..()
	if(.)
		return

	scanning = !scanning
	balloon_alert(user, "meter [scanning ? "on" : "off"]")

	if(scanning)
		START_PROCESSING(SSobj, src)
		playsound(src, 'sound/machines/twobeep.ogg', 30)
	else
		STOP_PROCESSING(SSobj, src)
		last_reading = 0
	update_appearance(UPDATE_ICON)

/obj/item/pke_meter/process(seconds_per_tick)
	if(!scanning)
		STOP_PROCESSING(SSobj, src)
		return

	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return

	// Scan nearby area for spectral entities
	var/total_reading = 0
	var/closest_ghost_dist = PKE_SCAN_RANGE + 1

	for(var/mob/dead/observer/ghost in range(PKE_SCAN_RANGE, our_turf))
		var/dist = get_dist(our_turf, get_turf(ghost))
		total_reading += max(1, (PKE_SCAN_RANGE - dist) * 10)
		if(dist < closest_ghost_dist)
			closest_ghost_dist = dist

	// Detect dead bodies
	for(var/mob/living/carbon/body in range(PKE_SCAN_RANGE, our_turf))
		if(body.stat == DEAD)
			var/dist = get_dist(our_turf, get_turf(body))
			total_reading += max(1, (PKE_SCAN_RANGE - dist) * 5)

	// Detect ectoplasmic decals
	for(var/obj/effect/decal/cleanable/greenglow/ecto/ecto_puddle in range(PKE_SCAN_RANGE, our_turf))
		var/dist = get_dist(our_turf, get_turf(ecto_puddle))
		total_reading += max(1, (PKE_SCAN_RANGE - dist) * 3)

	// Detect hauntium materials
	for(var/atom/thing in range(PKE_SCAN_RANGE, our_turf))
		var/list/materials = thing.has_material_type(/datum/material/hauntium)
		if(materials)
			total_reading += 5

	last_reading = clamp(total_reading, 0, 100)

	// Produce clicking sounds based on intensity
	if(last_reading > 0)
		var/sound_volume = clamp(last_reading, 10, 60)
		if(last_reading >= 50)
			playsound(src, 'sound/machines/ping.ogg', sound_volume, vary = TRUE)
		else if(last_reading >= 20)
			if(SPT_PROB(50, seconds_per_tick))
				playsound(src, 'sound/machines/twobeep.ogg', sound_volume * 0.5, vary = TRUE)

/obj/item/pke_meter/examine(mob/user)
	. = ..()
	if(!scanning)
		. += span_notice("It is currently turned off. Use it in-hand to activate.")
		return
	switch(last_reading)
		if(0)
			. += span_notice("The display reads: <b>NO SPECTRAL ACTIVITY DETECTED</b>.")
		if(1 to 20)
			. += span_notice("The display reads: <b>FAINT RESIDUAL ENERGY</b>. Something was here recently...")
		if(21 to 50)
			. += span_warning("The display reads: <b>MODERATE PKE READINGS</b>. Spectral entities are nearby!")
		if(51 to 80)
			. += span_boldwarning("The display reads: <b>STRONG PKE READINGS</b>! Multiple entities detected!")
		if(81 to INFINITY)
			. += span_userdanger("The display reads: <b>CRITICAL PKE LEVELS</b>!! The area is saturated with psychokinetic energy!")

/// Active scan - click on a turf or mob to do a focused scan
/obj/item/pke_meter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!scanning)
		balloon_alert(user, "meter is off!")
		return ITEM_INTERACT_BLOCKING
	if(!COOLDOWN_FINISHED(src, scan_cooldown))
		balloon_alert(user, "still calibrating...")
		return ITEM_INTERACT_BLOCKING

	COOLDOWN_START(src, scan_cooldown, PKE_SCAN_COOLDOWN)
	user.visible_message(
		span_notice("[user] waves [src] at [interacting_with], scanning for spectral energy..."),
		span_notice("You scan [interacting_with] with [src]..."),
	)

	// Check if we're scanning a ghost directly
	if(isobserver(interacting_with))
		var/mob/dead/observer/ghost = interacting_with
		playsound(src, 'sound/effects/ghost2.ogg', 50)
		to_chat(user, span_boldnotice("[icon2html(src, user)] [src] goes haywire! A powerful spectral presence detected right here!"))
		// Ask the ghost if they want to manifest
		var/response = tgui_alert(ghost, "[user.real_name] is scanning you with a P.K.E. Meter! Do you want to manifest?", "Spectral Detection", list("Yes", "No"))
		if(response == "Yes")
			// Ghost chose to manifest - create visual effect
			playsound(src, 'sound/effects/ghost.ogg', 60)
			new /obj/effect/temp_visual/pke_manifestation(get_turf(ghost))
			to_chat(user, span_green("A ghostly presence reveals itself momentarily!"))
		return ITEM_INTERACT_SUCCESS

	// Scan a dead body
	if(isliving(interacting_with))
		var/mob/living/target = interacting_with
		if(target.stat == DEAD)
			playsound(src, 'sound/effects/ghost2.ogg', 40)
			to_chat(user, span_boldnotice("[icon2html(src, user)] Strong residual PKE readings emanating from [target]'s remains. The spirit may still linger nearby."))
			return ITEM_INTERACT_SUCCESS
		else
			to_chat(user, span_notice("[icon2html(src, user)] No significant spectral readings from [target]. They appear to be among the living."))
			return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/pke_meter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/// Temporary visual effect for when a ghost manifests through a PKE scan
/obj/effect/temp_visual/pke_manifestation
	name = "spectral manifestation"
	desc = "A brief glimpse of the other side..."
	icon = 'icons/effects/effects.dmi'
	icon_state = "yourfloor1"
	color = "#44FF88"
	duration = 3 SECONDS
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/pke_manifestation/Initialize(mapload)
	. = ..()
	// Simple visual: a green glowing pulse
	animate(src, alpha = 255, time = 0.5 SECONDS)
	animate(alpha = 80, time = 1 SECONDS)
	animate(alpha = 255, time = 0.5 SECONDS)
	animate(alpha = 0, time = 1 SECONDS)

#undef PKE_SCAN_RANGE
#undef PKE_SCAN_COOLDOWN
