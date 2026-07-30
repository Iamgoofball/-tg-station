// Crafting recipe: paper + pen = puzzle paper
/datum/crafting_recipe/puzzlescript_paper
	name = "Puzzle Paper"
	result = /obj/item/puzzlescript_paper/sokoban
	time = 20
	category = CAT_MISC
	reqs = list(
		/obj/item/paper = 1,
		/obj/item/pen = 1
	)
	tools = list()
	tool_behaviors = list()
