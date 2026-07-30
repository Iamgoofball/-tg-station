// Drink reagents

/datum/reagent/consumable/thirteen_loko
	name = "Fourteen Loko"
	description = "An energy drink so powerful it was banned in several star systems."
	color = "#c80000"
	nutrition = 2
	alcohol_power = 0.4
	metabolism_rate = REM * 0.5
	override_chem_description = "An extremely potent alcoholic energy drink."

/datum/reagent/consumable/thirteen_loko/on_mob_metabolize(mob/living/carbon/M)
	. = ..() 
	M.adjust_nutrition(1)
	if(M.getBrainLoss() < 60)
		M.adjustBrainLoss(-1)
