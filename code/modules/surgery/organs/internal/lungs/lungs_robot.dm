/obj/item/organ/lungs/cooling_fans
	name = "cooling fans"
	desc = "Modulates the temperature of the robot via air intake. Be careful not to get it gummed up!"
	organ_flags = ORGAN_ROBOTIC
	low_threshold_passed = span_warning("You feel short of breath.")
	high_threshold_passed = span_warning("You feel some sort of constriction around your chest as your breathing becomes shallow and rapid.")
	now_fixed = span_warning("Your lungs seem to once again be able to hold air.")
	low_threshold_cleared = span_info("You can breathe normally again.")
	high_threshold_cleared = span_info("The constriction around your chest loosens as your breathing calms down.")
	icon_state = "cooling_fans"

/obj/item/organ/lungs/cooling_fans/setup_breathing()
	return // we don't do that here

/obj/item/organ/lungs/cooling_fans/check_breath(datum/gas_mixture/breath, mob/living/carbon/human/breather)
	return TRUE

/obj/item/organ/lungs/cooling_fans/on_life(seconds_per_tick, times_fired)
	. = ..()
	var/mob/living/carbon/human/breather = owner
	if(!istype(breather))
		return
	var/obj/item/organ/brain/cybernetic/robot_brain = breather.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!robot_brain || !istype(robot_brain))
		if(!(organ_flags & ORGAN_DEPOWERED))
			say("ERROR: No cybernetic brain to draw power from!")
			organ_flags |= ORGAN_DEPOWERED
		return
	if(robot_brain.power <= 20)
		if(!(organ_flags & ORGAN_DEPOWERED))
			say("ERROR: Power critically low, depowering cooling fans to conserve energy!")
			organ_flags |= ORGAN_DEPOWERED
	else
		organ_flags &= ~ORGAN_DEPOWERED
	if(organ_flags & ORGAN_DEPOWERED)
		return
	robot_brain.power -= (ROBOT_POWER_DRAIN * seconds_per_tick) * robot_brain.temperature_disparity
	robot_brain.run_updates()
	var/datum/gas_mixture/environment = breather.loc?.return_air()
	if(!environment)
		return
	var/area_temp = breather.get_temperature(environment)
	var/temperature_disparity = 1
	var/damage_modifier = 1
	if(damage > 0)
		damage_modifier = 1 - (damage / maxHealth)
	if(area_temp > breather.bodytemperature)
		temperature_disparity = area_temp / breather.bodytemperature
		breather.adjust_bodytemperature((3 * damage_modifier) * temperature_disparity)
		breather.adjust_coretemperature((3 * damage_modifier) * temperature_disparity)
	else if(area_temp < breather.bodytemperature)
		temperature_disparity = breather.bodytemperature / area_temp
		breather.adjust_bodytemperature((-3 * damage_modifier) * temperature_disparity)
		breather.adjust_coretemperature((-3 * damage_modifier) * temperature_disparity)
