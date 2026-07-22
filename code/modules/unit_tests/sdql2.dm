/datum/unit_test/sdql2_query_length_limit

/datum/unit_test/sdql2_query_length_limit/Run()
	var/maximum_length_query = ""
	for(var/index in 1 to 4096)
		maximum_length_query += "A"

	TEST_ASSERT(!SDQL2_query_too_long(maximum_length_query), "A query at the maximum length should be accepted.")
	TEST_ASSERT(SDQL2_query_too_long("[maximum_length_query]A"), "An oversized query should be rejected before tokenization.")
	TEST_ASSERT_NULL(SDQL2_tokenize("[maximum_length_query]A"), "The tokenizer should reject oversized input defensively.")
