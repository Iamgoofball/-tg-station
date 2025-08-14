
GLOBAL_DATUM_INIT(ad_window, /datum/advertisement, new)

/datum/advertisement/ui_host(mob/user)
	. = ..()

/datum/advertisement/ui_state(mob/user)
	return GLOB.always_state

/datum/strip_menu/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

