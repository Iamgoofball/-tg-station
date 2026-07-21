// Tether Ejector - Emergency safety ejection system
// Provides safe, tethered ejection from damaged mecha

/obj/item/mecha_parts/mecha_equipment/tether_ejector
	name = "tether ejection module"
	desc = "An emergency ejection system that safely propels the pilot out of the mech using a high-pressure pneumatic safety harness. Includes automatic tether binding to prevent injury."
	icon_state = "mecha_tether"
	equip_cooldown = 10
	energy_drain = 100
	range = 0 // No target needed
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 3, /datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2)
	action_type = /datum/action/vehicle/sealed/mecha/equipment/tether_eject_action
	var/uses = 3 // Limited uses before recharge
	var/max_uses = 3
	var/damage_on_use = 0 // Damage to mecha when used

/obj/item/mecha_parts/mecha_equipment/tether_ejector/proc/recharge()
	uses = max_uses

/datum/action/vehicle/sealed/mecha/equipment/tether_eject_action
	name = "Emergency Tether Ejection"
	button_icon_state = "mech_eject" // Can reuse the eject icon

/datum/action/vehicle/sealed/mecha/equipment/tether_eject_action/set_equipment(passed_equipment)
	. = ..()
	name = "[equipment.name]"

/datum/action/vehicle/sealed/mecha/equipment/tether_eject_action/Trigger(mob/clicker, trigger_flags)
	SHOULD_CALL_PARENT(FALSE)
	if(!chassis || !(owner in chassis.occupants) || !equipment)
		return
	if(!istype(equipment, /obj/item/mecha_parts/mecha_equipment/tether_ejector))
		return

	var/obj/item/mecha_parts/mecha_equipment/tether_ejector/ejector = equipment

	if(ejector.uses <= 0)
		to_chat(owner, "[icon2html(ejector, owner)][span_warning("Tether ejection system depleted!")]")
		return

	if(!length(chassis.occupants))
		to_chat(owner, "[icon2html(ejector, owner)][span_warning("No occupants to eject!")]")
		return

	// Use the ejection system
	ejector.uses--
	to_chat(owner, "[icon2html(ejector, owner)][span_notice("Activating emergency tether ejection system... [(ejector.uses > 0) ? "[ejector.uses] uses remaining" : "DEPLETED"]")]")

	// Do the actual ejection
	chassis.tether_eject_all(owner, damage = ejector.damage_on_use)

	// Log it
	chassis.log_message("Tether ejection activated by [owner].", LOG_GAME)