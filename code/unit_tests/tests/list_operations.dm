// Tests for list operations - common source of flakiness due to reference issues

/datum/unit_test/list_operations
	name = "List Operations"

/datum/unit_test/list_operations/Run()
	// Test basic list creation
	var/list/L = list()
	AssertNotNull(L, "List should not be null")
	AssertEqual(L.len, 0, "New list should be empty")

	// Test adding elements
	L += "a"
	L += "b"
	L += "c"
	AssertEqual(L.len, 3, "List should have 3 elements after adding 3")

	// Test removal
	L -= "b"
	AssertEqual(L.len, 2, "List should have 2 elements after removing 1")
	Assert(!("b" in L), "Removed element should not be in list")
	Assert("a" in L, "Non-removed element should still be in list")
	Assert("c" in L, "Non-removed element should still be in list")

	// Test that lists are independent (no shared reference bugs)
	var/list/L2 = list()
	L2 += "x"
	AssertEqual(L.len, 2, "Original list should be unaffected by operations on L2")
	AssertEqual(L2.len, 1, "L2 should only have its own elements")

	// Test list copy independence
	var/list/L3 = L.Copy()
	L3 += "new_item"
	AssertEqual(L.len, 2, "Original list should be unaffected by copy modification")
	AssertEqual(L3.len, 3, "Copied list should have new item")
