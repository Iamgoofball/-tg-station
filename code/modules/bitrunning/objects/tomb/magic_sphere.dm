/obj/structure/magic_sphere
	name = "sphere"
	desc = "A colored, spherical orb."
	icon = 'icons/obj/bitrunning/tomb.dmi'
	icon_state = "magic_sphere"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	var/color_name = "debug"
	var/trap_to_trigger = "dud"


/obj/structure/magic_sphere/Initialize(mapload)
	. = ..()
	name = "[color_name] sphere"
	AddComponent(/datum/component/trap_trigger, trap_id_to_trigger = trap_to_trigger, triggers_on_crossed = FALSE, triggers_on_attackhand = TRUE, triggers_on_attacked = TRUE)

// Spheres that do stuff (placed up here for ease of reading)
/obj/structure/magic_sphere/gold
	icon_state = "gold"
	color_name = "gold"
	trap_to_trigger = "room9_11" // never forget

/obj/structure/magic_sphere/black
	icon_state = "black"
	color_name = "black"
	trap_to_trigger = "room9_14"

/obj/structure/magic_sphere/red
	icon_state = "red"
	color_name = "red"
	trap_to_trigger = "room9_13"

/obj/structure/magic_sphere/orange
	icon_state = "orange"
	color_name = "orange"
	trap_to_trigger = "room9_spear"

/obj/structure/magic_sphere/bronze
	icon_state = "bronze"
	color_name = "bronze"
	trap_to_trigger = "room9_spear"

// Dud spheres

/obj/structure/magic_sphere/purple
	icon_state = "purple"
	color_name = "purple"

/obj/structure/magic_sphere/gray
	icon_state = "gray"
	color_name = "gray"

/obj/structure/magic_sphere/bright_blue
	icon_state = "brightblue"
	color_name = "bright blue"

/obj/structure/magic_sphere/white
	icon_state = "white"
	color_name = "white"

/obj/structure/magic_sphere/turqoise
	icon_state = "turquioise"
	color_name = "turqoise"

/obj/structure/magic_sphere/scarlet
	icon_state = "scarlet"
	color_name = "scarlet"

/obj/structure/magic_sphere/pale_green
	icon_state = "palegreen"
	color_name = "pale green"

/obj/structure/magic_sphere/pale_blue
	icon_state = "paleblue"
	color_name = "pale blue"

/obj/structure/magic_sphere/silver
	icon_state = "silver"
	color_name = "silver"

/obj/structure/magic_sphere/green
	icon_state = "green"
	color_name = "green"

/obj/structure/magic_sphere/yellow
	icon_state = "yellow"
	color_name = "yellow"

/obj/structure/magic_sphere/pink
	icon_state = "pink"
	color_name = "pink"

/obj/structure/magic_sphere/pale_violet
	icon_state = "paleviolet"
	color_name = "pale violet"

/obj/structure/magic_sphere/indigo
	icon_state = "indigo"
	color_name = "indigo"

/obj/structure/magic_sphere/buff
	icon_state = "buff"
	color_name = "buff"

