/human/tests/interaction
    // Test interactions with pixel-based movement
    proc test_pixel_interaction()
        var/human1 = new /mob/living/carbon/human
        human1.init_pixel_position()
        var/human2 = new /mob/living/carbon/human
        human2.loc = world.pos(1, 0)
        human2.init_pixel_position()

        // Test interaction within range
        human1.interact_pixel(human2)
        // Verify interaction occurred

        // Test interaction out of range
        human2.loc = world.pos(2, 0)
        human2.init_pixel_position()
        human1.interact_pixel(human2)
        // Verify interaction didn't occur