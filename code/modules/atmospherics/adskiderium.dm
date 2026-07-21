/proc/adskiderium_corruption(target)
    var/eldritch_effects = list("psychological_horror", "eldritch_manifestation", "reality_warp")
    var/selected_effect = eldritch_effects[rand(1..eldritch_effects.length)]

    switch(selected_effect)
        if("psychological_horror")
            target.psychological_horror = 1
        if("eldritch_manifestation")
            target.eldritch_manifestation = 1
        if("reality_warp")
            target.reality_warp = 1

    target.message("You have been corrupted by eldritch forces!", target)