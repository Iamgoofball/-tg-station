//Medical reagents - renamed from Star Trek references

/datum/reagent/medicine/ryetalyn
	name = "Cellular Restoration Compound"
	description = "A synthetic compound capable of curing most genetic defects and diseases."
	color = "#aaffaa"
	metabolism_rate = REM * 0.5
	override_chem_description = "Cures genetic anomalies and most diseases."

/datum/reagent/medicine/ryetalyn/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	M.cure_disease()
	M.adjustCloneLoss(-5)

/datum/reagent/medicine/cordrazine
	name = "Neuro-Stimulant Compound"
	description = "A powerful stimulant used to revive patients from critical states. Dangerous in large doses."
	color = "#ff66ff"
	metabolism_rate = REM * 0.5
	override_chem_description = "A powerful stimulant. Dangerous in high doses."

/datum/reagent/medicine/cordrazine/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	if(current_cycle <= 3)
		M.adjustOxyLoss(-10)
		M.adjustBrainLoss(-5)
	else
		M.adjustBrainLoss(3)
		M.confused = max(M.confused, 3)

/datum/reagent/medicine/tri_ox
	name = "Oxygenation Booster"
	description = "A chemical compound that dramatically increases the body's ability to absorb oxygen."
	color = "#aaaaff"
	metabolism_rate = REM * 0.5
	override_chem_description = "Increases oxygen absorption efficiency."

/datum/reagent/medicine/tri_ox/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	M.adjustOxyLoss(-8)
	if(M.stat == UNCONSCIOUS && M.getOxyLoss() < 10)
		M.set_stat(CONSCIOUS)
