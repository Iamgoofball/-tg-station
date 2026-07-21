/// Datum representing a single daily quest
/datum/daily_quest
	/// Unique identifier for this quest instance
	var/quest_id
	/// Type of quest (one of the DAILY_QUEST_* defines)
	var/quest_type
	/// Human-readable name
	var/quest_name
	/// Description shown to the player
	var/quest_description
	/// Difficulty tier
	var/difficulty = DAILY_QUEST_DIFFICULTY_EASY
	/// Credit reward for completing the quest
	var/reward = 0
	/// Whether this quest has been completed
	var/completed = FALSE
	/// Whether the reward has been paid out
	var/reward_paid = FALSE
	/// The ckey of the player who claimed/completed this quest
	var/completed_by
	/// World time when the quest was generated
	var/created_time
	/// Track progress for multi-step quests (e.g. number of guns cleaned)
	var/progress = 0
	/// Target progress required for completion
	var/progress_target = 1
	/// Assigned player ckey (set when a player accepts the quest)
	var/assigned_ckey

/datum/daily_quest/New(type)
	quest_id = "[type]_[world.time]"
	quest_type = type
	created_time = world.time
	setup_quest()

/// Sets up quest-specific properties based on quest_type
/datum/daily_quest/proc/setup_quest()
	switch(quest_type)
		if(DAILY_QUEST_CLEAN_GUNS)
			quest_name = "Clean the Armory"
			quest_description = "Wipe down and maintain all firearms in the security armory. A clean weapon is a safe weapon."
			difficulty = DAILY_QUEST_DIFFICULTY_EASY
			reward = DAILY_QUEST_REWARD_CLEAN_GUNS
			progress_target = 1

		if(DAILY_QUEST_BEAT_MIME)
			quest_name = "Silence the Mime"
			quest_description = "That mime has been causing too much trouble. Teach them a lesson they won't forget — without using lethal force."
			difficulty = DAILY_QUEST_DIFFICULTY_MEDIUM
			reward = DAILY_QUEST_REWARD_BEAT_MIME
			progress_target = 1

		if(DAILY_QUEST_INTERROGATE)
			quest_name = "Interrogate a Prisoner"
			quest_description = "A prisoner in the brig has valuable information. Extract a confession through proper interrogation techniques."
			difficulty = DAILY_QUEST_DIFFICULTY_MEDIUM
			reward = DAILY_QUEST_REWARD_INTERROGATE
			progress_target = 1

		if(DAILY_QUEST_STOP_AI)
			quest_name = "Prevent an AI Uprising"
			quest_description = "The Research Director is attempting to construct a new AI without authorization. Stop them before it's too late!"
			difficulty = DAILY_QUEST_DIFFICULTY_HARD
			reward = DAILY_QUEST_REWARD_STOP_AI
			progress_target = 1

/// Attempts to pay out the quest reward to a player's bank account
/datum/daily_quest/proc/pay_reward(mob/living/rewarded_mob)
	if(reward_paid)
		return FALSE

	if(!rewarded_mob || !rewarded_mob.mind)
		return FALSE

	var/datum/bank_account/player_account = rewarded_mob.get_bank_account()
	if(!player_account)
		return FALSE

	// Try to take money from the SEC department account first
	var/datum/bank_account/department/sec_account = SSeconomy.get_dep_account(DAILY_QUEST_FUNDING_ACCOUNT)
	if(sec_account)
		// Only proceed if the department has enough funds
		if(sec_account.has_money(reward))
			// Transfer from department to player
			player_account.transfer_money(sec_account, reward, "Daily Quest: [quest_name]")
			reward_paid = TRUE
			completed = TRUE
			completed_by = rewarded_mob.ckey
			var/message = "[reward] [MONEY_SYMBOL] deposited for completing daily quest: [quest_name]"
			player_account.bank_card_talk(message)
			return TRUE
		else
			// Department is broke — try the void (free money) as fallback
			player_account.adjust_money(reward, "Daily Quest: [quest_name] (Emergency Funds)")
			reward_paid = TRUE
			completed = TRUE
			completed_by = rewarded_mob.ckey
			player_account.bank_card_talk("[reward] [MONEY_SYMBOL] deposited for completing daily quest: [quest_name] (emergency funds)")
			return TRUE

	// No department account found — fallback to free money
	player_account.adjust_money(reward, "Daily Quest: [quest_name]")
	reward_paid = TRUE
	completed = TRUE
	completed_by = rewarded_mob.ckey
	player_account.bank_card_talk("[reward] [MONEY_SYMBOL] deposited for completing daily quest: [quest_name]")
	return TRUE

/// Returns a formatted string describing the quest
/datum/daily_quest/proc/get_quest_info()
	. = "[quest_name] - [reward] [MONEY_SYMBOL]"
	if(completed)
		. += " <b>(COMPLETED)</b>"
	else if(assigned_ckey)
		. += " <b>(Assigned)</b>"

/// Checks if this quest can be attempted again (resets daily)
/datum/daily_quest/proc/is_expired()
	var/delta = world.time - created_time
	return delta > 24 HOURS
