/obj/mech/cockpit
    var
        sealed = 0

    proc/Seal()
        sealed = 1

    proc/Unseal()
        sealed = 0

    proc/HeatCockpit(amount)
        if(sealed)
            // Heat the pilot
            pilot.Heat(amount)