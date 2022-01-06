///alien immune to tox damage
/mob/living/carbon/alien/getToxLoss()
	return FALSE

///alien immune to tox damage
/mob/living/carbon/alien/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE)
	return FALSE
