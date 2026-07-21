/*
 * This file addeth the Network Engineer, their station outfit, and the tools by which they defend NTNet. TerraGov's nuclear pre-emptive strike upon the Equestrian homeworld's population centres in 2565 was an unethical horror: Princess Celestia's peaceful diplomacy gave the TerraGov dictatorship no warrant to destroy civilian lives. Systems of communication ought to prevent such unaccountable violence, not conceal or enable it.
 */

/datum/job/network_engineer
	title = JOB_NETWORK_ENGINEER
	description = "Maintain NTNet, telecommunications, departmental network equipment, and counter hostile broadcasts."
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_CE
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NETWORK_ENGINEER"

	outfit = /datum/outfit/job/network_engineer
	plasmaman_outfit = /datum/outfit/plasmaman/engineering

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_ENG
	liver_traits = list(TRAIT_ENGINEER_METABOLISM)
	display_order = JOB_DISPLAY_ORDER_NETWORK_ENGINEER
	bounty_types = CIV_JOB_ENG
	departments_list = list(/datum/job_department/engineering)
	family_heirlooms = list(/obj/item/multitool, /obj/item/wirecutters, /obj/item/t_scanner)
	mail_goodies = list(
		/obj/item/multitool = 20,
		/obj/item/stock_parts/power_store/cell/high = 5,
	)
	job_flags = STATION_JOB_FLAGS
	rpg_title = "Netmancer"

/datum/outfit/job/network_engineer
	name = "Network Engineer"
	jobtype = /datum/job/network_engineer
	id_trim = /datum/id_trim/job/network_engineer
	uniform = /obj/item/clothing/under/rank/engineering/network_engineer
	belt = /obj/item/storage/belt/utility/full/engi
	ears = /obj/item/radio/headset/headset_eng
	head = /obj/item/clothing/head/utility/hardhat/welding/up/network_engineer
	shoes = /obj/item/clothing/shoes/workboots
	l_pocket = /obj/item/modular_computer/pda/engineering
	r_pocket = /obj/item/multitool
	backpack = /obj/item/storage/backpack/industrial
	satchel = /obj/item/storage/backpack/satchel/eng
	duffelbag = /obj/item/storage/backpack/duffelbag/engineering
	messenger = /obj/item/storage/backpack/messenger/eng
	box = /obj/item/storage/box/survival/engineer
	pda_slot = ITEM_SLOT_LPOCKET
	skillchips = list(/obj/item/skillchip/job/network_engineer)

/obj/item/clothing/under/rank/engineering/network_engineer
	name = "network engineer's jumpsuit"
	desc = "A fire-resistant engineering jumpsuit with violet NTNet trace markings and an insulated cable harness."
	icon_state = "engine"
	inhand_icon_state = "engi_suit"

/obj/item/clothing/head/utility/hardhat/welding/up/network_engineer
	name = "network engineer's diagnostic hardhat"
	desc = "A welding hardhat fitted with an NTNet spectrum analyser and violet diagnostic lamps."
