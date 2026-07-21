// Add kirkificator equip to the item equip procedures
proc/equip_kirkificator(user, kirkificator)
    if(!user || !kirkificator)
        return

    user << "You equip the kirkificator."