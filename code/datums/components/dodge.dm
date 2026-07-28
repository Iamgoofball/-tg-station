/// Dodge roll mechanic: while dodging, the mob takes no damage.
/datum/component/dodge
	/// How long (deciseconds) the dodge i-frames last.
	var/dodge_duration = 5
	/// Cooldown (deciseconds) before the mob can dodge again.
	var/dodge_cooldown = 30
	/// Whether the mob is currently mid-dodge (invulnerable).
	var/dodging = FALSE
	/// World time at which the mob can dodge again.
	var/next_dodge = 0

/datum/component/dodge/Initialize(duration = 5, cooldown = 30)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	dodge_duration = duration
	dodge_cooldown = cooldown
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_apply_damage))
	return ..()

/datum/component/dodge/Destroy(force, silent)
	UnregisterSignal(parent, COMSIG_MOB_APPLY_DAMAGE)
	return ..()

/datum/component/dodge/proc/on_apply_damage(mob/living/source, damage, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, sharpness, attack_direction, attacking_item)
	SIGNAL_HANDLER
	if(dodging)
		return COMPONENT_NO_DAMAGE

/// Triggers a dodge roll. Returns TRUE if the dodge started.
/datum/component/dodge/proc/start_dodge()
	if(dodging || (world.time < next_dodge))
		return FALSE
	var/mob/living/L = parent
	dodging = TRUE
	L.visible_message(span_danger("[L] performs a dodge roll!"))
	// brief movement flair: nudge the mob in its facing direction
	if(L.dir)
		step(L, L.dir)
	addtimer(CALLBACK(src, PROC_REF(end_dodge)), dodge_duration)
	return TRUE

/datum/component/dodge/proc/end_dodge()
	dodging = FALSE
	next_dodge = world.time + dodge_cooldown

/// Verb so players can bind a key to dodge.
/mob/living/verb/dodge()
	set name = "Dodge Roll"
	set category = "IC"
	set desc = "Perform a dodge roll, briefly avoiding all damage."
	var/datum/component/dodge/D = src.GetComponent(/datum/component/dodge)
	if(!D)
		D = src.AddComponent(/datum/component/dodge)
	if(D)
		to_chat(src, D.start_dodge() ? span_notice("You dodge roll!") : span_warning("You can't dodge yet!"))
