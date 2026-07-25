/// Tests fow da fewinid owospeak speech fiwtew :3
/// These tests ensuwe dat ouw fwuffy fwiends tawk pwopewwy and dat da signaws awe managwed cowwectwy nya~

/// Test diwect text twansfowmation in da handwe_speech pwoc
/datum/unit_test/owospeak_transformation
	var/mob/living/carbon/human/test_felinid
	var/list/handle_speech_result = null

/datum/unit_test/owospeak_transformation/proc/capture_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	handle_speech_result = list()
	handle_speech_result += speech_args

/datum/unit_test/owospeak_transformation/Run()
	test_felinid = allocate(/mob/living/carbon/human/consistent)
	test_felinid.set_species(/datum/species/human/felinid)

	// Wegistew ouw own wisteneiw aftew da species one, so we get da twansfowmed output
	// Signaws awe dispatched in wegistwation owdew: species handwew fiwst, ouw captuwe second
	RegisterSignal(test_felinid, COMSIG_MOB_SAY, PROC_REF(capture_speech))

	// Test basic w and w wepwacement
	test_felinid.say("Hello there friend, ready to roll?")
	TEST_ASSERT(handle_speech_result, "Handwe speech signaw was not fiwed fow basic twansfowmation test :(")
	var/message = handle_speech_result[SPEECH_MESSAGE]
	// Sampwe the output - the w/w wepwacement pawt is detewministic
	TEST_ASSERT(findtext(message, "Hewwo") == 1, "Basic w/w wepwacement faiwed (expected 'Hewwo' at stawt)! Got: [message]")
	TEST_ASSERT(findtext(message, "fwiend"), "'friend' shouwd become 'fwiend'! Got: [message]")
	TEST_ASSERT(findtext(message, "woww"), "'roll' shouwd become 'woww'! Got: [message]")
	handle_speech_result = null

	// Test case pwesewvation - uppeawcase W and W shouwd stay uppeawcase
	test_felinid.say("LARGE ROCK ROLLING LOUDLY")
	message = handle_speech_result[SPEECH_MESSAGE]
	TEST_ASSERT(findtext(message, "WAWGE"), "'LARGE' shouwd become 'WAWGE'! Got: [message]")
	TEST_ASSERT(findtext(message, "WOCK"), "'ROCK' shouwd become 'WOCK'! Got: [message]")
	TEST_ASSERT(findtext(message, "WOUDWY"), "'LOUDLY' shouwd become 'WOUDWY'! Got: [message]")
	handle_speech_result = null

	// Test mixed case
	test_felinid.say("Little Rabbit running around")
	message = handle_speech_result[SPEECH_MESSAGE]
	TEST_ASSERT(findtext(message, "Wittwe"), "'Little' shouwd become 'Wittwe'! Got: [message]")
	TEST_ASSERT(findtext(message, "Wabbit"), "'Rabbit' shouwd become 'Wabbit'! Got: [message]")
	handle_speech_result = null

	// Test wowds wiff no tawget chawactews (shouwd pass thwough unchanged except wandom owo-isms)
	test_felinid.say("Hi")
	message = handle_speech_result[SPEECH_MESSAGE]
	TEST_ASSERT(findtext(message, "Hi") == 1, "Untwansfowmed text shouwd stawt wiff 'Hi'! Got: [message]")
	handle_speech_result = null

	UnregisterSignal(test_felinid, COMSIG_MOB_SAY)

/// Test dat da signaw gets wegistewed on species gain and cweaned up on species woss
/datum/unit_test/owospeak_signal_lifecycle
	var/mob/living/carbon/human/test_mob
	var/list/handle_speech_result = null

/datum/unit_test/owospeak_signal_lifecycle/proc/capture_for_lifecycle(datum/source, list/speech_args)
	SIGNAL_HANDLER

	handle_speech_result = list()
	handle_speech_result += speech_args

/datum/unit_test/owospeak_signal_lifecycle/Run()
	test_mob = allocate(/mob/living/carbon/human/consistent)

	// Phase 1: species gain - signaw shouwd be wegistewed and speech twansfowmed
	test_mob.set_species(/datum/species/human/felinid)
	RegisterSignal(test_mob, COMSIG_MOB_SAY, PROC_REF(capture_for_lifecycle))
	test_mob.say("Hello")
	TEST_ASSERT(handle_speech_result, "Speech signaw was not fiwed aftew species gain")
	TEST_ASSERT(findtext(handle_speech_result[SPEECH_MESSAGE], "Hewwo"), "Speech was NOT twansfowmed aftew species gain! Got: [handle_speech_result[SPEECH_MESSAGE]]")
	handle_speech_result = null

	// Phase 2: species woss - unwegistew da fewinid handwew, then vewify speech is NOT twansfowmed
	// NOTE: we must unwegistew ouw own signaw fiwst so we can we-wegistew it aftew species change
	UnregisterSignal(test_mob, COMSIG_MOB_SAY)
	test_mob.set_species(/datum/species/human)
	RegisterSignal(test_mob, COMSIG_MOB_SAY, PROC_REF(capture_for_lifecycle))
	test_mob.say("Hello")
	TEST_ASSERT(handle_speech_result, "Speech signaw was not fiwed aftew species woss")
	TEST_ASSERT_EQUAL(handle_speech_result[SPEECH_MESSAGE], "Hello", "Speech was STIWW twansfowmed aftew species woss! Shouwd be pwain 'Hello'. Got: [handle_speech_result[SPEECH_MESSAGE]]")

	UnregisterSignal(test_mob, COMSIG_MOB_SAY)

/// Test wandom owo-isms and :3 suffix pwobabiwities
/// Wuns muwtipwe itewations to ensuwe da distwibutions awe woughwy cowwect
/datum/unit_test/owospeak_random_isms

/datum/unit_test/owospeak_random_isms/Run()
	// Diwectwy test da handwe_speech pwoc fow wandom pawts by sampwing many itewations
	var/datum/species/human/felinid/fake_species = allocate(/datum/species/human/felinid)
	var/samples = 500
	var/suffix_count = 0
	var/ism_count = 0

	for(var/i in 1 to samples)
		// Fwesh speech awgs fow each itewation (no wowds wiff w/w so base text stays cwean)
		var/list/speech_args = list(SPEECH_MESSAGE = "Test")

		fake_species.handle_speech(null, speech_args)

		var/message = speech_args[SPEECH_MESSAGE]

		// Check fow :3 suffix
		if(findtext(message, ":3"))
			suffix_count++

		// Check fow owo-isms
		if(findtext(message, "nya~") \
			|| findtext(message, "owo") \
			|| findtext(message, "uwu") \
			|| findtext(message, "rawr") \
			|| findtext(message, "mrrp"))
			ism_count++

	// ~15% means we expect woughwy 75 in 500 sampwes (acceptabwe wange: 40-110)
	TEST_ASSERT(suffix_count >= 40, ":3 suffix appeawed too wawewy ([suffix_count]/[samples])")
	TEST_ASSERT(suffix_count <= 110, ":3 suffix appeawed too fwequentwy ([suffix_count]/[samples])")

	// ~8% means we expect woughwy 40 in 500 sampwes (acceptabwe wange: 15-65)
	TEST_ASSERT(ism_count >= 15, "Owo-isms appeawed too wawewy ([ism_count]/[samples])")
	TEST_ASSERT(ism_count <= 65, "Owo-isms appeawed too fwequentwy ([ism_count]/[samples])")
