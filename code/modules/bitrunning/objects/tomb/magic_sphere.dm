/obj/structure/magic_sphere
	name = "sphere"
	desc = "A colored, spherical orb."
	icon = 'icons/obj/bitrunning/tomb.dmi'
	icon_state = "magic_sphere"
	max_integrity = INFINITY
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE
	color = "#FFFFFF"
	var/color_name = "debug"
	var/trap_to_trigger = "dud"


/obj/structure/magic_sphere/Initialize(mapload)
	. = ..()
	name = "[color_name] sphere"
	AddComponent(/datum/component/trap_trigger, trap_id_to_trigger = trap_to_trigger, triggers_on_crossed = FALSE, triggers_on_attackhand = TRUE, triggers_on_attacked = TRUE)

// Spheres that do stuff (placed up here for ease of reading)
/obj/structure/magic_sphere/gold
	color = "#ffd700"
	color_name = "gold"
	trap_to_trigger = "room9_11" // never forget

/obj/structure/magic_sphere/black
	color = "#000000"
	color_name = "black"
	trap_to_trigger = "room9_14"

/obj/structure/magic_sphere/red
	color = "#FF0000"
	color_name = "red"
	trap_to_trigger = "room9_13"

/obj/structure/magic_sphere/orange
	color = "#ffa500"
	color_name = "orange"
	trap_to_trigger = "room9_spear"

/obj/structure/magic_sphere/bronze
	color = "#CD7F32"
	color_name = "bronze"
	trap_to_trigger = "room9_spear"

// Dud spheres

/obj/structure/magic_sphere/purple
	color = "#800080"
	color_name = "purple"

/obj/structure/magic_sphere/gray
	color = "#808080"
	color_name = "gray"

/obj/structure/magic_sphere/bright_blue
	color = "#0096FF"
	color_name = "bright_blue"

/obj/structure/magic_sphere/white
	color = "#FFFFFF"
	color_name = "white"

/obj/structure/magic_sphere/turqoise
	color = "#40e0d0"
	color_name = "turqoise"

/obj/structure/magic_sphere/scarlet
	color = "#ff2400"
	color_name = "scarlet"

/obj/structure/magic_sphere/pale_green
	color = "#98FB98"
	color_name = "pale_green"

/obj/structure/magic_sphere/pale_blue
	color = "#afeeee"
	color_name = "pale_blue"

/obj/structure/magic_sphere/silver
	color = "#c0c0c0"
	color_name = "silver"

/obj/structure/magic_sphere/green
	color = "#008000"
	color_name = "green"

/obj/structure/magic_sphere/yellow
	color = "#ffff00"
	color_name = "yellow"

/obj/structure/magic_sphere/pink
	color = "#ffc0cb"
	color_name = "pink"

/obj/structure/magic_sphere/pale_violet
	color = "#cc99ff"
	color_name = "pale_violet"

/obj/structure/magic_sphere/indigo
	color = "#4b0082"
	color_name = "indigo"

/obj/structure/magic_sphere/buff
	color = "#f0dc82"
	color_name = "buff"

