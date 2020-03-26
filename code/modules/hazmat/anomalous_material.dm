/obj/machinery/hazmat/anomalous_material
	name = "anomalous material"
	desc = "It's been waiting for you. In the test chamber."
	icon_state = "anomalous_material"
	var/list/correct_laser_settings = list(
		list("color" = CRYSTAL_COLOR_RED, "shape" = CRYSTAL_SHAPE_SQUARE, "size" = CRYSTAL_SIZE_SMALL),
		list("color" = CRYSTAL_COLOR_BLUE, "shape" = CRYSTAL_SHAPE_CIRCLE, "size" = CRYSTAL_SIZE_MEDIUM),
		list("color" = CRYSTAL_COLOR_GREEN, "shape" = CRYSTAL_SHAPE_TRIANGLE, "size" = CRYSTAL_SIZE_LARGE))