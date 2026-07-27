/// Status effect applied to a mob while they're dodge rolling.
/// Makes them immune to damage during the roll and throws them in their facing direction.
/datum/status_effect/dodge_rolling
	id = "dodge_rolling"
	duration = 1 SECONDS
	tick_interval = STATUS_EFFECT_NO_TICK
	alert_type = null

/datum/status_effect/dodge_rolling/on_apply()
	if(!isliving(owner))
		return FALSE

	RegisterSignal(owner, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(on_check_block))
	RegisterSignal(owner, COMSIG_MOVABLE_THROW_LANDED, PROC_REF(on_throw_landed))

	owner.visible_message(
		span_danger("[owner] dodge rolls out of the way!"),
		span_userdanger("You perform a dodge roll, evading all attacks!"),
	)
	playsound(owner, 'sound/items/weapons/punchmiss.ogg', 50, TRUE, -1)

	// Launch the owner a short distance in the direction they're facing
	var/atom/throw_target = get_edge_target_turf(owner, owner.dir)
	if(throw_target)
		owner.throw_at(throw_target, 3, 2, owner, spin = TRUE)

	return TRUE

/datum/status_effect/dodge_rolling/on_remove()
	UnregisterSignal(owner, list(
		COMSIG_LIVING_CHECK_BLOCK,
		COMSIG_MOVABLE_THROW_LANDED,
	))

/// Called when we try to receive damage. Block all incoming damage while rolling.
/datum/status_effect/dodge_rolling/proc/on_check_block(
	mob/living/source,
	atom/movable/hitby,
	damage,
	attack_text,
	attack_type,
	armour_penetration,
	damage_type,
)
	SIGNAL_HANDLER

	source.visible_message(
		span_danger("[source] rolls out of the way, avoiding [attack_text]!"),
		span_userdanger("You dodge [attack_text] by rolling out of the way!"),
	)
	playsound(source, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	return SUCCESSFUL_BLOCK

/// Signal from /datum/thrownthing/finalize() - clean up when the throw ends
/datum/status_effect/dodge_rolling/proc/on_throw_landed(datum/source, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER

	qdel(src)
