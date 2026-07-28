/datum/action/cooldown/mob_cooldown/dodge_roll
	name = "Dodge Roll"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "Perform a quick dodge roll in your facing direction. Grants complete invulnerability to damage during the roll."
	cooldown_time = 3 SECONDS
	/// Duration of invulnerability and rolling state
	var/roll_duration = 0.8 SECONDS
	/// Distance moved during roll
	var/roll_distance = 3

/datum/action/cooldown/mob_cooldown/dodge_roll/Activate(atom/target_atom)
	var/mob/living/L = owner
	if(!istype(L) || L.incapacitated())
		return FALSE

	perform_dodge_roll(L)
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/dodge_roll/proc/perform_dodge_roll(mob/living/user)
	if(!user)
		return

	var/was_already_godmode = (user.status_flags & GODMODE) != 0

	// Grant temporary invulnerability (no damage taken)
	user.status_flags |= GODMODE
	user.visible_message(
		span_warning("[user] performs a nimble dodge roll!"),
		span_notice("You perform a dodge roll, granting temporary invulnerability!")
	)

	// Animate spin / roll visual
	animate(user, transform = turn(matrix(), 180), time = roll_duration / 2, loop = 1)
	animate(transform = turn(matrix(), 360), time = roll_duration / 2)

	// Move user forward in facing direction
	for(var/i in 1 to roll_distance)
		step(user, user.dir)
		sleep(1)

	// Remove invulnerability after roll finishes only if user was not originally in godmode
	addtimer(CALLBACK(GLOBAL_PROC, /proc/end_dodge_invulnerability, user, was_already_godmode), roll_duration)

/proc/end_dodge_invulnerability(mob/living/user, was_already_godmode = FALSE)
	if(!user || QDELETED(user))
		return
	if(!was_already_godmode)
		user.status_flags &= ~GODMODE
	user.transform = matrix() // Reset transform matrix
