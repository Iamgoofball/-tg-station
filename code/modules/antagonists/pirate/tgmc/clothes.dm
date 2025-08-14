/datum/armor/tgmc_marine_armor
	melee = 40
	bullet = 60
	laser = 60
	energy = 45
	bomb = 45
	fire = 45
	acid = 50
	wound = 10

/datum/armor/tgmc_marine_helmet_armor
	melee = 50
	bullet = 50
	laser = 50
	energy = 50
	bomb = 50
	fire = 50
	acid = 50
	wound = 10

/datum/armor/tgmc_marine_cap_armor
	melee = 35
	bullet = 35
	laser = 35
	energy = 15
	bomb = 10
	fire = 15
	acid = 15
	wound = 10

/datum/action/item_action/toggle_light/tgmc
	background_icon_state = "bg_tgmc"

/obj/item/clothing/suit/armor/vest/tgmc
	name = "M3 pattern marine armor"
	desc = "A standard TerraGov Marine Corps M3 Pattern Chestplate. Protects the chest from ballistic rounds, bladed objects and accidents. \
	It has a small leather pouch strapped to it for limited storage."
	icon_state = "tgmc_armor"
	worn_icon_state = "tgmc_armor"
	inhand_icon_state = "armor"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor_type = /datum/armor/tgmc_marine_armor
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	siemens_coefficient = 0.7
	actions_types = list(/datum/action/item_action/toggle_light/tgmc)
	light_range = 5 // A little better than the standard flashlight.
	light_power = 0.8
	light_on_time = 0.05 SECONDS
	light_off_time = 0.15 SECONDS
	light_color = "#99ccff"
	light_system = OVERLAY_LIGHT_DIRECTIONAL_VISCONTENTS
	light_on = FALSE
	/// The sound the light makes when it's turned on
	var/sound_on = 'sound/items/weapons/magin.ogg'
	/// The sound the light makes when it's turned off
	var/sound_off = 'sound/items/weapons/magout.ogg'
	///Boolean on whether the light is on and flashing.
	var/light_enabled = FALSE

/obj/item/clothing/suit/armor/vest/tgmc/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/magnetic_harness)

/obj/item/clothing/suit/armor/vest/tgmc/attack_self(mob/user)
	. = ..()
	if(.)
		return .
	light_enabled = !light_enabled
	set_light_on(light_enabled)
	playsound(src, light_on ? sound_off : sound_on, 40, TRUE)
	update_item_action_buttons()
	update_appearance(UPDATE_ICON)
	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		wearer.update_worn_oversuit()

/obj/item/clothing/suit/armor/vest/tgmc/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(light_enabled)
		. += emissive_appearance(icon, "tgmc_armor-e", src)

/obj/item/clothing/suit/armor/vest/tgmc/command
	name = "M3-C pattern marine armor"
	desc = "A standard TerraGov Marine Corps M3-C Pattern Chestplate. Protects the officer's chest from ballistic rounds, bladed objects and accidents. \
	It has a small leather pouch strapped to it for limited storage."
	icon_state = "tgmc_armor_command"
	worn_icon_state = "tgmc_armor_command"

/obj/item/clothing/suit/armor/vest/tgmc/engineer
	name = "M3-E pattern marine armor"
	desc = "A standard TerraGov Marine Corps M3-E Pattern Chestplate. Protects the engineer's chest from ballistic rounds, bladed objects and accidents. \
	It has a small leather pouch strapped to it for limited storage."
	icon_state = "tgmc_armor_engineer"
	worn_icon_state = "tgmc_armor_engineer"

/obj/item/clothing/under/misc/tgmc
	name = "TGMC uniform"
	icon = 'icons/obj/clothing/under/misc.dmi'
	icon_state = "tgmc_uniform"
	worn_icon_state = "tgmc_uniform"
	desc = "A standard-issue, kevlar-weaved, hazmat-tested, EMF-augmented marine uniform. You suspect it's not as robust-proof as advertised."
	siemens_coefficient = 0.9
	sensor_mode = SENSOR_COORDS
	can_adjust = TRUE

/obj/item/clothing/under/misc/tgmc/medic
	name = "TGMC corpsman uniform"
	icon_state = "tgmc_uniform_medic"
	worn_icon_state = "tgmc_uniform_medic"

/obj/item/clothing/under/misc/tgmc/engineer
	name = "TGMC engineer uniform"
	icon_state = "tgmc_uniform_engineer"
	worn_icon_state = "tgmc_uniform_engineer"

/obj/item/clothing/head/soft/tgmc
	name = "marine sergeant cap"
	desc = "It's a soft cap made from advanced ballistic-resistant fibres. Fails to prevent lumps in the head."
	icon_state = "tgmc_cap"
	soft_type = "tgmc"
	soft_suffix = "_cap"
	armor_type = /datum/armor/tgmc_marine_cap_armor
	dog_fashion = null

/obj/item/clothing/shoes/jackboots/tgmc
	name = "marine combat boots"
	desc = "Standard issue combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "tgmc_boots"
	worn_icon_state = "tgmc_boots"
	clothing_traits = list(TRAIT_NO_SLIP_ALL)
	siemens_coefficient = 0.7

/obj/item/clothing/shoes/jackboots/tgmc/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jump_shoes)

/obj/item/clothing/head/helmet/tgmc
	name = "\improper M10 pattern marine helmet"
	desc = "A standard M10 Pattern Helmet. It reads on the label, 'The difference between an open-casket and closed-casket funeral. Wear on head for best results.'."
	icon_state = "tgmc_helmet"
	worn_icon_state = "tgmc_helmet"
	clothing_traits = list(TRAIT_SECURITY_HUD)
	armor_type = /datum/armor/tgmc_marine_helmet_armor

/obj/item/clothing/head/helmet/tgmc/command
	name = "\improper M10-C pattern marine helmet"
	icon_state = "tgmc_helmet_command"
	worn_icon_state = "tgmc_helmet_command"
	clothing_traits = list(TRAIT_SECURITY_HUD, TRAIT_MEDICAL_HUD)
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/clothing/head/helmet/tgmc/command/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	. += emissive_appearance(icon_file, "tgmc_helmet_command-e", src)

/obj/item/clothing/head/helmet/tgmc/medic
	name = "\improper M10-M pattern marine helmet"
	icon_state = "tgmc_helmet_medic"
	worn_icon_state = "tgmc_helmet_medic"
	clothing_traits = list(TRAIT_SECURITY_HUD, TRAIT_MEDICAL_HUD)

/obj/item/clothing/head/helmet/tgmc/medic/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	. += emissive_appearance(icon_file, "tgmc_helmet_medic-e", src)

/obj/item/clothing/head/helmet/tgmc/engineer
	name = "\improper M10-E pattern marine helmet"
	icon_state = "tgmc_helmet_engineer"
	worn_icon_state = "tgmc_helmet_engineer"
	flash_protect = FLASH_PROTECTION_WELDER

/obj/item/storage/backpack/tgmc
	name = "\improper lightweight IMP backpack"
	desc = "The standard-issue pack of the TGMC forces. Designed to slug gear into the battlefield."
	icon_state = "marinepack"
	worn_icon_state = "marinepack"

/datum/action/item_action/toggle_paddles/tgmc
	background_icon_state = "bg_tgmc"

/obj/item/storage/backpack/tgmc/corpsman
	name = "\improper TGMC corpsman backpack"
	desc = "The standard-issue backpack worn by TGMC corpsmen. Has a built in defibrilator."
	icon_state = "marinepackm"
	worn_icon_state = "marinepackm"
	actions_types = list(/datum/action/item_action/toggle_paddles)
	var/obj/item/shockpaddles/tgmc/paddles
	var/obj/item/shockpaddles/paddle_type = /obj/item/shockpaddles/tgmc

/obj/item/shockpaddles/tgmc
	req_defib = FALSE
	var/obj/item/storage/backpack/tgmc/corpsman/my_backpack

/obj/item/storage/backpack/tgmc/corpsman/Initialize(mapload)
	. = ..()
	paddles = new paddle_type(src)
	paddles.my_backpack = src

/obj/item/storage/backpack/tgmc/corpsman/Destroy(force)
	paddles.my_backpack = null
	qdel(paddles)
	paddles = null
	. = ..()

/obj/item/shockpaddles/tgmc/dropped(mob/user)
	. = ..()
	user.balloon_alert(user, "paddles stowed")
	forceMove(my_backpack)

/obj/item/storage/backpack/tgmc/corpsman/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(held_item == paddles)
		context[SCREENTIP_CONTEXT_LMB] = "Stow Paddles"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Take Paddles"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/storage/backpack/marine/corpsman/click_alt(mob/user)
	. = ..()
	if(loc == user)
		if(user.get_item_by_slot(ITEM_SLOT_BACK) == src)
			ui_action_click()
			return NONE
		else
			user.balloon_alert(user, "wear first!")
			return NONE
	return ..()

/obj/item/storage/backpack/tgmc/corpsman/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool == paddles)
		user.balloon_alert(user, "paddles stowed")
		user.temporarilyRemoveItemFromInventory(paddles)
		paddles.forceMove(src)
		return
	. = ..()

/obj/item/storage/backpack/tgmc/corpsman/ui_action_click()
	INVOKE_ASYNC(src, PROC_REF(toggle_paddles))

/obj/item/storage/backpack/tgmc/corpsman/proc/toggle_paddles()
	if(usr)
		var/mob/living/carbon/human/user = usr
		if(paddles.loc == src)
			if(!user.put_in_hands(paddles))
				user.balloon_alert(user, "hands full!")
				return
		else
			user.balloon_alert(user, "paddles stowed")
			user.temporarilyRemoveItemFromInventory(paddles)
			paddles.forceMove(src)
			return

/obj/item/storage/backpack/tgmc/engineer
	name = "\improper TGMC engineer backpack"
	desc = "The standard-issue backpack worn by TGMC engineers."
	icon_state = "engineerpack"
	worn_icon_state = "engineerpack"

/datum/action/item_action/radio_requisitions
	name = "Radio Requisitions"
	background_icon_state = "bg_tgmc"

/datum/action/item_action/radio_requisitions/do_effect(trigger_flags)
	if(!target)
		return FALSE
	var/obj/item/item_target = target
	item_target.ui_interact(owner)
	return TRUE

/obj/item/storage/backpack/tgmc/command
	name = "\improper TGMC command radiopack"
	desc = "A backpack that resembles the ones old-age radio operator marines would use. \
	It has a supply ordering console installed on it, and a retractable antenna to receive supply drops. \
	There's a red snake logo on the radio pack, and it looks like it's been tampered with beyond standard TGMC spec."
	icon_state = "radiopack"
	worn_icon_state = "radiopack"
	actions_types = list(/datum/action/item_action/radio_requisitions)
	var/list/meme_pack_data

/obj/item/storage/backpack/tgmc/command/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoExpressTGMC", name) // REQ PLEASE SEND ME MORE SMARTGUN AMMO
		ui.open()

/obj/item/storage/backpack/tgmc/command/proc/get_packs_data(group, express = FALSE)
	var/list/packs = list()
	for(var/pack_id in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_id]
		if(pack.group != group)
			continue

		var/obj/item/first_item = length(pack.contains) > 0 ? pack.contains[1] : null
		packs += list(list(
			"name" = pack.name,
			"cost" = pack.get_cost(),
			"id" = pack_id,
			"desc" = pack.desc || pack.name, // If there is a description, use it. Otherwise use the pack's name.
			"first_item_icon" = first_item?.icon,
			"first_item_icon_state" = first_item?.icon_state,
			"goody" = pack.goody,
			"access" = pack.access,
			"contraband" = pack.contraband,
			"contains" = pack.get_contents_ui_data(),
		))

	return packs

/obj/item/storage/backpack/tgmc/command/proc/packin_up(forced = FALSE)
	meme_pack_data = list()
	if(!forced && !SSshuttle.initialized)
		SSshuttle.express_consoles += src
		return

	for(var/pack_id in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_id]
		if(!istype(pack, /datum/supply_pack/tgmc))
			continue
		if(!meme_pack_data[pack.group])
			meme_pack_data[pack.group] = list(
				"name" = pack.group,
				"packs" = get_packs_data(pack.group, express = TRUE),
			)

/obj/item/storage/backpack/tgmc/command/ui_data(mob/user)
	var/list/data = list()
	var/datum/bank_account/account = SSeconomy.get_dep_account(ACCOUNT_SYN)
	if(account)
		data["points"] = account.account_balance
	data["supplies"] = list()
	if(!meme_pack_data)
		packin_up()
		stack_trace("There was no pack data for [src]")
	data["supplies"] = meme_pack_data
	return data

/obj/item/storage/backpack/tgmc/command/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	switch(action)
		if("add")//Generate Supply Order first
			if(TIMER_COOLDOWN_RUNNING(src, COOLDOWN_EXPRESSPOD_CONSOLE))
				say("Railgun recalibrating. Stand by.")
				return
			var/id = params["id"]
			id = text2path(id) || id
			var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
			if(!istype(pack))
				CRASH("Unknown supply pack id given by express order console ui. ID: [params["id"]]")
			var/name = "*None Provided*"
			var/rank = "*None Provided*"
			var/ckey = user.ckey
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				name = H.get_authentification_name()
				rank = H.get_assignment(hand_first = TRUE)
			var/reason = "TGMC Requisition"
			var/datum/supply_order/order = new(pack, name, rank, ckey, reason)
			var/datum/bank_account/account = SSeconomy.get_dep_account(ACCOUNT_SYN)
			if (isnull(account) && order.pack.get_cost() > 0)
				return

			var/turf/landing_turf = get_turf(src)

			if (!account.adjust_money(-order.pack.get_cost()))
				return

			TIMER_COOLDOWN_START(src, COOLDOWN_EXPRESSPOD_CONSOLE, 5 SECONDS)
			new /obj/effect/pod_landingzone/hacked(landing_turf, /obj/structure/closet/supplypod/syndicate, order)
			return TRUE

/obj/structure/closet/supplypod/syndicate
	style = /datum/pod_style/syndicate

/obj/item/radio/headset/syndicate/alt/tgmc
	name = "marine radio headset"
	desc = "A standard military radio headset."
	icon_state = "tgmc_headset"
	worn_icon_state = "tgmc_headset"
	var/marker_flags = MINIMAP_FLAG_TGMC
	var/map_type = /datum/action/minimap/tgmc
	var/icon_state_for_map = "private"

/obj/item/radio/headset/syndicate/alt/tgmc/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/locator_and_minimap, map_type, marker_flags, icon_state_for_map)

/obj/item/radio/headset/syndicate/alt/tgmc/command
	name = "marine commander radio headset"
	command = TRUE
	icon_state_for_map = "leader"

/obj/item/radio/headset/syndicate/alt/tgmc/medic
	name = "marine corpsman radio headset"
	icon_state_for_map = "medic"

/obj/item/radio/headset/syndicate/alt/tgmc/engineer
	name = "marine engineer radio headset"
	worn_icon_state = "tgmc_headset_engineer"
	icon_state = "tgmc_headset_engineer"
	icon_state_for_map = "engi"

/datum/outfit/tgmc
	name = "TGMC Marine"
	uniform = /obj/item/clothing/under/misc/tgmc
	shoes = /obj/item/clothing/shoes/jackboots/tgmc
	gloves = /obj/item/clothing/gloves/combat
	belt = /obj/item/gun/ballistic/p23
	head = /obj/item/clothing/head/helmet/tgmc
	suit = /obj/item/clothing/suit/armor/vest/tgmc
	ears = /obj/item/radio/headset/syndicate/alt/tgmc
	r_pocket = /obj/item/storage/tgmc_pouch/ammo/ar21
	l_pocket = /obj/item/storage/tgmc_pouch/grenade_pouch/prefilled
	back = /obj/item/storage/backpack/tgmc
	backpack_contents = list(
		/obj/item/lighter/greyscale,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/tgmc_pouch/ammo_pistol/filled,
	)
	suit_store = /obj/item/gun/ballistic/automatic/ar21
	id = /obj/item/card/id/tgmc

/datum/outfit/tgmc/command
	name = "TGMC Squad Leader"
	head = /obj/item/clothing/head/soft/tgmc
	suit = /obj/item/clothing/suit/armor/vest/tgmc/command
	ears = /obj/item/radio/headset/syndicate/alt/tgmc/command
	mask = /obj/item/cigarette/cigar/premium
	back = /obj/item/storage/backpack/tgmc/command
	belt = /obj/item/gun/ballistic/p23
	backpack_contents = list(
		/obj/item/melee/baton/telescopic/gold,
		/obj/item/lighter,
		/obj/item/clothing/mask/whistle,
		/obj/item/storage/tgmc_pouch/ammo_pistol/filled,
		/obj/item/storage/tgmc_pouch/grenade_pouch/prefilled,
	)
	id = /obj/item/card/id/tgmc/leader

/datum/outfit/tgmc/medic
	name = "TGMC Corpsman"
	head = /obj/item/clothing/head/helmet/tgmc/medic
	ears = /obj/item/radio/headset/syndicate/alt/tgmc/medic
	uniform = /obj/item/clothing/under/misc/tgmc/medic
	r_pocket = /obj/item/healthanalyzer/advanced
	l_pocket = /obj/item/storage/tgmc_pouch/medipen_pouch/prefilled
	r_hand = /obj/item/storage/medkit/surgery
	belt = /obj/item/storage/belt/medical/paramedic
	back = /obj/item/storage/backpack/tgmc/corpsman
	gloves = /obj/item/clothing/gloves/latex/nitrile
	suit_store = /obj/item/gun/ballistic/shotgun/sh35
	mask = /obj/item/clothing/mask/surgical
	backpack_contents = list(
		/obj/item/lighter/greyscale,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/gun/ballistic/p23,
		/obj/item/storage/tgmc_pouch/ammo_pistol/filled,
		/obj/item/storage/tgmc_pouch/grenade_pouch/prefilled,
		/obj/item/storage/shell_box/buckshot/prefilled,
		/obj/item/storage/shell_box/buckshot/prefilled,
	)
	id = /obj/item/card/id/tgmc/corpsman

/datum/outfit/tgmc/engineer
	name = "TGMC Engineer"
	head = /obj/item/clothing/head/helmet/tgmc/engineer
	ears = /obj/item/radio/headset/syndicate/alt/tgmc/engineer
	uniform = /obj/item/clothing/under/misc/tgmc/engineer
	suit = /obj/item/clothing/suit/armor/vest/tgmc/engineer
	belt = /obj/item/storage/belt/utility/full/engi
	back = /obj/item/storage/backpack/tgmc/engineer
	r_pocket = /obj/item/storage/tgmc_pouch/explosive_pouch/prefilled
	l_pocket = /obj/item/storage/tgmc_pouch/ammo/smartgun
	r_hand = /obj/item/gun/ballistic/automatic/smartmachinegun
	backpack_contents = list(
		/obj/item/lighter/greyscale,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/gun/ballistic/p23,
		/obj/item/storage/tgmc_pouch/ammo_pistol/filled,
		/obj/item/storage/tgmc_pouch/grenade_pouch/prefilled,
	)
	id = /obj/item/card/id/tgmc/engineer

/obj/item/card/id/tgmc
	name = "dog tag"
	desc = "A marine dog tag."
	trim = /datum/id_trim/tgmc
	icon_state = "tgmc_dogtag"
	registered_age = null

/obj/item/card/id/tgmc/marine
	name = "marine dog tag"

/obj/item/card/id/tgmc/corpsman
	name = "corpsman dog tag"
	trim = /datum/id_trim/tgmc/corpsman

/obj/item/card/id/tgmc/engineer
	name = "engineer dog tag"
	trim = /datum/id_trim/tgmc/engineer

/obj/item/card/id/tgmc/leader
	name = "squad leader dog tag"
	trim = /datum/id_trim/tgmc/leader

/obj/item/boots_jump_kit
	name = "Jump Boots Upgrade Kit"
	desc = "Use on jackboots to upgrade with jumping capabilities."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "flat"

/obj/item/armor_magharness_kit
	name = "Armor Mag-Harness Upgrade Kit"
	desc = "Use on armor to upgrade with a mag harness."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "flat"

/obj/item/headset_minimap_kit
	name = "Security Headset Minimap Upgrade Kit"
	desc = "Use on a headset to upgrade with a minimap and locator."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "flat"
