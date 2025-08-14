/datum/component/jump_shoes
    var/datum/action/cooldown/marine_jump/jumping_power

/datum/component/jump_shoes/Initialize()
	if(!istype(parent, /obj/item/clothing/shoes))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/clothing/shoes/our_shoes = parent
	jumping_power = new(parent)
	if(istype(our_shoes.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/temp = our_shoes.loc
		if(temp.shoes == our_shoes)
			jumping_power.Grant(temp)

/datum/component/jump_shoes/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_attached))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_detached))

/datum/component/jump_shoes/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

/datum/component/jump_shoes/proc/on_attached(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(slot == ITEM_SLOT_FEET)
		jumping_power.Grant(equipper)

/datum/component/jump_shoes/proc/on_detached(datum/source, mob/user)
	SIGNAL_HANDLER
	jumping_power.Remove(user)


#define MARINE_JUMP "marine_jump"

/datum/action/cooldown/marine_jump
	name = "Marine Jump"
	desc = "Put those knees to work and jump over obstacles!"
	button_icon = 'icons/obj/clothing/shoes.dmi'
	button_icon_state = "tgmc_boots"
	background_icon_state = "bg_tgmc"
	cooldown_time = 1 SECONDS

/datum/action/cooldown/marine_jump/Activate(atom/target)
	. = ..()
	var/mob/living/carbon/human/marine = owner
	marine.balloon_alert_to_viewers("jumps")
	playsound(marine, 'sound/effects/arcade_jump.ogg', 75, vary=TRUE)
	marine.layer = ABOVE_MOB_LAYER
	marine.pass_flags |= PASSMACHINE|PASSSTRUCTURE
	passtable_on(marine, MARINE_JUMP)
	ADD_TRAIT(marine, TRAIT_SILENT_FOOTSTEPS, MARINE_JUMP)
	ADD_TRAIT(marine, TRAIT_MOVE_FLYING, MARINE_JUMP)
	marine.zMove(UP)
	marine.add_filter(MARINE_JUMP, 2, drop_shadow_filter(color = "#03020781", size = 0.9))
	var/shadow_filter = marine.get_filter(MARINE_JUMP)
	var/jump_height = 16
	var/jump_duration = 0.5 SECONDS
	new /obj/effect/temp_visual/mook_dust(get_turf(marine))
	animate(marine, pixel_y = marine.pixel_y + jump_height, time = jump_duration / 2, easing = CIRCULAR_EASING|EASE_OUT)
	animate(pixel_y = initial(owner.pixel_y), time = jump_duration / 2, easing = CIRCULAR_EASING|EASE_IN)

	animate(shadow_filter, y = -jump_height, size = 4, time = jump_duration / 2, easing = CIRCULAR_EASING|EASE_OUT)
	animate(y = 0, size = 0.9, time = jump_duration / 2, easing = CIRCULAR_EASING|EASE_IN)

	addtimer(CALLBACK(src, PROC_REF(end_jump), marine), jump_duration)

///Ends the jump
/datum/action/cooldown/marine_jump/proc/end_jump(mob/living/jumper)
	jumper.remove_filter(MARINE_JUMP)
	jumper.layer = initial(jumper.layer)
	passtable_off(jumper, MARINE_JUMP)
	jumper.pass_flags = initial(jumper.pass_flags)
	REMOVE_TRAIT(jumper, TRAIT_SILENT_FOOTSTEPS, MARINE_JUMP)
	REMOVE_TRAIT(jumper, TRAIT_MOVE_FLYING, MARINE_JUMP)
	new /obj/effect/temp_visual/mook_dust(get_turf(jumper))
