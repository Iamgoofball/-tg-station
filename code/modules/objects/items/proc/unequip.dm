// Add kirkificator unequip to the item unequip procedures
proc/unequip_kirkificator(user, kirkificator)
    if(!user || !kirkificator)
        return

    user << "You unequip the kirkificator."