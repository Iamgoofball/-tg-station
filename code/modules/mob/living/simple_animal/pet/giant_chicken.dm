/mob/living/simple_animal/pet/giant_chicken
	name = "Giant Chicken"
	desc = "A massive chicken with a thirst for vengeance. It seems to have a grudge against a certain overweight man."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("Bwok!", "Bwaaaawk!", "CLUCK!", "You will pay for this!")
	speak_emote = list("clucks aggressively", "squawks", "flaps wings")
	speak_chance = 15
	emote_hear = list("clucks", "squawks", "flaps")
	emote_see = list("stares menacingly", "peeks at the ground", "shakes its feathers")
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	butcher_results = list(/obj/item/food/meat/chicken = 3)
	faction = list("neutral")
