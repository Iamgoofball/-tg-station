// Tests for object creation and destruction - fixes flaky behavior
// by ensuring proper cleanup and no shared state between test runs

/datum/unit_test/create_destroy
	name = "Create and Destroy"
	var/list/created_atoms = list()

/datum/unit_test/create_destroy/setup()
	created_atoms = list()

/datum/unit_test/create_destroy/teardown()
	// Always clean up any atoms we created, even if test failed
	for(var/atom/A in created_atoms)
		if(!QDELETED(A))
			qdel(A)
	created_atoms = list()

/datum/unit_test/create_destroy/Run()
	// Test basic datum creation and deletion
	var/datum/D = new /datum()
	AssertNotNull(D, "Datum creation returned null")
	Assert(!QDELETED(D), "Datum should not be deleted immediately after creation")
	qdel(D)
	Assert(QDELETED(D), "Datum should be deleted after qdel")

	// Test atom creation on a safe turf
	var/turf/T = locate(1, 1, 1)
	if(!T)
		Warn("Could not locate test turf at 1,1,1 - skipping atom tests")
		return

	var/obj/O = new /obj(T)
	created_atoms += O
	AssertNotNull(O, "Object creation returned null")
	Assert(!QDELETED(O), "Object should not be deleted immediately after creation")
	AssertEqual(O.loc, T, "Object location should be the turf it was created on")

	qdel(O)
	created_atoms -= O
	Assert(QDELETED(O), "Object should be deleted after qdel")

	// Test multiple create/destroy cycles to catch intermittent issues
	var/list/objs = list()
	for(var/i = 1 to 5)
		var/obj/obj_i = new /obj(T)
		AssertNotNull(obj_i, "Object [i] creation returned null")
		objs += obj_i
		created_atoms += obj_i

	AssertEqual(objs.len, 5, "Should have created 5 objects")

	for(var/obj/obj_j in objs)
		Assert(!QDELETED(obj_j), "Object should not be deleted before explicit qdel")
		qdel(obj_j)
		created_atoms -= obj_j
		Assert(QDELETED(obj_j), "Object should be deleted after qdel")
