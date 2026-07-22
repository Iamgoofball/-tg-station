/obj/system/combat
    // Modify to detect punches on cyborgs
    proc/handle_punch(user, target)
        if (target.type == /obj/machinery/cyborg)
            target.handle_punch(user, target)