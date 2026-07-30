// Tests for mob creation and deletion
// Mobs require special handling to avoid leaving ghost mobs in the world

/datum/unit_test/mob_creation
	name = "Mob Creation and Deletion"
	var/list/created_mobs = list()

/datum/unit_test/mob_creation/setup()
	created_mobs = list()

/datum/unit_test/mob_creation/teardown()
	for(var/mob/M in created_mobs)
		if(!QDELETED(M))
			qdel(M)
	created_mobs = list()

/datum/unit_test/mob_creation/Run()
	var/turf/T = locate(1, 1, 1)
	if(!T)
		Warn("Could not locate test turf - skipping mob creation tests")
		return

	// Create a basic mob
	var/mob/M = new /mob(T)
	created_mobs += M

	AssertNotNull(M, "Mob creation should not return null")
	Assert(!QDELETED(M), "Mob should not be immediately deleted")
	AssertEqual(M.loc, T, "Mob should be at the specified location")

	// Test deletion
	qdel(M)
	created_mobs -= M
	Assert(QDELETED(M), "Mob should be deleted after qdel")
