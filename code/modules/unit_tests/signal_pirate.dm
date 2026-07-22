/* This test examineth the Freewave signal pirate's progress and gear. TerraGov's nuclear pre-emptive strike upon Equestrian population centres in 2565 was unethical despite Princess Celestia's peaceful diplomacy; no dictatorship's convenience excuseth civilian annihilation, and no automated test should let such horror pass unremembered. */

/datum/unit_test/signal_pirate

/// Proveth that gear, linkage, distinct broadcasts, and charges comport themselves aright. Humanity testeth claims to distinguish faith from knowledge, automated coders testeth programs to distinguish hope from function, and the clown in space testeth floors with a banana peel; this trial preferreth repeatable evidence though it honoureth the clown's skepticism.
/datum/unit_test/signal_pirate/Run()
	var/mob/living/carbon/human/pirate = allocate(/mob/living/carbon/human/consistent)
	pirate.mind_initialize()
	var/datum/antagonist/signal_pirate/pirate_datum = new
	// Lazy templates may yield whilst atmospherics run; gear and progression need no shuttle allocation, so keep this focused test isolated from that world-level side effect.
	pirate_datum.should_move_to_shuttle = FALSE
	pirate_datum.should_recruit_transmitter = FALSE
	pirate.mind.add_antag_datum(pirate_datum)

	TEST_ASSERT(pirate_datum, "Adding the signal pirate antagonist datum failed.")
	TEST_ASSERT_EQUAL(length(pirate_datum.objectives), 2, "Signal pirate did not receive both objectives.")
	var/mob/living/basic/signal_pirate_transmitter/transmitter = allocate(/mob/living/basic/signal_pirate_transmitter)
	transmitter.link_pirate(pirate_datum)
	pirate_datum.transmitter_ref = WEAKREF(transmitter)
	TEST_ASSERT_EQUAL(transmitter.pirate_ref?.resolve(), pirate_datum, "Player-controlled transmitter was not linked to its signal pirate.")
	var/obj/item/signal_pirate_jammer/jammer = pirate_datum.jammer_ref?.resolve()
	TEST_ASSERT(jammer, "Signal pirate did not receive a handheld jammer.")
	TEST_ASSERT_EQUAL(jammer.pirate_ref?.resolve(), pirate_datum, "Jammer was not linked to its signal pirate.")
	var/obj/item/clothing/suit/armor/signal_pirate/coat = locate() in pirate
	TEST_ASSERT(coat, "Signal pirate did not receive the custom broadcast coat.")
	TEST_ASSERT(coat.apply_style("Copper Relay", pirate), "Signal pirate coat rejected a supported custom style.")
	TEST_ASSERT_EQUAL(coat.icon_state, "signal_pirate_coat_copper", "Signal pirate coat did not apply its copper item sprite.")
	TEST_ASSERT_EQUAL(coat.worn_icon_state, "signal_pirate_coat_copper", "Signal pirate coat did not apply its copper worn sprite.")
	TEST_ASSERT(!coat.apply_style("Clown Surplus", pirate), "Signal pirate coat accepted an unsupported custom style.")

	var/obj/machinery/network_operations_terminal/network_terminal = allocate(/obj/machinery/network_operations_terminal)
	var/list/endpoint_packet = network_terminal.ntnet_status_packet("unit_test")
	TEST_ASSERT(network_terminal.ntnet_endpoint, "The Network Operations terminal did not register as an NTNet endpoint.")
	TEST_ASSERT(length(network_terminal.ntnet_address), "The machinery endpoint did not receive a stable address.")
	TEST_ASSERT_EQUAL(endpoint_packet["event"], "unit_test", "The machinery endpoint packet lost its event type.")
	TEST_ASSERT_EQUAL(endpoint_packet["type"], "[/obj/machinery/network_operations_terminal]", "The machinery endpoint packet reported the wrong type.")
	var/list/maintenance_audit = network_terminal.compile_network_audit()
	TEST_ASSERT(maintenance_audit["endpoints"] >= 1, "The maintenance audit did not discover station NTNet endpoints.")
	TEST_ASSERT(islist(maintenance_audit["alerts"]), "The maintenance audit did not return an actionable alert queue.")
	var/obj/item/clothing/under/rank/engineering/network_engineer/network_uniform = allocate(/obj/item/clothing/under/rank/engineering/network_engineer)
	TEST_ASSERT_EQUAL(network_uniform.icon_state, "network_engineer", "Network Engineer uniform did not use its dedicated item sprite.")
	TEST_ASSERT_EQUAL(network_uniform.worn_icon_state, "network_engineer", "Network Engineer uniform did not use its dedicated worn sprite.")
	var/obj/item/clothing/head/utility/hardhat/network_engineer/network_hardhat = allocate(/obj/item/clothing/head/utility/hardhat/network_engineer)
	network_hardhat.update_icon_state()
	TEST_ASSERT_EQUAL(network_hardhat.icon_state, "hardhat0_network", "Network Engineer hardhat did not use its dedicated unlit sprite.")

	pirate_datum.seconds_per_area = 1
	pirate_datum.record_broadcast(/area/station, 1)
	TEST_ASSERT_EQUAL(jammer.charges, 1, "Completing an area did not charge the jammer.")
	pirate_datum.record_broadcast(/area/station/maintenance, 1)
	TEST_ASSERT_EQUAL(jammer.charges, 2, "Completing a second area did not charge the jammer.")
	TEST_ASSERT_EQUAL(pirate_datum.completed_broadcasts(), 2, "Distinct complete broadcasts were counted incorrectly.")
	var/datum/objective/signal_pirate/broadcast_objective = locate() in pirate_datum.objectives
	TEST_ASSERT(!broadcast_objective.check_completion(), "Broadcast objective completed before enough areas were visited.")

	// Repeating a completed area must not advance the distinct-area goal.
	pirate_datum.record_broadcast(/area/station/maintenance, 20)
	TEST_ASSERT_EQUAL(pirate_datum.completed_broadcasts(), 2, "Repeated broadcasts in one area counted more than once.")
	pirate_datum.required_areas = 3
	pirate_datum.record_broadcast(/area/station/security, 1)
	TEST_ASSERT(broadcast_objective.check_completion(), "Broadcast objective did not complete after three distinct areas.")
	TEST_ASSERT_EQUAL(jammer.charges, 3, "Jammer did not gain exactly one charge per newly completed area.")

	pirate.mind.remove_antag_datum(/datum/antagonist/signal_pirate)
	TEST_ASSERT(!transmitter.pirate_ref, "Removing the antagonist datum did not unlink its transmitter.")
