/**
 * # Paranormalist Unit Tests
 *
 * Validates the Paranormalist job and equipment are properly configured
 * and functioning.
 */

/// Verify the Paranormalist job exists and is properly configured in SSjob
/datum/unit_test/paranormalist_job_exists

/datum/unit_test/paranormalist_job_exists/Run()
	var/found = FALSE
	for(var/datum/job/job as anything in SSjob.joinable_occupations)
		if(job.title == JOB_PARANORMALIST)
			found = TRUE
			TEST_ASSERT_EQUAL(job.total_positions, 1, "Paranormalist should have 1 total position.")
			TEST_ASSERT_EQUAL(job.spawn_positions, 1, "Paranormalist should have 1 spawn position.")
			TEST_ASSERT_NOTNULL(job.outfit, "Paranormalist should have an outfit assigned.")
			TEST_ASSERT_EQUAL(job.config_tag, "PARANORMALIST", "Paranormalist config_tag should be PARANORMALIST.")
			break
	TEST_ASSERT(found, "Paranormalist job was not found in SSjob.joinable_occupations!")

/// Verify the PKE meter can be created and toggled
/datum/unit_test/paranormalist_pke_meter

/datum/unit_test/paranormalist_pke_meter/Run()
	var/obj/item/pke_meter/meter = allocate(/obj/item/pke_meter)
	TEST_ASSERT_NOTNULL(meter, "PKE meter should be created successfully.")
	TEST_ASSERT_EQUAL(meter.scanning, FALSE, "PKE meter should start off.")

/// Verify the spirit jar can be created
/datum/unit_test/paranormalist_spirit_jar

/datum/unit_test/paranormalist_spirit_jar/Run()
	var/obj/item/spirit_jar/jar = allocate(/obj/item/spirit_jar)
	TEST_ASSERT_NOTNULL(jar, "Spirit jar should be created successfully.")
	TEST_ASSERT_NULL(jar.occupant, "Spirit jar should start empty.")

/// Verify the ecto-sucker can be created and has reagent container
/datum/unit_test/paranormalist_ecto_sucker

/datum/unit_test/paranormalist_ecto_sucker/Run()
	var/obj/item/ecto_sucker/sucker = allocate(/obj/item/ecto_sucker)
	TEST_ASSERT_NOTNULL(sucker, "Ecto-sucker should be created successfully.")
	TEST_ASSERT_NOTNULL(sucker.reagents, "Ecto-sucker should have a reagent container.")
	TEST_ASSERT_EQUAL(sucker.reagents.total_volume, 0, "Ecto-sucker should start empty.")

/// Verify the ouija board item can be created
/datum/unit_test/paranormalist_ouija_board

/datum/unit_test/paranormalist_ouija_board/Run()
	var/obj/item/ouija_board/board = allocate(/obj/item/ouija_board)
	TEST_ASSERT_NOTNULL(board, "Ouija board should be created successfully.")

/// Verify spectral essence reagent exists
/datum/unit_test/paranormalist_spectral_essence

/datum/unit_test/paranormalist_spectral_essence/Run()
	var/datum/reagent/spectral_essence/essence = new()
	TEST_ASSERT_NOTNULL(essence, "Spectral essence reagent should be created.")
	TEST_ASSERT_EQUAL(essence.name, "Spectral Essence", "Spectral essence should have correct name.")
	qdel(essence)

/// Verify the Paranormalist outfit has all required items
/datum/unit_test/paranormalist_outfit

/datum/unit_test/paranormalist_outfit/Run()
	var/datum/outfit/job/paranormalist/outfit = new()
	TEST_ASSERT_NOTNULL(outfit, "Paranormalist outfit should be created.")
	TEST_ASSERT_NOTNULL(outfit.uniform, "Paranormalist outfit should have a uniform.")
	TEST_ASSERT_NOTNULL(outfit.suit, "Paranormalist outfit should have a suit.")
	TEST_ASSERT_NOTNULL(outfit.head, "Paranormalist outfit should have headwear.")
	TEST_ASSERT_NOTNULL(outfit.ears, "Paranormalist outfit should have an earpiece.")
	TEST_ASSERT_NOTNULL(outfit.backpack_contents, "Paranormalist outfit should have backpack contents.")

	// Check that all equipment is in the backpack
	var/has_pke = FALSE
	var/has_ouija = FALSE
	var/has_sucker = FALSE
	var/has_jar = FALSE
	for(var/item_type in outfit.backpack_contents)
		if(ispath(item_type, /obj/item/pke_meter))
			has_pke = TRUE
		if(ispath(item_type, /obj/item/ouija_board))
			has_ouija = TRUE
		if(ispath(item_type, /obj/item/ecto_sucker))
			has_sucker = TRUE
		if(ispath(item_type, /obj/item/spirit_jar))
			has_jar = TRUE
	TEST_ASSERT(has_pke, "Paranormalist outfit should include a PKE meter.")
	TEST_ASSERT(has_ouija, "Paranormalist outfit should include an ouija board.")
	TEST_ASSERT(has_sucker, "Paranormalist outfit should include an ecto-sucker.")
	TEST_ASSERT(has_jar, "Paranormalist outfit should include a spirit jar.")
	qdel(outfit)

/// Verify the Paranormalist ID trim exists and has correct access
/datum/unit_test/paranormalist_id_trim

/datum/unit_test/paranormalist_id_trim/Run()
	var/datum/id_trim/job/paranormalist/trim = new()
	TEST_ASSERT_NOTNULL(trim, "Paranormalist ID trim should be created.")
	TEST_ASSERT(ACCESS_MORGUE in trim.access, "Paranormalist should have morgue access.")
	TEST_ASSERT(ACCESS_SERVICE in trim.access, "Paranormalist should have service access.")
	qdel(trim)
