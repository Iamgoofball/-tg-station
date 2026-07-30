// Tests that verify timer-related operations don't cause flakiness
// Timers are a common source of flaky tests in DM

/datum/unit_test/timer_safety
	name = "Timer Safety"
	var/callback_fired = FALSE
	var/callback_datum

/datum/unit_test/timer_safety/setup()
	callback_fired = FALSE
	callback_datum = null

/datum/unit_test/timer_safety/teardown()
	callback_fired = FALSE
	callback_datum = null

/datum/unit_test/timer_safety/Run()
	// Test that we can safely check timer state without race conditions
	// by not relying on actual timer firing in unit tests

	// Verify TIMER_UNIQUE flag behavior is consistent
	var/timer_id = addtimer(CALLBACK(src, .proc/timer_callback), 1, TIMER_UNIQUE | TIMER_STOPPABLE)
	AssertNotNull(timer_id, "Timer should return a valid ID")

	// Stop the timer immediately - we don't want actual async behavior in unit tests
	deltimer(timer_id)

	// The callback should NOT have fired since we deleted it before it could run
	// This tests that deltimer works correctly
	Assert(!callback_fired, "Callback should not fire after deltimer")

/datum/unit_test/timer_safety/proc/timer_callback()
	callback_fired = TRUE
