/proc/kurchatov_quantium_mutation(target)
    var/random_properties = list("explosive", "radioactive", "edible", "hostile", "quantum_mutated")
    var/selected_property = random_properties[rand(1..random_properties.length)]

    switch(selected_property)
        if("explosive")
            target.explosive = 1
        if("radioactive")
            target.radioactive = 1
        if("edible")
            target.edible = 1
        if("hostile")
            target.hostile = 1
        if("quantum_mutated")
            target.quantum_mutated = 1

    target.message("You have been quantum mutated!", target)