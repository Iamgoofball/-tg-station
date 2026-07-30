/datum/unit_test
	var/name = "Unknown Test"
	var/list/failures = list()
	var/list/warnings = list()
	var/running = FALSE

/datum/unit_test/proc/Run()
	return

/datum/unit_test/proc/Fail(reason)
	failures += reason

/datum/unit_test/proc/Warn(reason)
	warnings += reason

/datum/unit_test/proc/Assert(condition, reason = "Assertion failed")
	if(!condition)
		Fail(reason)

/datum/unit_test/proc/AssertEqual(a, b, reason)
	if(a != b)
		Fail(reason || "Expected [b], got [a]")

/datum/unit_test/proc/AssertNotEqual(a, b, reason)
	if(a == b)
		Fail(reason || "Expected values to differ, both were [a]")

/datum/unit_test/proc/AssertNotNull(val, reason = "Expected non-null value")
	if(isnull(val))
		Fail(reason)

/datum/unit_test/proc/setup()
	return

/datum/unit_test/proc/teardown()
	return

// Master runner
/datum/unit_test_runner
	var/list/tests = list()
	var/list/results = list()
	var/pass_count = 0
	var/fail_count = 0
	var/total_count = 0

/datum/unit_test_runner/proc/run_all()
	var/list/test_types = typesof(/datum/unit_test) - /datum/unit_test
	for(var/test_type in test_types)
		var/datum/unit_test/T = new test_type()
		run_test(T)
		qdel(T)

/datum/unit_test_runner/proc/run_test(datum/unit_test/T)
	total_count++
	T.failures = list()
	T.warnings = list()
	T.running = TRUE

	// Setup phase
	var/setup_error = null
	try
		T.setup()
	catch(var/exception/E)
		setup_error = "Setup threw exception: [E.name] - [E.desc]"

	if(setup_error)
		T.Fail(setup_error)
	else
		// Run phase
		try
			T.Run()
		catch(var/exception/E)
			T.Fail("Test threw exception: [E.name] - [E.desc]")

	// Teardown always runs
	try
		T.teardown()
	catch(var/exception/E)
		T.Fail("Teardown threw exception: [E.name] - [E.desc]")

	T.running = FALSE

	if(T.failures.len)
		fail_count++
		results += "[\[FAIL\]] [T.name]"
		for(var/f in T.failures)
			results += "  - [f]"
	else
		pass_count++
		results += "[\[PASS\]] [T.name]"

	for(var/w in T.warnings)
		results += "  [\[WARN\]] [w]"

/datum/unit_test_runner/proc/print_results()
	for(var/r in results)
		world.log << r
	world.log << "Results: [pass_count]/[total_count] passed, [fail_count] failed"
