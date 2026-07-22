/obj/item/skillchip/job/network_engineer
	name = "N3T-W0RK diagnostic skillchip"
	desc = "A certified neural library for auditing NTNet faults and retuning hostile carrier waves."
	auto_traits = list(TRAIT_KNOW_ENGI_WIRES, TRAIT_NETWORK_DIAGNOSTICS)
	skill_name = "NTNet Diagnostics"
	skill_description = "Audit station endpoint faults, read hostile-broadcast telemetry, and suppress an active Signal Pirate carrier."
	skill_icon = "network-wired"
	activate_message = span_notice("NTNet topology unfolds in your mind as a legible web of carriers and endpoints.")
	deactivate_message = span_notice("The station's carrier waves dissolve back into undifferentiated static.")
