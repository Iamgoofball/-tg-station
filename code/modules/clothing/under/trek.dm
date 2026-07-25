// 🛡️ Retro duty uniforms - entirely original design
// Replaces former Star Trek themed uniforms with original designs

/obj/item/clothing/under/trek
	can_adjust = FALSE
	icon = 'icons/obj/clothing/under/trek.dmi'
	worn_icon = 'icons/mob/clothing/under/trek.dmi'

/obj/item/clothing/under/trek/command
	name = "golden duty uniform"
	desc = "A classic golden duty uniform, worn by command staff in the old fleet."
	inhand_icon_state = "y_suit"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/command"
	post_init_icon_state = "trek_tos_com"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#fab342"

/obj/item/clothing/under/trek/engsec
	name = "navy duty uniform"
	desc = "A dark navy duty uniform, worn by engineering and security personnel in the old fleet."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/engsec"
	post_init_icon_state = "trek_tos_sec"
	inhand_icon_state = "r_suit"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#1B3B6F" // Dark navy blue instead of Star Trek red

/obj/item/clothing/under/trek/medsci
	name = "teal duty uniform"
	desc = "A teal duty uniform, worn by medical and science personnel in the old fleet."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/medsci"
	post_init_icon_state = "trek_tos"
	inhand_icon_state = "b_suit"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#5FA4CC"

/*
*	The Next Generation
*/
/obj/item/clothing/under/trek/command/next
	icon_state = "/obj/item/clothing/under/trek/command/next"
	post_init_icon_state = "trek_next" //Technically TNG had Command wearing red, but bc gold is closer to command roles for SS13 we're taking some liberties

/obj/item/clothing/under/trek/engsec/next
	icon_state = "/obj/item/clothing/under/trek/engsec/next"
	post_init_icon_state = "trek_next"

/obj/item/clothing/under/trek/medsci/next
	icon_state = "/obj/item/clothing/under/trek/medsci/next"
	post_init_icon_state = "trek_next"

/*
*	Voyager
*/
/obj/item/clothing/under/trek/command/voy
	icon_state = "/obj/item/clothing/under/trek/command/voy"
	post_init_icon_state = "trek_voy" //Same point applies as TNG

/obj/item/clothing/under/trek/engsec/voy
	icon_state = "/obj/item/clothing/under/trek/engsec/voy"
	post_init_icon_state = "trek_voy"

/obj/item/clothing/under/trek/medsci/voy
	icon_state = "/obj/item/clothing/under/trek/medsci/voy"
	post_init_icon_state = "trek_voy"

/*
*	Enterprise
*/
/obj/item/clothing/under/trek/command/ent
	icon_state = "/obj/item/clothing/under/trek/command/ent"
	post_init_icon_state = "trek_ent"
	//Greyscale sprite note, the base of it can't be greyscaled lest I make a whole new .json, but the color bands are greyscale at least.
	inhand_icon_state = "bl_suit"

/obj/item/clothing/under/trek/engsec/ent
	icon_state = "/obj/item/clothing/under/trek/engsec/ent"
	post_init_icon_state = "trek_ent"
	inhand_icon_state = "bl_suit"

/obj/item/clothing/under/trek/medsci/ent
	icon_state = "/obj/item/clothing/under/trek/medsci/ent"
	post_init_icon_state = "trek_ent"
	inhand_icon_state = "bl_suit"

//Q
/obj/item/clothing/under/trek/q
	name = "french marshall's uniform"
	desc = "Something about this uniform feels off..."
	icon_state = "trek_Q"
	inhand_icon_state = "r_suit"
