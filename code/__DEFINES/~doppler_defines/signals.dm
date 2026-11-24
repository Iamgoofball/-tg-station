///Fired in combat_indicator.dm, used for syncing CI between mech and pilot
#define COMSIG_MOB_CI_TOGGLED "mob_ci_toggled"

/// Sent when an obj/item calls item_use_power: (use_amount, user, check_only)
#define COMSIG_ITEM_POWER_USE "item_use_power"
	#define NO_COMPONENT NONE
	#define COMPONENT_POWER_SUCCESS (1<<0)
	#define COMPONENT_NO_CELL  (1<<1)
	#define COMPONENT_NO_CHARGE (1<<2)

/// For when a Hemophage's pulsating tumor gets added to their body.
#define COMSIG_PULSATING_TUMOR_ADDED "pulsating_tumor_added"
/// For when a Hemophage's pulsating tumor gets removed from their body.
#define COMSIG_PULSATING_TUMOR_REMOVED "pulsating_tumor_removed"
/// From /obj/item/organ/stomach/after_eat(atom/edible)
#define COMSIG_STOMACH_AFTER_EAT "stomach_after_eat"
/// Whenever a baton successfully executes its nonlethal attack. WARNING wonderful FUCKING CODE by niko THIS IS peak AAAAAAAAAAAAH
#define COMSIG_PRE_BATON_FINALIZE_ATTACK "pre_baton_finalize_attack"
// For after a user has sent a say message
#define COMSIG_MOB_POST_SAY "mob_post_say"
/// Whenever we need to check if a mob is currently inside of soulcatcher.
#define COMSIG_SOULCATCHER_CHECK_SOUL "soulcatcher_check_soul"
/// Whenever we need to get the soul of the mob inside of the soulcatcher.
#define COMSIG_SOULCATCHER_SCAN_BODY "soulcatcher_scan_body"
/// When a soulcatcher room's joinability is updated by opening the room, closing the room, allowing ghosts, etc
#define COMSIG_SOULCATCHER_UPDATE_JOINABILITY "soulcatcher_update_joinability"
/// For modifying a mob holder based on what it's holding
#define COMSIG_ADDING_MOB_HOLDER_SPECIALS "adding_mob_holder_specials"

///from base of /mob/living/carbon/update_stat(): (stat_mob) allows you to block normal stat processing
#define COMSIG_CARBON_UPDATE_STAT "carbon_update_stat"
	#define COMSIG_CARBON_UPDATE_STAT_NO_UPDATE (1<<0)

/// from base of mob/living/carbon/human/updatehealth()
#define COMSIG_HUMAN_HEALTH_PRE_UPDATE "human_health_update"
	#define COMSIG_HUMAN_HEALTH_PRE_UPDATE_DONT_UPDATE_MOVESPEED (1<<0)

/// from base of mob/living/med_hud_set_status()
#define COMSIG_LIVING_MED_HUD_SET_STATUS "living_med_hud_set_status"
	#define COMSIG_LIVING_MED_HUD_SET_STATUS_OVERRIDE (1<<0)
/// from base of mob/living/med_hud_set_health()
#define COMSIG_LIVING_MED_HUD_SET_HEALTH "living_med_hud_set_health"
	#define COMSIG_LIVING_MED_HUD_SET_HEALTH_OVERRIDE (1<<0)
/// from base of mob/living/revive()
#define COMSIG_LIVING_CAN_REVIVE "living_can_revive"
	#define COMSIG_LIVING_CAN_REVIVE_OVERRIDE (1<<0)

///from datum/species/handle_body_temperature(): (mob/living/carbon/human/affected, seconds_per_tick, times_fired)
#define COMSIG_SPECIES_HANDLE_TEMPERATURE "species_handle_temperature"
	#define COMSIG_SPECIES_OVERRIDE_TEMPERATURE (1<<0)

///from base of mob/adjust_bodytemperature(): (new_temp, old_temp)
#define COMSIG_MOB_TEMPERATURE_CHANGE "mob_temperature_change"
