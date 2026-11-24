// Reboots the robot
/obj/item/disk/reboot_card
	name = "system reboot card"
	desc = "A Cyberson containing a system reboot program which initiates a hard reset of the robot. \
	This clears any neuroware, fixes any speech impediments, corrects any hallucinations, and fixes any other minor \
	neurological-simulation bugs. Deeper-rooted traumas will not be impacted."
	icon_state = "reboot_card"
	icon = 'modular_doppler/modular_species/species_types/android/icons/robot_organs.dmi'

/obj/item/disk/reboot_card/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(!ishuman(interacting_with))
		return ITEM_INTERACT_FAILURE
	var/mob/living/carbon/human/target = interacting_with
	var/obj/item/organ/brain/cybernetic/robot_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!istype(robot_brain))
		target.balloon_alert(user, "not a robot!")
		return ITEM_INTERACT_FAILURE
	target.balloon_alert(user, "rebooting...")
	if(do_after(user, 5 SECONDS, target))
		robot_brain.trigger_reboot()
		target.balloon_alert(user, "rebooted")
		return ITEM_INTERACT_SUCCESS
	return ITEM_INTERACT_FAILURE
