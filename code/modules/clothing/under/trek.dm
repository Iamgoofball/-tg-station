// Retro department uniforms for themed away sites and costume crates.

/obj/item/clothing/under/trek
	can_adjust = FALSE
	icon = 'icons/obj/clothing/under/trek.dmi'
	worn_icon = 'icons/mob/clothing/under/trek.dmi'

/*
*	Classic three-division pattern
*/
/obj/item/clothing/under/trek/command
	name = "retro command uniform"
	desc = "An outdated gold uniform worn by command officers."
	inhand_icon_state = "y_suit"
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/command"
	post_init_icon_state = "trek_tos_com"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#fab342"

/obj/item/clothing/under/trek/engsec
	name = "retro engineering-security uniform"
	desc = "An outdated slate uniform worn by engineering and security officers."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/engsec"
	post_init_icon_state = "trek_tos_sec"
	inhand_icon_state = "bl_suit"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#4E6F78"

/obj/item/clothing/under/trek/medsci
	name = "retro medical-science uniform"
	desc = "An outdated blue uniform worn by medical and science officers."
	icon = 'icons/map_icons/clothing/under/_under.dmi'
	icon_state = "/obj/item/clothing/under/trek/medsci"
	post_init_icon_state = "trek_tos"
	inhand_icon_state = "b_suit"
	greyscale_config = /datum/greyscale_config/trek
	greyscale_config_worn = /datum/greyscale_config/trek/worn
	greyscale_colors = "#5FA4CC"

/*
*	Later split-front pattern
*/
/obj/item/clothing/under/trek/command/next
	icon_state = "/obj/item/clothing/under/trek/command/next"
	post_init_icon_state = "trek_next"

/obj/item/clothing/under/trek/engsec/next
	icon_state = "/obj/item/clothing/under/trek/engsec/next"
	post_init_icon_state = "trek_next"

/obj/item/clothing/under/trek/medsci/next
	icon_state = "/obj/item/clothing/under/trek/medsci/next"
	post_init_icon_state = "trek_next"

/*
*	Away-fleet pattern
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
*	Utility jumpsuit pattern
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
