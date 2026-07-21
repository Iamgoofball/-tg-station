/obj/mech/equipment
    // Existing code...

    proc/UseEquipment(equipment)
        // Existing code...

        // Generate heat based on equipment usage
        var heat_generated = equipment.heat_generation
        if(heat_generated)
            ..thermal/GenerateHeat(heat_generated)