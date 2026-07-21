// Add kirkificator usage to the item usage procedures
proc/use_kirkificator(user, kirkificator)
    if(!user || !kirkificator)
        return

    var/target = user.clicked_on
    if(!target)
        return

    if(target.type != /obj)
        user << "You can't kirkify that!"
        return

    target.name = "Kirkified " + target.name
    target.desc = "This object has been transformed into a Kirk-like item."
    target.icon_state = "kirkified_" + target.icon_state

    user << "You kirkify the " + target.name + "!"