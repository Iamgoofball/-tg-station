/human/tests/collision
    // Test collision detection with pixel-based movement
    proc test_pixel_collision()
        var/human = new /mob/living/carbon/human
        human.init_pixel_position()

        // Test collision with object
        var/obj = new /obj
        obj.loc = world.pos(1, 0)
        obj.blocks_movement = 1
        var/collider = human.check_collision_pixel(32, 0)
        assert(collider == obj)

        // Test no collision
        collider = human.check_collision_pixel(64, 0)
        assert(!collider)