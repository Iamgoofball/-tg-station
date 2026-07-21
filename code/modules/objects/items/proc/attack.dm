// Add kirkificator attack to the item attack procedures
proc/attack_kirkificator(user, kirkificator, target)
    if(!user || !kirkificator || !target)
        return

    if(target.type != /obj)
        user << "You can't kirkify that!"
        return

    target.name = "Kirkified " + target.name
    target.desc = "This object has been transformed into a Kirk-like item."
    target.icon_state = "kirkified_" + target.icon_state

    user << "You kirkify the " + target.name + "!"