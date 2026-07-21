// Camera Beacon - AI tracking and visibility enhancement equipment
// Allows AI to track and hack the mecha when installed
// Note: The has_camera_beacon flag is toggled by on_equipment_attach/detach in _mecha.dm

/obj/item/mecha_parts/mecha_equipment/camera_beacon
	name = "camera beacon"
	desc = "An AI tracking beacon that enhances remote visibility and allows AI hacking attempts. Emit a signal that AI can use to track and interact with the mech."
	icon_state = "mecha_camera_beacon"
	equip_cooldown = 5
	energy_drain = 50
	range = MECHA_RANGED
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass = SHEET_MATERIAL_AMOUNT)