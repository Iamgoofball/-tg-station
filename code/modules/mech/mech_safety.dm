/obj/mech/safety
    var
        safety_active = 1

    proc/CheckSafety()
        if(..thermal/heat > ..thermal/default_threshold)
            safety_active = 0
            // Shutdown equipment
            ..equipment/ShutdownAll()
        else if(..thermal/heat < ..thermal/default_threshold - 100)
            safety_active = 1