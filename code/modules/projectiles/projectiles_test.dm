[test("Laser reflection test")]
proc/TestLaserReflection()
    var/test_turf = new /turf/wall/reflective
    var/test_laser = new /obj/projectile/proj_weak_laser_2
    test_laser.dir = (1, 0)

    // Test normal reflection
    test_laser.Reflect(test_turf)
    assert(test_laser.dir.x > 0 && test_laser.dir.y != 0)

    // Test random reflection
    var/random_turf = new /turf/wall/reflective/random
    test_laser.Reflect(random_turf)
    assert(test_laser.dir.x != 1 || test_laser.dir.y != 0)