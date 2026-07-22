///Tests all projectiles that none of them are phasing.
/datum/unit_test/projectile_movetypes

/datum/unit_test/projectile_movetypes/Run()
	for(var/obj/projectile/projectile as anything in typesof(/obj/projectile))
		if(initial(projectile.movement_type) & PHASING)
			TEST_FAIL("[projectile] has default movement type PHASING. Piercing projectiles should be done using the projectile piercing system, not movement_types!")

/// Verifies reflective walls apply the requested quadratic curve to weak lasers.
/datum/unit_test/weak_laser_reflective_wall

/datum/unit_test/weak_laser_reflective_wall/Run()
	var/turf/test_turf = run_loc_floor_top_right
	var/original_turf_type = test_turf.type
	var/original_baseturfs = islist(test_turf.baseturfs) ? test_turf.baseturfs.Copy() : test_turf.baseturfs
	var/turf/closed/wall/reflective/reflective_wall = test_turf.ChangeTurf(/turf/closed/wall/reflective)

	TEST_ASSERT_EQUAL(reflective_wall.get_reflection_angle(0), 0, "A head-on impact should have the minimum reflection angle.")
	TEST_ASSERT_EQUAL(reflective_wall.get_reflection_angle(44.5), 22.25, "The midpoint should follow the quadratic reflection curve.")
	TEST_ASSERT_EQUAL(reflective_wall.get_reflection_angle(89), 89, "An 89 degree impact should have the maximum reflection angle.")
	TEST_ASSERT_EQUAL(reflective_wall.get_reflection_angle(90), 89, "Impact angles must be capped at 89 degrees.")
	TEST_ASSERT_EQUAL(reflective_wall.get_reflection_angle(-44.5), -22.25, "The curve should preserve the side of incidence.")

	var/obj/projectile/beam/weak/weak_laser = allocate(/obj/projectile/beam/weak)
	weak_laser.forceMove(get_step(reflective_wall, WEST))
	weak_laser.set_angle(0)
	TEST_ASSERT(reflective_wall.handle_ricochet(weak_laser), "The reflective wall rejected a weak laser.")
	TEST_ASSERT_EQUAL(weak_laser.angle, 180, "A head-on weak laser did not reflect directly backwards.")

	reflective_wall.ChangeTurf(original_turf_type, original_baseturfs)

/// Verifies scattering reflective walls always choose an angle in their advertised range.
/datum/unit_test/weak_laser_random_reflective_wall

/datum/unit_test/weak_laser_random_reflective_wall/Run()
	var/turf/test_turf = run_loc_floor_top_right
	var/original_turf_type = test_turf.type
	var/original_baseturfs = islist(test_turf.baseturfs) ? test_turf.baseturfs.Copy() : test_turf.baseturfs
	var/turf/closed/wall/reflective/random/reflective_wall = test_turf.ChangeTurf(/turf/closed/wall/reflective/random)

	for(var/iteration in 1 to 100)
		var/reflection_angle = reflective_wall.get_reflection_angle(45)
		TEST_ASSERT(reflection_angle >= 0 && reflection_angle <= 180, "Random reflection angle [reflection_angle] was outside 0 to 180 degrees.")

	reflective_wall.ChangeTurf(original_turf_type, original_baseturfs)

///Shoots a victim with a gun to ensure the gun properly loads and the victim take the correct amount of damage.
/datum/unit_test/gun_go_bang

/datum/unit_test/gun_go_bang/Run()
	// test is for a ballistic gun that starts loaded + chambered
	var/obj/item/gun/ballistic/test_gun = allocate(/obj/item/gun/ballistic/automatic/pistol)
	var/mob/living/carbon/human/victim = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/gunner = allocate(/mob/living/carbon/human/consistent)
	ADD_TRAIT(victim, TRAIT_PIERCEIMMUNE, INNATE_TRAIT) // So the human isn't randomly affected by shrapnel
	test_gun.can_misfire = FALSE //just in case

	var/obj/item/ammo_casing/loaded_casing = test_gun.chambered
	TEST_ASSERT(loaded_casing, "Gun started without round chambered, should be loaded")
	var/obj/projectile/loaded_bullet = loaded_casing.loaded_projectile
	TEST_ASSERT(loaded_bullet, "Ammo casing has no loaded bullet")

	gunner.put_in_hands(test_gun, forced=TRUE)
	gunner.set_combat_mode(FALSE) // just to make sure we know we're not trying to pistol-whip them
	var/expected_damage = loaded_bullet.damage
	loaded_bullet.def_zone = BODY_ZONE_CHEST
	var/did_we_shoot = test_gun.melee_attack_chain(gunner, victim)
	TEST_ASSERT(did_we_shoot, "Gun does not appeared to have successfully fired.")
	TEST_ASSERT_EQUAL(victim.get_brute_loss(), expected_damage, "Victim took incorrect amount of damage, expected [expected_damage], got [victim.get_brute_loss()].")

	var/obj/item/bodypart/expected_part = victim.get_bodypart(BODY_ZONE_CHEST)
	TEST_ASSERT_EQUAL(expected_part.brute_dam, expected_damage, "Intended bodypart took incorrect amount of damage, either it hit another bodypart or armor was incorrectly applied. Expected [expected_damage], got [expected_part.brute_dam].")
