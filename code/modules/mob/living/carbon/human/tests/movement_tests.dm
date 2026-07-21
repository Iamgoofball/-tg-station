/human/tests/movement
    // Test pixel-based movement
    proc test_pixel_movement()
        var/human = new /mob/living/carbon/human
        human.init_pixel_position()

        // Test basic movement
        human.move_pixel(32, 0)
        assert(human.pixel_x == 32 && human.pixel_y == 0)

        // Test movement blocking
        var/blocker = new /obj
        blocker.loc = world.pos(2, 0)
        blocker.blocks_movement = 1
        human.move_pixel(32, 0)
        assert(human.pixel_x == 32 && human.pixel_y == 0)

        // Test tile-swapping
        var/target = new /mob/living/carbon/human
        target.loc = world.pos(1, 0)
        target.init_pixel_position()
        human.swap_tiles_pixel(target)
        assert(human.pixel_x == 0 && human.pixel_y == 0)
        assert(target.pixel_x == 32 && target.pixel_y == 0)