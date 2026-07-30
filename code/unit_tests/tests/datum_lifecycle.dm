// Tests for datum lifecycle - no shared mutable state between runs

/datum/unit_test/datum_lifecycle
	name = "Datum Lifecycle"

/datum/unit_test/datum_lifecycle/Run()
	// Test that new datums start with clean state
	var/datum/D1 = new /datum()
	var/datum/D2 = new /datum()

	Assert(D1 != D2, "Two new datums should be distinct objects")
	AssertNotNull(D1, "First datum should not be null")
	AssertNotNull(D2, "Second datum should not be null")

	qdel(D1)
	qdel(D2)

	Assert(QDELETED(D1), "D1 should be deleted")
	Assert(QDELETED(D2), "D2 should be deleted")

	// Test that deleting one doesn't affect the other
	var/datum/D3 = new /datum()
	var/datum/D4 = new /datum()

	qdel(D3)
	Assert(QDELETED(D3), "D3 should be deleted")
	Assert(!QDELETED(D4), "D4 should not be deleted when D3 is deleted")

	qdel(D4)
	Assert(QDELETED(D4), "D4 should be deleted")
