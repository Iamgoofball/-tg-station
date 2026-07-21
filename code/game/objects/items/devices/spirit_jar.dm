/**
 * # Spirit Jar
 *
 * A containment vessel for spectral entities. A ghost can click on
 * an empty Spirit Jar to occupy it. While inside, the ghost can
 * speak to nearby living creatures by whispering from within.
 *
 * The ghost can leave at any time by moving.
 * The jar glows green when occupied.
 */

/obj/item/spirit_jar
	name = "spirit jar"
	desc = "A glass jar lined with conductive metallic filaments. Spirits are drawn to its resonance and can inhabit it temporarily, allowing them to whisper to the living."
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "yourorgans1"
	w_class = WEIGHT_CLASS_NORMAL
	item_flags = NOBLUDGEON

	/// The ghost currently occupying this jar
	var/mob/dead/observer/occupant
	/// Whether the jar is sealed (prevents new ghosts from entering)
	var/sealed = FALSE

/obj/item/spirit_jar/Initialize(mapload)
	. = ..()
	SSpoints_of_interest.make_point_of_interest(src)

/obj/item/spirit_jar/Destroy()
	eject_ghost()
	return ..()

/obj/item/spirit_jar/examine(mob/user)
	. = ..()
	if(occupant)
		. += span_green("A faint green glow emanates from within. Something is inside...")
		. += span_notice("Use in-hand to release the spirit.")
	else
		. += span_notice("The jar is empty. A ghost may click on it to enter.")

/obj/item/spirit_jar/update_icon_state()
	. = ..()
	if(occupant)
		icon_state = "yourorgans1"
	else
		icon_state = "yourorgans1"

/obj/item/spirit_jar/update_overlays()
	. = ..()
	if(occupant)
		// Green glow overlay when occupied
		var/mutable_appearance/glow = mutable_appearance('icons/effects/effects.dmi', "yourfloor1")
		glow.color = "#44FF88"
		glow.alpha = 150
		glow.pixel_y = 0
		. += glow

/obj/item/spirit_jar/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(occupant)
		to_chat(user, span_warning("This spirit jar is already occupied!"))
		return
	if(sealed)
		to_chat(user, span_warning("This spirit jar is sealed shut!"))
		return

	var/response = tgui_alert(user, "Do you want to enter this Spirit Jar? You will be able to whisper to the living. You can leave at any time.", "Spirit Jar", list("Enter", "Cancel"))
	if(response != "Enter")
		return
	if(QDELETED(src) || occupant) // Re-check after alert
		return

	enter_jar(user)

/// Puts a ghost into the jar
/obj/item/spirit_jar/proc/enter_jar(mob/dead/observer/ghost)
	if(occupant || !ghost)
		return
	occupant = ghost
	RegisterSignal(ghost, COMSIG_MOVABLE_MOVED, PROC_REF(on_ghost_moved))
	RegisterSignal(ghost, COMSIG_QDELETING, PROC_REF(on_ghost_deleted))
	to_chat(ghost, span_green("You flow into the Spirit Jar. You can whisper to the living by using the Say verb. Move to leave."))
	ghost.forceMove(src)
	update_appearance()
	playsound(src, 'sound/effects/ghost.ogg', 40)

	// Notify nearby
	var/turf/our_turf = get_turf(src)
	for(var/mob/living/viewer in range(4, our_turf))
		to_chat(viewer, span_green("The spirit jar begins to glow with an eerie green light! Something has entered it!"))

/// Ejects the ghost from the jar
/obj/item/spirit_jar/proc/eject_ghost()
	if(!occupant)
		return
	UnregisterSignal(occupant, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(occupant, COMSIG_QDELETING)
	var/turf/our_turf = get_turf(src)
	occupant.forceMove(our_turf)
	to_chat(occupant, span_notice("You flow out of the Spirit Jar."))
	occupant = null
	update_appearance()
	playsound(src, 'sound/effects/ghost2.ogg', 30)

	for(var/mob/living/viewer in range(4, our_turf))
		to_chat(viewer, span_purple("The green glow in the spirit jar fades... the spirit has departed."))

/obj/item/spirit_jar/proc/on_ghost_moved(datum/source)
	SIGNAL_HANDLER
	eject_ghost()

/obj/item/spirit_jar/proc/on_ghost_deleted(datum/source)
	SIGNAL_HANDLER
	occupant = null
	update_appearance()

/obj/item/spirit_jar/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(occupant)
		user.visible_message(
			span_notice("[user] opens the spirit jar, releasing the spirit within!"),
			span_notice("You open the spirit jar, releasing the spirit."),
		)
		eject_ghost()
	else
		balloon_alert(user, "jar is empty")

/// Allow the ghost inside to speak to nearby living mobs
/obj/item/spirit_jar/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods, message_range)
	. = ..()
	if(speaker != occupant)
		return
	// Relay the ghost's message to nearby living mobs
	var/turf/our_turf = get_turf(src)
	var/ghost_name = speaker.name
	for(var/mob/living/listener in range(3, our_turf))
		to_chat(listener, span_purple("[ghost_name] (from within the spirit jar) whispers, \"[raw_message]\""))
	playsound(src, 'sound/effects/ghost2.ogg', 20, vary = TRUE)
