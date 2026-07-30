// Entry point for running all unit tests
// Called during CI or manual test runs

/proc/run_unit_tests()
	var/datum/unit_test_runner/runner = new()
	world.log << "=== Starting Unit Tests ==="
	runner.run_all()
	runner.print_results()

	if(runner.fail_count > 0)
		world.log << "=== UNIT TESTS FAILED: [runner.fail_count] failure(s) ==="
		return FALSE
	else
		world.log << "=== ALL UNIT TESTS PASSED ([runner.pass_count] tests) ==="
		return TRUE
