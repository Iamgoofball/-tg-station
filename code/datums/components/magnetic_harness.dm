/datum/component/magnetic_harness
	/// Time before we activate the magnet.
	var/magnet_delay = 0.8 SECONDS
	/// The typecache of all guns we allow.
	var/static/list/guns_typecache
	/// Our wearer.
	var/mob/living/wearer

/datum/component/magnetic_harness/Initialize()
	if(!istype(parent, /obj/item/clothing/suit))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/clothing/suit/our_suit = parent
	if(!guns_typecache)
		guns_typecache = typecacheof(list(/obj/item/gun/ballistic, /obj/item/gun/energy, /obj/item/gun/grenadelauncher, /obj/item/gun/chem, /obj/item/gun/syringe))
	if(istype(our_suit.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/temp = our_suit.loc
		if(temp.wear_suit == parent)
			wearer = temp
			RegisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(check_dropped_item))

/datum/component/magnetic_harness/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_attached))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_detached))

/datum/component/magnetic_harness/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_MOB_UNEQUIPPED_ITEM))

/datum/component/magnetic_harness/proc/on_attached(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(slot == ITEM_SLOT_OCLOTHING)
		RegisterSignal(equipper, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(check_dropped_item))
		wearer = equipper

/datum/component/magnetic_harness/proc/on_detached(datum/source, mob/user)
	SIGNAL_HANDLER
	wearer = null
	UnregisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM)

/datum/component/magnetic_harness/proc/check_dropped_item(datum/source, obj/item/dropped_item, force, new_location)
	SIGNAL_HANDLER

	if(!is_type_in_typecache(dropped_item, guns_typecache))
		return
	if(new_location != get_turf(src))
		return
	addtimer(CALLBACK(src, PROC_REF(pick_up_item), dropped_item), magnet_delay)

/datum/component/magnetic_harness/proc/pick_up_item(obj/item/item)
	if(!isturf(item.loc) || !item.Adjacent(wearer))
		return
	if(!wearer.equip_to_slot_if_possible(item, ITEM_SLOT_SUITSTORE, qdel_on_fail = FALSE, disable_warning = TRUE))
		return
	playsound(wearer, 'sound/items/modsuit/magnetic_harness.ogg', 50, TRUE)
	wearer.balloon_alert(wearer, "gun reattached")
