/**
 * # Ecto-Sucker (Ectoplasmic Vacuum)
 *
 * A handheld vacuum device used by the Paranormalist to clean up
 * ectoplasmic residue (ecto decals) from the floor and convert them
 * into units of spectral_essence reagent stored in an internal container.
 *
 * The collected spectral essence can be poured into beakers or
 * consumed for temporary ghost sight effects.
 */

#define ECTO_SUCKER_MAX_VOLUME 100
#define ECTO_PER_PUDDLE 15

/obj/item/ecto_sucker
	name = "ecto-sucker"
	desc = "A modified handheld vacuum designed to collect ectoplasmic residue. The internal container converts spectral matter into a drinkable (if inadvisable) liquid. Standard Paranormalist equipment."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "health"
	inhand_icon_state = "multitool"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	item_flags = NOBLUDGEON

	/// Whether the ecto-sucker is actively on
	var/active = FALSE

/obj/item/ecto_sucker/Initialize(mapload)
	. = ..()
	create_reagents(ECTO_SUCKER_MAX_VOLUME)

/obj/item/ecto_sucker/attack_self(mob/user)
	. = ..()
	if(.)
		return
	active = !active
	balloon_alert(user, "sucker [active ? "on" : "off"]")
	if(active)
		playsound(src, 'sound/machines/twobeep.ogg', 20)
	update_appearance(UPDATE_ICON)

/obj/item/ecto_sucker/examine(mob/user)
	. = ..()
	. += span_notice("It is currently [active ? "on" : "off"].")
	. += span_notice("Internal tank: [reagents.total_volume]/[reagents.maximum_volume] units of spectral essence.")
	. += span_notice("Click on ectoplasmic puddles to vacuum them up. Alt-click to pour into a container.")

/// Click on an ecto puddle to clean it and harvest reagent
/obj/item/ecto_sucker/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!active)
		balloon_alert(user, "turn it on first!")
		return ITEM_INTERACT_BLOCKING

	// Check for ecto puddles
	if(istype(interacting_with, /obj/effect/decal/cleanable/greenglow/ecto))
		if(reagents.total_volume >= reagents.maximum_volume)
			balloon_alert(user, "tank is full!")
			return ITEM_INTERACT_BLOCKING

		user.visible_message(
			span_notice("[user] vacuums up [interacting_with] with [src]."),
			span_notice("You vacuum up the ectoplasmic residue. The internal tank fills with spectral essence."),
		)
		playsound(src, 'sound/items/drink.ogg', 30, vary = TRUE)
		reagents.add_reagent(/datum/reagent/spectral_essence, ECTO_PER_PUDDLE)
		qdel(interacting_with)
		return ITEM_INTERACT_SUCCESS

	// Check for ectoplasm items on the ground
	if(istype(interacting_with, /obj/item/ectoplasm))
		if(reagents.total_volume >= reagents.maximum_volume)
			balloon_alert(user, "tank is full!")
			return ITEM_INTERACT_BLOCKING

		user.visible_message(
			span_notice("[user] vacuums up [interacting_with] with [src]."),
			span_notice("You vacuum up the ectoplasm. The internal tank fills with spectral essence."),
		)
		playsound(src, 'sound/items/drink.ogg', 30, vary = TRUE)
		reagents.add_reagent(/datum/reagent/spectral_essence, ECTO_PER_PUDDLE * 2)
		qdel(interacting_with)
		return ITEM_INTERACT_SUCCESS

	// Also clean generic green glow decals (they're close enough to ecto)
	if(istype(interacting_with, /obj/effect/decal/cleanable/greenglow))
		if(reagents.total_volume >= reagents.maximum_volume)
			balloon_alert(user, "tank is full!")
			return ITEM_INTERACT_BLOCKING

		user.visible_message(
			span_notice("[user] vacuums up [interacting_with] with [src]."),
			span_notice("You vacuum up the strange residue."),
		)
		playsound(src, 'sound/items/drink.ogg', 30, vary = TRUE)
		reagents.add_reagent(/datum/reagent/spectral_essence, ECTO_PER_PUDDLE / 2)
		qdel(interacting_with)
		return ITEM_INTERACT_SUCCESS

	return NONE

/// Pour contents into a beaker or other reagent container
/obj/item/ecto_sucker/click_alt(mob/user)
	if(reagents.total_volume <= 0)
		balloon_alert(user, "tank is empty!")
		return CLICK_ACTION_BLOCKING

	// Try to pour into whatever is in the user's other hand
	var/obj/item/other = user.get_inactive_held_item()
	if(other?.reagents)
		var/transfer_amount = min(reagents.total_volume, other.reagents.maximum_volume - other.reagents.total_volume)
		if(transfer_amount <= 0)
			balloon_alert(user, "container is full!")
			return CLICK_ACTION_BLOCKING
		reagents.trans_to(other, transfer_amount)
		balloon_alert(user, "transferred [transfer_amount]u")
		return CLICK_ACTION_SUCCESS

	balloon_alert(user, "hold a container in your other hand!")
	return CLICK_ACTION_BLOCKING

#undef ECTO_SUCKER_MAX_VOLUME
#undef ECTO_PER_PUDDLE
