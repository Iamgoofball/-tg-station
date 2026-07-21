SUBSYSTEM_DEF(daily_quest)
	name = "Daily Quest"
	wait = DAILY_QUEST_CHECK_INTERVAL
	ss_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME
	/// List of active /datum/daily_quest for the current day
	var/list/datum/daily_quest/active_quests = list()
	/// List of completed quest datums from previous days (for record keeping)
	var/list/datum/daily_quest/completed_quests = list()
	/// The last day (in station time) that quests were rotated. Used to detect day changes.
	var/last_rotation_day = 0
	/// Whether the initial batch of quests has been created
	var/initialized = FALSE

/datum/controller/subsystem/daily_quest/Initialize()
	generate_daily_quests()
	initialized = TRUE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/daily_quest/Recover()
	active_quests = SSdaily_quest.active_quests
	completed_quests = SSdaily_quest.completed_quests
	last_rotation_day = SSdaily_quest.last_rotation_day
	initialized = SSdaily_quest.initialized

/datum/controller/subsystem/daily_quest/fire(resumed = FALSE)
	if(!initialized)
		generate_daily_quests()
		initialized = TRUE
		return

	// Check if a new day has started — rotate quests
	var/current_day = text2num(time2text(world.timeofday, "DDD"))
	if(current_day != last_rotation_day)
		rotate_daily_quests()

	// Each fire tick, try to assign unassigned quests to security players
	assign_unassigned_quests()

/// Generates a fresh set of daily quests
/datum/controller/subsystem/daily_quest/proc/generate_daily_quests()
	// Archive any existing active quests
	for(var/datum/daily_quest/quest as anything in active_quests)
		completed_quests += quest
	active_quests.Cut()

	last_rotation_day = text2num(time2text(world.timeofday, "DDD"))

	// Generate one of each quest type
	var/static/list/quest_types = list(
		DAILY_QUEST_CLEAN_GUNS,
		DAILY_QUEST_BEAT_MIME,
		DAILY_QUEST_INTERROGATE,
		DAILY_QUEST_STOP_AI,
	)

	for(var/quest_type in quest_types)
		var/datum/daily_quest/new_quest = new /datum/daily_quest(quest_type)
		active_quests += new_quest

	log_game("[name]: Generated [active_quests.len] daily quests for day [last_rotation_day].")

/// Rotates out old quests and generates new ones (called on day change)
/datum/controller/subsystem/daily_quest/proc/rotate_daily_quests()
	// Move completed/expired quests to archive
	for(var/datum/daily_quest/quest as anything in active_quests)
		if(!quest.completed)
			// Uncompleted quests expire without reward
			quest.completed = TRUE
		completed_quests += quest

	active_quests.Cut()
	generate_daily_quests()

	// Announce the new quests over the radio for sec
	var/datum/radio_frequency/radio_freq = SSradio.return_frequency(FREQ_SECURITY)
	if(radio_freq)
		var/list/announcement_messages = list()
		for(var/datum/daily_quest/quest as anything in active_quests)
			announcement_messages += "[quest.quest_name] — [quest.reward] [MONEY_SYMBOL]"
		var/announcement_text = "New Daily Security Quests Available:\n" + announcement_messages.Join("\n")
		radio_freq.announcement(announcement_text, "Daily Quest Terminal")

/// Assigns unassigned quests to security-aligned players
/datum/controller/subsystem/daily_quest/proc/assign_unassigned_quests()
	for(var/datum/daily_quest/quest as anything in active_quests)
		if(quest.completed || quest.assigned_ckey)
			continue
		// Find a security player who hasn't been assigned this quest
		for(var/mob/living/player as anything in GLOB.mob_living_list)
			if(!player.client || !player.mind)
				continue
			if(!player.mind.assigned_role)
				continue
			if(!(player.mind.assigned_role.departments_bitflags & DEPARTMENT_BITFLAG_SECURITY))
				continue
			if(is_quest_assigned_to(player.ckey))
				continue
			quest.assigned_ckey = player.ckey
			to_chat(player, span_notice("<b>Daily Quest</b>: [quest.quest_name] — [quest.quest_description]"))
			to_chat(player, span_notice("Reward: [quest.reward] [MONEY_SYMBOL]"))
			break

/// Check if a ckey already has an active quest assignment
/datum/controller/subsystem/daily_quest/proc/is_quest_assigned_to(ckey)
	for(var/datum/daily_quest/quest as anything in active_quests)
		if(quest.assigned_ckey == ckey && !quest.completed)
			return TRUE
	return FALSE

/// Returns the active quest matching a quest type, if any
/datum/controller/subsystem/daily_quest/proc/get_quest_by_type(quest_type)
	for(var/datum/daily_quest/quest as anything in active_quests)
		if(quest.quest_type == quest_type && !quest.completed)
			return quest
	return null

/// Returns the active quest assigned to a given ckey, if any
/datum/controller/subsystem/daily_quest/proc/get_quest_by_ckey(ckey)
	for(var/datum/daily_quest/quest as anything in active_quests)
		if(quest.assigned_ckey == ckey && !quest.completed)
			return quest
	return null

/// Attempts to advance progress on a quest for a specific player
/datum/controller/subsystem/daily_quest/proc/advance_quest(quest_type, mob/living/player)
	var/datum/daily_quest/quest = get_quest_by_type(quest_type)
	if(!quest)
		return FALSE
	if(quest.completed)
		return FALSE
	if(quest.assigned_ckey && quest.assigned_ckey != player.ckey)
		// Different player — can't progress this assigned quest
		return FALSE

	quest.progress = min(quest.progress + 1, quest.progress_target)
	if(quest.progress >= quest.progress_target)
		return complete_quest(quest, player)
	return TRUE

/// Completes a quest and pays out the reward
/datum/controller/subsystem/daily_quest/proc/complete_quest(datum/daily_quest/quest, mob/living/player)
	if(quest.completed)
		return FALSE

	var/success = quest.pay_reward(player)
	if(success)
		// Announce over security radio
		var/datum/radio_frequency/radio_freq = SSradio.return_frequency(FREQ_SECURITY)
		if(radio_freq)
			radio_freq.announcement("[player.real_name] completed daily quest: [quest.quest_name]!", "Daily Quest Terminal")
		log_game("[name]: [player.real_name] ([player.ckey]) completed quest [quest.quest_name] for [quest.reward] credits.")
		return TRUE
	return FALSE

/// Returns a formatted list of all active quests
/datum/controller/subsystem/daily_quest/proc/list_active_quests()
	. = list()
	for(var/datum/daily_quest/quest as anything in active_quests)
		. += quest.get_quest_info()
