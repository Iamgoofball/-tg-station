// Add kirkificator to the item spawning procedures
proc/spawn_kirkificator()
    var/kirkificator = new /obj/item/kirkificator
    kirkificator.loc = world
    return kirkificator