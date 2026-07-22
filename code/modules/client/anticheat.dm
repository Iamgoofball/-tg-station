/**
 * Server-side anticheat helpers.
 *
 * Covers heuristic detection for:
 * - Sleepfeet automation (move/click input while sleeping or knocked out)
 * - Aimbot middle-click drag abuse (escalation beyond click-limit coupling)
 * - Repeated autoclick limit trips
 *
 * These are detection/mitigation signals for admins — client-side DLL cheats
 * (true wallhacks) cannot be fully blocked from DM alone.
 */

/// How many incapacitated move attempts before we flag sleepfeet automation.
#define SLEEPFEET_MOVE_WARN_THRESHOLD 8
/// Window (ds) to accumulate sleepfeet move attempts before the counter resets.
#define SLEEPFEET_MOVE_WINDOW (3 SECONDS)
/// How many incapacitated click attempts before we flag sleepfeet click automation.
#define SLEEPFEET_CLICK_WARN_THRESHOLD 6
/// Window (ds) for sleepfeet click accumulation.
#define SLEEPFEET_CLICK_WINDOW (3 SECONDS)
/// Distinct middle-drag aimbot hits required before admin warning (independent of click-limit).
#define AIMBOT_HIT_WARN_THRESHOLD 2
/// Autoclick second-limit trips in a short window before admin note.
#define AUTOCLICK_TRIP_WARN_THRESHOLD 3
#define AUTOCLICK_TRIP_WINDOW (10 SECONDS)
/// Minimum aimbot score from a single Click() to count as one hit.
#define AIMBOT_HIT_MIN_SCORE 10

/**
 * Returns TRUE if this living mob should be treated as sleepfeet-incapacitated
 * for anticheat purposes (asleep / knocked out, and not sleep-immune).
 */
/client/proc/is_sleepfeet_incapacitated()
	if(holder)
		return FALSE
	if(!isliving(mob))
		return FALSE
	var/mob/living/living_mob = mob
	if(HAS_TRAIT(living_mob, TRAIT_SLEEPIMMUNE))
		return FALSE
	if(living_mob.IsSleeping())
		return TRUE
	if(HAS_TRAIT(living_mob, TRAIT_KNOCKEDOUT))
		return TRUE
	return FALSE

/**
 * Unified anticheat admin/logging reporter with per-reason cooldown.
 * Returns TRUE if a report was emitted this call.
 */
/client/proc/report_anticheat(reason, detail, note_ckey = null, cooldown = 30 SECONDS)
	if(!reason)
		return FALSE
	if(!anticheat_last_report)
		anticheat_last_report = list()
	if(anticheat_last_report[reason] && (world.time - anticheat_last_report[reason] < cooldown))
		return FALSE
	anticheat_last_report[reason] = world.time

	var/mob/report_mob = mob || usr
	var/msg = "[key_name(src)] anticheat/[reason]: [detail]"
	log_game(msg)
	message_admins("[ADMIN_LOOKUPFLW(report_mob)] [ADMIN_KICK(report_mob)] anticheat/[reason]: [detail]")
	if(note_ckey)
		add_system_note(note_ckey, detail)
	return TRUE

/**
 * Detects automation of movement while sleeping/knocked out ("sleepfeet").
 * Call from client/Move when an input arrives; returns TRUE if the move should be hard-blocked.
 */
/client/proc/check_sleepfeet_move()
	if(!is_sleepfeet_incapacitated())
		return FALSE

	if(world.time > sleepfeet_move_reset)
		sleepfeet_move_count = 0
		sleepfeet_move_reset = world.time + SLEEPFEET_MOVE_WINDOW

	sleepfeet_move_count++

	if(sleepfeet_move_count >= SLEEPFEET_MOVE_WARN_THRESHOLD)
		report_anticheat(
			"sleepfeet_move",
			"Repeated movement input while sleeping/knocked out ([sleepfeet_move_count] in window) — possible sleepfeet automation",
			"sleepfeet",
		)
		// Soft mute further movement attempts for a short period to blunt scripts.
		move_delay = max(move_delay, world.time + (1 SECONDS))
		return TRUE

	return TRUE // still block the move; we only escalate at threshold

/**
 * Detects click spam while sleeping/knocked out.
 * Returns TRUE if the click should be ignored.
 */
/client/proc/check_sleepfeet_click()
	if(!is_sleepfeet_incapacitated())
		return FALSE

	if(world.time > sleepfeet_click_reset)
		sleepfeet_click_count = 0
		sleepfeet_click_reset = world.time + SLEEPFEET_CLICK_WINDOW

	sleepfeet_click_count++

	if(sleepfeet_click_count >= SLEEPFEET_CLICK_WARN_THRESHOLD)
		report_anticheat(
			"sleepfeet_click",
			"Repeated click input while sleeping/knocked out ([sleepfeet_click_count] in window) — possible sleepfeet/autoclick automation",
			"sleepfeet",
		)
		return TRUE

	return TRUE

/**
 * Escalates middle-click aimbot heuristics even when the minute click cap is not hit.
 * `ab_score` is the weighted aimbot score from Click().
 */
/client/proc/check_aimbot_score(ab_score)
	if(holder || ab_score < AIMBOT_HIT_MIN_SCORE)
		return
	aimbot_score_total++ // reused as hit counter
	if(aimbot_score_total >= AIMBOT_HIT_WARN_THRESHOLD)
		report_anticheat(
			"aimbot",
			"Middle-click aimbot exploit pattern ([aimbot_score_total] hits, last score [ab_score])",
			"aimbot",
		)
		aimbot_score_total = 0

/**
 * Track repeated per-second autoclick limit trips.
 */
/client/proc/check_autoclick_trip()
	if(holder)
		return
	if(world.time > autoclick_trip_reset)
		autoclick_trip_count = 0
		autoclick_trip_reset = world.time + AUTOCLICK_TRIP_WINDOW

	autoclick_trip_count++
	if(autoclick_trip_count >= AUTOCLICK_TRIP_WARN_THRESHOLD)
		report_anticheat(
			"autoclick",
			"Repeatedly hit per-second click limit ([autoclick_trip_count] trips) — possible autoclicker",
			"autoclick",
		)
		autoclick_trip_count = 0

#undef SLEEPFEET_MOVE_WARN_THRESHOLD
#undef SLEEPFEET_MOVE_WINDOW
#undef SLEEPFEET_CLICK_WARN_THRESHOLD
#undef SLEEPFEET_CLICK_WINDOW
#undef AIMBOT_HIT_WARN_THRESHOLD
#undef AUTOCLICK_TRIP_WARN_THRESHOLD
#undef AUTOCLICK_TRIP_WINDOW
#undef AIMBOT_HIT_MIN_SCORE
