// Advanced Combat Mecha - Uses all new mecha features
// Includes thermal system, complexity tracking, visibility restrictions, 
// combat mech restrictions, required pilot gloves, tether ejector, and camera beacon

/obj/vehicle/sealed/mecha/hephaestus
	desc = "A heavy combat exosuit designed for extreme conditions. Features advanced thermal management, reinforced cockpit with visibility restrictions, and requires specialized pilot gloves for operation."
	name = "\improper Hephaestus"
	icon_state = "hephaestus"
	base_icon_state = "hephaestus"
	movedelay = 3.5
	max_integrity = 400
	accesses = list(ACCESS_MECH_SECURITY, ACCESS_MECH_COMMAND)
	armor_type = /datum/armor/mecha_hephaestus
	max_temperature = 40000
	force = 30
	destruction_sleep_duration = 60
	exit_delay = 60
	wreckage = /obj/structure/mecha_wreckage/gygax/dark
	mech_type = EXOSUIT_MODULE_HEPHAESTUS
	max_equip_by_category = list(
		MECHA_L_ARM = 1,
		MECHA_R_ARM = 1,
		MECHA_UTILITY = 3,
		MECHA_POWER = 1,
		MECHA_ARMOR = 1,
	)
	step_energy_drain = 8
	can_use_overclock = TRUE
	overclock_safety_available = TRUE
	overclock_safety = TRUE
	overclock_coeff = 2
	overclock_temp_danger = 25
	// This mech has:
	// - COMBAT_MECH flag: Cannot be piloted by MMI or positronic brains
	// - VISIBILITY_RESTRICTED: View is restricted when cockpit is sealed, needs camera beacon
	// - required_pilot_gloves: Requires heavy mech pilot gloves
	mecha_flags = CAN_STRAFE | IS_ENCLOSED | HAS_LIGHTS | AI_COMPATIBLE | MMI_COMPATIBLE | BEACON_TRACKABLE | COMBAT_MECH | VISIBILITY_RESTRICTED
	// Complexity system - this is a complex mech
	max_complexity = 25
	// Thermal thresholds - this mech runs hot
	thermal_threshold_warning = 40
	thermal_threshold_danger = 65
	thermal_threshold_critical = 80
	thermal_threshold_emergency = 95
	// Restricted view when cockpit is sealed
	restricted_pilot_view_range = 7
	// Require heavy pilot gloves to operate
	required_pilot_gloves = /obj/item/clothing/gloves/touchtether/latex/nitrile

/datum/armor/mecha_hephaestus
	melee = 50
	bullet = 40
	laser = 50
	energy = 30
	bomb = 30
	fire = 100
	acid = 100

/obj/vehicle/sealed/mecha/hephaestus/loaded/Initialize(mapload)
	. = ..()
	add_minimap_blip(src, /datum/asset/sprite/blip/career, "hephaestus")

/obj/vehicle/sealed/mecha/hephaestus/loaded/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()

// Variant with tether ejector pre-installed
/obj/vehicle/sealed/mecha/hephaestus/tether
	name = "\improper Hephaestus-T"
	desc = "A heavy combat exosuit with a tether ejection system pre-installed. The safety tether ensures pilot extraction even in catastrophic situations."
	equip_by_category = list(
		MECHA_L_ARM = null,
		MECHA_R_ARM = null,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/tether_ejector, /obj/item/mecha_parts/mecha_equipment/camera_beacon, /obj/item/mecha_parts/mecha_equipment/radio),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/obj/vehicle/sealed/mecha/hephaestus/tether/Initialize(mapload)
	. = ..()
	// Start with tether ejector charges
	var/obj/item/mecha_parts/mecha_equipment/tether_ejector/te = locate() in flat_equipment
	if(te)
		te.charges = 3

// Greytide implant implant implant
/obj/vehicle/sealed/mecha/hephaestus/greytide
	desc = "A heavy combat exosuit, painted in greytide colors. Looks like it might have had some modifications done to it..."
	mecha_flags = CAN_STRAFE | IS_ENCLOSED | HAS_LIGHTS | AI_COMPATIBLE | BEACON_TRACKABLE | COMBAT_MECH | VISIBILITY_RESTRICTED
	accesses = list(ACCESS_SYNDICATE)
	equip_by_category = list(
		MECHA_L_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot,
		MECHA_R_ARM = /obj/item/mecha_parts/mecha_equipment/weapon/energy/disabler,
		MECHA_UTILITY = list(/obj/item/mecha_parts/mecha_equipment/tether_ejector, /obj/item/mecha_parts/mecha_equipment/camera_beacon),
		MECHA_POWER = list(),
		MECHA_ARMOR = list(),
	)

/obj/vehicle/sealed/mecha/hephaestus/greytide/Initialize(mapload)
	. = ..()
	add_minimap_blip(src, MINIMAP_SYNDICATE_MECH_BLIP, "syndiemech")

/obj/vehicle/sealed/mecha/hephaestus/greytide/populate_parts()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace(src)
	scanmod = new /obj/item/stock_parts/scanning_module/triphasic(src)
	capacitor = new /obj/item/stock_parts/capacitor/quadratic(src)
	servo = new /obj/item/stock_parts/servo/femto(src)
	update_part_values()
