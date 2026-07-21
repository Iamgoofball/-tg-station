/obj/mech/thermal
    var
        heat = 0
        heat_capacity = 1000
        default_threshold = 800
        emergency_threshold = 950
        overclocking = 0
        servo_tier = 1
        capacitor_tier = 1

    proc/GenerateHeat(amount)
        heat = min(heat + amount, heat_capacity)

    proc/DissipateHeat(amount)
        heat = max(heat - amount, 0)

    proc/CheckOverheat()
        if(heat > emergency_threshold)
            // Apply overheating effects
            .movement/ReduceSpeed(heat - emergency_threshold)
            .equipment/ReduceEfficiency(heat - emergency_threshold)
            .armor/ReduceStability(heat - emergency_threshold)
            if(.cockpit/IsSealed())
                .cockpit/HeatCockpit(heat - emergency_threshold)

    proc/Update()
        // Passive heat dissipation
        var env_temp = world.T()
        if(env_temp < heat)
            DissipateHeat((heat - env_temp) / 10)

        // Apply servo tier benefits
        if(servo_tier > 1)
            DissipateHeat(servo_tier * 10)

        // Apply capacitor tier benefits
        if(capacitor_tier > 1)
            DissipateHeat(capacitor_tier * 5)

        // Check for overheating
        CheckOverheat()