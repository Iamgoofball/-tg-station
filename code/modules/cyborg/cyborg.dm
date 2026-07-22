/obj/machinery/cyborg
    // Add hand_on_stick component
    var/hand_on_stick = null

    New()
        hand_on_stick = new /obj/component/cyborg/hand_on_stick
        hand_on_stick.loc = usr

    // Handle punch event
    proc/handle_punch(user, target)
        if (hand_on_stick)
            hand_on_stick.handle_punch(user, target)