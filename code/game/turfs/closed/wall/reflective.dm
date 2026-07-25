/turf/closed/wall/reflective
	name = "reflective wall"
	desc = "A highly polished surface designed to deflect energy weapons with precision."
	icon_state = "wall_reflective"
	base_icon_state = "wall_reflective"
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS
	flags_ricochet = RICOCHET_SHINY
	receive_ricochet_chance_mod = 2
	hardness = 30
	sheet_type = /obj/item/stack/sheet/iron
	sheet_amount = 2
	girder_type = /obj/structure/girder

/turf/closed/wall/reflective/handle_ricochet(obj/projectile/ricocheting_projectile)
	var/turf/p_turf = get_turf(ricocheting_projectile)
	var/face_direction = get_dir(src, p_turf) || get_dir(src, ricocheting_projectile)
	var/face_angle = dir2angle(face_direction)
	var/incidence_s = GET_ANGLE_OF_INCIDENCE(face_angle, (ricocheting_projectile.angle + 180))
	var/a_incidence_s = abs(incidence_s)
	if(a_incidence_s > 90 && a_incidence_s < 270)
		return FALSE
	// Quadratic curve reflection angle based on angle of incidence
	// At near-head-on impact (factor ~0), reflection is minimal (~0 degrees)
	// At shallow grazing impact (factor ~1), reflection is maximal (~89 degrees)
	var/incidence_factor = min(a_incidence_s, 180 - a_incidence_s) / 90
	var/reflection_offset = 89 * (incidence_factor * incidence_factor)
	var/sign = (incidence_s > 0) ? 1 : -1
	var/new_angle_s = SIMPLIFY_DEGREES(face_angle + sign * reflection_offset)
	ricocheting_projectile.set_angle(new_angle_s)
	return TRUE

/turf/closed/wall/reflective/random
	name = "random reflective wall"
	desc = "A chaotic reflective surface that scatters energy in unpredictable directions."

/turf/closed/wall/reflective/random/handle_ricochet(obj/projectile/ricocheting_projectile)
	// Random scattering 0-180 degrees for chaotic reflection
	ricocheting_projectile.set_angle(rand(0, 180))
	return TRUE
