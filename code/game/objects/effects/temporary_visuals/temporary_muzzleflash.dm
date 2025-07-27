/obj/effect/temp_visual/muzzle
	name = "muzzle flash"
	icon = 'icons/obj/weapons/guns/projectiles_muzzle.dmi'
	layer = MOB_BELOW_PIGGYBACK_LAYER
	duration = 2 SECONDS // give it enough time to die
	light_system = OVERLAY_LIGHT_DIRECTIONAL_VISCONTENTS
	light_range = 3
	light_color = COLOR_VERY_SOFT_YELLOW
	light_on = FALSE
	light_on_time = 0.05 SECONDS
	light_off_time = 0.15 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/muzzle/Initialize(mapload, mob/user, atom/target)
	. = ..()
	var/firing_angle = get_angle(user, target)
	var/firing_direction = get_dir(user, target)
	setDir(firing_direction)
	set_light_dir(firing_direction)
	set_light_angle(firing_angle)
	//Offset the pixels.
	switch(firing_angle)
		if(0, 360)
			pixel_x = 0
			pixel_y = 13
			layer = initial(layer)
		if(1 to 44)
			pixel_x = round(6 * ((firing_angle) / 45))
			pixel_y = 13
			layer = initial(layer)
		if(45)
			pixel_x = 13
			pixel_y = 13
			layer = initial(layer)
		if(46 to 89)
			pixel_x = 13
			pixel_y = round(6 * ((90 - firing_angle) / 45))
			layer = initial(layer)
		if(90)
			pixel_x = 13
			pixel_y = 0
			layer = initial(layer)
		if(91 to 134)
			pixel_x = 13
			pixel_y = round(-4 * ((firing_angle - 90) / 45))
			layer = initial(layer)
		if(135)
			pixel_x = 13
			pixel_y = -10
			layer = initial(layer)
		if(136 to 179)
			pixel_x = round(4 * ((180 - firing_angle) / 45))
			pixel_y = -12
			layer = ABOVE_MOB_LAYER
		if(180)
			pixel_x = 0
			pixel_y = -12
			layer = ABOVE_MOB_LAYER
		if(181 to 224)
			pixel_x = round(-6 * ((firing_angle - 180) / 45))
			pixel_y = -12
			layer = ABOVE_MOB_LAYER
		if(225)
			pixel_x = -12
			pixel_y = -12
			layer = initial(layer)
		if(226 to 269)
			pixel_x = -12
			pixel_y = round(-12 * ((270 - firing_angle) / 45))
			layer = initial(layer)
		if(270)
			pixel_x = -12
			pixel_y = 0
			layer = initial(layer)
		if(271 to 313)
			pixel_x = -12
			pixel_y = round(8 * ((firing_angle - 270) / 45))
			layer = initial(layer)
		if(315)
			pixel_x = -12
			pixel_y = 13
			layer = initial(layer)
		if(316 to 359)
			pixel_x = round(-12 * ((360 - firing_angle) / 45))
			pixel_y = 13
			layer = initial(layer)
	transform = null
	transform = turn(transform, firing_angle)
	set_light_on(TRUE)
	set_light_on(FALSE)
	animate(src, alpha = 0, time = 0.2 SECONDS, easing = CUBIC_EASING | EASE_OUT)

/obj/effect/temp_visual/muzzle/laser
	icon_state = "muzzle_laser"
	light_color = COLOR_RED_LIGHT

/obj/effect/temp_visual/muzzle/laser/blue
	icon_state = "muzzle_blue"
	light_color = COLOR_BLUE_LIGHT

/obj/effect/temp_visual/muzzle/disabler
	icon_state = "muzzle_omni"
	light_color = COLOR_BLUE_LIGHT

/obj/effect/temp_visual/muzzle/xray
	icon_state = "muzzle_xray"
	light_color = COLOR_GREEN

/obj/effect/temp_visual/muzzle/pulse
	icon_state = "muzzle_u_laser"
	light_color = COLOR_BLUE

/obj/effect/temp_visual/muzzle/plasma_cutter
	icon_state = "muzzle_plasmacutter"
	light_color = COLOR_CYAN

/obj/effect/temp_visual/muzzle/stun
	icon_state = "muzzle_stun"
	light_color = COLOR_YELLOW

/obj/effect/temp_visual/muzzle/heavy_laser
	icon_state = "muzzle_beam_heavy"
	light_color = COLOR_RED

/obj/effect/temp_visual/muzzle/wormhole
	icon_state = "wormhole_g"
	light_color = COLOR_BLACK

/obj/effect/temp_visual/muzzle/laser/emitter
	name = "emitter flash"
	icon_state = "muzzle_emitter"
	light_color = COLOR_CYAN

/obj/effect/temp_visual/muzzle/solar
	icon_state = "muzzle_solar"
	light_color = COLOR_YELLOW

/obj/effect/temp_visual/muzzle/sniper
	icon_state = "sniper"

/obj/effect/temp_visual/muzzle/bullet
	icon_state = "muzzle_tgmc"
