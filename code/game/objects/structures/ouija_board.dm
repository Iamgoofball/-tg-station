/**
 * # Ouija Board (Portable Spirit Board)
 *
 * A portable variant of the spirit board that the Paranormalist carries.
 * It can be deployed on any flat surface (table or floor) and allows
 * ghosts to communicate with the living by selecting letters.
 *
 * Unlike the station spirit board, the Ouija Board is an item that
 * can be picked up and placed. It only requires 1 living user nearby
 * (the Paranormalist) instead of 2.
 */

/obj/item/ouija_board
	name = "ouija board"
	desc = "A portable wooden board with letters and numbers etched into it. The planchette is held in place with a small clasp. Used by paranormal investigators to communicate with spirits."
	icon = 'icons/obj/structures.dmi'
	icon_state = "spirit_board"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FLAMMABLE

/obj/item/ouija_board/attack_self(mob/user)
	. = ..()
	if(.)
		return
	// Deploy the board
	var/turf/deploy_turf = get_turf(user)
	if(!deploy_turf)
		return
	user.visible_message(
		span_notice("[user] carefully lays out [src] on the ground..."),
		span_notice("You lay out the ouija board and prepare for a seance."),
	)
	var/obj/structure/deployed_ouija_board/deployed = new(deploy_turf)
	deployed.deployer_ckey = user.ckey
	qdel(src)

/**
 * # Deployed Ouija Board
 *
 * The deployed (placed) version of the ouija board.
 * Works like a spirit board but only needs 1 living user (the Paranormalist)
 * and can be picked back up.
 */
/obj/structure/deployed_ouija_board
	name = "ouija board"
	desc = "A wooden board with letters etched into it, laid out for a seance. Ghosts can interact with it to spell out messages."
	icon = 'icons/obj/structures.dmi'
	icon_state = "spirit_board"
	density = FALSE
	anchored = TRUE
	resistance_flags = FLAMMABLE
	layer = BELOW_OBJ_LAYER

	/// Whether anyone has used the board yet
	var/virgin = TRUE
	/// Cooldown between planchette movements
	COOLDOWN_DECLARE(next_use)
	/// Current planchette position
	var/planchette
	/// Last user's ckey
	var/lastuser
	/// The ckey of whoever deployed this board
	var/deployer_ckey
	/// Options ghosts can pick from
	var/list/ghosty_options = list(
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
		"1","2","3","4","5","6","7","8","9","0",
		"Yes","No","Goodbye","Help","Danger",
	)

/obj/structure/deployed_ouija_board/Initialize(mapload)
	. = ..()
	planchette = ghosty_options[1]

/obj/structure/deployed_ouija_board/examine(mob/user)
	. = ..()
	if(planchette)
		. += span_notice("The planchette is currently at \"[planchette]\".")
	. += span_notice("Click to pick it up.")

/obj/structure/deployed_ouija_board/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	// Pick up the board
	var/obj/item/ouija_board/board = new(user.loc)
	user.put_in_hands(board)
	user.visible_message(
		span_notice("[user] picks up the ouija board."),
		span_notice("You pick up the ouija board."),
	)
	qdel(src)

/obj/structure/deployed_ouija_board/attack_ghost(mob/dead/observer/user)
	. = ..()
	if(.)
		return
	spirit_board_pick_letter(user)

/obj/structure/deployed_ouija_board/proc/spirit_board_pick_letter(mob/ghost)
	if(!spirit_board_checks(ghost))
		return

	if(virgin)
		virgin = FALSE
		notify_ghosts(
			"A Paranormalist has laid out an ouija board in [get_area(src)]!",
			source = src,
			header = "Ouija Board",
		)

	var/new_planchette = tgui_input_list(ghost, "Choose a letter or word.", "Ouija Board", ghosty_options)
	if(isnull(new_planchette))
		return
	if(!COOLDOWN_FINISHED(src, next_use))
		return
	planchette = new_planchette
	ghost.log_message("picked \"[planchette]\" on [src].", LOG_GAME)
	COOLDOWN_START(src, next_use, rand(2 SECONDS, 4 SECONDS))
	lastuser = ghost.ckey

	// Broadcast to nearby living mobs
	for(var/mob/viewer in range(3, src))
		if(isnull(viewer.client))
			continue
		if(viewer.stat != CONSCIOUS && viewer.stat != DEAD)
			continue
		if(viewer.is_blind())
			to_chat(viewer, span_hear("You hear a slow scraping sound across wood..."))
		else
			to_chat(viewer, span_purple("The planchette slowly glides across the ouija board... it points to: \"[planchette]\"."))
	playsound(src, 'sound/effects/footstep/wood1.ogg', 30, vary = TRUE)

/obj/structure/deployed_ouija_board/proc/spirit_board_checks(mob/ghost)
	var/cd_penalty = (ghost.ckey == lastuser) ? 1 SECONDS : 0 SECONDS

	if(next_use - cd_penalty > world.time)
		return FALSE

	// Only need 1 living person nearby (the Paranormalist)
	var/users_in_range = 0
	for(var/mob/living/player in orange(2, src))
		if(isnull(player.ckey) || isnull(player.client))
			continue
		if(player.client?.is_afk() || player.stat != CONSCIOUS || HAS_TRAIT(player, TRAIT_HANDS_BLOCKED))
			to_chat(ghost, span_warning("[player] doesn't seem to be paying attention..."))
			continue
		users_in_range++

	if(users_in_range < 1)
		to_chat(ghost, span_warning("There's nobody paying attention to the board!"))
		return FALSE

	return TRUE
