/// SAP KPI Extraction Subsystem
/// Extracts and exports Space Station 13 server metrics for SAP HANA ingestion.
/// Part of Bounty #353: Enterprise Modernization — SAP S/4HANA Integration
#define SAP_KPI_EXPORT_DIR "data/sap_kpi/"

SUBSYSTEM_DEF(sap_kpi)
	name = "SAP KPI"
	wait = 5 MINUTES
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	ss_flags = SS_NO_TICK_CHECK

	/// Accumulated round stats for the current round
	var/list/round_stats = list()
	/// Tracked ckey -> rounds played for all-time aggregation
	var/list/player_rounds = list()
	/// Tracked character appearances: ckey -> list(name, job, department)
	var/list/character_appearances = list()
	/// Tracked game mode outcomes: mode -> list(wins=0, losses=0, draws=0)
	var/list/mode_outcomes = list()
	/// Antagonist win/loss ratios: antag_type -> list(wins=0, losses=0)
	var/list/antag_outcomes = list()
	/// Cause of death tracking: cause -> count
	var/list/death_causes = list()
	/// Station damage per round: total brute damage dealt to station structures
	var/station_damage_total = 0
	/// Round start real time
	var/round_start_real = 0
	/// Whether a round-end dump has been performed
	var/round_end_dumped = FALSE

/datum/controller/subsystem/sap_kpi/Initialize()
	round_start_real = REALTIMEOFDAY
	round_stats = list(
		"round_id" = GLOB.round_id,
		"start_time" = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss"),
		"server_name" = world.name,
		"server_address" = world.internet_address || "127.0.0.1",
		"server_port" = world.port,
	)
	return SS_INIT_SUCCESS

/// Record a player joining a round
/datum/controller/subsystem/sap_kpi/proc/record_player_round(ckey)
	if(!ckey)
		return
	player_rounds[ckey] = (player_rounds[ckey] || 0) + 1

/// Record a character appearance with job info
/datum/controller/subsystem/sap_kpi/proc/record_character_appearance(ckey, char_name, job_title, department)
	if(!ckey || !char_name)
		return
	if(!character_appearances[ckey])
		character_appearances[ckey] = list()
	character_appearances[ckey] += list(list(
		"name" = char_name,
		"job" = job_title || "Unknown",
		"department" = department || "Unknown",
		"timestamp" = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss"),
	))

/// Record a game mode outcome
/datum/controller/subsystem/sap_kpi/proc/record_mode_outcome(mode_name, outcome)
	if(!mode_name)
		return
	if(!mode_outcomes[mode_name])
		mode_outcomes[mode_name] = list("wins" = 0, "losses" = 0, "draws" = 0)
	switch(outcome)
		if("crew_victory")
			mode_outcomes[mode_name]["wins"]++
		if("crew_loss")
			mode_outcomes[mode_name]["losses"]++
		if("draw")
			mode_outcomes[mode_name]["draws"]++

/// Record antagonist outcome
/datum/controller/subsystem/sap_kpi/proc/record_antag_outcome(antag_type, success)
	if(!antag_type)
		return
	if(!antag_outcomes[antag_type])
		antag_outcomes[antag_type] = list("wins" = 0, "losses" = 0)
	if(success)
		antag_outcomes[antag_type]["wins"]++
	else
		antag_outcomes[antag_type]["losses"]++

/// Record a cause of death
/datum/controller/subsystem/sap_kpi/proc/record_death_cause(cause)
	if(!cause)
		cause = "Unknown"
	death_causes[cause] = (death_causes[cause] || 0) + 1

/// Record station structural damage
/datum/controller/subsystem/sap_kpi/proc/record_station_damage(amount)
	station_damage_total += amount

/// Fire periodically: export live data snapshot
/datum/controller/subsystem/sap_kpi/fire()
	export_live_snapshot()

/// Export a live snapshot to JSON file for SAP polling
/datum/controller/subsystem/sap_kpi/proc/export_live_snapshot()
	var/list/snapshot = build_snapshot()
	snapshot["snapshot_type"] = "live"
	snapshot["timestamp"] = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	snapshot["round_elapsed"] = round((world.time - SSticker.round_start_time) / 600, 0.1)

	var/json_data = json_encode(snapshot)
	var/filename = "[SAP_KPI_EXPORT_DIR]live_snapshot_[GLOB.round_id].json"
	fdel(filename)
	text2file(json_data, filename)

/// Build the full KPI data structure
/datum/controller/subsystem/sap_kpi/proc/build_snapshot()
	. = list()
	.["round"] = round_stats.Copy()
	.["player_count"] = LAZYLEN(GLOB.player_list)
	.["total_players_tracked"] = LAZYLEN(player_rounds)
	.["player_rounds"] = player_rounds.Copy()
	.["character_appearances"] = character_appearances.Copy()
	.["mode_outcomes"] = mode_outcomes.Copy()
	.["antag_outcomes"] = antag_outcomes.Copy()
	.["death_causes"] = death_causes.Copy()
	.["station_damage_total"] = station_damage_total
	.["round_duration_seconds"] = round((world.time - SSticker.round_start_time) / 10, 1)
	.["unique_characters"] = LAZYLEN(character_appearances)

/// Final round-end export — called when round completes
/datum/controller/subsystem/sap_kpi/proc/export_round_end()
	if(round_end_dumped)
		return
	round_end_dumped = TRUE

	var/list/final_data = build_snapshot()
	final_data["snapshot_type"] = "round_end"
	final_data["timestamp"] = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	final_data["round_end_reason"] = SSticker.end_state || "unknown"
	final_data["round_duration_seconds"] = round((world.time - SSticker.round_start_time) / 10, 1)
	final_data["total_station_damage"] = station_damage_total

	var/json_data = json_encode(final_data)
	var/filename = "[SAP_KPI_EXPORT_DIR]round_end_[GLOB.round_id].json"
	fdel(filename)
	text2file(json_data, filename)

	// Also write a cumulative all-time stats file
	export_cumulative_stats()

/// Export all-time cumulative statistics
/datum/controller/subsystem/sap_kpi/proc/export_cumulative_stats()
	var/list/cumulative = list()
	cumulative["snapshot_type"] = "cumulative"
	cumulative["timestamp"] = time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")
	cumulative["total_rounds_tracked"] = 1 // incremented each round-end
	cumulative["total_player_rounds"] = LAZYLEN(player_rounds)
	cumulative["total_character_appearances"] = LAZYLEN(character_appearances)
	cumulative["mode_outcomes"] = mode_outcomes.Copy()
	cumulative["antag_outcomes"] = antag_outcomes.Copy()
	cumulative["death_causes_top10"] = get_top_death_causes(10)
	cumulative["total_station_damage_all_time"] = station_damage_total

	var/json_data = json_encode(cumulative)
	var/filename = "[SAP_KPI_EXPORT_DIR]cumulative_stats.json"
	fdel(filename)
	text2file(json_data, filename)

/// Get top N death causes sorted by count
/datum/controller/subsystem/sap_kpi/proc/get_top_death_causes(limit = 10)
	var/list/sorted = sortTimedeath_causes.Copy(), GLOBAL_PROC_REF(cmp_numeric_dsc), associative = TRUE)
	var/list/result = list()
	var/count = 0
	for(var/cause in sorted)
		if(count >= limit)
			break
		result[cause] = sorted[cause]
		count++
	return result
