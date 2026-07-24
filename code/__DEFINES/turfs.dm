/// A universal base type for all turfs that can be found across space
/turf/open
	gender = PLURAL
	/// Baseturfs that this turf can become when something changes... In practice this is mostly for space, which becomes asteroid turf when it gets bombed... You can also create complex chains (for fancy baseturfs)
	var/list/baseturfs = /turf/baseturf_bottom
	var/initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	/// Wall mount interactions will target this turf and may offset visual objects to this plane
	var/wall_mounted_plane = FLOOR_PLANE
	/// Set this to make an open turf not be destroyed when being hit by a shower of sparks, meteors, etc.
	var/indestructible = FALSE
	/// Whether this turf will cause radioactive contamination if analyzed. Defaults to FALSE, override to TRUE for specific radioactive turfs.
	var/radioactive_contamination = FALSE

/turf/open/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
		return
	flags_1 |= INITIALIZED_1

	// We don't call the parent here because we want to save on the huge amount of init calls this would invoke.
	// We call it below after the area init

	// by default, vis_contents doesn't work on turfs
	// some turfs use it, though
	// this might be a tiny bit laggy but it's a way better alternative to enabling it on every turf
	if(length(vis_contents))
		vis_flags |= VIS_INHERIT_PLANE

	if(requires_activation)
		CALL_IN(src, /atom/proc/update_icon) // just in case the icon needs to be set as broken

	// If we are being maploaded, don't bother with anything too heavy.
	if(mapload)
		return INITIALIZE_HINT_LATELOAD

	var/area/our_area = loc
	if(!IS_DYNAMIC_LIGHTING(src) && istype(our_area))
		add_overlay(/obj/effect/fullbright)

	if(light_power && light_range)
		update_light()

	if(opacity)
		has_opaque_atom = TRUE

	var/turf/T = GET_TURF_ABOVE(src)
	if(T?.flags_1 & INITIALIZED_1)
		QUEUE_SMOOTH(T)

	var/turf/U = GET_TURF_BELOW(src)
	if(U?.flags_1 & INITIALIZED_1)
		QUEUE_SMOOTH(U)

	return INITIALIZE_HINT_LATELOAD

/turf/open/LateInitialize()
	..()
	if(requires_activation)
		CALL_IN(src, /atom/proc/update_icon) // just in case the icon needs to be set as broken

/turf/open/Destroy()
	// Doing this to accomodate for baseturf changes ontop of the assumption we'll be immediately replaced
	if(!baseturfs)
		stack_trace("A turf that doesn't have baseturfs was destroyed, somehow: [src]([type])")
	return ..()

/turf/open/Initalize_Atmos(time)
	// We create a new gas mix if the turf needs to be
	air = new /datum/gas_mixture
	if(blocks_air)
		air.set_moles(GAS_O2, 0)
		air.set_moles(GAS_N2, 0)
		air.set_temperature(TCMB)
	else
		air.copy_from_turf(src)
		SSair.add_to_active(src)

/turf/open/proc/CopyOnTop(turf/open/copytarget, ignore_bottom = 1, depth=0, copy_air = FALSE)
	if (ignore_bottom && istype(copytarget, /turf/open/openspace))
		var/turf/below = GET_TURF_BELOW(copytarget)
		if(below)
			levelupdate()
			return CopyOnTop(below, ignore_bottom, depth + 1, copy_air)
	var/old_flags = copytarget.flags_1
	var/old_baseturfs = copytarget.baseturfs
	copytarget.flags_1 = flags_1
	copytarget.baseturfs = baseturfs
	var/list/old_blueprint_data = copytarget.blueprint_data
	copytarget.blueprint_data = null
	copytarget.copy_air_with_tile(src)
	copytarget.blueprint_data = old_blueprint_data
	var/turf/our_target = copytarget.above()
	// Only update openspace when it's already openspace, otherwise we could overwrite a floor
	if(istype(our_target, /turf/open/openspace))
		our_target.levelupdate()
	copytarget.flags_1 = old_flags
	copytarget.baseturfs = old_baseturfs
	if(depth)
		var/turf/our_below = GET_TURF_BELOW(src)
		if(our_below)
			copytarget.CopyOnTop(our_below, ignore_bottom, depth-1, copy_air)

/turf/open/proc/copy_air_with_tile(turf/open/copy_from)
	if(!copy_from.air)
		CRASH("Trying to copy air from a turf that expects to have it, but doesn't.")
	if(blocks_air)
		return
	air.copy_from(copy_from.air)
	if(!SSair.has_valid_zone(src)) // In the case of "airless" with an actual gasmix, clean it up properly by not adding to active.
		air.clear()
	SSair.add_to_active(src, FALSE)

/// Creates a gas mixture for the initial state of the turf... By default, we copy 20% oxygen and 80% nitrogen from the gas data list... Other gases can be added through return value.
/turf/open/proc/get_initial_air_mixture()
	var/datum/gas_mixture/air = new
	air.set_moles(GAS_O2, MOLES_O2STANDARD)
	air.set_moles(GAS_N2, MOLES_N2STANDARD)
	air.set_temperature(T20C)
	return air

/turf/open/proc/levelupdate()
	var/turf/path = below()
	if(!path)
		return
	plane = path.plane
	plane = GET_TURF_PLANE(path)

/**
 * Checks if a mob can resist to escape from the current turf.
 *
 * Defaults to TRUE for most open turfs. Can be overridden by subtypes
 * that completely envelop a mob (such as by chasms.)
 *
 * You should really try to keep the text short, cause resisting spam is a bitch.
 */
/turf/open/proc/can_resist(mob/living/resister)
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/**
 * What happens when a mob succeeds at a resist check to escape from the turf?
 */
/turf/open/proc/resist_escape(mob/living/resister)
	SHOULD_CALL_PARENT(FALSE)
	resister.changeMoveState()

/// Defines the x offset to apply to larger smoothing turfs (such as grass).
#define LARGE_TURF_SMOOTHING_X_OFFSET -9
/// Defines the y offset to apply to larger smoothing turfs (such as grass).
#define LARGE_TURF_SMOOTHING_Y_OFFSET -9

/// Defines a consistent light power for our various basalt turfs
#define BASALT_LIGHT_POWER 0.6

/// The set of smoothing groups for a closed turf that shows an icon despite density (such as walls).
#define SMOOTH_GROUP_CLOSED_TURFS S_GROUP_TURF(`_OPEN`)

/// The set of smoothing groups for an open turf, for decorative purposes.
#define SMOOTH_GROUP_OPEN_TURFS S_GROUP_TURF
