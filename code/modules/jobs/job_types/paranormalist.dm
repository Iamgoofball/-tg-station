/datum/job/paranormalist
	title = JOB_PARANORMALIST
	description = "Investigate space station hauntings, collect ectoplasmic residue, and aid the spirits of the deceased."
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOP
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "PARANORMALIST"

	outfit = /datum/outfit/job/paranormalist

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV

	display_order = JOB_DISPLAY_ORDER_PARANORMALIST
	departments_list = list(
		/datum/job_department/service,
	)

	family_heirlooms = list(
		/obj/item/ouija_board,
	)

	job_flags = STATION_JOB_FLAGS

/datum/job/paranormalist/get_default_roundstart_spawn_point()
	// Dynamically integrate job into ALL maps!
	// If no specific landmark exists for this job, find any service department start landmark (like chapel or library or assistant start)
	// and spawn the landmark there.
	var/obj/effect/landmark/start/spawn_point = ..()
	if(!spawn_point)
		var/list/fallback_types = list(
			/obj/effect/landmark/start/chaplain,
			/obj/effect/landmark/start/librarian,
			/obj/effect/landmark/start/assistant
		)
		for(var/fallback_type in fallback_types)
			var/obj/effect/landmark/start/fallback = locate(fallback_type) in GLOB.start_landmarks_list
			if(fallback)
				// Create a new start landmark at the fallback's location
				var/obj/effect/landmark/start/new_spawn = new /obj/effect/landmark/start/paranormalist(fallback.loc)
				new_spawn.name = title
				return new_spawn
	return spawn_point

/datum/outfit/job/paranormalist
	name = "Paranormalist"
	jobtype = /datum/job/paranormalist

	id_trim = /datum/id_trim/job/paranormalist
	uniform = /obj/item/clothing/under/rank/civilian/chaplain
	suit = /obj/item/clothing/suit/toggle/jacket/det_trench
	backpack_contents = list(
		/obj/item/pke_meter = 1,
		/obj/item/ouija_board = 1,
		/obj/item/ecto_sucker = 1,
		/obj/item/spirit_jar = 1,
	)
	belt = /obj/item/modular_computer/pda/chaplain
	ears = /obj/item/radio/headset/headset_srv
	head = /obj/item/clothing/head/fedora/det_hat

/obj/effect/landmark/start/paranormalist
	name = JOB_PARANORMALIST
	icon_state = "chaplain"
