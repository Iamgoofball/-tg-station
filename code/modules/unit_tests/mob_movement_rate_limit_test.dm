/// Unit tests for mob movement rate-limiting mechanism in /client/Move()
/datum/unit_test/mob_movement_rate_limit/Run()
	var/mob/living/carbon/human/test_mob = allocate(/mob/living/carbon/human/consistent, run_loc_floor_bottom_left)
	var/client/test_client = new /client()
	test_client.mob = test_mob

	var/turf/start_turf = run_loc_floor_bottom_left
	var/turf/target_north = get_step(start_turf, NORTH)
	var/turf/target_east = get_step(start_turf, EAST)
	var/turf/target_northeast = get_step(start_turf, NORTHEAST)

	// 1. Initial State Verification
	test_client.move_delay = world.time
	var/base_slowdown = test_mob.cached_multiplicative_slowdown

	// 2. Rapid Packet Execution Rejection Test (world.time < move_delay)
	// Set move_delay in the future
	test_client.move_delay = world.time + 10
	var/move_result = test_client.Move(target_north, NORTH)
	TEST_ASSERT_EQUAL(move_result, FALSE, "Movement attempt when world.time < move_delay should return FALSE")
	TEST_ASSERT_EQUAL(test_mob.loc, start_turf, "Mob location should not change when movement is rate-limited")
	TEST_ASSERT_EQUAL(test_client.move_delay, world.time + 10, "move_delay should remain unchanged on rejected movement attempt")

	// 3. Valid Movement Execution Test (world.time >= move_delay)
	test_client.move_delay = world.time
	var/expected_next_delay = world.time + base_slowdown
	move_result = test_client.Move(target_north, NORTH)
	TEST_ASSERT(move_result, "Movement attempt when world.time >= move_delay should succeed")
	TEST_ASSERT_EQUAL(test_client.move_delay, expected_next_delay, "Valid movement should increment move_delay by cached_multiplicative_slowdown")

	// 4. Consecutive Packet Flood Rejection
	// Packet 2 in same tick should be rejected since move_delay is now > world.time
	var/flood_result = test_client.Move(target_east, EAST)
	TEST_ASSERT_EQUAL(flood_result, FALSE, "Rapid second movement packet in same tick must be strictly rejected")
	TEST_ASSERT_EQUAL(test_client.move_delay, expected_next_delay, "move_delay must not change on rejected flood packet")

	// 5. Diagonal Movement Delay Increase Test
	test_client.move_delay = world.time
	move_result = test_client.Move(target_northeast, NORTHEAST)
	if(move_result && test_mob.loc == target_northeast)
		var/expected_diag_slowdown = FLOOR(base_slowdown * sqrt(2), world.tick_lag)
		var/expected_diag_delay = world.time + expected_diag_slowdown
		TEST_ASSERT_EQUAL(test_client.move_delay, expected_diag_delay, "Diagonal movement should accurately increment move_delay with sqrt(2) slowdown scaling")

	// Clean up mock client mob reference
	test_client.mob = null
