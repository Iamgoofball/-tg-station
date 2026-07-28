/datum/action/cooldown/mob_cooldown/dodge_roll
	name = "Dodge Roll"
	desc = "Perform a quick dodge roll in the direction you're facing, making you invulnerable during the roll."
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	background_icon_state = "bg_default"
	cooldown_time = 6 SECONDS
	melee_cooldown_time = 1.5 SECONDS
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/dodge_roll/Activate(atom/target)
	if(!owner || owner.stat != CONSCIOUS)
		return FALSE

	if(!isliving(owner))
		return FALSE

	var/mob/living/living_owner = owner

	// Can't dodge roll if we're already doing it
	if(living_owner.has_status_effect(/datum/status_effect/dodge_rolling))
		living_owner.balloon_alert(living_owner, "already rolling!")
		return FALSE

	// Can't dodge roll while lying down, buckled, or incapacitated
	if(living_owner.body_position != STANDING_UP)
		living_owner.balloon_alert(living_owner, "can't roll while prone!")
		return FALSE

	if(living_owner.buckled)
		living_owner.balloon_alert(living_owner, "buckled in!")
		return FALSE

	if(HAS_TRAIT(living_owner, TRAIT_IMMOBILIZED) || HAS_TRAIT(living_owner, TRAIT_INCAPACITATED))
		living_owner.balloon_alert(living_owner, "can't move!")
		return FALSE

	if(living_owner.throwing)
		living_owner.balloon_alert(living_owner, "already moving!")
		return FALSE

	disable_cooldown_actions()
	living_owner.apply_status_effect(/datum/status_effect/dodge_rolling)
	StartCooldown()
	enable_cooldown_actions()
	return TRUE
