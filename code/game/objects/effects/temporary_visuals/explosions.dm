/particles/explosion_smoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke3"
	width = 1000
	height = 1000
	count = 75
	spawning = 75
	gradient = list("#FA9632", "#C3630C", "#333333", "#808080", "#FFFFFF")
	lifespan = 20
	fade = 60
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.04, 0.05)
	velocity = generator(GEN_CIRCLE, 15, 15)
	drift = generator(GEN_CIRCLE, 0, 1, NORMAL_RAND)
	spin = generator(GEN_NUM, -20, 20)
	friction = generator(GEN_NUM, 0.1, 0.5)
	gravity = list(1, 2)
	scale = 0.25
	grow = 0.05

/particles/explosion_smoke/nodirt
	gradient = list("#333333", "#808080", "#FFFFFF")

/particles/explosion_smoke/deva
	scale = 0.5
	velocity = generator(GEN_CIRCLE, 23, 23)

/particles/explosion_smoke/deva/nodirt
	gradient = list("#333333", "#808080", "#FFFFFF")

/particles/explosion_smoke/small
	count = 25
	spawning = 25
	scale = 0.25
	velocity = generator(GEN_CIRCLE, 10, 10)

/particles/explosion_smoke/small/nodirt
	gradient = list("#333333", "#808080", "#FFFFFF")

/particles/explosion_smoke/tiny
	count = 25
	spawning = 25
	scale = 0.1
	fade = 100
	grow = 0.025
	velocity = generator(GEN_CIRCLE, 5, 5)

/particles/explosion_smoke/tiny/nodirt
	gradient = list("#333333", "#808080", "#FFFFFF")

/particles/explosion_water
	icon = 'icons/effects/96x96.dmi'
	icon_state = list("smoke4" = 1, "smoke5" = 1)
	width = 1000
	height = 1000
	count = 75
	spawning = 75
	lifespan = 20
	fade = 80
	velocity = generator(GEN_CIRCLE, 15, 15)
	drift = generator(GEN_CIRCLE, 0, 1, NORMAL_RAND)
	spin = generator(GEN_NUM, -20, 20)
	friction = generator(GEN_NUM, 0.1, 0.5)
	gravity = list(1, 2)
	scale = 0.15
	grow = 0.02

/particles/explosion_water/tiny
	count = 25
	spawning = 25
	scale = 0.1
	fade = 100
	grow = 0.025
	velocity = generator(GEN_CIRCLE, 5, 5)

/particles/smoke_wave
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke3"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 15
	fade = 70
	gradient = list("#BA9F6D", "#808080", "#FFFFFF")
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.08, 0.07)
	velocity = generator(GEN_CIRCLE, 25, 25)
	rotation = generator(GEN_NUM, -45, 45)
	scale = 0.25
	grow = 0.05
	friction = 0.05

/particles/smoke_wave/nodirt
	gradient = list("#808080", "#FFFFFF")

/particles/smoke_wave/small
	count = 45
	spawning = 45
	scale = 0.1

/particles/smoke_wave/small/nodirt
	gradient = list("#808080", "#FFFFFF")

/particles/wave_water
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke5"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 15
	fade = 25
	color_change = generator(GEN_NUM, 0.08, 0.07)
	velocity = generator(GEN_CIRCLE, 25, 25)
	rotation = generator(GEN_NUM, -45, 45)
	scale = 0.45
	grow = 0.05
	friction = 0.05

/particles/dirt_kickup
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke"
	width = 500
	height = 500
	count = 80
	spawning = 10
	lifespan = 15
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 0.18, 0.15)
	position = generator(GEN_SPHERE, 150, 150)
	color = COLOR_BROWN
	velocity = list(0, 12)
	grow = list(0, 0.01)
	gravity = list(0, -1.25)

/particles/water_splash
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke2"
	width = 500
	height = 500
	count = 80
	spawning = 10
	lifespan = 15
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 0.18, 0.15)
	position = generator(GEN_SPHERE, 150, 150)
	velocity = list(0, 12)
	grow = list(0, 0.01)
	gravity = list(0, -1.25)

/particles/dirt_kickup_large
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke"
	width = 750
	height = 750
	gradient = list("#FA9632", "#C3630C", "#333333", "#808080", "#FFFFFF")
	count = 3
	spawning = 3
	lifespan = 20
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 0.5, 1)
	position = generator(GEN_BOX, list(-12, 32), list(12, 48), NORMAL_RAND)
	color = generator(GEN_NUM, 0, 0.25)
	color_change = generator(GEN_NUM, 0.04, 0.05)
	velocity = list(0, 12)
	grow = list(0, 0.025)
	gravity = list(0, -1)

/particles/dirt_kickup_large/deva
	velocity = list(0, 25)
	scale = generator(GEN_NUM, 1, 1.25)
	grow = list(0, 0.03)
	gravity = list(0, -2)
	fade = 10

/particles/water_splash_large
	icon = 'icons/effects/96x157.dmi'
	icon_state = "smoke2"
	width = 750
	height = 750
	count = 3
	spawning = 3
	lifespan = 20
	fade = 10
	fadein = 3
	scale = generator(GEN_NUM, 1, 1.25)
	position = generator(GEN_BOX, list(-12, 32), list(12, 48), NORMAL_RAND)
	velocity = list(0, 12)
	grow = list(0, 0.05)
	gravity = list(0, -1)

/particles/falling_debris
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "rock"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 20
	fade = 5
	position = generator(GEN_SPHERE, 16, 16)
	color = COLOR_DARK_BROWN
	velocity = list(0, 26)
	scale = generator(GEN_NUM, 1, 2)
	gravity = list(0, -3)
	friction = 0.02
	drift = generator(GEN_CIRCLE, 0, 1.5)

/particles/falling_debris/small
	count = 40
	spawning = 40

/particles/water_falling
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "cross_tgmc"
	width = 750
	height = 750
	count = 75
	spawning = 75
	lifespan = 20
	fade = 5
	position = generator(GEN_SPHERE, 16, 16)
	velocity = list(0, 26)
	scale = generator(GEN_NUM, 1, 2)
	gravity = list(0, -3)
	friction = 0.02
	drift = generator(GEN_CIRCLE, 0, 1.5)

/particles/sparks_outwards
	icon = 'icons/effects/64x64.dmi'
	icon_state = "flare"
	width = 750
	height = 750
	count = 40
	spawning = 20
	lifespan = 15
	fade = 15
	position = generator(GEN_SPHERE, 8, 8)
	velocity = generator(GEN_CIRCLE, 30, 30)
	scale = 0.1
	friction = 0.1

/particles/water_outwards
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = "cross"
	width = 750
	height = 750
	count = 40
	spawning = 20
	lifespan = 15
	fade = 15
	position = generator(GEN_SPHERE, 8, 8)
	velocity = generator(GEN_CIRCLE, 30, 30)
	scale = 1.25
	friction = 0.1

/obj/effect/temp_visual/explosion
	name = "boom"
	icon = 'icons/blanks/32x32.dmi'
	icon_state = "nothing"
	light_system = COMPLEX_LIGHT
	duration = 25
	/// What icon state do we use for the actual explosion?
	var/explosion_icon_state = "explosion"
	/// What icon do we use for the actual explosion?
	var/explosion_icon = 'icons/effects/96x96.dmi'
	var/pixel_w_offset = -32
	var/pixel_z_offset = -32
	var/speed_multiplier = 1
	var/speed_multiplier_invert = 1
	///smoke wave particle holder
	var/obj/effect/abstract/particle_holder/smoke_wave
	///explosion smoke particle holder
	var/obj/effect/abstract/particle_holder/explosion_smoke
	///debris dirt kickup particle holder
	var/obj/effect/abstract/particle_holder/dirt_kickup
	///falling debris particle holder
	var/obj/effect/abstract/particle_holder/falling_debris
	///sparks particle holder
	var/obj/effect/abstract/particle_holder/sparks
	///large dirt kickup particle holder
	var/obj/effect/abstract/particle_holder/large_kickup

/obj/effect/temp_visual/explosion/Initialize(mapload, radius = 1, color = LIGHT_COLOR_LAVA, small = FALSE, large = FALSE, tiny = FALSE)
	. = ..()
	set_light(radius, radius, color)
	generate_particles(radius, small, large, tiny)
	var/image/I
	if(tiny)
		explosion_icon = "icons/effects/64x64.dmi"
		pixel_w_offset = -16
		pixel_z_offset = -16
	I = image(explosion_icon, src, explosion_icon_state, 10, pixel_w = pixel_w_offset, pixel_z = pixel_z_offset)
	var/matrix/rotate = matrix()
	rotate.Turn(rand(0, 359))
	I.transform = rotate
	overlays += I //we use an overlay so the explosion and light source are both in the correct location plus so the particles don't rotate with the explosion
	icon_state = null

///Generate the particles
/obj/effect/temp_visual/explosion/proc/generate_particles(radius, small = FALSE, large = FALSE, tiny = FALSE)
	var/turf/turf_type = get_turf(src)
	var/outdoors = FALSE
	if(is_type_in_list(turf_type, list(
		/turf/open/floor/asphalt,
		/turf/open/floor/fake_snow,
		/turf/open/floor/fakebasalt,
		/turf/open/floor/fakeice,
		/turf/open/misc,
	)))
		outdoors = TRUE
	if(outdoors)
		if(large)
			explosion_smoke = new(src, /particles/explosion_smoke/deva)
		else if(small)
			explosion_smoke = new(src, /particles/explosion_smoke/small)
		else if(tiny)
			explosion_smoke = new(src, /particles/explosion_smoke/tiny)
		else
			explosion_smoke = new(src, /particles/explosion_smoke)
	else
		if(large)
			explosion_smoke = new(src, /particles/explosion_smoke/deva/nodirt)
		else if(small)
			explosion_smoke = new(src, /particles/explosion_smoke/small/nodirt)
		else if(tiny)
			explosion_smoke = new(src, /particles/explosion_smoke/tiny/nodirt)
		else
			explosion_smoke = new(src, /particles/explosion_smoke/nodirt)
		explosion_smoke.particles.lifespan *= speed_multiplier
		explosion_smoke.particles.fade *= speed_multiplier
		explosion_smoke.particles.velocity = generator(GEN_CIRCLE, 15 * speed_multiplier_invert, 15 * speed_multiplier_invert)
	if(!tiny)
		if(outdoors)
			if(small)
				smoke_wave = new(src, /particles/smoke_wave/small)
			else
				smoke_wave = new(src, /particles/smoke_wave)
			dirt_kickup = new(src, /particles/dirt_kickup)
			if(small)
				falling_debris = new(src, /particles/falling_debris/small)
			else
				falling_debris = new(src, /particles/falling_debris)
			dirt_kickup.particles.lifespan *= speed_multiplier
			dirt_kickup.particles.fade *= speed_multiplier
			dirt_kickup.particles.velocity = list(0, 12 * speed_multiplier_invert)
			falling_debris.particles.lifespan *= speed_multiplier
			falling_debris.particles.fade *= speed_multiplier
			falling_debris.particles.velocity = list(0, 26 * speed_multiplier_invert)
		else
			if(small)
				smoke_wave = new(src, /particles/smoke_wave/small/nodirt)
			else
				smoke_wave = new(src, /particles/smoke_wave/nodirt)
		smoke_wave.particles.lifespan *= speed_multiplier
		smoke_wave.particles.fade *= speed_multiplier
		sparks = new(src, /particles/sparks_outwards)
		if(outdoors)
			if(large)
				large_kickup = new(src, /particles/dirt_kickup_large/deva)
				large_kickup.particles.velocity = list(0, 25 * speed_multiplier_invert)
			else
				large_kickup = new(src, /particles/dirt_kickup_large)
				large_kickup.particles.velocity = list(0, 12 * speed_multiplier_invert)
			large_kickup.particles.lifespan *= speed_multiplier
			large_kickup.particles.fade *= speed_multiplier
		sparks.particles.lifespan *= speed_multiplier
		sparks.particles.fade *= speed_multiplier
		if(large)
			smoke_wave.particles.velocity = generator(GEN_CIRCLE, (6 * radius) * speed_multiplier_invert, (6 * radius) * speed_multiplier_invert)
		else if(small)
			smoke_wave.particles.velocity = generator(GEN_CIRCLE, (3 * radius) * speed_multiplier_invert, (3 * radius) * speed_multiplier_invert)
		else
			smoke_wave.particles.velocity = generator(GEN_CIRCLE, (5 * radius) * speed_multiplier_invert, (5 * radius) * speed_multiplier_invert)

	if(!tiny)
		sparks.particles.velocity = generator(GEN_CIRCLE, (8 * radius) * speed_multiplier_invert, (8 * radius) * speed_multiplier_invert)
		addtimer(CALLBACK(src, PROC_REF(set_count_long)), 10 * speed_multiplier)
	else
		sparks.particles.velocity = generator(GEN_CIRCLE, 30 * speed_multiplier_invert, 30 * speed_multiplier_invert)
	addtimer(CALLBACK(src, PROC_REF(set_count_short), tiny), 5 * speed_multiplier)
	explosion_smoke.layer = layer + 0.1

/obj/effect/temp_visual/explosion/proc/set_count_short(tiny = FALSE)
	if(tiny)
		explosion_smoke.particles.count = 0
	else
		smoke_wave.particles.count = 0
		explosion_smoke.particles.count = 0
		sparks.particles.count = 0
		if(large_kickup)
			large_kickup.particles.count = 0
		if(falling_debris)
			falling_debris.particles.count = 0

/obj/effect/temp_visual/explosion/proc/set_count_long()
	if(dirt_kickup)
		dirt_kickup.particles.count = 0

/obj/effect/temp_visual/explosion/Destroy()
	QDEL_NULL(smoke_wave)
	QDEL_NULL(explosion_smoke)
	QDEL_NULL(sparks)
	QDEL_NULL(large_kickup)
	QDEL_NULL(falling_debris)
	QDEL_NULL(dirt_kickup)
	return ..()

/obj/effect/temp_visual/explosion/fast
	explosion_icon_state = "explosionfast"
	duration = 12.5
	speed_multiplier = 0.5
	speed_multiplier_invert = 2
