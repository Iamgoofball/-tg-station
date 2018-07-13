GLOBAL_LIST_INIT(skin_colors, list(COLOR_ASSEMBLY_BLACK,
									COLOR_ASSEMBLY_BGRAY,
									COLOR_ASSEMBLY_WHITE,
									COLOR_ASSEMBLY_RED,
									COLOR_ASSEMBLY_ORANGE,
									COLOR_ASSEMBLY_BEIGE,
									COLOR_ASSEMBLY_BROWN,
									COLOR_ASSEMBLY_GOLD,
									COLOR_ASSEMBLY_YELLOW,
									COLOR_ASSEMBLY_GURKHA,
									COLOR_ASSEMBLY_LGREEN,
									COLOR_ASSEMBLY_GREEN,
									COLOR_ASSEMBLY_LBLUE,
									COLOR_ASSEMBLY_BLUE,
									COLOR_ASSEMBLY_PURPLE))

/datum/item_skin
	var/name = "Item Skin"
	var/list/used_colors
	var/ctype
	var/skin_index
	var/layer_amt
	var/icon/generated_skin

/datum/item_skin/camo
	ctype = "camo"

/datum/item_skin/paint
	ctype = "paint"

/datum/item_skin/camo/basic_woodland
	name = "Basic Woodland"
	skin_index = 1
	layer_amt = 2

/datum/item_skin/camo/combine
	name = "Future"
	skin_index = 2
	layer_amt = 2

/datum/item_skin/camo/nature
	name = "Nature"
	skin_index = 3
	layer_amt = 3

/datum/item_skin/paint/light
	name = "Light Paint"
	skin_index = 1
	layer_amt = 1

/datum/item_skin/paint/normal
	name = "Paint"
	skin_index = 2
	layer_amt = 1

/datum/item_skin/paint/intense
	name = "Intense Paint"
	skin_index = 3
	layer_amt = 1

/datum/item_skin/New()
	..()
	for(var/i in 1 to layer_amt)
		LAZYADD(used_colors, pick(GLOB.skin_colors))
	generate_skin()

/datum/item_skin/proc/generate_skin()
	generated_skin = new('icons/obj/camo.dmi', "skin_background")
	for(var/i in 1 to layer_amt)
		var/color_to_use = used_colors[i]
		to_chat(world, "[ctype]-[skin_index]-[i]")
		var/icon/layer_to_color = new('icons/obj/camo.dmi', "[ctype]-[skin_index]-[i]")
		var/list/color_rgb = ReadRGB(color_to_use)
		layer_to_color.Blend(rgb(color_rgb[1], color_rgb[2], color_rgb[3]), ICON_ADD)
		generated_skin.Blend(layer_to_color, ICON_OVERLAY)

/datum/item_skin/proc/apply_skin(icon/I)
	var/icon/RE = new /icon
	for(var/IS in icon_states(I))
		var/icon/IC = new(I, IS)
		var/icon/skin = icon(generated_skin)
		skin.Blend(IC, ICON_ADD)
		RE.Insert(skin, IS)
	return RE