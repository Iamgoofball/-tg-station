/obj/mech/overclock
    proc/ActivateOverclock()
        ..thermal/overclocking = 1
        ..safety/safety_active = 0

    proc/DeactivateOverclock()
        ..thermal/overclocking = 0
        ..safety/safety_active = 1