/turf/closed/wall/mineral/cult
	name = "runed metal wall"
	desc = "A cold metal wall engraved with indecipherable symbols. Studying them causes your head to pound."
	icon = 'icons/turf/walls/cult_wall.dmi'
	icon_state = "cult_wall-0"
	base_icon_state = "cult_wall"
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = null
	sheet_type = /obj/item/stack/sheet/runed_metal
	sheet_amount = 1
	girder_type = /obj/structure/girder/cult

/turf/closed/wall/mineral/cult/Initialize(mapload)
	new /obj/effect/temp_visual/cult/turf(src)
	. = ..()

/turf/closed/wall/mineral/cult/devastate_wall()
	new sheet_type(get_turf(src), sheet_amount)

/turf/closed/wall/mineral/cult/artificer
	name = "runed stone wall"
	desc = "A cold stone wall engraved with indecipherable symbols. Studying them causes your head to pound."

/turf/closed/wall/mineral/cult/artificer/break_wall()
	new /obj/effect/temp_visual/cult/turf(get_turf(src))
	return null //excuse me we want no runed metal here

/turf/closed/wall/mineral/cult/artificer/devastate_wall()
	new /obj/effect/temp_visual/cult/turf(get_turf(src))

/turf/closed/wall/ice
	icon = 'icons/turf/walls/icedmetal_wall.dmi'
	icon_state = "icedmetal_wall-0"
	base_icon_state = "icedmetal_wall"
	desc = "A wall covered in a thick sheet of ice."
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	canSmoothWith = null
	rcd_memory = null
	hardness = 35
	slicing_duration = 150 //welding through the ice+metal
	bullet_sizzle = TRUE

/// A mirror-finished wall which gives weak lasers a curved reflection angle.
/turf/closed/wall/reflective
	name = "reflective wall"
	desc = "A wall covered in highly reflective metal plating."
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	receive_ricochet_chance_mod = INFINITY

/**
 * Maps the signed angle of incidence to a reflection angle on a quadratic curve.
 *
 * Incidence is capped just below perpendicular so the result is always in the
 * requested 0 to 89 degree range. The sign preserves which side of the wall's
 * normal the projectile approached from.
 */
/turf/closed/wall/reflective/proc/get_reflection_angle(incidence)
	var/angle_sign = incidence < 0 ? -1 : 1
	var/impact_angle = clamp(abs(incidence), 0, 89)
	return angle_sign * impact_angle ** 2 / 89

/turf/closed/wall/reflective/handle_ricochet(obj/projectile/ricocheting_projectile)
	if(!istype(ricocheting_projectile, /obj/projectile/beam/weak))
		return ..()

	var/turf/projectile_turf = get_turf(ricocheting_projectile)
	var/face_direction = get_dir(src, projectile_turf) || get_dir(src, ricocheting_projectile)
	var/face_angle = dir2angle(face_direction)
	var/incidence = GET_ANGLE_OF_INCIDENCE(face_angle, ricocheting_projectile.angle + 180)
	var/absolute_incidence = abs(incidence)
	if(absolute_incidence > 90 && absolute_incidence < 270)
		return FALSE
	if(incidence > 180)
		incidence -= 360

	ricocheting_projectile.set_angle(SIMPLIFY_DEGREES(face_angle + get_reflection_angle(incidence)))
	return TRUE

/// A reflective wall which scatters weak lasers unpredictably.
/turf/closed/wall/reflective/random
	name = "scattering reflective wall"
	desc = "Its irregular mirrored surface scatters reflected light in unpredictable directions."

/turf/closed/wall/reflective/random/get_reflection_angle(incidence)
	return rand(0, 180)

/turf/closed/wall/rust
	//SDMM supports colors, this is simply for easier mapping
	WHEN_MAP(color = COLOR_ORANGE_BROWN)

/turf/closed/wall/rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust)

/turf/closed/wall/heretic_rust
	WHEN_MAP(color = COLOR_GREEN_GRAY)

/turf/closed/wall/heretic_rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust/heretic)

/turf/closed/wall/r_wall/rust
	//SDMM supports colors, this is simply for easier mapping
	WHEN_MAP(color = COLOR_ORANGE_BROWN)
	base_decon_state = "rusty_r_wall"

/turf/closed/wall/r_wall/rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust)

/turf/closed/wall/r_wall/heretic_rust
	WHEN_MAP(color = COLOR_GREEN_GRAY)

/turf/closed/wall/r_wall/heretic_rust/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/rust/heretic)

/turf/closed/wall/mineral/bronze
	name = "clockwork wall"
	desc = "A huge chunk of bronze, decorated like gears and cogs."
	icon = 'icons/turf/walls/clockwork_wall.dmi'
	icon_state = "clockwork_wall-0"
	base_icon_state = "clockwork_wall"
	turf_flags = IS_SOLID
	smoothing_flags = SMOOTH_BITMASK
	sheet_type = /obj/item/stack/sheet/bronze
	sheet_amount = 2
	girder_type = /obj/structure/girder/bronze

/turf/closed/wall/rock
	name = "reinforced rock"
	desc = "It has metal struts that need to be welded away before it can be mined."
	icon = 'icons/turf/walls/reinforced_rock.dmi'
	icon_state = "porous_rock-0"
	base_icon_state = "porous_rock"
	turf_flags = NO_RUST
	sheet_amount = 1
	hardness = 50
	girder_type = null
	decon_type = /turf/closed/mineral/asteroid

/turf/closed/wall/rock/porous
	name = "reinforced porous rock"
	desc = "This rock is filled with pockets of breathable air. It has metal struts to protect it from mining."
	decon_type = /turf/closed/mineral/asteroid/porous

/turf/closed/wall/space
	name = "illusionist wall"
	icon = 'icons/turf/space.dmi'
	icon_state = "space"
	plane = PLANE_SPACE
	turf_flags = NO_RUST
	smoothing_flags = NONE
	canSmoothWith = null
	smoothing_groups = null

/turf/closed/wall/material/meat
	name = "living wall"
	baseturfs = /turf/open/floor/material/meat
	girder_type = null
	material_flags = MATERIAL_EFFECTS | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/turf/closed/wall/material/meat/Initialize(mapload)
	. = ..()
	set_custom_materials(list(SSmaterials.get_material(/datum/material/meat) = SHEET_MATERIAL_AMOUNT))

/turf/closed/wall/material/meat/airless
	baseturfs = /turf/open/floor/material/meat/airless

/turf/closed/wall/tomb
	name = "tomb wall"
	desc = "The carved surface of a dusty tomb. It's not clear who built this."
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "boss_wall-0"
	base_icon_state = "boss_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_BOSS_WALLS
	canSmoothWith = SMOOTH_GROUP_BOSS_WALLS
	turf_flags = NO_RUST
	explosive_resistance = 50
	baseturfs = /turf/open/misc/asteroid/basalt/airless
