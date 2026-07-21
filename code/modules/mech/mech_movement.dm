/obj/mech/movement
    // Existing code...

    proc/Strafe(direction)
        // Existing code...

        // Generate heat from strafing
        var heat_generated = 50
        if(..thermal/servo_tier > 1)
            heat_generated = heat_generated / ..thermal/servo_tier
        ..thermal/GenerateHeat(heat_generated)