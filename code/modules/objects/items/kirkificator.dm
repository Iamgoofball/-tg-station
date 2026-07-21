/obj/item/kirkificator
    name = "kirkificator"
    desc = "A device that transforms objects into Kirk-like items."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "kirkificator"
    layer = 4.2

    proc/Initialize()
        . = new /obj/item
        name = "kirkificator"
        desc = "A device that transforms objects into Kirk-like items."
        icon = 'icons/obj/items_and_weapons.dmi'
        icon_state = "kirkificator"
        layer = 4.2

    proc/Use(user)
        if(!user)
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

    proc/Attack(user, target)
        if(!user || !target)
            return

        if(target.type != /obj)
            user << "You can't kirkify that!"
            return

        target.name = "Kirkified " + target.name
        target.desc = "This object has been transformed into a Kirk-like item."
        target.icon_state = "kirkified_" + target.icon_state

        user << "You kirkify the " + target.name + "!"

    proc/Equip(user)
        if(!user)
            return

        user << "You equip the kirkificator."

    proc/Unequip(user)
        if(!user)
            return

        user << "You unequip the kirkificator."