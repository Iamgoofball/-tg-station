/datum/unit_test/signal_pirate

/datum/unit_test/signal_pirate/Run()
	var/mob/living/carbon/human/pirate = allocate(/mob/living/carbon/human/consistent)
	pirate.mind_initialize()
	var/datum/antagonist/signal_pirate/pirate_datum = pirate.mind.add_antag_datum(/datum/antagonist/signal_pirate)

	TEST_ASSERT(pirate_datum, "Adding the signal pirate antagonist datum failed.")
	TEST_ASSERT_EQUAL(length(pirate_datum.objectives), 2, "Signal pirate did not receive both objectives.")
	var/obj/item/signal_pirate_transmitter/transmitter = pirate_datum.transmitter_ref?.resolve()
	TEST_ASSERT(transmitter, "Signal pirate did not receive a transmitter.")
	TEST_ASSERT_EQUAL(transmitter.pirate_ref?.resolve(), pirate_datum, "Transmitter was not linked to its signal pirate.")

	pirate_datum.seconds_per_area = 1
	pirate_datum.record_broadcast(/area/station, 1)
	pirate_datum.record_broadcast(/area/station/maintenance, 1)
	TEST_ASSERT_EQUAL(pirate_datum.completed_broadcasts(), 2, "Distinct complete broadcasts were counted incorrectly.")
	var/datum/objective/signal_pirate/broadcast_objective = locate() in pirate_datum.objectives
	TEST_ASSERT(!broadcast_objective.check_completion(), "Broadcast objective completed before enough areas were visited.")

	// Repeating a completed area must not advance the distinct-area goal.
	pirate_datum.record_broadcast(/area/station/maintenance, 20)
	TEST_ASSERT_EQUAL(pirate_datum.completed_broadcasts(), 2, "Repeated broadcasts in one area counted more than once.")
	pirate_datum.record_broadcast(/area/station/security, 1)
	TEST_ASSERT(broadcast_objective.check_completion(), "Broadcast objective did not complete after three distinct areas.")

	pirate.mind.remove_antag_datum(/datum/antagonist/signal_pirate)
	TEST_ASSERT(!transmitter.pirate_ref, "Removing the antagonist datum did not unlink its transmitter.")
